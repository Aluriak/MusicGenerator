function [  ] = midi2Lformat( filename )
%  [  ] = midi2Lformat( filename )
% ex: midi2Lformat( ' file.mid' )
  % Author1: Samuel Dupont
  % Date:    November 2016 
  % 
  % Function   : midi2Lformat 
  % 
  % Description: take the midi in input and export a .txt [time before next note, midi note]
  %              
  midi=readmidi(filename);
  Notes = midiInfo(midi,0);
  b = [Notes(2:end,5);Notes(end,5)] - [Notes(1:end,5)];
  output=[round(b*1000),Notes(:,3)];
  filename=[filename(1:end-4) '.txt'];
  dlmwrite(filename,output,'delimiter','\t','precision',5)
end

