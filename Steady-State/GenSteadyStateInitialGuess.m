function x = GenSteadyStateInitialGuess(P)

    %Intial guess as zero-vector
%     x = GenStateVec(P,"");
    
    seed = 1;
    x = GenSteadyStateVec(P, seed);
    
%     xMat = convertSeirCellToMat(x);
%     delta_x = transpose([-8517 718 76 1301 -8587 2274 862 2414 -25258 13500 1630 2220 -45682 24042 11191 5955]);
%     x = convertSeirMatToCell(xMat - delta_x);
    
%     [num_row, num_col] = size(x);
%     for i=1:num_row
%         for j=1:4
%            x{i}(j) = x{i}(j)/2;
%         end
%     end
    
    
end