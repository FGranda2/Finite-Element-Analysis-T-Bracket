function [Ele_Nodes,Total] = nodeCoordinates2(gen_nodes1,N,impSide)
x_side = max(gen_nodes1(:,1))-min(gen_nodes1(:,1));
y_side = max(gen_nodes1(:,2))-min(gen_nodes1(:,2));
gen_area1 = x_side*y_side;
syms s real
%N = 10;
eqn1 = N*s^2 == gen_area1;
solu = solve(eqn1,s);
solu = double(solu);
solu = solu(solu>0);
ax = x_side/solu;
by = y_side/solu;
A = x_side/impSide
B = ceil(by);
el_sidex = impSide
el_sidey = gen_area1/(N*impSide)
x_vert = min(gen_nodes1(:,1)):el_sidex:max(gen_nodes1(:,1));
y_vert = min(gen_nodes1(:,2)):el_sidey:max(gen_nodes1(:,2));
% Obtain node coordinates anticlockwise for element
for j = 1:1:(B+1)
    for i = 1:1:(A+1)
        
        cord=(A+1)*(j-1)+i;    
        Nodes(cord,1)=x_vert(i);
        Nodes(cord,2)=y_vert(j);  
        
    end
end

% Determine each node of each element
for j = 1:1:B
    for i = 1:1:A
        
        pos=A*(j-1)+i;    
        posNode(pos,1)=(A+1)*(j-1)+i;
        posNode(pos,2)=(A+1)*(j-1)+i+1;
        posNode(pos,3)=(A+1)*j+i+1;
        posNode(pos,4)=(A+1)*j+i;
        
    end
end

% Recover coordinates of each node in each element
for i = 1:A*B
    
    Ele_Nodes(1:4,i*2-1:i*2) = Nodes(posNode(i,:),:);
    
end
Total = A*B;
end