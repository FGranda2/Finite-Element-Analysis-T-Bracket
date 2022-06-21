function [K,H] = elKmat(E,v,t,xy_bar)
% Compute K matrix of each element
% Plane Stress D
D = (E / (1-v^2)) * [1, v, 0;v, 1, 0;0, 0, (1-v)/2];
syms xi real
syms eta real

% Jacobian
J = 1/4 * [eta-1,1-eta,1+eta,-1-eta;xi-1,-xi-1,1+xi,1-xi]*xy_bar;
det_J = det(J);
J_inv = inv(J);

% H star matrix
GN = 1/4*[eta-1,1-eta,1+eta,-1-eta;xi-1,-xi-1,1+xi,1-xi];
H_star = J_inv * GN;

% H matrix
H = [H_star(1,1),0,H_star(1,2),0,H_star(1,3),0,H_star(1,4),0;...
     0,H_star(2,1),0,H_star(2,2),0,H_star(2,3),0,H_star(2,4);...
     H_star(2,1),H_star(1,1),H_star(2,2),H_star(1,2),H_star(2,3),...
     H_star(1,3),H_star(2,4),H_star(1,4)];

% Evaluation of the integral we will need two Gauss points and weights:
eta_i = [1/sqrt(3), -1/sqrt(3)];
xi_i = [1/sqrt(3), -1/sqrt(3)];
w_i = [1,1];
counter = 1;
I = cell(4, 1) ;
for i = 1:2
    
    for j = 1:2
        
        HH = subs(H,[xi,eta],[xi_i(i),eta_i(j)]);
        HH = sparse(double(HH));
        det_JJ = subs(det_J,[xi,eta],[xi_i(i),eta_i(j)]);
        I{counter} = w_i(i)*w_i(j)*det_JJ*HH.'*D*HH;
        counter = counter + 1;
        
    end
    
end
K = I{1}+I{2}+I{3}+I{4};

% Inclusion of thickness of plate
K = K*t;
K = double(K);
K = sparse(K);
end