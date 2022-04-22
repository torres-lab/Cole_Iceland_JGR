basEM = mean(basDataS);
rhyEM = mean(rhyDataS); %conc units
mixf = linspace(0,1)';
mixRR = (mixf.*basEM)+((1-mixf).*rhyEM);

%% Transform data
dataSclr = clrtransform([AllRivS(:,3:6);AllSubS(:,3:6)]);

%% perform PCA on clr Data
[coeff,score,latent,tsq,explained] = pca((dataSclr),'center','on','Algorithm','svd');

%% Projecting End-members into PCA space
rivDataPCA = (dataSclr-mean(dataSclr))*(coeff);
%
basclrPC = projIntoPCAclr(basDataS(:,3:6),mean(dataSclr),coeff);
basMclrPC = projIntoPCAclr(mean(basDataS(:,3:6)),mean(dataSclr),coeff);

RainclrPC = projIntoPCAclr(sumDataQC{10}(:,3:6),mean(dataSclr),coeff);

rhyMclrPC = projIntoPCAclr(mean(rhyDataS(:,3:6)),mean(dataSclr),coeff);
rhyclrPC = projIntoPCAclr(rhyDataS(:,3:6),mean(dataSclr),coeff);


hydclrPC = projIntoPCAclr(sumDataQC{9}(:,3:6),mean(dataSclr),coeff);
clayclrPC = projIntoPCAclr(clayS(:,3:6),mean(dataSclr),coeff);
mixRPC = projIntoPCAclr(mixRR(:,3:6),mean(dataSclr),coeff);

%%
figure(2)
clf
subplot(1,2,1)
hold on

