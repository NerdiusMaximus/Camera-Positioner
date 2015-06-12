function varargout = CameraPositionerGui(varargin)
% CAMERAPOSITIONERGUI MATLAB code for CameraPositionerGui.fig
%      CAMERAPOSITIONERGUI, by itself, creates a new CAMERAPOSITIONERGUI or raises the existing
%      singleton*.
%
%      H = CAMERAPOSITIONERGUI returns the handle to a new CAMERAPOSITIONERGUI or the handle to
%      the existing singleton*.
%
%      CAMERAPOSITIONERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERAPOSITIONERGUI.M with the given input arguments.
%
%      CAMERAPOSITIONERGUI('Property','Value',...) creates a new CAMERAPOSITIONERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CameraPositionerGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CameraPositionerGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CameraPositionerGui

% Last Modified by GUIDE v2.5 08-Sep-2014 12:32:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CameraPositionerGui_OpeningFcn, ...
                   'gui_OutputFcn',  @CameraPositionerGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% --- Executes just before CameraPositionerGui is made visible.
function CameraPositionerGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CameraPositionerGui (see VARARGIN)
% Choose default command line output for CameraPositionerGui
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes CameraPositionerGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% --- Outputs from this function are returned to the command line.
function varargout = CameraPositionerGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% --- Executes on button press in importCameraData.
function importCameraData_Callback(hObject, eventdata, handles)
% hObject    handle to importCameraData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Run parser function on file user specifies
filename = uigetfile('*.txt','Select Camera Data File');
[data] = importfile(filename);
[T,O,C,R,times,parts,NAMES,CLOUDS,TARGET_POINTS,TARGET_CENTERS,TARGET_AXES,FRAMES] = parser_f_MTL(data);
set(handles.fileNameDisplay, 'string', filename);

set(handles.object1Name,'string',NAMES(1));
set(handles.object2Name,'string',NAMES(2));
% set(handles.object3Name,'string',NAMES(3));

%% Store Data for access by all functions
% use UserData field of the callback to store data in a structure for all
% other functions to use
parserData = struct('T',T,'O',O,'C',C,'R',R,'times',times,'parts',parts,'NAMES',NAMES);
%% set handle 'UserData' parameter for importCameraData to the data from the parser function
set(handles.importCameraData,'UserData',parserData);

% display(hObject,'UserData')
%% set buttons active
%Set mesh buttons
set(handles.importMesh1, 'enable', 'on');
set(handles.importMesh2, 'enable', 'on');
% set(handles.importMesh3, 'enable', 'on');

%set point cloud & plane buttons
set(handles.importCircular, 'enable', 'on');
set(handles.importPlane, 'enable', 'on');
set(handles.ObjectFixed2, 'enable', 'on');

%Set target buttons
set(handles.importTarget1, 'enable', 'on');
set(handles.importTarget2, 'enable', 'on');
% set(handles.importTarget3, 'enable', 'on');

%set coord buttons
set(handles.importCoords1, 'enable', 'on');
set(handles.importCoords2, 'enable', 'on');
% set(handles.importCoords3, 'enable', 'on');


% set(handles.parseTransformations, 'enable','on');

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', strcat('Camera Data imported successfully. There are ',...
                        int2str(parts),' objects in the file'));

%% --- Executes on button press in importTarget1.
function importTarget1_Callback(hObject, eventdata, handles)
% hObject    handle to importTarget1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[TARGET_POINTS(1), names] = targetImport(1);
set(handles.matchingTarget1, 'string', 'Target Imported');

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Target 1 imported successfully');
% display(cell2mat(TARGET_POINTS(1)))

target1.name = names;
target1.TARGET_POINTS = TARGET_POINTS;
set(handles.importTarget1, 'UserData', target1);

%% --- Executes on button press in importTarget2.
function importTarget2_Callback(hObject, eventdata, handles)
% hObject    handle to importTarget2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[TARGET_POINTS(2), names] = targetImport(1);
set(handles.matchingTarget2, 'string', 'Target Imported');

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Target 2 imported successfully');
% display(cell2mat(TARGET_POINTS(2)))

target2.name = names;
target2.TARGET_POINTS = TARGET_POINTS;
set(handles.importTarget2, 'UserData', target2);

