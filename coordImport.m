function [TARGET_AXES,TARGET_CENTERS] = coordImport(a)
%% Coordinate input function
    %% Query user to select file name 
    %Input Coordinate system file WITH Geomagic Headers
    filename = uigetfile('*Coordinate.txt','Select Camera Data File');
    [target_coord] = importfile(filename);
%asign the target axes from the coordinate system *'
    TARGET_AXES(a) = {[target_coord.data(1,4:6);...
                      target_coord.data(1,7:9);...
                      target_coord.data(1,10:12)]'};    
                  
    %assign the center point of target points *'
    TARGET_CENTERS(a) = {(target_coord.data(1,1:3))'};

end