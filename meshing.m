function [Nodes_Global,Pos_Global,Ele_Nodes,Close1,Close2,sideB,A2] = meshing(N)
% Create mesh of structure
gen_nodes1 = [0,0;0,0.04;0.2,0.04;0.2,0];
[Ele_Nodes1,Nodes1,posNode1,A1,Total1] = nodeCoordinates(gen_nodes1,N);
gen_nodes2 = [0.08,0.04;0.08,0.1;0.120,0.1;0.120,0.04];
[Ele_Nodes2,Nodes2,posNode2,A2,Total2,sideB] = nodeCoordinates(gen_nodes2,N/4);

% Info for closing lines
test = A1+1;
test2 = A2+1;
Close1 = Ele_Nodes2(1,1:2);
Close2 = [min(Nodes2(:,1)),max(Nodes2(:,2))];

% Section junction and node organization
Nodes2(1:test2,:) = [];
Nodes_Global = [Nodes1;Nodes2];
test4 = posNode2+size(Nodes1,1)-test2;
test4(1:A2,1:2) = test4(1:A2,flip([3,4]))-round((test+test2)/2);
Pos_Global = [posNode1;test4];

% Elements nodes in global bracket
for i = 1:Total1+Total2
    
    Ele_Nodes(1:4,i*2-1:i*2) = Nodes_Global(Pos_Global(i,:),:);
    
end
end

