function [] = exportResults(app)
    %Save file containing all results of the timeseries image processing.
    %Save as .mat file and export df/f as csv/excel file. In the future,
    %maybe add functionality to create an analysis report containing plots
    %and other information summarizing the data.
    fileToSave = strcat(app.imageStackInfo.pathName,'/',app.imageStackInfo.fileName);
    results = app.results;
    save(strcat(fileToSave(1:end-4),'.mat'),'results','-v7.3');
    %Create array of dF/F values
    df = zeros(length(results.roiData(1).dFdetrend),length(results.roiData));
    for i=1:length(results.roiData)
        df(:,i)=results.roiData(i).dFdetrend;
    end
    writematrix(df,strcat(fileToSave(1:end-4),'.xlsx'),'Sheet','dF_F0 Detrend')
    
    outputImagePath = strcat(app.imageStackInfo.pathName,app.imageStackInfo.fileName(1:end-4));
    
    generateROIPlots(outputImagePath, results, app.dFFFrameEditField.Value, app.dFFFrameCheckBox.Value, app.PixelsmEditField.Value, app.dFFClipLowEditField.Value, app.dFFClipHighEditField.Value);
end
