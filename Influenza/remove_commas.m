function vals = remove_commas(col)
% Expects nx1 cell array of strings
% Outputs nx? cell array of strings 
    vals = cell(length(col),1);
    for col_iter = 1:length(col)
        str = col(col_iter);
        i = regexp(str{1},',');
        if length(i)==length(str{1})
            vals{col_iter}='-N/A-';
        else
            if isempty(i)
                vals{col_iter}=str{1};
            else
                % Deal with case of ',' as first element
                if i(1)==1
                    i(1) = 2;
                end
                % Deal with case of ',' not as last element
                if i(end)~=length(str{1})
                    i = [i, length(str{1})];
                end
                str_iter = 1;
                var_temp = [];
                while str_iter <= length(str{1})
                    if sum(i==str_iter)>0
                        if ~isempty(var_temp)
                            % Deal with case of ' ' at start or end
                            if var_temp(1)==' '
                                var_temp = var_temp(2:end);
                            end
                            if var_temp(end)==' '
                                var_temp = var_temp(1:end-1);
                            end
                            vals{col_iter}=[vals{col_iter}, {var_temp}];
                        end
                        var_temp = [];    
                    else
                        var_temp = [var_temp, str{1}(str_iter)];
                    end
                    str_iter = str_iter+1;
                end
            end   
        end
    end
end