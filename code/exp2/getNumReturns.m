%broken. uses an early signature of getErr
num_returns = cell(1,6);
num_returns = arrayfun(@(i) getErr(ranges{i},i), 1:6,'uni',false);