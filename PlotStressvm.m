% PLOT VON MISES STRESS BASED ON STORED INFO (.mat)
% Matrix of elastic constants
D = (E / (1-v^2)) * [1, v, 0;v, 1, 0;0, 0, (1-v)/2];
figure
for i = 1:size(Ele_Nodes,2)/2
    
    L = elLmat(i,Pos_Global,S);
    H = H_els{i};
    xy_bar = Ele_Nodes(:,i*2-1:i*2);
    stressVMPlot(L,d_Comp,H,xy_bar,D)
    hold on
    
end
set(gca, 'YDir','reverse')
colorbar