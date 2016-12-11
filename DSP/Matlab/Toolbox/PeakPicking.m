function [ posPeak, peak ] = PeakPicking( input )
% [ posPeak, peak ] = PeakPicking( input )
% 
% Author1: Samuel Dupont
% Author2: I worked alone  
% Date:    November 2016 
% 
% Function   : PeakPicking 
% 
% Description: Define primary peaks and their position on oscillating data,
%     one peak being defined by the maximum  between two zeros values  
%              
%              This based on the work :
%              McLeod, Philip. "Fast, accurate pitch detection tools
%                 for music analysis."
%                 Academisch proefschrift, University of Otago.
%                 Department of Computer Science (2009).
% 
% Parameters : input              - oscillating value like modified cepstrum
%            
% 
% Return     : vector of peaks and positions
% 
% Examples of Usage: 
% 
% [ posPeak, peak ] = PeakPicking( input )
%
 debut=1;
 test=0;
 posPeak=1;
 peak=0;
 TAILLE=length(input);
%  while(input(debut)>input(debut+10) && input(debut)>0)%locate first treshold
%     debut=debut+1;
%  end
 
 for i = debut:TAILLE
    
        if test==0
        
            if(input(i)>0)
                test=1;
                maxThr=input(i);
                pos=i;
            end
        else    
           if(input(i)>maxThr)          
               maxThr=input(i);
               pos=i;
           else if (input(i)<0)
           
               test=0;
               posPeak(end+1,1)=pos;
               peak(end+1,1)=maxThr;         
               end
           end
        end
 end
 %trick to add last cut peak, to do --> do something better
               posPeak(end+1,1)=pos;
               peak(end+1,1)=maxThr;  
               
 posPeak(1:2)='';
 peak(1:2)='';
 if posPeak(end)==TAILLE
    posPeak(end)='';
    peak(end)='';
 end

[posPeak,peak]= Interp3Peak(posPeak,input(posPeak-1),peak,input(posPeak+1));
%if posPeak<0



    

end

