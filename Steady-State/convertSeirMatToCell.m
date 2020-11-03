function seirCell = convertSeirMatToCell(seirMat)
    [num_row, num_col] = size(seirMat);
    P = num_row/4;
    seirCell = transpose(num2cell((reshape(seirMat, P, 4)), 1));
end