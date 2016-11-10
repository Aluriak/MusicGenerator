function [ winner ] = PrimaryPeaks( posPeaks,peaks )
% [ winner ] = PrimaryPeaks( posPeaks,peaks )
% 
% Author1: Samuel Dupont
% Date:    November 2016 
% 
% Function   : PrimaryPeaks 
% 
% Description: Send back the position and value of the first maximum peak
%               which is 0.9* max of the peaks
%              
%              This based on the work :
%              McLeod, Philip. "Fast, accurate pitch detection tools
%                 for music analysis."
%                 Academisch proefschrift, University of Otago.
%                 Department of Computer Science (2009).
% 
% Parameters : peaks        -vector of peaks value
%              posPeaks     -vector of peaks positions
%            
% 
% Return     : winner --> [peak, position peak]
% 
% Examples of Usage: 
% 
%  [ winner ] = PrimaryPeaks( posPeaks,peaks )
%

     vThr = max(peaks)*0.9;
     pos = find(peaks>vThr);
     winner(1) = posPeaks(pos(1));
     winner(2) = peaks(pos(1));
     
end

