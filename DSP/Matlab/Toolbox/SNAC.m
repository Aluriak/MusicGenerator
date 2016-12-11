function [ snac ] = SNAC( input )
  % [ snac ] = SNAC( input )
  % Author1: Samuel Dupont
  % Date:    November 2016 
  % 
  % Function   : SNAC 
  % 
  % Description: take the signal in input and do snac function
  %              defined as real(fft(log(1+abs(fft(input)))))
  %              
  %              This based on the work :
  %              McLeod, Philip. "Fast, accurate pitch detection tools
  %                 for music analysis."
  %                 Academisch proefschrift, University of Otago.
  %                 Department of Computer Science (2009).
  % 
  % Parameters : input              - audio buffer ex 1024 points from wav
  %            
  % 
  % Return     :  snac autocorrelation function
  % 
  % Examples of Usage: 
  % 
  
  W=length(input);
  m = zeros(W,1);
  input2=input.^2;
  m(1) = 2 * sum(input2); 
  for ii = 2:W-1
    m(ii)=m(ii-1)-input2(ii-1)-input2(W-ii+1);
  end
  cor=xcorr(input);
  snac= 2 *  cor (W:end)./ m ;
end

