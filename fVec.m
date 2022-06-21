function [f] = fVec(sideB,S,A2)
% Computes force vector
% Distributed load
fa = 5000; % Newtons
t = 0.0025; %m
area = 0.04*t;
fa = fa/area;

% Contribution of each node
fy_edge = fa*t*sideB/2;
fy_in = fa*t*sideB;
f = zeros(1,S);
nodes_f = A2+1;

% Organization and forming of vector
for i = S:-2:1+S-nodes_f*2
    
    if i == 2+S-nodes_f*2
        f(i) = fy_edge;
    elseif i == S
        f(i) = fy_edge;
    else
        f(i) = fy_in;
    end
    
end
end

