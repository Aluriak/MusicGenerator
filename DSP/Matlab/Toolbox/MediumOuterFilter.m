  function [ sos ] = MediumOuterFilter( FS,opt )
      % [ sos ] = MediumOuterFilter( FS,opt )
      % 
      % Author1: Samuel Dupont
      % Author2: I worked alone  
      % Date:    November 2016 
      % 
      % Function   : MediumOuterFilter 
      % 
      % Description: Create a filter based on the hearing of the human ear
      %              It constituated of two filter: a 2nd order
      %              butterworth and a Yulewalk 10th order.
      %             
      % 
      % Parameters : FS              - Sampling frequency 
      %              opt             - boolean to plot, 1 to plot
      % 
      % Return     : SOS of both filters in a matrix 
      % 
      % Examples of Usage: 
      % 
      % [ sos ] = MediumOuterFilter( 44100 ) % sampling at 44100 Hz
      %
    
    if nargin ==1
        opt=0;
    end
%% constant def
    FNYQ=FS/2;

%% Yulewak filter def
    yulefilt.f = [0 4000/FNYQ 4000/FNYQ 5000/FNYQ  7500/FNYQ 10000/FNYQ 1];% frequency aimed
    yulefilt.m = [10^(-9/20) 10^(-8/20) 1  1 10^(-16/20) 10^(-15/20) 10^(-70/20)];% value of the above freq
%     yulefilt.m = [0.98 1 1  1 1 1 1];% value of the above freq
    [yulefilt.b,yulefilt.a] = yulewalk(10,yulefilt.f,yulefilt.m);% design a b 



%% highpass butterworth 150Hz
    butterFilt.n=2;%order of the filter
    butterFilt.wn=150/FNYQ;% cuff of freq divided by nyquist freq
    [butterFilt.b,butterFilt.a] = butter(butterFilt.n,butterFilt.wn,'high');%butterworth filter with previous param
    flag = isstable(butterFilt.b,butterFilt.a);%vif pole in unit circle
    if flag == 0
        sprintf('The butterworth filter is unstable')        
    end
    
%% medium outer filter
    if opt==1
        [yulefilt.h,yulefilt.w] = freqz(yulefilt.b,yulefilt.a,2048,FS);%freqz to obverse filter
        [butterFilt.h2,butterFilt.w] = freqz(butterFilt.b,butterFilt.a,2048,FS);%verification filter
        
        figure
        semilogx(yulefilt.w,db(yulefilt.h)+db(butterFilt.h2),'r');%sum of both filter
        hold on
        semilogx(yulefilt.w,db(yulefilt.h),'--');%yule
        hold on
        semilogx(butterFilt.w,db(butterFilt.h2),'--g');%butter
        grid on
        legend('Medium outer filter','yulefilt Designed','butterworth Designed');
        xlim([40 FNYQ]);
        ylim([-80 10])
    end

%% calculate biquad coefficient and verification
    [yulefilt.sos] = tf2sos(yulefilt.b,yulefilt.a);% 10th in biquad
    flag = isstable(yulefilt.sos);%stability
   if flag == 0
        sprintf('The yulewalk sos filter is unstable')        
    end
    
%% concatenate sos
    sos=zeros(6,6);
    sos(2:6,1:6)=yulefilt.sos;
    sos(1,1:6)=[butterFilt.b , butterFilt.a];
    if opt==1
         test=rand(1,2048);
        test=filtfilt( sos, 1, test);
        figure 
        freq=FreqVect(FS,2048);
            semilogx(freq,db(abs(fft(test))));
    end   
    

  end