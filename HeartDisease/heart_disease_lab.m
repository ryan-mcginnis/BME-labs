% Heart Disease Data Analysis
% Written by Ryan S. McGinnis - ryan.mcginnis@uvm.edu

%% Get the data
websave('readme.txt','http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/heart-disease.names')
websave('original.csv','http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/cleveland.data')
websave('processed.csv','http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data')

%% Load the processed data as a datatable
dt = readtable('processed.csv');

%% Assign column names
% Find the column names in readme text file you downloaded
dt.Properties.VariableNames = {'age','sex','cp','trestbps','chol','fbs',...
                               'restecg','thalach','exang','oldpeak',...
                               'slope','ca','thal','num'};
                           
% Describe each variable based on the readme file                           
% Label the data types as nominal, dichotomous, ordinal, or continuous.

%% Convert appropriate variables to double based on descriptions
dt.ca = str2double(dt.ca);
dt.thal = str2double(dt.thal);

%% Convert variables to categorical (and ordinal) where appropriate
dt.sex = categorical(dt.sex);
dt.cp = categorical(dt.cp);
dt.fbs = categorical(dt.fbs,'Ordinal',1);
dt.restecg = categorical(dt.restecg);
dt.exang = categorical(dt.exang);
dt.slope = categorical(dt.slope);
dt.ca = categorical(dt.ca,'Ordinal',1);
dt.thal = categorical(dt.thal);
dt.num = categorical(dt.num,'Ordinal',1);

%% Print a summary of the variables
summary(dt);

% How many observations?
% How many independent variables? Dependent?
% How are missing values coded?
% How many observations are missing values?

%% Remove missing data
data = rmmissing(dt);
summary(data);

%% Visualize relationship between variables (scatter)
figure;
scatter(data.age,data.trestbps)
title('Age vs Resting BP');
xlabel('Age (yrs)');
ylabel('Resting Systolic BP (mmHg)');

%% Pearson product moment correlation coefficient
[RHO,PVAL] = corr(data.age,data.trestbps,'type','Pearson'); 

% Are there any assumptions made about the data when using the Pearson
% product moment correlation coefficient? If so, list them.
% How do you interpret these results?

%% Spearman rank order correlation coefficient
[RHO,PVAL] = corr(data.age,data.trestbps,'type','Spearman'); %Need to convert categorical variables back to numeric indices using grp2idx() for input to corr() 

% Are there any assumptions made about the data when using the Spearman
% rank correlation coefficient? If so, list them.
% How do you interpret these results?
% Avoid spurrious correlations (i.e. correlation != causation), what are
% some mechanisms that could be driving this relationship?

%% Examine differences between groups
% Visualize relationship and differences by group (gscatter, boxplot)
figure;
gscatter(data.age,data.trestbps,data.num)
title('Age vs Resting BP grouped by Heart Disease Severity');
xlabel('Age (yrs)');
ylabel('Resting Systolic BP (mmHg)');

figure;
boxplot(data.trestbps,data.num)
xlabel('Heart Disease Severity Group');
ylabel('Resting Systolic BP');
title('Resting BP grouped by Heart Disease Severity')

%% ANOVA: parameteric test for difference between groups
[p,tbl,stats] = anova1(data.trestbps,data.num);
[c,m,h,nms] = multcompare(stats);
rslts = cell2table([nms num2cell(m)]);
rslts.Properties.VariableNames = {'Group','Mean','STDERR'};
rslts

% Are there any assumptions made about the data when using ANOVA?
% How do you interpret these results?

%% Kruskal-Wallis: non-parameteric test for difference between groups
[p,tbl,stats] = kruskalwallis(data.trestbps,data.num);
[c,m,h,nms] = multcompare(stats);
rslts = cell2table([nms num2cell(m)]);
rslts.Properties.VariableNames = {'Group','Mean','STDERR'};
rslts

% Are there any assumptions made about the data when using the Kruskal-Wallis test?
% How do you interpret these results?
