function [ freqnote ] = Midi2note( midinote )
% Convert the midi notes into frequency notes
% [ freqnote ] = Midi2note( midinote )
freqnote=exp(((midinote-69)./12).*log(2))*440;
end

