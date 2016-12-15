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
                           
% 1. Describe each variable based on the readme file                           
% 2. Label the data types as nominal, dichotomous, ordinal, or continuous.

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

% 3. How many observations?
% 4. How many independent variables? Dependent?
% 5. How are missing values coded?
% 6. How many observations are missing values?

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

% 7. What question are you answering with this test?
% 8. Are there any assumptions made about the data when using the Pearson
%    product moment correlation coefficient? If so, list them.
% 9. How do you interpret these results?

%% Spearman rank order correlation coefficient
[RHO,PVAL] = corr(data.age,data.trestbps,'type','Spearman'); %Need to convert categorical variables back to numeric indices using grp2idx() for input to corr() 

% 10. Are there any assumptions made about the data when using the Spearman
%     rank correlation coefficient? If so, list them.
% 11. What is the difference between Pearson and Spearman?
% 12. What is the appropriate correlation to use for these variables?
% 13. What about between data.age and data.num?
% 14. How do you interpret these results?
% 15. What is the strength of the relationship?
% 16. What is the direction of the relationship?
% 17. Avoid spurrious correlations (i.e. correlation != causation), what are
%     some mechanisms that could be driving this relationship?

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

% 18. What question are you answering with this test?
% 19. Are there any assumptions made about the data when using ANOVA?
% 20. What is the p-value?
% 21. What are the group means?
% 22. How do you interpret these results?

%% Testing for normality
normplot(data.trestbps); %If normally distributed, data will be linear.
[h,p] = lillietest(data.trestbps)

% 23. What does an h=0 mean?
% 24. Is the data normally distributed?

%% Kruskal-Wallis: non-parameteric test for difference between groups
[p,tbl,stats] = kruskalwallis(data.trestbps,data.num);
[c,m,h,nms] = multcompare(stats);
rslts = cell2table([nms num2cell(m)]);
rslts.Properties.VariableNames = {'Group','Mean','STDERR'};
rslts

% 25. Are there any assumptions made about the data when using the Kruskal-Wallis test?
% 26. What is the difference between ANOVA and Kruskal-Wallis?
% 27. Is ANOVA or the Kruskal-Wallis test appropriate test for this case? Why?
% 28. What is the p-value?
% 29. What are the group means?
% 30. How do you interpret these results?
