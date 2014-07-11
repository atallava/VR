classdef circArray
    %CIRCARRAY Useful methods when dealing with wrap-around arrays
        
    properties
    end
    
    methods (Static = true)
         function res = circDiff(a,b,n)
            % b-a when these values wrap around n
            
            if a <= b
                res = b-a;
            else
                res = b+n-a;
            end
        end

        function [l,r] = circNbrs(i,n,k)
            % k left and right neighbours of i in a circular array of
            % length n
            if nargin < 3
                k = 2;
            end
            l = i-k/2:i-1;
            l(l < 1) = l(l < 1)+n;
            r = i+1:i+k/2;
            r(r > n) = r(r > n)-n+1;
        end
        
        function res = projectToCircIds(ids,n)
           % project ids to circular array of length n
           res = ids;
           res(res > n) = res(res > n)-n;
        end
        
        function res = getCircSection(first,last,n)
            % get a section of circular array of length n given 
            % first and last ids
            if first <= last
                res = first:last;
            else
                res = [first:n 1:last];
            end
        end
    end
    
end