%% --- Executes on button press in importTarget3.
function importTarget3_Callback(hObject, eventdata, handles)
% hObject    handle to importTarget3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[TARGET_POINTS(3), names] = targetImport(1);
set(handles.matchingTarget3, 'string', 'Target Imported');

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Target 3 imported successfully');
% display(cell2mat(TARGET_POINTS(3)))

target3.name = names;
target3.TARGET_POINTS = TARGET_POINTS;
set(handles.importTarget3, 'UserData', target3);

%% --- Executes on button press in importCoords1.
function importCoords1_Callback(hObject, eventdata, handles)
% hObject    handle to importCoords1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[TARGET_AXES(1),TARGET_CENTERS(1)] = coordImport(1);
set(handles.coords1Name, 'string', 'Coordinate Imported');

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Coordinate 1 imported successfully');

coords1.TARGET_AXES = TARGET_AXES;
coords1.TARGET_CENTERS = TARGET_CENTERS;

set(handles.importCoords1, 'UserData', coords1)

%% --- Executes on button press in importCoords2.
function importCoords2_Callback(hObject, eventdata, handles)
% hObject    handle to importCoords2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[TARGET_AXES(2),TARGET_CENTERS(2)] = coordImport(1);
set(handles.coords2Name, 'string', 'Coordinate Imported');

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Coordinate 2 imported successfully');

coords2.TARGET_AXES = TARGET_AXES;
coords2.TARGET_CENTERS = TARGET_CENTERS;

set(handles.importCoords2, 'UserData', coords2)

%% --- Executes on button press in importCoords3.
function importCoords3_Callback(hObject, eventdata, handles)
% hObject    handle to importCoords3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[TARGET_AXES(3),TARGET_CENTERS(3)] = coordImport(1);
set(handles.coords3Name, 'string', 'Coordinate Imported');

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Coordinate 3 imported successfully');

coords3.TARGET_AXES = TARGET_AXES;
coords3.TARGET_CENTERS = TARGET_CENTERS;

set(handles.importCoords3, 'UserData', coords3)

%% mesh import functions
%% --- Executes on button press in importMesh1.
function importMesh1_Callback(hObject, eventdata, handles)
% hObject    handle to importMesh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[stl_file, dir, MESH_V(1), MESH_F(1),MESH_N(1),MESH_C(1),MESH_TITLE(1)] = meshImport(1);
%display mesh file name in the mesh 1 item
set(handles.mesh1Name, 'string', stl_file);

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Mesh 1 imported successfully');

mesh1.name = stl_file
mesh1.dir = dir
mesh1.v = MESH_V
mesh1.f = MESH_F
mesh1.n = MESH_N
mesh1.c = MESH_C
mesh1.title = MESH_TITLE;
set(handles.importMesh1, 'UserData', mesh1)

%% --- Executes on button press in importMesh2.
function importMesh2_Callback(hObject, eventdata, handles)
% hObject    handle to importMesh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[stl_file,dir, MESH_V(2), MESH_F(2),MESH_N(2),MESH_C(2),MESH_TITLE(2)] = meshImport(1);
%display mesh file name in the mesh 1 item
set(handles.mesh2Name, 'string', stl_file);

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Mesh 2 imported successfully');

mesh2.name = stl_file;
mesh2.dir = dir;
mesh2.v = MESH_V;
mesh2.f = MESH_F;
mesh2.n = MESH_N;
mesh2.c = MESH_C;
mesh2.title = MESH_TITLE;
set(handles.importMesh2, 'UserData', mesh2)

%% --- Executes on button press in importMesh3.
function importMesh3_Callback(hObject, eventdata, handles)
% hObject    handle to importMesh3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[stl_file,dir, MESH_V(3), MESH_F(3),MESH_N(3),MESH_C(3),MESH_TITLE(3)] = meshImport(1);
%display mesh file name in the mesh 1 item
set(handles.mesh3Name, 'string', stl_file);

%output in dialog box to tell user what to do next
set(handles.dialogBox, 'string', '');
set(handles.dialogBox, 'string', 'Mesh 3 imported successfully');

mesh3.name = stl_file;
mesh3.dir = dir;
mesh3.v = MESH_V;
mesh3.f = MESH_F;
mesh3.n = MESH_N;
mesh3.c = MESH_C;
mesh3.title = MESH_TITLE;
set(handles.importMesh3, 'UserData', mesh3)

