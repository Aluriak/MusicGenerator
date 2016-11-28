
[data, fs]=audioread('chpn_op23.wav');
taille = length(data);

T=10*fs;
NSPLIT=floor(taille/T);
%%
for ii=1:2
    filename=['test' num2str(ii)]
[ debut ] = closest( (ii-1)*T,out(:,1) )
[ fin ] = closest( (ii)*T,out(:,1) )

while out(debut,1) < (ii-1)*T
   debut=debut+1; 
end

while out(fin,1) > (ii)*T
   fin=fin-1; 
end

 audiowrite([filename '.wav'],data(((ii-1)*T+1):(ii*T)),fs);
 pos=(out(debut:fin,1)-((ii-1)*T))/fs;
 dlmwrite([filename '.txt'],pos,'delimiter','\t','precision',9);
 
 plot(abs(data(((ii-1)*T+1):(ii*T))))
 hold on
stem(pos*fs,ones(length(pos),1))
k = waitforbuttonpress;
close
end