function res = choiceString(choice)

switch choice
    case 1
        res = 'real';
    case 2
        res = 'baseline';
    case 3
        res = 'sim';
    case 4
        res = 'sim_pooled';
    case 5
        res = 'sim_local_match';
    otherwise
        error('CHOICE NOT IN AVAILABLE.');
end

end

