function [stl_file, dir, MESH_V, MESH_F,MESH_N,MESH_C,MESH_TITLE] = meshImport(a)
%% Input mesh
% Prompt user to fetch the stl mesh for the a-th part and save the file
% name in stl_file, the dir in dir, and apply the filter index of *.stl
% and *.bstl so only stl and binary stl can be chosen
[stl_file, dir, ~] = uigetfile({'*.stl';'*.bstl'});
        
%% Parse mesh
[v, f, n, c, stltitle] = stlread(strcat(dir,stl_file));
% v contains the vertices for all triangles [3*n x 3].
% f contains the vertex lists defining each triangle face [n x 3].
% n contains the normals for each triangle face [n x 3].
% c is optional and contains color rgb data in 5 bits [n x 3].
% stltitle contains the title of the specified stl file [1 x 80].
MESH_V(a) = {v'}; %transposes the verticies into MESH_V(a)
MESH_F(a) = {f};
MESH_N(a) = {n'}; %Transposes the normal vectors into MESH_N(a)
MESH_C(a) = {c};
MESH_TITLE(a) = {stltitle};