%variable loadings
plot([0,coeff(1,1)],[0,coeff(1,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])
plot([0,coeff(2,1)],[0,coeff(2,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])
plot([0,coeff(3,1)],[0,coeff(3,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])
plot([0,coeff(4,1)],[0,coeff(4,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])

text(-0.55,0.8,'clr(K/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);
text(-0.96,-0.35,'clr(Na/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);
text(-0.26,-0.52,'clr(Ca/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);
text(0.51,-0.09,'clr(Mg/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);

%hydrothermal
plot(hydclrPC(hothotInd,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    hydclrPC(hothotInd,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'v','markerfacecolor',[0.6 0 0],'color',[0.6 0 0],'markersize',8)
plot(hydclrPC(coldhotInd,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    hydclrPC(coldhotInd,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'v','markerfacecolor','w','color',[0.6 0 0],'markersize',8)
%basaltic glass
plot(basclrPC(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    basclrPC(:,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'ks','markerfacecolor','k')
%rhyolites
plot(rhyclrPC(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    rhyclrPC(:,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'ks','markerfacecolor',[0.6 0.4 0.4],'color',[0.6 0.4 0.4])
% subsurface waters
plot(score(538:end,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    score(538:end,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'wd','markerfacecolor','b','markersize',11,'color','w','linewidth',1)
%river waters
plot(score(1:537,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    score(1:537,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'wo','markerfacecolor','b','color','w','markersize',10,'linewidth',1)
%rain
plot(RainclrPC(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    RainclrPC(:,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'k>','markerfacecolor','c','markersize',8,'color','k','linewidth',0.5)
%clay
plot(clayclrPC(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    clayclrPC(:,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'k^','color','k','markerfacecolor','y','markersize',12,'linewidth',1)

%plot details
makepretty_axes(strcat('PC1 (',num2str(round(explained(1))),'%)'),...
    strcat('PC2 (',num2str(round(explained(2))),'%)'))
%axis([-1.1 0.5 -0.4 0.6])
axis([-1 0.9 -0.6 0.9])

%axis('equal')

%%
rectangle('Position',[0 0.4 0.85 0.48],'FaceColor','w','EdgeColor','w')


pltPos = 0.42:0.06:0.90;
pltSyms = {'o','d','s','s','^','>','v','v'};
plotType = {'Rivers','Sub-surface waters','Basalt','Rhyolite','Clay',...
    'Rain','Hydrothermal (<100^{\circ}C)','Hydrothermal (>100^{\circ}C)'};
   

%%
subplot(1,2,2)
hold on
%variable loadings
plot([0,coeff(1,1)],[0,coeff(1,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])
plot([0,coeff(2,1)],[0,coeff(2,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])
plot([0,coeff(3,1)],[0,coeff(3,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])
plot([0,coeff(4,1)],[0,coeff(4,2)],'k-','linewidth',3,'color',[0.6 0.6 0.6])

text(-0.55,0.8,'clr(K/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);
text(-0.96,-0.35,'clr(Na/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);
text(-0.26,-0.52,'clr(Ca/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);
text(0.51,-0.09,'clr(Mg/\Sigma^c)','fontsize',16,'color',[0.6 0.6 0.6]);

scatter(score(538:end,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    score(538:end,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    140,compiledWaterData.pH(AllSubInd),'filled','marker','d','markeredgecolor','w')

scatter(score(1:537,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    score(1:537,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    150,compiledWaterData.pH(AllRivInd),'filled','markeredgecolor','w')

conHull95([rhyclrPC(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    rhyclrPC(:,2)./max(max(abs(score))).*max(max(abs(coeff)))],[0.6 0.4 0.4])

conHull95([basclrPC(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    basclrPC(:,2)./max(max(abs(score))).*max(max(abs(coeff)))],[0 0 0])

makepretty_axes(strcat('PC1 (',num2str(round(explained(1))),'%)'),...
    strcat('PC2 (',num2str(round(explained(2))),'%)'))
cax = colorbar;
axis([-1 0.9 -0.6 0.9])
cax.Label.String = 'pH';

%%
fSi = linspace(0,1,1001); %fraction of Si removal

% Clay Fractionation
clayEM1 = clayS(3,:);

mixRI = zeros(length(fSi),4); %pre-allocation
mixRI3 = zeros(length(fSi),4); %pre-allocation
mixVal = 51;
for m = 1:length(fSi)  
    mixRI(m,:) = (((1./mixRR(mixVal,7)).*mixRR(mixVal,3:6)) - ...
        (fSi(m).*((1./clayEM1(7)).*clayEM1(3:6))))./...
        ((1./mixRR(mixVal,7)) - ((1./clayEM1(7)).*fSi(m)));
    
    mixRI3(m,:) = (((1./mixRR(mixVal,7)).*mixRR(mixVal,3:6)) - ...
        (fSi(m).*((1./clayEM1(7)).*clayEM1(3:6))))./...
        ((1./mixRR(mixVal,7)) - ((1./clayEM1(7)).*fSi(m)));  
end
    MgCheck = find(mixRI(:,4)<0);
    KCheck = find(mixRI(:,2)<0);
    maxPlot = min([min(KCheck),min(MgCheck)])-1;
    
    MgCheck3 = find(mixRI3(:,4)<0);
    KCheck3 = find(mixRI3(:,2)<0);
    maxPlot3 = min([min(KCheck3),min(MgCheck3)])-1;
           
mixIclrPC = projIntoPCAclr(mixRI(1:maxPlot,1:4),mean(dataSclr),coeff);
mixIclrPC3 = projIntoPCAclr(mixRI3(1:maxPlot3,1:4),mean(dataSclr),coeff);
clayEMclrPC = projIntoPCAclr(clayEM1(3:6),mean(dataSclr),coeff);  

plot(mixIclrPC(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    mixIclrPC(:,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'k:','linewidth',2.5,'color','r')

plot(mixIclrPC3(:,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    mixIclrPC3(:,2)./max(max(abs(score))).*max(max(abs(coeff))),...
    'k:','linewidth',2.5,'color','r')

plot(clayEMclrPC(1,1)./max(max(abs(score))).*max(max(abs(coeff))),...
    clayEMclrPC(1,2)./max(max(abs(score))).*max(max(abs(coeff))),...
        'k^','color','k','markerfacecolor','y','markersize',12,'linewidth',1)