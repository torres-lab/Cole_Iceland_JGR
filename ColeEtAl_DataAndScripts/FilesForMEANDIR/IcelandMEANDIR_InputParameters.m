%% IMPORTANT, to use with MEANDIR, these need to be pasted into the
% if statement in MEANDIR_FindScenarioParameters.m


%% MEANDIR parameters for inversion of Ca, Si, Mg, and Sr isotope ratios   
    Riverdatasource              = 'MyDefaultRiverData';                                                      % Name of source of the river data
    AdjustRiverObs               = 0;                                                                % Whether river measurements should be adjusted to reflect experimental uncertainty. Options are: 0 or 1
    ObsList                      = {'Na','K','Ca','Mg','Cl','SO4','Si','Sr','Sr8786','d44Ca','d26Mg','d30Si'};       % List of dissolved variables to include in the inversion
    CostFunType                  = {'rel','rel','rel','rel','rel','rel','rel','rel','rel','rel','rel','rel'};    % Whether each variable should be evaluated as proportional cost or absolute cost. Options are 'rel' and 'abs'.
    WeightingList                = [1    1    1    1    1    1    1    1      1      1  1   1];             % Weighting term for the cost function
    ErrorCutMinMB                = [80   80   80   80   80   80  80   80   -.002  -0.2 -0.2    -0.2];%?? remove if EM            % If IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    ErrorCutMaxMB                = [120  120  120  120  120  120  120  120   .002   0.2 0.2 0.2];            % If IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    nCFList                      = {};                                                               % List of dissolved variables (in ObsList) to not include in the cost function evaluation
    ConvertDelta2RList           = {'d44Ca','d26Mg','d30Si'};                                                        % List of isotopic variables (in delta notation) to be converted to isotopic ratios for the analysis (results are converted back to delta)
    AllIonsExplicitlyResolved    =  0;                                                               % Indicate if all cations and anions (all sources of charge) are resolved. Options are 0 or 1       
    ObsInNormalization           = {'Ca','Mg','Na','K','SO4'};                                       % List of which variables are included in the normalization
 	ImposeNormalizationCheck     = 1;                             % whether the normalization should be reproduced to the minimum and maximum values for non-isotopic variables 

    % (2/5) General simulation settings (8 variables)
    Solver                       = 'mldivide_optimize';                                              % Type of inversion solution, options are: 'mldivide', 'lsqnonneg', 'mldivide_optimize', 'lsqnonneg_optimize', 'optimize'. Enter as string, not a cell.
    IterateOver                  = 'Samples';  %endmembers                                                      % Whether to iterate over the same end-members to all sample ('End-members'), or different end-members to each sample ('Sample'). Options are: 'End-members', 'Samples'
    maxiterations                = 1e6; %NaN                                                              % If IterateOver is "Samples", this is the maximum number of inversion attempts 
    maxsuccess                   = 200;    %NaN                                                         % If IterateOver is "Samples", this is the desired number of successes     
    numberiterations             = NaN; %1000                                                              % If IterateOver is "End-members", this is the number of inversions to perform
    MisfitCuts                   = NaN; %100(percentage)                                                             % If IterateOver is "End-members", this percentage of simulations with lowest misfit between model result and data will be kept    
    CullOn                       = 'EachSample';                                                     % If IterateOver is "End-members", this must be either 'EachSample' or 'AllSample' and describes HOW to cull the data              
    saveuncutdata                = 0;                                                                % If 1, saves all the simulation data (results in very large files)        
  % (3/5) Information on end-members (12 variables)
    EMdatasource                 = 'II20_SumObs_uniform';                                            % The name of the end-member group (the entry on column A of the spreadsheet containing end-member information). 
    EMList0                      = {'prec','htsp','nsil','ksil','csil','msil','carb','clay','pyri'}; % List of the end-members to use in the inversion.     
    MinFractionalContribution    = [000 000 000 000 000 000 000 -inf 000];                           % The minumum fractional contribution of each end-member to the normalization ion (typically 0)
    MaxFractionalContribution    = [inf inf inf inf inf inf inf 0000 inf];                           % The maximum fractional contribution of each end-member to the normalization ion (should be 1, unless secondary mineral formation is involved) 
    ListNormClosure              = {'Na','K','Na','K','Ca','Mg','Ca','Mg','SO4'};                    % The ratio for each end-member that will be calculated by mass balance, not using the assigned distribution, when normalization is to SumObs
    ListChargeClosure            = {};                                                               % The ratio for each end-member that will be calculated by charge balance, not using the assigned distribution, when normalization is to SumObs
    EMUnits                      = 'conc';                                                           % Whether the end-member units are in concentration or equivilents. Options are: 'conc', 'equi'    
    EndMembersWithNegativeRatios = {};                                                               % End-members with negative chemical ratios    
    CoupleFeS2SO4intoEM          = {};                                                               % Determine whether a subset of end-members should have their SO4 ratios values overwritten and used to represent pyrite
    CoupleFeS2d34SintoEM         = {};                                                               % Determine whether a subset of end-members should have their d34S values overwritten and used to represent pyrite
    RecordFullFeS2Distribution   = 0;                                                                % Whether to record the full distribution of calculated FeS2 values, when d34S is not included in the inversion
    BalanceEvaporite             = 0;                                                                % Determine if evaporite SO4 = Ca+Mg and Cl = Na+K.
  % (4/5) Cl correction (2 variables)
    PrecProcessing               = 'EndMember';                                                      % Whether Cl should be treated as a common ion ('EndMember') or if there are Cl critical values ('ClCrit') Options are: 'EndMember', 'ClCrit'              
    ClCriticalValuesGiven        = 0;                                                                % Whether Cl critical values are given. If PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 1, those ClCritical values are used. If PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 0, 100% of river Cl is used.        
  % (5/5) Post-inversion R/Z/W/Y/C calculation settings (10 variables)
    CalculateRZCWY               = 1;                                                                % Whether model should attempt to calculate R, Z, C, W, and Y. Options are: 0 or 1
    R_Numerator_EMList           = {'carb'};                                                         % End-members that should contribute to the numerator of R
    R_Numerator_IonList          = {'Na','Ca','Mg','K'};                                             % Ions that should contribute to the numerator of R        
    Z_NumeratorType              = {'ZfromEM'};                                                      % How the numerator of Z (SO4 from FeS2) should be calculated. Options are: 'ZfromEM', 'ZfromSO4excess', 'ZfromriverSO4', 'Znotcalculated'
    Z_Numerator_EMList           = {'pyri'};                                                         % End-members that should contribute to the numerator of Z (only used if Z_NumeratorType = {'ZfromEM'}).   
    C_Numerator_EMList           = {};                                                               % End-member that should contribute to the numerator of C     
    RZC_Denominator_EMList       = {'nsil','ksil','csil','msil','carb'};                             % End-members that should contribute to the denominator of R and Z (weathering end-members)
    RZC_Denominator_IonList      = {'Na','Ca','Mg','K'};                                             % Ions that should contribute to the denominator of R and Z (weathering end-members)                    
    EMsources                  = {'pyri','prec','htsp','nsil','ksil','csil','msil','carb'};        % End-members that count as sources of dissolved constituents (typically rocks and other solute sources)
    EMsinks                    = {'clay'};      

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   
       
