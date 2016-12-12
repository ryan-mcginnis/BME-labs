function vals = select_first(col)
    vals = cell(length(col),1);
    for row_ind = 1:length(col)
        temp = col(row_ind);
        if iscell(temp{1})
            vals(row_ind) = {temp{1}{1}};
        else
            vals(row_ind) = {temp{1}};
        end
    end
end