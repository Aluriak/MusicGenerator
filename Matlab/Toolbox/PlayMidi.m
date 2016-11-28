function [ ] = PlayMidi( input, FS )
% 
  % Author1: Samuel Dupont
  % Date:    November 2016 
  % 
  % Function   : playmidi
  % 
  % Description: take the signal in input: two columns [delay next note; midi note]
  %              
  % 
  % Parameters : input             : two columns [delay next note; midi note]
  %            
  % 
  % Return     : play sound
  % 
  % Examples of Usage: 
  % 
  % PlayMidi( input )
  %
     for ii=1:length(input)
        filename=['PianoNote/',num2str(input(ii,2)), '.wav'];
        son=audioread(filename);
        sound(son,FS)
        pause(input(ii,1))
     end     

end