%% --- Executes on button press in parseTransformations.
function parseTransformations_Callback(hObject, eventdata, handles)
% hObject    handle to parseTransformations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Retrieve User Data from all the Handles
% Retrieve user data from all the other GUI Handles in the UserData
% category and save them in this callback in a structure to pass to the
% tranformation parsing function

transformData.cameraData = get(handles.importCameraData, 'UserData');

transformData.mesh1 = get(handles.importMesh1, 'UserData');
transformData.mesh2 = get(handles.importMesh2, 'UserData');
% transformData.mesh3 = get(handles.importMesh3, 'UserData');

transformData.circular = get(handles.importCircular, 'UserData');
transformData.plane = get(handles.importPlane, 'UserData');
transformData.fixed = get(handles.ObjectFixed2, 'Value');

transformData.target1 = get(handles.importTarget1, 'UserData');
transformData.target2 = get(handles.importTarget2, 'UserData');
% transformData.target3 = get(handles.importTarget3, 'UserData');

transformData.coord1 = get(handles.importCoords1, 'UserData');
transformData.coord2 = get(handles.importCoords2, 'UserData');
% transformData.coord3 = get(handles.importCoords3, 'UserData');

transformData.outputDir = get(handles.outputDirectory, 'UserData');

angles = get(handles.flexionAngles, 'string');
angles = eval(angles);
angles = angles';
transformData.angles = angles;


set(handles.parseTransformations, 'UserData', transformData)
% Dialog box to tell user that the data is being gathered
set(handles.dialogBox, 'string', 'Gathering Data...')

% %send data to transform script
doTransforms(hObject, handles, transformData);
% set(handles.dialogBox, 'string', 'Performing Transformations...')

% display(transformData);

%When the tranforms are finished, update dialog box
%set(handles.dialogBox, 'string', 'Transormations Complete.')

%Send transforms data structure to video creation gui thing
%dataAnalysis(transforms);

%% --- Executes on button press in chooseOutputDirectory.
function chooseOutputDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to chooseOutputDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Select Output Directory
% nfprintf('Select output directory:\n');
dirName = uigetdir;
%save in ...output/"timestep"/"part"
output = sprintf('%s',dirName);
%set the output directory to appear in the GUI
set(handles.outputDirectory, 'string', output)
set(handles.outputDirectory, 'UserData', output)
set(handles.dialogBox, 'string', '')
set(handles.dialogBox, 'string', 'Output Directory Set')

set(handles.parseTransformations, 'Enable', 'On');

%% Output Directory Clalback
function outputDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to outputDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of outputDirectory as text
%        str2double(get(hObject,'String')) returns contents of outputDirectory as a double

%% --- Executes during object creation, after setting all properties.
function outputDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

%% 
function flexionAngles_Callback(hObject, eventdata, handles)
% hObject    handle to flexionAngles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of flexionAngles as text
%        str2double(get(hObject,'String')) returns contents of flexionAngles as a double

%%
% --- Executes during object creation, after setting all properties.
function flexionAngles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flexionAngles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
% --- Executes on button press in importCircular.
function importCircular_Callback(hObject, eventdata, handles)
% hObject    handle to importCircular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = uigetfile('*.asc','Select point cloud file');
CircularPoints = transpose(importdata(filename));
set(handles.circularName, 'string', 'Circular Axis Imported');
set(handles.importCircular, 'UserData', CircularPoints);
% target1.name = names;
% target1.TARGET_POINTS = TARGET_POINTS;
% set(handles.importTarget1, 'UserData', target1);

%%
% --- Executes on button press in importPlane.
function importPlane_Callback(hObject, eventdata, handles)
% hObject    handle to importPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TibialPlane = importdata(uigetfile('*.txt','Select the tibial plane file'));
plane = [TibialPlane.data(1:3);TibialPlane.data(4:6)];
set(handles.planeName, 'string', 'Tibial Plane Imported');
set(handles.importPlane, 'UserData', plane);
% target1.name = names;
% target1.TARGET_POINTS = TARGET_POINTS;
% set(handles.importTarget1, 'UserData', target1);

%%
% --- Executes on button press in ObjectFixed2.
function ObjectFixed2_Callback(hObject, eventdata, handles)
% hObject    handle to ObjectFixed2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ObjectFixed2
