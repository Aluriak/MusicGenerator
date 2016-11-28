% 
%  File    :   main 
% 
% Author1: Samuel Dupont
% Date:    November 2016 
%   
%  Description :  
%                     
%    1) This code is use to detect a series of musical note using the an
%       onset algorithm and perform the pitch analysis on the detected
%       note.          
%                     
%    2) It use struct data, vect
%                     
%    3) The process consist of three different parts
%            - Load the wav file to extract
%            - Detect the begining of a note (Onset detection)
%            - Use a pitch algorithm to extract the pitch with several
%              algo:
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
%                   select the choosen audio file in the first part 
%                   run the script      
 
    clear variables; close all; clc
    addpath('Toolbox')

%% Load the audio file 
tic

   [wav.wav, ct.FS] = audioread('FF10s.wav');
%    wav.wav=wav.wav(1:30*ct.FS,1);
   wav.wav=mean(wav.wav,2);

   ct.TAILLE=length(wav.wav);
toc
    
%% Pitch detection algorithm
tic
    % constant def part
    ct.NWIN = round(910); % number of points in the buffer fo algo
    ct.NLOOP=floor(ct.TAILLE/ct.NWIN);
    ct.NBR=round(6*1024/ct.NWIN);

    
    var.acoSum=0;% variable for energy of the frame
    var.ALD=zeros(ct.NWIN,1);% init for ALD
    var.aco=zeros(ct.NLOOP,1);% keep squared rms in a vector
    var.notePos=zeros(round(ct.NLOOP/2),2);% declare max note pos, remove zeros at the end
                                    % [posNote noteValue ]
    var.indexNote=1;                               
    bool.onset=0;
    
    % medium outer ear filter coef
    [ sos ] = MediumOuterFilter( ct.FS ); % create filter
    
               
toc

%% Loop and algo run
    % init value for the onset detection --> var.aco
    for ii=1:ct.NBR
        wav.buffer = wav.wav( 1+(ii-1)*ct.NWIN : ii*ct.NWIN,1 );% take buffer size from total wav
        wav.buffer = filtfilt( sos, 1, wav.buffer); % implement medium outer filter   
        var.aco(ii) = EnergyACF0(wav.buffer);%energy of buffer for ALD
        var.acoSum = var.acoSum + var.aco(ii);%total energy of the whole loop
        wav.lastALD = var.aco(ii) .* wav.buffer ;
        var.ALD = var.ALD + wav.lastALD ; % Aggregate Lag Domain
    end
    
    % begin to shearch the note
    for ii=ct.NBR+1:ct.NLOOP
        
        % apply pre signal conditionning
        wav.buffer = wav.wav( 1+(ii-1)*ct.NWIN : ii*ct.NWIN,1 );% take buffer size from total wav
        wav.buffer = filtfilt( sos, 1, wav.buffer); % implement medium outer filter
        var.aco(ii) = EnergyACF0(wav.buffer);%energy of buffer for ALD
        wav.buffer = MCepstrum( wav.buffer );%modified cepstrum on buffer
        
        % detect if there if a new note occuring
        [ var.notePos(ii,1),bool.onset ] = OnsetAlgo(var.aco,ct.NWIN,bool.onset,ii, ct.NBR );
        
        if var.notePos(ii,1) ~= 0 || ii == ct.NLOOP
            %define note pitch
            var.ALD = var.ALD/var.acoSum;
            [ posPeaks, peaks ] = PeakPicking( var.ALD );
            pitch = PrimaryPeaks(posPeaks, peaks);
            var.notePos(var.indexNote,2) = pitch(1);
            var.indexNote=ii;
            var.ALD = wav.lastALD+ var.aco(ii) .* wav.buffer;% re-init for ALD
            var.acoSum = sum(var.aco(ii-1:ii));
            %figure;figure;plot(var.ALD);
        else
            [ posPeaks, peaks ] = PeakPicking( wav.buffer );%select main peaks
            var.acoSum = var.acoSum + var.aco(ii);%total energy of the whole loop
            wav.lastALD = var.aco(ii) .* wav.buffer ;
            var.ALD = var.ALD + wav.lastALD ; % Aggregate Lag Domain
             %figure;plot(var.ALD);
        end
        
       
            
    end
 var.notePos(var.notePos(:,1)==0,:) = [];
 var.notePos(:,2)=Note2midi(ct.FS./var.notePos(:,2));
%% Plot signal and result

    bool.plot=1;
    if bool.plot==1
        figure
            plot(wav.wav);
            hold on
            plot([var.notePos(:,1) var.notePos(:,1)],[-0.5 0.5],'g');
    end

%% sound music
           var.notePos(:,2)=CorrectionCepValue( var.notePos(:,2),ct.NWIN );
%%
    bool.sound=1;
    if bool.sound==1
         wait=([var.notePos(:,1); 0]-[0;var.notePos(:,1)])/ct.FS-0.03;
         wait(1)='';wait(end)=0;
         var.notePos(:,2)=round((var.notePos(:,2)));
         for ii=1:length(var.notePos)
            filename=['PianoNote/',num2str(var.notePos(ii,2)), '.wav'];
            son=audioread(filename);
            sound(son,ct.FS)
            pause(wait(ii))
         end        
    end
    
%     fichier=[round(wait*1000)  var.notePos(:,2)];