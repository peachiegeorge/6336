function [maxS, maxE, maxI, maxR] = getMaxSEIR(x)
   
    maxX = max(x,[],2);

    maxS = maxX(1);
    maxE = maxX(2); 
    maxI = maxX(3);
    maxR = maxX(4);
end
