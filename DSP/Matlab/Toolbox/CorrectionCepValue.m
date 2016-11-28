function [ midi ] = CorrectionCepValue( midi,N )
%[ midi ] = CorrectionCepValue( midi,N )
%   Dirty correction (like really dirty) of midi pitch error resulting of modified cepstrum
%   result
Npt=[512 1024 2048 4092];

pos=find(N==Npt,1);
if ~isempty(pos)
    for ii=1:length(midi)
        cor=load('correctCepstrum.txt');
        pos2=find(cor(:,1)==round(midi(ii)),1);
        midi(ii)=midi(ii)-cor(pos2,pos+1);
    end
end

end

