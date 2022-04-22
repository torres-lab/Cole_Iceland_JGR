function conHull95(dataT,linClr)
dataTxCI = prctile(dataT(:,1),[1 99]);
dataT(dataT(:,1)<dataTxCI(1),:) = NaN;
dataT(dataT(:,1)>dataTxCI(2),:) = NaN;

dataTyCI = prctile(dataT(:,2),[1 99]);
dataT(dataT(:,2)<dataTyCI(1),:) = NaN;
dataT(dataT(:,2)>dataTyCI(2),:) = NaN;

dataT = dataT(isfinite(dataT(:,1)),:);

[k,~] = convhull(dataT);
plot(dataT(k,1),dataT(k,2),'-','color',linClr,'linewidth',2)
