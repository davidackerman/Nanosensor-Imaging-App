function []=drawGrid(roiMask,axesSelection)
hold(axesSelection,'on')
roi_list = nonzeros(unique(roiMask));
mask = roiMask;
cidx = 0;
for roi_index=1:length(roi_list)
    roi = roi_list(roi_index);
    roi_mask = mask;
    roi_mask(roi_mask~=roi)=0;
    [B,L,~,~] = bwboundaries(roi_mask,'noholes');
    colors=['b' 'g' 'r' 'c' 'm' 'y'];
    cidx = mod(cidx,length(colors))+1; %Cycle through colors for drawing borders
    for k=1:length(B)
        boundary = B{k};
        plot(axesSelection,boundary(:,2), boundary(:,1),...
           colors(cidx),'LineWidth',1);
        s=regionprops(L,'Centroid');
        text(axesSelection,s.Centroid(1),s.Centroid(2),num2str(roi),'HorizontalAlignment','Center');
    end
end
hold(axesSelection,'off')
end
