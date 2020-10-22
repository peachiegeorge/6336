function x = GenSteadyStateVec(P, seed)
    x = cell(P,1);
    
    rng(seed);
    rand_e = randi([0 20], 1, 4) * 10;
    rand_r = randi([0 20], 1, 4) * 10;
    
    x{1} = [6100; rand_e(1); 190; rand_r(1)];
    x{2} = [2500; rand_e(2); 350; rand_r(2)];
    x{3} = [7200; rand_e(3); 620; rand_r(3)];
    x{4} = [3400; rand_e(4); 860; rand_r(4)];
end