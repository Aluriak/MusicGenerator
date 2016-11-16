% 
%  File    :   onset algo 
% 
% Author1: Samuel Dupont
% Date:    November 2016 
%   
%  Description :  
%                     
%    1) This code is use to detect a series of musical note using the pitch
%           This is Onset detection
%         
%                     
%    2) It use struct data, vect
%                     
%    3) The process consist of three different parts
%             Load the wav file to extract
%             Detect the begining of a note (Onset detection based on pitch)
%             Use a pitch algorithm to extract the pitch with several
%             algo:
%                   -medium outer filter

%                   -peak peaking algo
%                   -main peak selection (pitch)
%
%
%              This based on the work :
%              McLeod, Philip. "Fast, accurate pitch detection tools
%                 for music analysis."
%                 Academisch proefschrift, University of Otago.
%                 Department of Computer Science (2009).
%
%  Examples of how to utilize the script:
%                   run the script        
   
    clear variables; close all; clc


%% Load the audio file 
tic

   [wav.wav, ct.FS] = audioread('FF10s.wav');
%    wav.wav=wav.wav(1:1.51e6,1);
   wav.wav=wav.wav(:,1);
    ct.TAILLE=length(wav.wav);
toc
%% Pitch detection algorithm
tic
    % constant def part
    ct.NWIN = 2048/2; % number of points in the buffer fo algo
    var.acoSum=0;% variable for energy of the frame
    var.ALD=zeros(ct.NWIN,1);
    % medium outer ear filter coef
    [ sos ] = MediumOuterFilter( ct.FS ); % create filter
    
    % run the loop algo
    ct.NLOOP=floor(ct.TAILLE/ct.NWIN)-25;
        aco=zeros(ct.NLOOP,1);

%% Detect first note
    plot(wav.wav.^2/max(wav.wav.^2));hold on;
    var.aco=[0.001 0.001];
    debut=1;
    
%     onset.pitchTsIndex=1;
%     onset.LIMIT(1)=round(ct.FS/5/ct.NWIN);
%     
%     onset.pitchTlIndex=1;
%     onset.LIMIT(2)=4*onset.LIMIT(1);
    
 %   wav.bufferpast=zeros(ct.NWIN,onset.LIMIT(2));
    onset.ts_tl=zeros(ct.NWIN,2);
    

    
    booldif=0;
    poschange=0;
    nmbr=6*1024/ct.NWIN;
    note=0;

    for i=nmbr+1:ct.NLOOP
         wav.buffer = wav.wav( 1+(i-1)*ct.NWIN : i*ct.NWIN,1 );% take buffer size from total wav
         wav.buffer = filtfilt( sos, 1, wav.buffer); % implement medium outer filter
%         wav.buffer = MCepstrum( wav.buffer );%modified cepstrum on buffer
% 
         var.aco = EnergyACF0(wav.buffer);%energy of buffer for ALD
         aco(i)=var.aco;
%         var.acoSum = var.acoSum + var.aco;%total energy of the whole loop 
%         
%         [ wav.bufferpast,onset.pitchTsIndex,onset.ts_tl ] = PitchDomain( var.aco*wav.buffer,wav.bufferpast,...
%                                                         onset.ts_tl,onset.pitchTsIndex,onset.LIMIT);
        
        % comparison TS TL peak                                           
%         [ onset.posPeaks, onset.peaks ] = PeakPicking( onset.ts_tl(:,1) );%select main peaks
%         pitch(1,:)=PrimaryPeaks(onset.posPeaks,onset.peaks);
%         [ onset.posPeaks, onset.peaks ] = PeakPicking( onset.ts_tl(:,2) );%select main peaks
%         pitch(2,:)=PrimaryPeaks(onset.posPeaks,onset.peaks);
%         test(i)=abs(pitch(1,1)/pitch(2,1)-1);
%         testpitch(1,i)=ct.FS/pitch(1,1);
%         testpitch(2,i)=ct.FS/pitch(2,1);
        
        if mean(aco(i-nmbr:i-1))<mean(aco(i-nmbr:i)) && aco(i)/aco(i-1)>1.4 && aco(i)>0.002552
%             abs(mean(aco(i-1))-mean(aco(i+1)))/mean(aco([i-1,i+1]))>1.3
            if booldif==0
                 poschange=(i)*ct.NWIN-ct.NWIN/2;
            end

            booldif=1;
            
        else if mean(aco(i-nmbr:i-1))>mean(aco(i-nmbr:i)) &&  booldif==1
                plot([poschange poschange],[-0 1],'g');
                booldif=0;
                note=note+1;
            end
        end
%         if abs(pitch(1,1)/pitch(2,1)-1)>0.2
%             if booldif==0
%                  poschange=i*ct.NWIN-ct.NWIN/2;
%             end
% 
%             booldif=1;
%       
% 
%             fprintf('\n The onset detected a shift at  %g Hz \n',i*ct.NWIN/2/ct.FS);
%             
%         else if abs(pitch(1,1)/pitch(2,1)-1)<0.1 &&  booldif==1
%                    plot([poschange poschange],[-1 1],'g')
%                    booldif=0;
%             
%             end
%                 
%         end

%         var.ALD = var.ALD + var.aco .* wav.buffer; % Aggregate Lag Domain
    end
%      var.ALD=var.ALD/var.acoSum;
toc 

%% plot result
     x=1:ct.NLOOP;
     x=x.*ct.NWIN;
%      plot(x,test)
     
%      figure(2)
%      [ posPeaks, peaks ] = PeakPicking( var.ALD );
%      pitch2=PrimaryPeaks(posPeaks,peaks);
%         plot(var.ALD)
%         hold on
%         plot(pitch2(1),pitch2(2),'r*')
%         xlim([0 ct.NWIN/2])
%      fprintf('\n The pitch of the sequence is %g Hz \n',ct.FS/pitch(1));
%      

%    figure
%    plot(x,testpitch)