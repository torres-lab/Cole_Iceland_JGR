%% Load compiled data into matlab as a table
% load hydrochemical data
compiledWaterData = readtable('Iceland_CompiledWaterData.xlsx',...
    'Sheet','Table 1 -WaterCompilation-USE');
%load rock data
load('bsltRhyCulled.mat')
%load clay data
moulton = readtable('MoultonClayDataMolPercent.xlsx');
thorpe = readtable('thorpeClayData.xlsx'); 

%% Find indices associated with each WATER type
waterTypes = {'Glacial river','Non-glacial river','Multi-source river',...
    'Not classified river','Cold Spring','Groundwater well','Soil water',...
    'Lakewater','Hot spring','Rainwater'}; %excludes 'Ice' and 'Seawater'
waterTypeInd = cell(length(waterTypes),1); %pre-allocation
for m = 1:length(waterTypes) %for each target class
    waterTypeInd{m} = find(ismember(compiledWaterData.Type_Modified,...
        waterTypes{m}) == 1); 
end

%% QC WATER data for missing concentrations & rough charge balance
% get the column numbers for the concentration variables of interest
concVars = {'Cl_umolL','SO4_umolL','Na_umolL','K_umolL',...
    'Ca_umolL','Mg_umolL','Si_umolL'};
concDataQC = cell(length(waterTypes),1);
waterTypeIndQC = cell(length(waterTypes),1);
for m = 1:length(waterTypes) %for each target class
    %pre-allocate matrix for concentration data
    testData = zeros(length(waterTypeInd{m}),length(concVars));
    for mm = 1:length(concVars) %populate matrix with concentration data
        % this doesnt need to be a loop, but loop easiest if using strings
        % for the elemental concentrations as opppose to column numbers
        testData(:,mm) = eval(strcat('compiledWaterData.',...
            concVars{mm},'(waterTypeInd{m})'));
    end
    %for each row, check if there are any NaNs or 0's.
    %also, compute cation charge - anion charge with uncertainty
    testData(testData==0) = NaN; %replace any 0's with NaN
    for mm = 1:length(waterTypeInd{m})
        if sum(isnan(testData(mm,:))) == 0 % if all the concs are present
            % compute cation charge minus anion charge and propogate error
            CatMinAn = sum(testData(mm,3:6) .* [1 1 2 2]) -...
                sum(testData(mm,1:2) .* [1 2]);      
            CatMinAnErr = sqrt(sum((0.05 .* testData(mm,1:6) .* [1 2 1 1 2 2]).^2));
            % if CatMinAn significantly less than 0, remove sample
            if m == 9  % accept all hotspring samples    
            elseif (CatMinAn + (2*CatMinAnErr)) < 0
                testData(mm,:) = NaN; %replace with NaN to remove
            else
            end
        elseif m == 10  % accept all rainwater samples
        else %sample is missing one or more concentrations
            testData(mm,:) = NaN; %replace with NaN to remove
        end
    end
    concDataQC{m,1} = testData(isfinite(testData(:,1)),:); %save the culled data
    waterTypeIndQC{m,1} = waterTypeInd{m}(isfinite(testData(:,1)));
end

%% convert WATER concentratios to sumspace
sumDataQC = cell(length(waterTypes),1);
for m = 1:length(waterTypes) %for each target class
    sumDataQC{m} = sumspace(concDataQC{m,1},[3 4 5 6]);
end

%% Group rivers and subsurface waters
AllRivC = [concDataQC{1};concDataQC{2};concDataQC{3};concDataQC{4}];
AllRivS = [sumDataQC{1};sumDataQC{2};sumDataQC{3};sumDataQC{4}];
AllRivInd =[waterTypeIndQC{1};waterTypeIndQC{2};waterTypeIndQC{3};waterTypeIndQC{4}];
AllSubC = [concDataQC{5};concDataQC{6};concDataQC{7}];
AllSubS = [sumDataQC{5};sumDataQC{6};sumDataQC{7}];
AllSubInd =[waterTypeIndQC{5};waterTypeIndQC{6};waterTypeIndQC{7}];

%find rivers with Sr & Ca isotopes
Ca44IsoInd = find(isfinite(compiledWaterData.d44_40Ca(AllRivInd)));
Ca42IsoInd = find(isfinite(compiledWaterData.d44_42Ca(AllRivInd)));
IsoInd = [Ca44IsoInd;Ca42IsoInd];
compiledWaterData.d44_40Ca(AllRivInd(Ca42IsoInd)) = ...
    (compiledWaterData.d44_42Ca(AllRivInd(Ca42IsoInd))-0.95).*2.099;

%% Process Clay Data
% Thorpe Data is in weight% oxide, convert to mol%
thorpeMol = [2 2 1 1 1].* thorpe{:,:}./[61.98 94.2 56.08 40.31 60.09];
% Moulton Data might be "contaminated by Cl, so correct it
moultonCor = moulton{:,1:4}-(moulton.Cl .*[0.857 0.018 0.019 0.098]);
moultonCor(:,5) = moulton.Si;
allClayData = [thorpeMol;moulton{:,1:5};moultonCor];
clayS(:,3:7) = sumspace(allClayData,1:4);

%% Process Basalt & Rhyolite Data
basDataS(:,3:7) = sumspace(table2array(basData),1:4);
rhyDataS(:,3:7) = sumspace(table2array(rhyData),1:4);

%% Calculate Amount-weighted rainwater concentrations
rainData = concDataQC{10,1};
rainDataInd = find(isfinite(rainData(:,2))==1);
rainData(:,7) = zeros(length(rainData(:,1)),1);    
rainMeans = zeros(9,1);
rainMin = zeros(9,1);
rainMax = zeros(9,1);
for m = 1:6
    rainMeans(m) = wmean(rainData(rainDataInd(2:end),m),...
        compiledWaterData.Discharge_km3_yr(waterTypeIndQC{10}(rainDataInd(2:end))));
	rainMin(m) = prctile(concDataQC{10,1}(:,m),25);
    rainMax(m) = prctile(concDataQC{10,1}(:,m),75);
end
rainMeans(9) = wmean(compiledWaterData.pH(waterTypeIndQC{10}(rainDataInd(2:end))),...
        compiledWaterData.Discharge_km3_yr(waterTypeIndQC{10}(rainDataInd(2:end))));
rainMin(9) = prctile(compiledWaterData.pH(waterTypeIndQC{10}(rainDataInd(2:end))),25);
rainMax(9) = prctile(compiledWaterData.pH(waterTypeIndQC{10}(rainDataInd(2:end))),75);

%% Separate hydrthermal by temperature
hothotInd = find(compiledWaterData.T_C(waterTypeIndQC{9})>=100);   
coldhotInd = find(compiledWaterData.T_C(waterTypeIndQC{9})<100); 

%% clear workspace of unnecessary variables
clearvars m mm CatMinAn CatMinAnErr concVars moulton ...
    moultonCor testData thorpe thorpeMol

