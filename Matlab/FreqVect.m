function [ freq ] = FreqVect( Fs,taille )
% [ freq ] = FreqVect( Fs,taille )
% Calculate frequency vector

dfe=Fs/taille;
freq=0:dfe:(taille-1)*dfe;

end

