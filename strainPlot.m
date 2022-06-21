function [] = strainPlot(L,d_Comp,H,xy_bar,comp)
% PLOT STRAIN CONTOURS OF EACH ELEMENT
% Shape functions
syms xi real
syms eta real
sh(1) = 1/4 * (1-xi)*(1-eta);
sh(2) = 1/4 * (1+xi)*(1-eta);
sh(3) = 1/4 * (1+xi)*(1+eta);
sh(4) = 1/4 * (1-xi)*(1+eta);

% Expression for strains at Gauss points
disp = d_Comp';
disp = disp(:);
d1 = L*disp;
strains = H*d1;

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

% Selection of component and plot
Number = 100;
if comp == 1
    strain_xx = subs(strains(1),eta,eta_2);
    contourf(xx,yy,strain_xx,Number,'LineColor','none')
    title('Contours for \epsilon_{11}')
    xlabel('X (meters)')
    ylabel('Y (meters)')
end

if comp == 2
    strain_yy = subs(strains(2),xi,xi_2);
    contourf(xx,yy,strain_yy,Number,'LineColor','none')
    title('Contours for \epsilon_{22}')
    xlabel('X (meters)')
    ylabel('Y (meters)')

end

if comp == 3
    strain_xy = subs(strains(3),{eta,xi},{eta_2,xi_2});
    contourf(xx,yy,strain_xy,Number,'LineColor','none')
    title('Contour for \gamma_{12}')
    xlabel('X (meters)')
    ylabel('Y (meters)')
end

end

