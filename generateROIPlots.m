function [] = generateROIPlots(path, results, frame, doImageAtFrame, pixelSize)
    stimFrame = results.imageStackInfo.stimFrame;
    mask = results.roiMask;

    aucImage = nan(size(mask));
    dFFImage = nan(size(mask));
    zscoreImage = nan(size(mask));
    if doImageAtFrame
        dFFImageAtFrame = nan(size(mask));
    end
    
    for current_roi_data = results.roiData
        current_roi = current_roi_data.ROInum;
        aucImage(mask==current_roi) = current_roi_data.auc;
        
        [~, index] = max(current_roi_data.zscore(stimFrame:end));
        dFFImage(mask==current_roi) = current_roi_data.dF(stimFrame+index-1);
        zscoreImage(mask==current_roi) = current_roi_data.zscore(stimFrame+index-1);
        
        if(doImageAtFrame)
            dFFImageAtFrame(mask==current_roi) = current_roi_data.dF(frame);
        end
    end
    
    writeImage(aucImage,pixelSize, path+"_AUC",'AUC', 'AUC');
    writeImage(dFFImage,pixelSize, path+"_dF_max_zscore",'\DeltaF Max Zscore',"\DeltaF");
    writeImage(zscoreImage,pixelSize, path+"_max_zscore",'Max Zscore',"zscore");
    if(doImageAtFrame)
        writeImage(dFFImageAtFrame, pixelSize, path+"_dF_frame_"+num2str(frame),"\DeltaF Frame "+num2str(frame),"\DeltaF");
    end
end

function writeImage(outputImage, pixelSize, path, titleValue, colorLabel)
    fh = figure();
    ah = axes('parent',fh);
    h = imagesc(outputImage, 'parent',ah);
    set(ah,'TickLength',[0 0])
    
    pixelConversion = 1/pixelSize; %Convert pixels->microns 3.67 pix/um for 60X on Linda's rig
    width = size(outputImage,2);
    height = size(outputImage,1);
    
    tickInterval=10/pixelConversion;
    xticks(ah,tickInterval:tickInterval:width/pixelConversion);
    labels = (tickInterval:tickInterval:width/pixelConversion)*pixelConversion;
    xticklabels(ah,labels);
    yticks(ah,tickInterval:tickInterval:height/pixelConversion);
    labels = (tickInterval:tickInterval:height/pixelConversion)*pixelConversion;
    yticklabels(ah,labels);
    ylabel("\mum")
    xlabel("\mum")
    %set(fh,'InvertHardCopy',false);
    
    colormap(ah, jet)
    set(h,'alphadata',~isnan(outputImage));
    set(ah,'color','white')
    c = colorbar;
    title(titleValue)
    ylabel(c, colorLabel)
    saveas(fh,path,'epsc');
end