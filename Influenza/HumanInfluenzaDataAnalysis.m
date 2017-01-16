%% Human Influenza Data Analysis
% Written by Ryan S. McGinnis - ryan.mcginnis@uvm.edu

%% Load excel file of human influenza patient data
dt = readtable('HumanInfluenzaClinicalMetadata_v2.xlsx');

%Check out data that we just loaded by double clicking the dt variable in
%the workspace

% What data types should be present based on the headings? Numeric,
% Categorical, Text Strings, ?
% What data types are present? Text strings


%% Clean up and extract data

    %% Summarize location (Country, State_Province, City_Local, CollectorInstitution, Latitude, Longitude)
    % Convert numeric columns to numbers 
    dt.Latitude = str2double(dt.Latitude);
    dt.Longitude = str2double(dt.Longitude);
    
    states = shaperead('usastatehi', 'UseGeoCoords', true);
    figure
    worldmap('na');
    hold on;
    geoshow(states)
    geoshow(dt.Latitude,dt.Longitude,'DisplayType','multipoint');
    
% Are all of the locations in the USA? 
    
    % Convert categorical columns to a categorical data type
    dt.Country = categorical(dt.Country);
    dt.State_Province = categorical(dt.State_Province);
    dt.City_Local = categorical(dt.City_Local);
    dt.CollectorInstitution = categorical(dt.CollectorInstitution);
    
    % Summarize Country, State_Province, City_Local, and CollectorInstitution
    fprintf(1,'\nCountry\n');
    summary(dt.Country);
    fprintf(1,'\nState\n');
    summary(dt.State_Province);
    fprintf(1,'\nCity\n');
    summary(dt.City_Local);
    fprintf(1,'\nInstitution\n');
    summary(dt.CollectorInstitution);

% How many observations do we have?
% How are missing cities coded?
% How many observations are missing a city?
% What state has the most data points?
% What state has the most data points?

% Are any states duplicated? If so, which ones?
% Are any cities duplicated? If so, which ones?
% Do any cities have a different format? If so, which ones?

    % Recode "NY" and "New York,NY" as "New York"
    dt.State_Province( dt.State_Province=='New York,NY' | dt.State_Province=='NY' )='New York';
    dt.State_Province = removecats(dt.State_Province);

% What does 'removecats' do?
    
    % Recode "Boston, MA" and "Massachesetts, Boston" as "Boston"
    dt.City_Local( dt.City_Local=='Boston, MA' | dt.City_Local=='Massachusetts, Boston' )='Boston';
    % Recode "Illinois, Chicago" as "Chicago"
    dt.City_Local( dt.City_Local=='Illinois, Chicago, Cook County' )='Chicago';
    % Recode "Santa Clara, CA" as "Santa Clara"
    dt.City_Local( dt.City_Local=='Santa Clara, CA' )='Santa Clara';
    dt.City_Local = removecats(dt.City_Local);
    
    % Print updated data
    fprintf(1,'\nCountry\n');
    summary(dt.Country);
    fprintf(1,'\nState\n');
    summary(dt.State_Province);
    fprintf(1,'\nCity\n');
    summary(dt.City_Local);
    fprintf(1,'\nInstitution\n');
    summary(dt.CollectorInstitution);

    %% Sumarize patient demographics (Age, Gender, MedicalConditions)
    % Convert numeric columns to numbers 
    dt.Age = str2double(dt.Age);
    
% Are there any observations with missing ages? If so, how are they coded?
    
    % Convert categorical columns to a categorical data type
    dt.Gender = categorical(dt.Gender);
    fprintf(1,'\nGender Summary\n');
    summary(dt.Gender)
    
% What percentage of observations are male? female?    
    
    % Parse MedicalConditions string variables 
    dt.MedicalConditions = remove_commas(dt.MedicalConditions);

    
    %% Summarize presentation temperature and timing (Temperature, Symptoms, CollectionDate)
    % Convert numeric columns to numbers 
    dt.Temperature = str2double(dt.Temperature);

% Are there any observations with missing temperatures? If so, how are they coded?     
        
    % Recode missing temperature
    dt.Temperature( dt.Temperature == 999 ) = NaN;

    % Select first date in each row of CollectionDate
    date_cells = select_first( remove_commas(dt.CollectionDate) );

    % Convert to datetime object
    dt.CollectionDate = datetime(date_cells,'InputFormat','MM/dd/yyyy');
    
    
    %% Extract diagnosis and treatment (Diagnosis, FluTestStatus, Subtype, PostVisitMedications)
       
    % Parse Diagnosis string variables into cells
    dt.Diagnosis = remove_commas(dt.Diagnosis);
        
    % Remove repeated test results in FluTestStatus by selecting first
    dt.FluTestStatus = categorical( select_first( remove_commas(dt.FluTestStatus) ) );
    
% How many patients had a positive flu test?
    
    % Parse Subtype variables and select first
    dt.Subtype = select_first( remove_commas(dt.Subtype) );
    
% What is difference between two subtypes of Flu? (Hint: google is your friend here)
    
    % Parse PostVisitMedications string variables into cells
    dt.PostVisitMedications = remove_commas(dt.PostVisitMedications);
   
    
%% How to summarize subsets of data

    % Examine data from Boston:
    dt_boston = dt(dt.City_Local=='Boston',:);

% How many observations from Boston?
    height(dt_boston)
    
% How many observations from men and women? 
    summary(dt_boston.Gender)

% What are the min and max, mean, and std dev. of age and temperatures for men and women with a positive Flu test?    
    stats = grpstats(dt_boston(dt_boston.FluTestStatus=='Positive',{'Gender','Age','Temperature'}),{'Gender'},{'min','max','mean','std','gname'})

% Are temperatures between men and women in Boston different?
    %Visualize data
    figure;
    errorbar(stats.mean_Temperature,stats.std_Temperature)
    set(gca,'xtick',1:3,'xticklabel',stats.gname,'xlim',[0.5,3.5])
    xlabel('Gender');
    ylabel('Temperature (deg. F)');


%% More visualization examples
% Where did the first Flu observation occur?
    dt_flu = dt(dt.FluTestStatus == 'Positive',:);
    dt_flu_sorted = sortrows(dt_flu,'CollectionDate');
    dt_flu_sorted.State_Province(1)
    
% Show location of flu observations by date
    states = shaperead('usastatehi', 'UseGeoCoords', true);
    figure
    worldmap('na');
    hold on;
    geoshow(states, 'DefaultFaceColor', [0.9, 0.9, 0.9], ...
   'DefaultEdgeColor', [0.8, 0.8, 0.8])
    caxis([1,height(dt_flu_sorted)])
    scatterm(dt_flu_sorted.Latitude,dt_flu_sorted.Longitude,15,1:height(dt_flu_sorted),'filled');
    cbr = colorbar('eastoutside');
    cbr.Ticks=[1, height(dt_flu_sorted)];
    cbr.TickLabels={'First','Last'};


%% Use skills so far to investigate some of the questions below or a question of your choosing

% How many observations have comorbitities?
% What is the most common comorbitity?
% How many observations ended up with a FLU diagnosis?
% How many observations ended up with an antibiotic prescription?
% For people who had a FLU diagnosis, what were their prescriptions?
% Is temperature higher for patients with a positive flu test?

