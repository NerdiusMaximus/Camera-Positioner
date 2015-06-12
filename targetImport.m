function [TARGET_POINTS, target_point_names] = targetImport(a)
    %% Query user to select file name 
    %Input target point file WITH Geomagic Headers from Ref Point, Named as
    %per Claron Camera API
    filename = uigetfile('*_Point.txt','Select Camera Data File');
    [data] = importfile(filename);
    
    %% Grab target point names from the textdata section of the GEOMAGIC file
        
    target_point_names = data.textdata(2:5,2)';
        
    %% import target point data
    TARGET_POINTS(a) = {data.data(1:4,1:3)'}; %convert to [X1 X2 X3 X4; Y1 Y2 Y3 Y4; Z1 Z2 Z3 Z4]
    