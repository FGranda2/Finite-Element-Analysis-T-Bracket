% PLOT ORIGINAL MESH AND DEFORMED STRUCTURE
% Original mesh
for ele = 1:size(Ele_Nodes,2)/2
    plot(Ele_Nodes(:,ele*2-1),Ele_Nodes(:,ele*2),'b-')
    hold on
end
% Closing line
plot(Cl(:,1),Cl(:,2),'b-')
hold on

% Deformed structure
for ele = 1:size(Ele_Nodes,2)/2
    plot(Ele_Nodes_New(:,ele*2-1),Ele_Nodes_New(:,ele*2),'r-')
    hold on
end
c1 = find(ismember(Nodes_Global,Cl1, 'rows'));
c2 = find(ismember(Nodes_Global,Cl2, 'rows'));
Cll = [Nodes_New(c2,1:2);Nodes_New(c1,1:2)];
plot(Cll(:,1),Cll(:,2),'r-')

set(gca, 'YDir','reverse')
title('Mesh With 522 Elements')
xlabel('X (meters)')
ylabel('Y (meters)')