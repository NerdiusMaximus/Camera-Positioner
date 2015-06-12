function writeTrm(T, filename)
%writeTrm Writes Geomagic Readable Tranformation Matrix File 
%   Takes in a 4 x 4 matrix and writes a text file in the format for
%   GeoMagic and Rapodform and other software to read

%% Write transformation matricies to a file
%write fileHeader
strArray = java_array('java.lang.String',6);
strArray(1) = java.lang.String('[VERSION] 1');
strArray(2) = java.lang.String('[TRANSFORM_NUM] 1');
strArray(3) = java.lang.String('[NAME] ACS');
strArray(4) = java.lang.String('[ANCHOR]');
strArray(5) = java.lang.String('0.0000000000000000 0.0000000000000000 0.0000000000000000');
strArray(6) = java.lang.String('[MATRIX_DATA]');
fileHeader = cell(strArray);

%Write Rapidform Readable Transformation Matrix File
dlmcell(filename,fileHeader);
dlmwrite(filename,T,'-append','delimiter',' ','precision','%16f','newline','pc');

end

