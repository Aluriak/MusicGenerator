clear all; close all;clc

%% read midi
  fs=44100;
  filename='chpn_op23';

  midi=readmidi(['../' filename '.mid']);
  Notes = midiInfo(midi,0);
  out=[Notes(:,5)*fs ,Notes(:,3)];
  

%% read wav
 [data, fs]=audioread(['../' filename '.wav'] );
% [data,fs] = midi2audio(midi);    
taille = length(data);

T=5*fs;
NSPLIT=floor(taille/T);


%%
% plot(data(1:1.581237e+06))
% hold on
% stem(out(1:102,1),ones(102,1))

%% split
cont=1;

for ii=1:NSPLIT
[ debut ] = closest( (ii-1)*T+1,out(:,1) );
[ fin ] = closest( (ii)*T,out(:,1) );

while out(debut,1) < (ii-1)*T
   debut=debut+1; 
end

while out(fin,1) > (ii)*T
   fin=fin-1; 
end

 pos=(out(debut:fin,1)-((ii-1)*T))/fs;
 num(ii)=length(out(debut:fin,1));
     if length(out(debut:fin,1))<=18
     figure
     plot(data((ii-1)*T+1:(ii)*T))
     hold on
     stem(pos*fs,ones(length(pos),1)-0.5)
     sound(data((ii-1)*T+1:(ii)*T),fs)
     filename=['TestlowDens' num2str(cont)]
%        audiowrite([filename '.wav'],data(((ii-1)*T+1):(ii*T)),fs);
%       dlmwrite([filename '.txt'],pos,'delimiter','\t','precision',9);
      k = waitforbuttonpress;


     cont=cont+1;
    close
     end
end

