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
sigIndex = find([results.fitData(:).significance]);
numSigs = length(sigIndex);
pctSig = numSigs./numRois;
fitResults = reshape([results.fitData(:).fitResults].',4,[])';
tau_on = nanmean(1./fitResults(:,3));
tau_on_std = nanstd(1./fitResults(:,3));
tau_off = nanmean(1./fitResults(:,2));
tau_off_std = nanstd(1./fitResults(:,2));
meanAuc = nanmean([results.roiData(sigIndex).auc]);
meanAuc_std = nanstd([results.roiData(sigIndex).auc]);
dFdetrend = reshape([results.roiData(sigIndex).dFdetrend].',length(results.roiData(1).dFdetrend),[])';
frameRate = results.imageStackInfo.frameRate;
stimFrame = results.imageStackInfo.stimFrame;
maxdFoverF = nanmean(max(dFdetrend(:,stimFrame:stimFrame+floor(3*frameRate)),[],2));
maxdFoverF_std = nanstd(max(dFdetrend(:,stimFrame:stimFrame+floor(3*frameRate)),[],2));
%{
dataValues = {numRois numSigs pctSig tau_on tau_off...
    meanAuc maxdFoverF};
stdValues = {'-' '-' '-' tau_on_std tau_off_std meanAuc_std maxdFoverF_std};
%}
variableNames = {'ROI Total','Signif ROIs', 'Pct Sig ROIs',...
    'Mean t On (s)','Mean t Off (s)','Mean AUC','Mean Peak dF/F'};
dataFill = table({numRois;'-'},{numSigs;'-'},...
    {pctSig;'-'}, {tau_on;tau_on_std},...
    {tau_off;tau_off_std},{meanAuc;meanAuc_std},...
    {maxdFoverF;maxdFoverF_std},'VariableNames',variableNames);
end
