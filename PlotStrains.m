% PLOT STRAINS BASED ON STORED INFO (.mat)
figure
for i = 1:size(Ele_Nodes,2)/2
    
    L = elLmat(i,Pos_Global,S);
    H = H_els{i};
    xy_bar = Ele_Nodes(:,i*2-1:i*2);
    strainPlot(L,d_Comp,H,xy_bar,3)
    hold on
    
end
set(gca, 'YDir','reverse')
colorbar
