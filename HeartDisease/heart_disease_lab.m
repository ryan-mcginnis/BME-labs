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

%% Testing for normality
normplot(data.trestbps); %If normally distributed, data will be linear.
[h,p] = lillietest(data.trestbps)

% 10. What does an h=1 mean?
% 11. Is the data normally distributed?

%% Spearman rank order correlation coefficient
[RHO,PVAL] = corr(data.age,data.trestbps,'type','Spearman'); %Need to convert categorical variables back to numeric indices using grp2idx() for input to corr() 

% 12. Are there any assumptions made about the data when using the Spearman
%     rank correlation coefficient? If so, list them.
% 13. What is the difference between Pearson and Spearman?
% 14. What is the appropriate correlation to use for these variables?
% 15. What about between data.age and data.num?
% 16. How do you interpret these results?
% 17. What is the strength of the relationship?
% 18. What is the direction of the relationship?
% 19. Avoid spurrious correlations (i.e. correlation != causation), what are
%     some mechanisms that could be driving this relationship?

%% Examine differences between groups
% Adjust the data so that we only have 2 diagnosis groups
% 0: without heart disease
% 1: with heart disease
data2 = data;
data2.num( data2.num=='1' | data2.num=='2' | data2.num=='3' | data2.num=='4' ) = '1';
data2.num = removecats(data2.num);

% Visualize relationship and differences by group (gscatter, boxplot)
figure;
gscatter(data2.age,data2.trestbps,data2.num)
title('Age vs Resting BP grouped by Heart Disease Severity');
xlabel('Age (yrs)');
ylabel('Resting Systolic BP (mmHg)');

figure;
boxplot(data2.trestbps,data2.num)
xlabel('Heart Disease Severity Group');
ylabel('Resting Systolic BP');
title('Resting BP grouped by Heart Disease Severity')

%% ANOVA: parameteric test for difference between groups
[p,tbl,stats] = anova1(data2.trestbps,data2.num);
[c,m,h,nms] = multcompare(stats);
rslts = cell2table([nms num2cell(m)]);
rslts.Properties.VariableNames = {'Group','Mean','STDERR'};
rslts

% 20. What question are you answering with this test?
% 21. Are there any assumptions made about the data when using ANOVA?
% 22. What is the p-value?
% 23. What are the group means?
% 24. How do you interpret these results?

%% Testing for normality within each group
figure;
subplot(211)
normplot(data2.trestbps(data2.num=='0')); %If normally distributed, data will be linear.
xlabel('Resting Systolic BP');
title('Healthy');

subplot(212)
normplot(data2.trestbps(data2.num=='1'));
xlabel('Resting Systolic BP');
title('Heart Disease');

[h0,p0] = lillietest(data.trestbps(data2.num=='0'))
[h1,p1] = lillietest(data.trestbps(data2.num=='1'))

%% Kruskal-Wallis: non-parameteric test for difference between groups
[p,tbl,stats] = kruskalwallis(data2.trestbps,data2.num);
c = multcompare(stats);

% 25. Are there any assumptions made about the data when using the Kruskal-Wallis test?
% 26. What is the difference between ANOVA and Kruskal-Wallis?
% 27. Is ANOVA or the Kruskal-Wallis test appropriate test for this case? Why?
% 28. What is the p-value?
% 29. What are the group means?
% 30. How do you interpret these results?

%% Questions
% 2. Differences in age between groups with and with diagnosis
% Test for normality
figure;
subplot(211)
normplot(data2.age(data2.num=='0')); 
xlabel('age');
title('Healthy');
subplot(212)
normplot(data2.age(data2.num=='1'));
xlabel('Age');
title('Heart Disease');

[h0,p0] = lillietest(data2.age(data2.num=='0'))
[h1,p1] = lillietest(data2.age(data2.num=='1'))

%Data is not normally distributed within groups.
[p,tbl,stats] = kruskalwallis(data2.age,data2.num);
c = multcompare(stats);

%The non-disease group is significantly younger.

