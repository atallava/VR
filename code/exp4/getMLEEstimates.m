function [pdf_params,p_zero] = getMLEEstimates(pdf_type,trainIds)
% given pdf_type and training ids, get MLE parameters
% pdf_params is a struct array of length R, where R: number of range
% returns

load processed_data

nTrain = length(trainIds);
nRays = size(ranges{1},1);
nObs = size(ranges{1},2);
pdf_params = cell(1,nRays);
p_zero = cell(1,nRays);

for i = 1:nTrain
    for j = 1:nRays
        data = ranges{trainIds(i)}(j,:);
        zero_ids = find(data == 0);        
        p_zero{j} = [p_zero{j} length(zero_ids)/nObs];
        data(zero_ids) = [];
        try
            % data could not fit a pdf type for a variety of reasons
            params = mle(data,'distribution',pdf_type);
        catch
            continue;
        end
        pdf_params{j} = [pdf_params{j} params'];
    end
end

end

