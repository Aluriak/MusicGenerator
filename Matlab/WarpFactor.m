function [ warp ] = WarpFactor(  posPeaks,winnerLast,warpLast )
% [ warp ] = WarpFactor( peaks, posPeaks,winnerLast,warpLast )
% 
% Author1: Samuel Dupont
% Date:    November 2016 
% 
% Function   : WarpFactor 
% 
% Description: Calculate warp factor for warped agregate lag domain
%              
%              This based on the work :
%              McLeod, Philip. "Fast, accurate pitch detection tools
%                 for music analysis."
%                 Academisch proefschrift, University of Otago.
%                 Department of Computer Science (2009).
% 
% Parameters :  posPeaks     -vector of peaks positions
%            
% 
% Return     : posPeaks -->           vector of position peaks
%              winnerLast -->       [peak, position peak] of last buffer frame
%              warpLast -->       last warp factor
% 

 warp=posPeak(closest(winnerLast(1),posPeaks))/winnerLast(1)*warpLast;
end

