clear
% MESHING OF STRUCTURE
% Approx number of elements
N = 3000; % 40 390 3.5 minutes for 390[558 real els]
% Compute mesh
[Nodes_Global,Pos_Global,Ele_Nodes,Cl1,Cl2,sideB,A2] = meshing(N);

% PLOT UNDEFORMED SHAPE
% Close lines
Cl = [Cl2;Cl1];

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
d_Global2 = reshape(d_Global2,[2,size(Nodes_Global,1)-...
    size(zero_disp_nodes,1)/2])';

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
Scal_Factor = 10;
Nodes_New = Nodes_Global + d_Comp*Scal_Factor;
for i = 1:size(Ele_Nodes,2)/2
    
    Ele_Nodes_New(1:4,i*2-1:i*2) = Nodes_New(Pos_Global(i,:),:);
    
end
