function [] = generateROIPlots(path, results)
    
    stimFrame = results.imageStackInfo.stimFrame;
    mask = results.roiMask;

    aucImage = nan(size(mask));
    dFImage = nan(size(mask));
    for current_roi_data = results.roiData
        current_roi = current_roi_data.ROInum;
        aucImage(mask==current_roi) = current_roi_data.auc;
        
        [~, index] = max(current_roi_data.zscore(stimFrame:end));
        dFImage(mask==current_roi) = current_roi_data.dF(stimFrame+index-1);
    end
    
    writeImage(aucImage,path+"_AUC.tif",'AUC')
    writeImage(dFImage,path+"_dF.tif",'\DeltaF')

end

function writeImage(outputImage, path, titleValue)
    fh = figure();
    ah = axes('parent',fh);
    set(fh,'InvertHardCopy',false);
    
    h = imagesc(outputImage, 'parent',ah);
    colormap(ah, jet)
    set(h,'alphadata',~isnan(outputImage));
    set(ah,'color','black')
    c = colorbar;
    title(titleValue)
    %ylabel(c, colorlabel)
    saveas(fh,path);
end
