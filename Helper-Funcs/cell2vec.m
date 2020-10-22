function v = cell2vec(C, dir)
% Simple function to vectorize a cell array into a column vector
% dir is either 1 to vectorize along row or 2 or vectorize along columns of
% [C{:}], e.g. 1 gives [S1; E1; I1; R1; ...] and 2 gives
% [S1; S2; S3; S4; E1; E2; E3; E4...]
if dir == 1
    tmp = [C{:}];
elseif dir == 2
    tmp = [C{:}]';
else
    disp('Not a valid direction; set 1 or 2 for row or col');
end
v = tmp(:);
end