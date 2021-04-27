function [roiMask]=generateGrid(app)%Generate grid of ROIs
gridSize=app.imageStackInfo.gridSize;
height = app.imageStackInfo.height;
width = app.imageStackInfo.width;
roiMask = zeros(height,width,'uint16');
minimumRoiArea = 0.7*gridSize*gridSize;

columnAdjuster = 0;
for column = 1:width
   for row = 1:height
       roiLabel = (floor((row-1)/gridSize)+1) + columnAdjuster;
       roiMask(row,column) = roiLabel;
   end
   
   if mod(column,gridSize)==0
       columnAdjuster=roiLabel;
   end
end

for currentRoi = 1:max(roiMask(:))
    currentRoiPixels = roiMask==currentRoi;
    if sum(currentRoiPixels(:)) < minimumRoiArea
        roiMask(currentRoiPixels) = 0;
    end
end

drawGrid(roiMask,app.UIAxes);

end
