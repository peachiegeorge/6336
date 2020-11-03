function fq = EVALFQ(x,p,u,q)
    
    fMat = convertSeirCellToMat(EVALF(x,p,u));
    xMat = convertSeirCellToMat(x);
    
    q_fMat = q*convertSeirCellToMat(EVALF(x,p,u));
    q_xMat = (1-q)*convertSeirCellToMat(x);

    fq = q*convertSeirCellToMat(EVALF(x,p,u)) + (1-q)*convertSeirCellToMat(x);
end