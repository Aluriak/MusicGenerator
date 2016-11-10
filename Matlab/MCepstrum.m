function [ mCepstrum ] = MCepstrum( input )
  % [ mCepstrum ] = MCepstrum( input )
  % 
  % Author1: Samuel Dupont
  % Author2: I worked alone  
  % Date:    November 2016 
  % 
  % Function   : MCepstrum 
  % 
  % Description: take the signal in input and do the modified cepstrum
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
  % Return     : modified cepstrum result
  % 
  % Examples of Usage: 
  % 
  % [ mCepstrum ] = MCepstrum( input )
  %
  
     mCepstrum = real(fft(log(1+abs(fft(input)))));


end

