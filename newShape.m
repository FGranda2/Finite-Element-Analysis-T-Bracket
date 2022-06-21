clear
% MESHING OF STRUCTURE
% Approx number of elements
N = 390; % 40 390 3.5 minutes for 390[558 real els]
% Compute mesh
[Nodes_Global,Pos_Global,Ele_Nodes,Cl1,Cl2,sideB,A2] = meshing2(N);

% PLOT UNDEFORMED SHAPE
% Close lines
Cl = [Cl2;Cl1];
% Figure plot

figure
for ele = 1:size(Ele_Nodes,2)/2
    plot(Ele_Nodes(:,ele*2-1),Ele_Nodes(:,ele*2),'b-')
    %text(Ele_Nodes(1,ele*2-1),Ele_Nodes(1,ele*2),num2str(ele))
    hold on
end
plot(Cl(:,1),Cl(:,2),'b-')
%{
% Plot nodes
N = Nodes_Global';
N = N(:);
N = N';
for ele = 1:size(Nodes_Global,1)
    text(N(1,ele*2-1),N(1,ele*2),num2str(ele))
    hold on
end
%set(gca, 'YDir','reverse')
%}
% GLOBAL K MATRIX
E = 70*10^9; %GPa
v = 0.3;
t = 0.0025; %m
S = size(Nodes_Global,1)*2;
for ele = 1:size(Ele_Nodes,2)/2
    xy_bar = Ele_Nodes(:,ele*2-1:ele*2);
    %K{ele} = elKmat(E,v,t,xy_bar);
    [K,H] = elKmat(E,v,t,xy_bar);
    L = elLmat(ele,Pos_Global,S);
    H_els{ele} = H; 
    if ele == 1
        KF = L.' * K * L;
    else
        KF = KF + L.' * K * L;
    end
end

% FORCE VECTOR
f = fVec(sideB,S,A2);

% FIND NODES WITH ZERO-DISPLACEMENT
left_C = ismember(Nodes_Global(:,1),0);
idx1 = find(left_C);
right_C = ismember(Nodes_Global(:,1),0.2);
idx2 = find(right_C);
zero_disp_nodes = [idx1;idx2];
zero_disp_nodes = [zero_disp_nodes*2-1;zero_disp_nodes*2];

% DELETE ROWS AND COLUMS FROM KF AND f
f(zero_disp_nodes) = [];
KF(zero_disp_nodes,:) = [];
KF(:,zero_disp_nodes) = [];

% SOLVE LINEAR SYSTEM
d_Global = f/KF; 
d_Global2 = d_Global(:);
d_Global2 = reshape(d_Global2,[2,size(Nodes_Global,1)-size(zero_disp_nodes,1)/2])';

% CREATE COMPLETE VECTOR OF DISPLACEMENTS
val = 1:1:size(Nodes_Global,1);
counter = 1;
for i = 1:size(Nodes_Global,1)
    node_val(counter) = val(i);
    counter = counter + 1;
    node_val(counter) = val(i);
    counter = counter + 1;
end
node_val(zero_disp_nodes) = [];
test = node_val(:);
test2 = reshape(test,[2,size(Nodes_Global,1)-size(zero_disp_nodes,1)/2])';
d_Comp(test2(:,1),1:2) = d_Global2; 

% FORM NEW ELEMENTS WITH DISPLACEMENT
Nodes_New = Nodes_Global + d_Comp*1000000;
for i = 1:size(Ele_Nodes,2)/2
    
    Ele_Nodes_New(1:4,i*2-1:i*2) = Nodes_New(Pos_Global(i,:),:);
    
end

% PLOT STRUCTURE WITH DISPLACEMENTS
%{
figure
for ele = 1:size(Ele_Nodes,2)/2
    plot(Ele_Nodes_New(:,ele*2-1),Ele_Nodes_New(:,ele*2),'b-')
    %text(Ele_Nodes(1,ele*2-1),Ele_Nodes(1,ele*2),num2str(ele))
    hold on
end
c1 = find(ismember(Nodes_Global,Cl1, 'rows'));
c2 = find(ismember(Nodes_Global,Cl2, 'rows'));
Cll = [Nodes_New(c2,1:2);Nodes_New(c1,1:2)];
plot(Cll(:,1),Cll(:,2),'b-')
%}

%{
% PLOT STRAINS 
figure
for i = 1:size(Ele_Nodes,2)/2
    
    L = elLmat(i,Pos_Global,S);
    H = H_els{i};
    xy_bar = Ele_Nodes(:,i*2-1:i*2);
    strainPlot(L,d_Comp,H,xy_bar,1)
    hold on
    
end

%}
% PLOT STRESSES
D = (E / (1-v^2)) * [1, v, 0;v, 1, 0;0, 0, (1-v)/2];
figure
for i = 1:size(Ele_Nodes,2)/2
    
    L = elLmat(i,Pos_Global,S);
    H = H_els{i};
    xy_bar = Ele_Nodes(:,i*2-1:i*2);
    stressPlot(L,d_Comp,H,xy_bar,D,1)
    hold on
    
end
colorbar

% PLOT VM STRESS
figure
for i = 1:size(Ele_Nodes,2)/2
    
    L = elLmat(i,Pos_Global,S);
    H = H_els{i};
    xy_bar = Ele_Nodes(:,i*2-1:i*2);
    stressVMPlot(L,d_Comp,H,xy_bar,D)
    hold on
    
end