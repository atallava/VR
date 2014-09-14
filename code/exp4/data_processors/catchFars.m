function [badFrac,badMean,nullFrac] = catchFars(mat)
% mat is cell of size nTrain x nPixels
% res is an array of size nTrain x nPixels with fraction of bad guys as
% entries
most = 0;
least = Inf;
goodmin = Inf;
[badFrac,badMean,nullFrac] = deal(zeros(size(mat)));
maxRange = 5.9; % 5 + enough slack
for i = 1:size(badFrac,1)
    for j = 1:size(badFrac,2)
        vec = mat{i,j};
        vec2 = vec; vec2(vec2 == 0) = [];
        if min(vec2) < goodmin
            goodmin = min(vec2);
        end
        badFrac(i,j) = sum(vec > maxRange)/length(vec);
        nullFrac(i,j) = sum(vec == 0)/length(vec);
        vec(vec <= maxRange) = [];
        badMean(i,j) = mean(vec);
        tempMost = max(vec);
        tempLeast = min(vec);
        if tempMost > most
            most = tempMost;
        end
        if tempLeast < least
            least = tempLeast;
        end
    end
end
end

