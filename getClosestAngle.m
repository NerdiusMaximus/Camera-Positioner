function [ index ] = getClosestAngle(desiredAngles,data)
%getCloserAgnels Finds the closest values from one array within another
%   
%% Determine which angles are closest to the desired angles
index = [];

for i=1:size(desiredAngles,1)
    
    diff = abs(data - desiredAngles(i));
    closest = find(diff == min(diff));
    
      index = cat(1,index,closest);
end


end
