function [clrData,geomeans] = clrtransform(data)
% geomeansRep = repmat(prod(data,2).^(1/length(data(1,:))),[1,length(data(1,:))]);
% clrData = log(data   ./  geomeansRep  );
% geomeans = geomeansRep(:,1);
geomeans = mean(log(data),2);
clrData = log(data) - geomeans;