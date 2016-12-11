% 
%  File    :   pitch algo test
% 
% Author1: Samuel Dupont
% Author2: I worked alone  
% Date:    November 2016 
%   
%  Description :  
%                     
%    1) This code is use to extract pitch from a series of musical note
%                     
%    2) It use struct data
%                     
%    3) The process consist of three different parts
%             Load the wav file to extract
%             Detect the begining of a note (Onset detection based on pitch)
%             Use a pitch algorithm to extract the pitch with several
%             algo:
%                   -medium outer filter
%                   -modified cepstrum
%                   -warped factor
%                   -Warped Agregate Lag Domain (only ALD for the moment)
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
addpath('Toolbox')

num=30:102;

Npt=[4024 ];
%% Load the audio file 
for kk = 1:length(Npt)
    tic
    for jj = 1:length(num)
    % tic
         filename=['../../AudioRessources/PianoNotes/',num2str(num(jj)),'.wav'];
         [wav.wav, ct.FS] = audioread(filename);
         wav.wav=mean(wav.wav,2)+rand(length(wav.wav),1)*1e-6;
%          ct.FS=44100;
%          t=0:1/ct.FS:1;
%          wav.wav=sin(2*pi*Midi2note(num(jj)).*t+ pi/2);
%          wav.wav=wav.wav.';
        ct.TAILLE=length(wav.wav);
    % toc
%% Pitch detection algorithm
   % tic
        % constant def part
        ct.NWIN = Npt(kk); % number of points in the buffer fo algo
        var.acoSum=0;% variable for energy of the frame
        var.ALD=zeros(ct.NWIN,1);
        var.hann=hann(ct.NWIN);
        % medium outer ear filter coef
        [ sos ] = MediumOuterFilter( ct.FS ); % create filter
        % run the loop algo
        ct.NLOOP=floor(ct.TAILLE/ct.NWIN);
        for i=1:ct.NLOOP

            wav.buffer = wav.wav( 1+(i-1)*ct.NWIN : i*ct.NWIN,1 );% take buffer size from total wav
            wav.buffer = wav.buffer .*  var.hann; % windowed
            wav.buffer = filtfilt( sos(1:2,:), 1, wav.buffer); % implement medium outer filter
            wav.buffer = SNAC( wav.buffer );%modified cepstrum on buffer
         
            var.aco = EnergyACF0(wav.buffer(1:end-1));%energy of buffer for ALD
            var.acoSum = var.acoSum + var.aco;%total energy of the whole loop 
            var.ALD = var.ALD + var.aco .* wav.buffer ; % Aggregate Lag Domain
        end
         var.ALD=var.ALD/var.acoSum;
     %toc 

%% plot result
         [ posPeaks, peaks ] = PeakPicking( var.ALD(1:end-1,1) );
         pitch=PrimaryPeaks(posPeaks,peaks);
         test(jj)=ct.FS/pitch(1);
    end
             error(:,kk)=Note2midi(test)-(num);

    fprintf('\n Elapsed time for Npt = %g is %g s \n',Npt(kk),toc)
    figure(1)
    plot(num,Note2midi(test))
    xlabel('Midi number of the file');
    ylabel('Midi number found')
    title('Comparison expected and founded midi')
    hold on

    figure(2)
    plot(num,abs(Note2midi( test)-(num) )./( (num))*100 )
    ylim([0 10])
    xlabel('Midi number of the file');
    ylabel('Error %')
    title('Pitch (freq) error midi')
    hold on
    
    figure(3)
    plot(num,abs( test-Midi2note(num) )./( Midi2note(num))*100 )
    ylim([0 10])
    xlabel('Midi number of the file');
    ylabel('Error %')
    title('Pitch (freq)  error Hz')
    hold on
end
figure(1);legend(num2str(Npt.'),'Location','SouthEast')
figure(2);legend(num2str(Npt.'),'Location','NorthEast')
