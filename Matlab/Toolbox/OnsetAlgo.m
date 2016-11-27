function [ poschange,booldif ] = OnsetAlgo(aco,NWIN,booldif,ii,nmbr )
% [ poschange,booldif ] = Onset(aco,NWIN )
% 
% Author1: Samuel Dupont
% Date:    November 2016 
% 
% Function   : Onset 
% 
% Description: Used on a vector of musical note it send back the beginning of the note,
%              this program must be a part of a loop, where short vector
%              are sent to the function
%              
% 
% Parameters : aco              - vector of the squared rms value
%                                 containing past frame and current
%              NWIN             - Constant of the number of point in the frame (ans past)
%              booldif          - boolean value for detection (0 at the first time)
% 
% Return     : booldif          - boolean value for detection
%              poschange        - pos of the note if there or empty
%         
% 
% Examples of Usage: 
% 
% [ posPeak, peak ] = PeakPicking( input )
%

    poschange=0;

    if mean(aco(ii-nmbr:ii-1))<mean(aco(ii-nmbr:ii)) && aco(ii)/aco(ii-1)>1.4 && aco(ii)>0.002552
        if booldif==0
            poschange = (ii) * NWIN-NWIN/2;
        end

        booldif=1;

        else if mean(aco(ii-nmbr:ii-1)) > mean(aco(ii-nmbr:ii)) &&  booldif==1
                booldif = 0;
             end
    end

end

