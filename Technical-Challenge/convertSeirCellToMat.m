function seirMat = convertSeirCellToMat(seirCell)
    [num_row, num_col] = size(seirCell);
    P = num_row;
    seirMat = reshape(cell2mat(seirCell), [4*P, 1]);
end