function [ bufferpast,index,sum ] = PitchDomain( buffer,bufferpast,sum,index,LIMIT )
    
    indexTs=index-LIMIT(1);
    if indexTs<1
        indexTs=LIMIT(2)+indexTs;
    end
    sum=sum-[bufferpast(:,indexTs),bufferpast(:,index)];% remove the most ancient value from sum for TS
    
    bufferpast(:,index)=buffer;% add new buffer
    sum=bsxfun(@plus,sum,buffer);% add new buffer to the sum
    
    index=index+1;% update index
    if index>LIMIT% circular index put 1 if index superior to circular LIMIT
       index=1; 
    end

end

