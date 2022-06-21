function [] = stressVMPlot(L,d_Comp,H,xy_bar,D)
% PLOT VON MISES STRESS CONTOUR OF EACH ELEMENT
% Shape functions
syms xi real
syms eta real
sh(1) = 1/4 * (1-xi)*(1-eta);
sh(2) = 1/4 * (1+xi)*(1-eta);
sh(3) = 1/4 * (1+xi)*(1+eta);
sh(4) = 1/4 * (1-xi)*(1+eta);

% Expression for stresses at Gauss points
disp = d_Comp';
disp = disp(:);
d1 = L*disp;
strains = H*d1;
stress = D*strains; % Strains var name used for stresses

% Neccesary equations for Von Mises equivalent stress
sigma_1 = (stress(1)+stress(2))/2 + sqrt(((stress(1)-stress(2))/2)^2+stress(3)^2);
sigma_2 = (stress(1)+stress(2))/2 - sqrt(((stress(1)-stress(2))/2)^2+stress(3)^2);
sigma_vm = sqrt(sigma_1^2 + sigma_2^2-2*sigma_1*sigma_2);

% Evaluation and interpolation
xi_1 = -1:0.1:1;
eta_1 = -1:0.1:1;
SIZE1 = size(xi_1,2);
x_coord = sh*(xy_bar(1:4,1));
y_coord = sh*(xy_bar(1:4,2));
for i = 1:SIZE1
    
    x(i) = subs(x_coord,[xi,eta],[xi_1(i),eta_1(i)]);
    y(i) = subs(y_coord,[xi,eta],[xi_1(i),eta_1(i)]);
    
end
x = double(x);
y = double(y);
[xx,yy] = meshgrid(x,y);
[xi_2,eta_2] = meshgrid(xi_1,eta_1);

% Contour plot
Number = 100;
stress_VM = subs(sigma_vm,{eta,xi},{eta_2,xi_2});
contourf(xx,yy,stress_VM,Number,'LineColor','none')
title('Contours for \sigma_{VM}')
xlabel('X (meters)')
ylabel('Y (meters)')

end