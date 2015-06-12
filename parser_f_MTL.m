function [T,O,C,R,times,parts,NAMES,CLOUDS,TARGET_POINTS,...
    TARGET_CENTERS,TARGET_AXES,FRAMES] = parser_f_MTL(input)

%Nick Wong
%June 13, 2011
%Edited by Mike Lowry on 3/26/2014
%Parser - Parsing raw data into transformation matrices

% Assume file is in the following format, for 'n' number of components and 'm' timesteps:
% #    time  OriginXYZ_1  XYZ1_1  XYZ2_1  XYZ3_1  XYZ_1 ... XYZ1_n  XYZ2_n  XYZ3_n
% [1]   [1]    [1x4]      [1x4]   [1x4]  [1x4] ...

% MTL: Need to grab 4 points [1x4], because using cross-targets and not L shaped targets

% The result are the following matrices:
% T ('m' by 1) contains time
% C ('m' by 'n' (1x4)) contains the coordinates of the 4 target points
% R ('m' by 'n (4 x 4)) contains the rotation matricies and origins of the targets 
% 24 ('P') elements go into making 1 set of C for a certain m timestamps
% and n components.0


P = 24;
FRAMES = -1;

%input data
data = input.data;
%eliminate the zero rows
data(any(data==0,2),:)=[];

%Determine 'n' and 'm' for data set
times = size(data,1);
% n equals the number of columns minus the starting timestamp column divided by 12 columns per target, P
parts = (size(data,2)-2)/P;

%--------------------------------------------------------------------------
%ALLOCATE/POPULATE MATRICES
%T equals the entire second  column of data, the time stapms
%':' means all elements
T = data(:,2);

% create an array to house the origin points of the targets in camera space
O = zeros(3,1,times,parts);
% O(4,1,:,:) = 1;

% create a four dimensional zero matrix of X points
C = zeros(3,4,times,parts);

% create an empty four dimensional array to house rotation matricies and
% origin vectors of all objects at all time points
R = zeros(3,3,times,parts);

%Scan through positiong data for C matrices
% This nested for loop accumulates data from the input file
for a = 1:1:times 		% 'm' iterates each time point

    for b = 1:1:parts		% 'n' iterates each number of components (implants, bones, etc)
        % takes all rows and columns for each time point and component
        C(:,:,a,b) = [data(a,P*(b-1)+15) data(a,P*(b-1)+18) data(a,P*(b-1)+21) data(a,P*(b-1)+24);... %Grabs X values
                      data(a,P*(b-1)+16) data(a,P*(b-1)+19) data(a,P*(b-1)+22) data(a,P*(b-1)+25);... %Grabs Y values
                      data(a,P*(b-1)+17) data(a,P*(b-1)+20) data(a,P*(b-1)+23) data(a,P*(b-1)+26)];  %Grabs Z values

        R(:,:,a,b) = [data(a,P*(b-1)+6) data(a,P*(b-1)+7) data(a,P*(b-1)+8);... %Grabs R11 through R13
                      data(a,P*(b-1)+9) data(a,P*(b-1)+10) data(a,P*(b-1)+11);... %Grabs R21 through R23
                      data(a,P*(b-1)+12) data(a,P*(b-1)+13) data(a,P*(b-1)+14)];%Grabs R31 through R33 

        O(:,1,a,b) = [data(a,P*(b-1)+3);...
                      data(a,P*(b-1)+4);...
                      data(a,P*(b-1)+5)];

    end
end

NAMES = cell(parts);                %generate array to hold part names
CLOUDS = cell(parts);               %generate array to hold part points
TARGET_POINTS = cell(parts);        %generate array to hold target points
TARGET_CENTERS = cell(parts);       %generate array to hold target center
TARGET_AXES = cell(parts);          %generate array to hold target axes
if FRAMES == -1
    FRAMES = times;                 %dump times into frames
end

%% extract names of targets from data
% extracts the names for each object in the camera's tracking file
for a = 1:parts
    %Extract names from positioning file
    name = input.colheaders(3+24*(a-1)); %Adjust for 12 instead of 9 points per target
    name = char(name);
    name((end-1):end) = []; %format to remove ' X' and sim characters
    NAMES(a) = {name};
end