function [ midinote  ] = Note2midi( freqnote  )
% Convert the frequency notes into midi notes
% [ midinote ] = Note2midi( freqnote )

midinote = 69+12*log(freqnote/440)/log(2);

end

