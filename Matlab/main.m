% 
%  File    :   main 
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
%                   -Warped Agregate Lag Domain
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
    [wav.wav, ct.FS] = audioread('Piano_mf_Gb2.wav');
    wav.wav=wav.wav(:,1);
    ct.TAILLE=length(wav.wav);
toc
%% Pitch detection algorithm
tic
    % constant def part
    ct.NWIN = 2048; % number of points in the buffer fo algo
    var.acoSum=0;% variable for energy of the frame
    var.ALD=zeros(ct.NWIN,1);
    % medium outer ear filter coef
    [ sos ] = MediumOuterFilter( ct.FS ); % create filter
    
    % run the loop algo
    ct.NLOOP=floor(ct.TAILLE/ct.NWIN);
    for i=1:ct.NLOOP
        wav.buffer = wav.wav( 1+(i-1)*ct.NWIN : i*ct.NWIN,1 );% take buffer size from total wav
        wav.buffer = filtfilt( sos, 1, wav.buffer); % implement medium outer filter
        wav.buffer = MCepstrum( wav.buffer );%modified cepstrum on buffer
        
        [ posPeaks, peaks ] = PeakPicking( wav.buffer );%select main peaks
        
        var.aco = EnergyACF0(wav.buffer);%energy of buffer for ALD
        var.acoSum = var.acoSum + var.aco;%total energy of the whole loop 
        var.ALD = var.ALD + var.aco .* wav.buffer; % Aggregate Lag Domain
    end
    
toc 

%% plot result
     [ posPeaks, peaks ] = PeakPicking( var.ALD );
     pitch=PrimaryPeaks(posPeaks,peaks);
     plot(var.ALD)
     hold on
     plot(pitch(1),pitch(2),'r*')
     xlim([0 ct.NWIN/2])
     fprintf('\n The pitch of the sequence is %g \n',ct.FS/pitch(1));
     

   