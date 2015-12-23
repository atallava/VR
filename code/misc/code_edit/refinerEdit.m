% search params
someUsefulPaths;
dirName = [pathToR1 '/code/'];
pattern = 'refiner.refine';

%% search
cmd = ['grep -r ''' pattern ''' ' dirName];
[~,cmdout] = system(cmd);

%% extract filenames
cmdout = deblank(cmdout);
lines = strsplit(cmdout,'\n');
nMatches = length(lines);
fnames = cell(1,nMatches);
for i = 1:nMatches
    line = lines{i};
    posns = strfind(line,':');
    posn = posns(1); 
    fnames{i} = line(1:(posn-1));
end
fnames = unique(fnames);
nFiles = length(fnames);

%% edit each file
% this part is unique to each replacement
dispFlag = false;

for i = 1:nFiles
    if dispFlag
        disp(fnames{i});
    end
    fid = fopen(fnames{i},'r');
    line = fgets(fid);
    newLines = {};
    while ischar(line)
        % assuming only one matlab command per line
        posn = strfind(line,pattern);
        % modify line
        if ~isempty(posn)
            posnBrace1 = strfind(line,'[');
            posnBrace2 = strfind(line,']');
            % assuming only one set of braces in line
            if ~isempty(posnBrace1) && ~isempty(posnBrace2)
                args = line(posnBrace1+1:posnBrace2-1);
                % assuming only one comma in braces
                posnSep = posnBrace1+strfind(args,',');
                arg1 = line(posnBrace1+1:posnSep-1);
                arg2 = line(posnSep+1:posnBrace2-1);
                newArgs = [arg2 ',' arg1];
                % assuming args combination isn't repeated in line!
                if dispFlag
                    fprintf('%s\n',line);
                end
                line = strrep(line,args,newArgs);
                if dispFlag
                    fprintf('%s\n\n',line);
                end
            end
        end
        newLines = [newLines line];
        line = fgets(fid);
    end
    fclose(fid);
    % warning, file rewrite 
    fid = fopen(fnames{i},'w');
    fprintf(fid,'%s',newLines{:});
    fclose(fid);
end