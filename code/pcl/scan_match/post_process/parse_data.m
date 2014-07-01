% parse output of pcl icp
lines = importdata('neato_data/data_jun24_1/icp_results.txt');
fields = lines{1};
fields = strsplit(fields,' ');
icp_results = struct('converged',{},'score',{},'correctionT',{});
for i = 2:length(lines)
    line = lines{i};
    blanks = strfind(line,' ');
    icp_results(i-1).converged = str2num(line(blanks(1)+1:blanks(2)-1));
    icp_results(i-1).score = str2num(line(blanks(2)+1:blanks(3)-1));
    correctionT_vector = str2num(line(blanks(3)+1:end));
    icp_results(i-1).correctionT = reshape(correctionT_vector,4,4);    
end