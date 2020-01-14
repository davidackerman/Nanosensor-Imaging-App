function [dataFill] = generateSummary(results)
%{
Generate the following vales and STD (if applicable) and display in GUI and export to file
> Number of ROIs
> Number of significant ROIs
> Mean peak dF/F
> Mean tau-on
> Mean tau-off
> Mean AUC
> Peak dF/F
%}
numRois = size(results.roiData,2);
numSigs = length(find([results.fitData(:).significance]));
pctSig = numSigs./numRois;
fitResults = [results.fitData(:).fitResults];
tau_on = mean(1./fitResults(:,3));
tau_on_std = std(1./fitResults(:,3));
tau_off = 1./fitResults(:,2);
tau_off_std = mean(1./fitResults(:,2));
meanAuc = mean([results.roiData(:).auc]);
meanAuc_std = std([results.roiData(:).auc]);
dFdetrend = reshape([results.roiData(:).dFdetrend],[],length(results.roiData(1).dFdetrend));
frameRate = results.imageStackInfo.frameRate;
stimFrame = results.imageStackInfo.stimFrame;
maxdFoverF = mean(max(dFdetrend(stimFrame:stimFrame+floor(3*frameRate)),[],2));
maxdFoverF_std = std(max(dFdetrend(stimFrame:stimFrame+floor(3*frameRate)),[],2));
%{
dataValues = {numRois numSigs pctSig tau_on tau_off...
    meanAuc maxdFoverF};
stdValues = {'-' '-' '-' tau_on_std tau_off_std meanAuc_std maxdFoverF_std};
%}
variableNames = {'ROI Total','Signif ROIs', 'Pct Sig ROIs',...
    'Mean t On','Mean t Off','Mean AUC','Mean Peak dF/F'};
dataFill = table({numRois;'-'},{numSigs;'-'},...
    {pctSig;'-'}, {tau_on;tau_on_std},...
    {tau_off;tau_off_std},{meanAuc;meanAuc_std},...
    {maxdFoverF;maxdFoverF_std},'VariableNames',variableNames);
end