%% MEANDIR parameters for inversion of Ca and Sr isotope ratios
    Riverdatasource              = 'MyDefaultRiverData';                                                      % Name of source of the river data
    AdjustRiverObs               = 0;                                                                % Whether river measurements should be adjusted to reflect experimental uncertainty. Options are: 0 or 1
    ObsList                      = {'Na','K','Ca','Mg','Cl','SO4','Si','Sr','Sr8786','d44Ca'};       % List of dissolved variables to include in the inversion
    CostFunType                  = {'rel','rel','rel','rel','rel','rel','rel','rel','rel','rel'};    % Whether each variable should be evaluated as proportional cost or absolute cost. Options are 'rel' and 'abs'.
    WeightingList                = [1    1    1    1    1    1    1    1      1      1     ];             % Weighting term for the cost function
    ErrorCutMinMB                = [80   80   80   80   80   80  80   80   -.002  -0.2    ];%?? remove if EM            % If IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    ErrorCutMaxMB                = [120  120  120  120  120  120  120  120   .002   0.2 ];            % If IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    nCFList                      = {};                                                               % List of dissolved variables (in ObsList) to not include in the cost function evaluation
    ConvertDelta2RList           = {'d44Ca'};                                                        % List of isotopic variables (in delta notation) to be converted to isotopic ratios for the analysis (results are converted back to delta)
    AllIonsExplicitlyResolved    =  0;                                                               % Indicate if all cations and anions (all sources of charge) are resolved. Options are 0 or 1       
    ObsInNormalization           = {'Ca','Mg','Na','K','SO4'};                                       % List of which variables are included in the normalization
 	ImposeNormalizationCheck     = 1;                             % whether the normalization should be reproduced to the minimum and maximum values for non-isotopic variables 

    % (2/5) General simulation settings (8 variables)
    Solver                       = 'mldivide_optimize';                                              % Type of inversion solution, options are: 'mldivide', 'lsqnonneg', 'mldivide_optimize', 'lsqnonneg_optimize', 'optimize'. Enter as string, not a cell.
    IterateOver                  = 'Samples';  %endmembers                                                      % Whether to iterate over the same end-members to all sample ('End-members'), or different end-members to each sample ('Sample'). Options are: 'End-members', 'Samples'
    maxiterations                = 1e6; %NaN                                                              % If IterateOver is "Samples", this is the maximum number of inversion attempts 
    maxsuccess                   = 200;    %NaN                                                         % If IterateOver is "Samples", this is the desired number of successes     
    numberiterations             = NaN; %1000                                                              % If IterateOver is "End-members", this is the number of inversions to perform
    MisfitCuts                   = NaN; %100(percentage)                                                             % If IterateOver is "End-members", this percentage of simulations with lowest misfit between model result and data will be kept    
    CullOn                       = 'EachSample';                                                     % If IterateOver is "End-members", this must be either 'EachSample' or 'AllSample' and describes HOW to cull the data              
    saveuncutdata                = 0;                                                                % If 1, saves all the simulation data (results in very large files)        
  % (3/5) Information on end-members (12 variables)
    EMdatasource                 = 'II20_SumObs_uniform';                                            % The name of the end-member group (the entry on column A of the spreadsheet containing end-member information). 
    EMList0                      = {'prec','htsp','nsil','ksil','csil','msil','carb','clay','pyri'}; % List of the end-members to use in the inversion.     
    MinFractionalContribution    = [000 000 000 000 000 000 000 -inf 000];                           % The minumum fractional contribution of each end-member to the normalization ion (typically 0)
    MaxFractionalContribution    = [inf inf inf inf inf inf inf 0000 inf];                           % The maximum fractional contribution of each end-member to the normalization ion (should be 1, unless secondary mineral formation is involved) 
    ListNormClosure              = {'Na','K','Na','K','Ca','Mg','Ca','Mg','SO4'};                    % The ratio for each end-member that will be calculated by mass balance, not using the assigned distribution, when normalization is to SumObs
    ListChargeClosure            = {};                                                               % The ratio for each end-member that will be calculated by charge balance, not using the assigned distribution, when normalization is to SumObs
    EMUnits                      = 'conc';                                                           % Whether the end-member units are in concentration or equivilents. Options are: 'conc', 'equi'    
    EndMembersWithNegativeRatios = {};                                                               % End-members with negative chemical ratios    
    CoupleFeS2SO4intoEM          = {};                                                               % Determine whether a subset of end-members should have their SO4 ratios values overwritten and used to represent pyrite
    CoupleFeS2d34SintoEM         = {};                                                               % Determine whether a subset of end-members should have their d34S values overwritten and used to represent pyrite
    RecordFullFeS2Distribution   = 0;                                                                % Whether to record the full distribution of calculated FeS2 values, when d34S is not included in the inversion
    BalanceEvaporite             = 0;                                                                % Determine if evaporite SO4 = Ca+Mg and Cl = Na+K.
  % (4/5) Cl correction (2 variables)
    PrecProcessing               = 'EndMember';                                                      % Whether Cl should be treated as a common ion ('EndMember') or if there are Cl critical values ('ClCrit') Options are: 'EndMember', 'ClCrit'              
    ClCriticalValuesGiven        = 0;                                                                % Whether Cl critical values are given. If PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 1, those ClCritical values are used. If PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 0, 100% of river Cl is used.        
  % (5/5) Post-inversion R/Z/W/Y/C calculation settings (10 variables)
    CalculateRZCWY               = 1;                                                                % Whether model should attempt to calculate R, Z, C, W, and Y. Options are: 0 or 1
    R_Numerator_EMList           = {'carb'};                                                         % End-members that should contribute to the numerator of R
    R_Numerator_IonList          = {'Na','Ca','Mg','K'};                                             % Ions that should contribute to the numerator of R        
    Z_NumeratorType              = {'ZfromEM'};                                                      % How the numerator of Z (SO4 from FeS2) should be calculated. Options are: 'ZfromEM', 'ZfromSO4excess', 'ZfromriverSO4', 'Znotcalculated'
    Z_Numerator_EMList           = {'pyri'};                                                         % End-members that should contribute to the numerator of Z (only used if Z_NumeratorType = {'ZfromEM'}).   
    C_Numerator_EMList           = {};                                                               % End-member that should contribute to the numerator of C     
    RZC_Denominator_EMList       = {'nsil','ksil','csil','msil','carb'};                             % End-members that should contribute to the denominator of R and Z (weathering end-members)
    RZC_Denominator_IonList      = {'Na','Ca','Mg','K'};                                             % Ions that should contribute to the denominator of R and Z (weathering end-members)                    
    EMsources                  = {'pyri','prec','htsp','nsil','ksil','csil','msil','carb'};        % End-members that count as sources of dissolved constituents (typically rocks and other solute sources)
    EMsinks                    = {'clay'};      

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%% MEANDIR parameters for inversion of major elements only
	Riverdatasource              = 'MyDefaultRiverData';                                                      % Name of source of the river data
    AdjustRiverObs               = 0;                                                                % Whether river measurements should be adjusted to reflect experimental uncertainty. Options are: 0 or 1
    ObsList                      = {'Na','K','Ca','Mg','Cl','SO4','Si'};       % List of dissolved variables to include in the inversion
    CostFunType                  = {'rel','rel','rel','rel','rel','rel','rel'};    % Whether each variable should be evaluated as proportional cost or absolute cost. Options are 'rel' and 'abs'.
    WeightingList                = [1    1    1    1    1    1    1     ];             % Weighting term for the cost function
    ErrorCutMinMB                = [80   80   80   80   80   80   80    ];            % If IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    ErrorCutMaxMB                = [120  120  120  120  120  120  120   ];            % If IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    nCFList                      = {};                                                               % List of dissolved variables (in ObsList) to not include in the cost function evaluation
    ConvertDelta2RList           = {};                                                        % List of isotopic variables (in delta notation) to be converted to isotopic ratios for the analysis (results are converted back to delta)
    AllIonsExplicitlyResolved    =  0;                                                               % Indicate if all cations and anions (all sources of charge) are resolved. Options are 0 or 1       
    ObsInNormalization           = {'Ca','Mg','Na','K','SO4'};                                       % List of which variables are included in the normalization
	ImposeNormalizationCheck     = 1;                             % whether the normalization should be reproduced to the minimum and maximum values for non-isotopic variables 
    % (2/5) General simulation settings (8 variables)
    Solver                       = 'mldivide_optimize';                                              % Type of inversion solution, options are: 'mldivide', 'lsqnonneg', 'mldivide_optimize', 'lsqnonneg_optimize', 'optimize'. Enter as string, not a cell.
    IterateOver                  = 'Samples';                                                        % Whether to iterate over the same end-members to all sample ('End-members'), or different end-members to each sample ('Sample'). Options are: 'End-members', 'Samples'
    maxiterations                = 1E3;                                                              % If IterateOver is "Samples", this is the maximum number of inversion attempts 
    maxsuccess                   = 100;                                                             % If IterateOver is "Samples", this is the desired number of successes     
    numberiterations             = NaN;                                                              % If IterateOver is "End-members", this is the number of inversions to perform
    MisfitCuts                   = NaN;                                                              % If IterateOver is "End-members", this percentage of simulations with lowest misfit between model result and data will be kept    
    CullOn                       = 'EachSample';                                                     % If IterateOver is "End-members", this must be either 'EachSample' or 'AllSample' and describes HOW to cull the data              
    saveuncutdata                = 0;                                                                % If 1, saves all the simulation data (results in very large files)        
  % (3/5) Information on end-members (12 variables)
    EMdatasource                 = 'II20_SumObs_uniform';                                            % The name of the end-member group (the entry on column A of the spreadsheet containing end-member information). 
    EMList0                      = {'prec','nksil','csil','msil','carb','clay','pyri'}; % List of the end-members to use in the inversion.     
    MinFractionalContribution    = [000 000 000 000 000 000 -inf 000];                           % The minumum fractional contribution of each end-member to the normalization ion (typically 0)
    MaxFractionalContribution    = [inf inf inf inf inf inf 0000 inf];                           % The maximum fractional contribution of each end-member to the normalization ion (should be 1, unless secondary mineral formation is involved) 
    ListNormClosure              = {'Na','K','Na','Ca','Mg','Ca','Mg','SO4'};                    % The ratio for each end-member that will be calculated by mass balance, not using the assigned distribution, when normalization is to SumObs
    ListChargeClosure            = {};                                                               % The ratio for each end-member that will be calculated by charge balance, not using the assigned distribution, when normalization is to SumObs
    EMUnits                      = 'conc';                                                           % Whether the end-member units are in concentration or equivilents. Options are: 'conc', 'equi'    
    EndMembersWithNegativeRatios = {};                                                               % End-members with negative chemical ratios    
    CoupleFeS2SO4intoEM          = {};                                                               % Determine whether a subset of end-members should have their SO4 ratios values overwritten and used to represent pyrite
    CoupleFeS2d34SintoEM         = {};                                                               % Determine whether a subset of end-members should have their d34S values overwritten and used to represent pyrite
    RecordFullFeS2Distribution   = 0;                                                                % Whether to record the full distribution of calculated FeS2 values, when d34S is not included in the inversion
    BalanceEvaporite             = 0;                                                                % Determine if evaporite SO4 = Ca+Mg and Cl = Na+K.
  % (4/5) Cl correction (2 variables)
    PrecProcessing               = 'EndMember';                                                      % Whether Cl should be treated as a common ion ('EndMember') or if there are Cl critical values ('ClCrit') Options are: 'EndMember', 'ClCrit'              
    ClCriticalValuesGiven        = 0;                                                                % Whether Cl critical values are given. If PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 1, those ClCritical values are used. If PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 0, 100% of river Cl is used.        
  % (5/5) Post-inversion R/Z/W/Y/C calculation settings (10 variables)
    CalculateRZCWY               = 1;                                                                % Whether model should attempt to calculate R, Z, C, W, and Y. Options are: 0 or 1
    R_Numerator_EMList           = {'carb'};                                                         % End-members that should contribute to the numerator of R
    R_Numerator_IonList          = {'Na','Ca','Mg','K'};                                             % Ions that should contribute to the numerator of R        
    Z_NumeratorType              = {'ZfromEM'};                                                      % How the numerator of Z (SO4 from FeS2) should be calculated. Options are: 'ZfromEM', 'ZfromSO4excess', 'ZfromriverSO4', 'Znotcalculated'
    Z_Numerator_EMList           = {'pyri'};                                                         % End-members that should contribute to the numerator of Z (only used if Z_NumeratorType = {'ZfromEM'}).   
    C_Numerator_EMList           = {};                                                               % End-member that should contribute to the numerator of C     
    RZC_Denominator_EMList       = {'nksil','csil','msil','carb'};                             % End-members that should contribute to the denominator of R and Z (weathering end-members)
    RZC_Denominator_IonList      = {'Na','Ca','Mg','K'};                                             % Ions that should contribute to the denominator of R and Z (weathering end-members)                    
    EMsources                  = {'pyri','prec','htsp','nksil','csil','msil','carb'};        % End-members that count as sources of dissolved constituents (typically rocks and other solute sources)
    EMsinks                    = {'clay'};  