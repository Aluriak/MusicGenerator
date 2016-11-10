function [ xMin,fb ] = Interp3Peak(  b,fa,fb,fc )
% [ xMin,fb ] = Interp3Peak(  pos,fa,fb,fc )
% 
% Author1: Samuel Dupont
% Author2: I worked alone  
% Date:    November 2016 
% 
% Function   : Interp3Peak 
% 
% Description: Do interpolation around a defined peak with the two point around,
%              send back interpolated new peak and it interpoled location  
%              
%              This based on the work :
%              McLeod, Philip. "Fast, accurate pitch detection tools
%                 for music analysis."
%                 Academisch proefschrift, University of Otago.
%                 Department of Computer Science (2009).
% 
% Parameters : input              peak and two points around
%            
% 
% Return     : interpolated peak and position
% 
% Examples of Usage: 
% 
%  [ posD,fb ] = Interp3Peak(  pos,fa,fb,fc )
%
%use parabolic interpolation on 3 points to find the local minima
%http://fourier.eng.hmc.edu/e176/lectures/NM/node25.html
    a=b-1;
    c=b+1;
    num=(fa-fb).*( (c-b).^2 ) - (fc-fb).* ((b-a).^2);
    den=(fa-fb).*(c-b)+(fc-fb).*(b-a);
    xMin=b+0.5*num./den;


    fb=fa.*(xMin-b).*(xMin-c)./((a-b).*(a-c))+fb.*(xMin-a).*(xMin-c)./((b-c).*(b-a))+fc.*(xMin-a).*(xMin-b)./((c-a).*(c-b));
end

