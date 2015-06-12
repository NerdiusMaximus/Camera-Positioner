function [ index ] = getClosestAngle(desiredAngles,data)
%getCloserAgnels Finds the closest values from one array within another
%   
%% Determine which angles are closest to the desired angles
index = [];

for i=1:size(desiredAngles,1)
 
    diff = abs(data - desiredAngles(i));
%     diff = sgolayfilt(diff,3,41);
    DataInv = 1.01*max(diff) - diff;
    minpeakheight = 1.01*max(diff) - 9; 
    minpeakdistance = size(data,1)-1;
    
    [Minima,MinIdx] = findpeaks(DataInv,'MINPEAKHEIGHT',minpeakheight,...
        'MINPEAKDISTANCE',minpeakdistance);
      index = cat(1,index,MinIdx);
   
      
end

end
