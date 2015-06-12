function doTransforms(hObject,handles,transformData)
%% Function to perform coordinate transforms
% Transform math will line up the meshes to the camera coordinate positions
% for all objects at all points in time. 

%% Extract Data from structure
FRAMES = -1;

% determine # of parts
parts = transformData.cameraData.parts;
% determine number of time points
times = transformData.cameraData.times;

%Retrieve flexion angles
flexionAngles = transformData.angles;

% Camera Data
T = transformData.cameraData.T;
O = transformData.cameraData.O;
C = transformData.cameraData.C;
R = transformData.cameraData.R;

NAMES = cell(parts);                %generate array to hold part names
% CLOUDS = cell(parts);               %generate array to hold part points
TARGET_POINTS = cell(parts);        %generate array to hold target points
TARGET_CENTERS = cell(parts);       %generate array to hold target center
TARGET_AXES = cell(parts);          %generate array to hold target axes
if FRAMES == -1
    FRAMES = times;                 %dump times into frames
end
MESH_V = cell(parts);
MESH_F = cell(parts);
MESH_N = cell(parts);
MESH_C = cell(parts);
MESH_TITLE = cell(parts);

%% Take the data from handles
% %extract names
NAMES(1) = {transformData.mesh1.name};
NAMES(2) = {transformData.mesh2.name};
% NAMES(3) = {transformData.mesh3.name};
% extract verticies
MESH_V(1) = {transformData.mesh1.v};
MESH_V(2) = {transformData.mesh2.v};
% MESH_V(3) = {transformData.mesh3.v};
% extract faces
MESH_F(1) = {transformData.mesh1.f};
MESH_F(2) = {transformData.mesh2.f};
% MESH_F(3) = {transformData.mesh3.f};
% extract normals
MESH_N(1) = {transformData.mesh1.n};
MESH_N(2) = {transformData.mesh2.n};
% MESH_N(3) = {transformData.mesh3.n};
% extract colors
MESH_C(1) = {transformData.mesh1.c};
MESH_C(2) = {transformData.mesh2.c};
% MESH_C(3) = {transformData.mesh3.c};
% extract titles
MESH_TITLE(1) = {transformData.mesh1.title};
MESH_TITLE(2) = {transformData.mesh2.title};
% MESH_TITLE(3) = {transformData.mesh3.title};

%extract circular axis pts and tibial plane
CIRCULARPts = transformData.circular;
plane = transformData.plane;

%% Import Target Data
TARGET_POINTS(1) = transformData.target1.TARGET_POINTS(1);
TARGET_POINTS(2) = transformData.target2.TARGET_POINTS(2);
% TARGET_POINTS(3) = transformData.target3.TARGET_POINTS(3);
%% Import target axes
TARGET_AXES(1) = transformData.coord1.TARGET_AXES(1);
TARGET_AXES(2) = transformData.coord2.TARGET_AXES(2);
% TARGET_AXES(3) = transformData.coord3.TARGET_AXES(3);
%% Import Target Centers
TARGET_CENTERS(1) = transformData.coord1.TARGET_CENTERS(1);
TARGET_CENTERS(2) = transformData.coord2.TARGET_CENTERS(2);
% TARGET_CENTERS(3) = transformData.coord3.TARGET_CENTERS(3);


%% Take angles between the X axes of tibia and femur
% Extract X axis unit vector from rot matrix
XAxis = R(:,1,:,:);
% calculate the inv cos of the dot product to get the angle and convert to deg
angleData = acosd(dot(XAxis(:,:,:,1),XAxis(:,:,:,2)));
% convert to a n row by 1 column matrix
angleData = reshape(angleData,1,times)';

%% Determine which angles are closest to the desired angles
index  = getClosestAngle(flexionAngles,angleData);

% set frames to the size of the data to acquire
T = T(index);
times = size(T);
FRAMES = times;

fixed = transformData.fixed;
centerfix = mean(O(:,:,:,2),3);
orientationfix = mean(R(:,:,:,2),3);
%% adjust the data to only feed the perscribed angles
O = O(:,:,index,:);
R = R(:,:,index,:);
C = C(:,:,index,:);

angleData= angleData(index);

%% Perform transformations
%Save transformed mesh as ascii .stl file
output = transformData.outputDir;
cd(output); %IN .../output

%Format circular axis points and plane for transformation
p = [CIRCULARPts; ones(1,size(CIRCULARPts,2))];
planept = plane(1,:);
planen = plane(2,:);
planept = [transpose(planept);ones(1,size(planept,1))];
planen = [transpose(planen);ones(1,size(planen,1))];

