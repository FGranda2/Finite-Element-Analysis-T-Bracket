function [L] = elLmat(j,Pos_Global,S)
% Compute L matrix of element
L = zeros(8,S);
L(1,2*Pos_Global(j,1)-1) = 1;
L(2,2*Pos_Global(j,1)) = 1;

L(3,2*Pos_Global(j,2)-1) = 1;
L(4,2*Pos_Global(j,2)) = 1;

L(5,2*Pos_Global(j,3)-1) = 1;
L(6,2*Pos_Global(j,3)) = 1;

L(7,2*Pos_Global(j,4)-1) = 1;
L(8,2*Pos_Global(j,4)) = 1;
L = sparse(L);
end

