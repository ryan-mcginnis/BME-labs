function symp_table = create_symptom_table(symps)
% Expects cell array of strings with format for each cell of xxxxxxx(xxx)
% Outputs table with symptoms at presentation

symp_table = cell2table({'-N/A-','-N/A-','-N/A-','-N/A-','-N/A-','-N/A-','-N/A-','-N/A-'});

symp_table.Properties.VariableNames={'running_nose','cough','myalgia',...
                    'headache','throat','fever','fatigue','temperature'};

symp_table = repmat(symp_table, length(symps), 1);

for row_ind=1:length(symps)
    cells = symps(row_ind);
    if ~strcmpi(cells{1},'-N/A-')
        if iscell(cells{1})
            len = length(cells{1});
        else
            len = 1;
        end
        for col_ind = 1:len
            if iscell(cells{1})
                temp = cells{1}{col_ind};
            else
                temp = cells{1};
            end
            content = regexp(temp,'\(.*\)','match');
            ind_end = regexp(temp,'(');
            table_col = remove_space(temp(1:ind_end-1));
            symp_table.(table_col)(row_ind) = {content{1}(2:end-1)};
        end
    end
end
end

function str = remove_space(str)
    ind = str==' ';
    str(ind) = '_';
end