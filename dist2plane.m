function [pp dz] = dist2plane(po,C)
%% Function to calculate the distance from a point to a plane
%
% Val Schmidt
% CCOM/JHC
% 2012
%
% input: 
%   po:  nx3 matrix of point coordinates
%   C:   3x1 plane coeficient vector i.e.
%        zplane = C(1)*x+C(2)+C(3)
%
% output:
%   pp:  nx3 matrix of closest point coordinates
%   zz:  vector/matrix of closest distances from each point, po, to plane
%        C.

% The normal to the plane is given by the cross-product of any two vectors
% in the plane. 
a = [0 0 C(3)];
b = [1 1 sum(C)];
c = [0 1 C(2)+C(3)];
N = cross(a-b,a-c);

% A line passing through the point of interest that is also normal to the
% plane can be parameterized by pp = po+N*t, where Po is the point, N is the
% normal to the plane (the slope of this line) and t is a variable. That
% is:
% 
% ppx = pox + Nx*t
% ppy = poy + Ny*t
% ppz = poz + Nz*t
%
% Substituting, Lx, Ly and Lz into the equation for the plane gives
% 
% ppz = C(1)*ppx+C(2)*ppy+C(3)
% 
% Substituting the expressions above for ppx, ppy and ppz and solving for t
% gives this expression:
t = (po(:,3)-C(1).*po(:,1)-C(2)*po(:,2)-C(3)) ./...
    ( C(1).*N(1)+ C(2).*N(2)-N(3));

% The point on the plane closest to the point of interest, po, can be
% calculated from the expressions above.
pp = [po(:,1)+N(1).*t po(:,2)+N(2)*t po(:,3)+N(3)*t];

% Calculating the length of the difference in vectors to the two points
% gives the distance from the point to the plane along the normal.
dz = sqrt(sum((po-pp)'.^2));