APDistance = [];
for a = 1:FRAMES
    
    directory = sprintf('%d_deg_T_%d',round(angleData(a)),a); 
    mkdir(directory);
    cd(directory);       %IN .../output/'current timestep'
       
    for b = 1:parts
        %Retrieve part name and points
        %name = char(NAMES(b));
        v = cell2mat(MESH_V{b});
        n = cell2mat(MESH_N{b});
        f = cell2mat(MESH_F{b});
        c = cell2mat(MESH_C{b});
        stltitle = deblank(char(MESH_TITLE{b,1}{1,b}));
        
        %Format mesh normals and verticies for transfromation
        v = [v;ones(1, size(v,2))];
        n = [n;ones(1, size(n,2))];
        % THIS IS THE MEASURED CAMERA DATA
        
        if b == 1 | fixed == 0;
            center = O(:,:,a,b);
            orientation = R(:,:,a,b);
            dotrans = 1;
        elseif fixed == 1 & a == 1;
            center = centerfix;
            orientation = orientationfix;
            dotrans = 1;
        else
            dotrans = 0;
        end
        
        if dotrans == 1;
        %Create transform matrix
%       framePW = [target_axes, target_center; [0 0 0 1]];     %part relative to world
        frameTW = [orientation, center; [0 0 0 1]];    %position relative to camera
        
%       %Transform vertex and normals
%       v = frameTW*(framePW\[v; ones(1,size(v,2))]);
        v = frameTW * v;% USE IF USING Femur', etc
        v(4,:) = [];
        v = v';
%       n = frameTW*(framePW\[n; ones(1,size(n,2))]); %Use if needing to
%       find femur '
        n = frameTW * n; % USE IF USING Femur', etc
        n(4,:) = [];
        n = n';       
        
%% Save transformed coordinates in file 'part'.stl
        filename = sprintf('%s_%d_Deg_T_%d.stl',stltitle(1:end-4),round(angleData(a)),a);
        transfilename = sprintf('%s_%d_Deg_T_%d.trm',stltitle(1:end-4),round(angleData(a)),a);
        ptfilename = sprintf('%s_%d_Deg_T_%d.txt',stltitle(1:end-4),round(angleData(a)),a);
        
        
        fid = fopen(filename,'wt+');
        fprintf(fid,'solid %s\n',stltitle); 
        for i = 1:size(f,1)
            face = f(i,:);
            fprintf(fid,'facet normal %e %e %e\n',n(1,1),n(1,2),n(1,3));
            fprintf(fid,'outer loop\n');
            fprintf(fid,'vertex %e %e %e\n',v(face(1),1),v(face(1),2),v(face(1),3));
            fprintf(fid,'vertex %e %e %e\n',v(face(2),1),v(face(2),2),v(face(2),3));
            fprintf(fid,'vertex %e %e %e\n',v(face(3),1),v(face(3),2),v(face(3),3));
            fprintf(fid,'endloop\n');
            fprintf(fid,'endfacet\n');
        end
        
        fprintf(fid,'endsolid %s',stltitle);
        fclose(fid);
         %Transform circular axis if part is femur & transform tibial plane
         %if part is tibia
        if b == 1;
            P = frameTW * p;
            P(4,:) = [];
            P = P';
            dlmwrite(ptfilename,P);
        elseif a==1 && b==2;
            planept = frameTW*planept;
            planept = transpose(planept(1:3));
            planen = transpose(inv(frameTW))*planen;
            planen = transpose(planen(1:3));
            C = [-planen(1)/planen(3) -planen(2)/planen(3) ...
                (dot(planen,planept)/planen(3))];
            planepts = [planept; [0 0 C(3)]; [-1 -1 C(3)-C(2)-C(1)]];
            planename = sprintf('%s Plane.txt',stltitle(1:end-4));
            dlmwrite(planename,planepts,'delimiter','\t','precision','%.6f%');
        else
        end
        %% Update dialog boxes on UI
        dialog = fprintf('%s has been saved\n',filename);
        set(handles.dialogBox, 'string', dialog);
        guidata(hObject,handles);
        
        %% Write transformation matricies to a file
        writeTrm(frameTW,transfilename);
        
       
        
        
        
        %% Update dialog box on UI
        dialog = fprintf('%s transform matrix has been saved\n',transfilename);
        set(handles.dialogBox, 'string', dialog);
        guidata(hObject,handles);
        else
        end
        
    end
      %% Determine distance between circular axis and tibial plane
      [pp dz] = dist2plane(P,C);
      APDistance = [APDistance ; [round(angleData(a)) dz]];

      
    
    cd ..;          %IN .../output dir
end

dlmwrite('APDistances.txt',APDistance,'delimiter','\t','precision','%.6f%');

plot(APDistance(:,1),APDistance(:,2:3));
axis([0 135 0 30]);

cd ..; % in root directory

