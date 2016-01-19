classdef thrunLaserModel < handle
    % simple stochastic laser model
    
    properties
        laser
        pZero; alpha; beta
        % mu = (1+alpha)*r
        % sigma = beta*r
        XQueryLast; YQueryLast;
        epsilonProb = 1e-8;
        debugFlag = false;
    end
    
    methods
        function obj = thrunLaserModel(inputStruct)
            % inputStruct fields ('laser','pZero','alpha','beta')
            % X is a struct array with fields ('sensorPose','map')
            if isfield('inputStruct','laser')
                obj.laser = inputStruct.laser;
            else
                obj.laser = inputStruct.laser;
            end
            if isfield('inputStruct','pZero')
                obj.pZero = inputStruct.pZero;
            end
            if isfield('inputStruct','alpha')
                obj.alpha = inputStruct.alpha;
            end
            if isfield('inputStruct','beta')
                obj.beta = inputStruct.beta;
            end
        end
        
        function updateModelParams(obj,params)
            if isstruct(params)
               obj.pZero = params.pZero;
               obj.alpha = params.alpha;
               obj.beta = params.beta;
            elseif isVec(params)
                obj.pZero = params(1);
                obj.alpha = params(2);
                obj.beta = params(3);
            else
                error('thrunLaserModel:updateModelParams:invalidParams',...
                    'params must be struct or vector.');
            end
        end
        
        function paramsVec = modelParamsStructToVec(obj,paramsStruct)
            %MODELPARAMSSTRUCTTOVEC
            %
            % paramsVec = MODELPARAMSSTRUCTTOVEC(paramsStruct)
            %
            % paramsStruct - Struct with fields ('pZero','alpha','beta).
            %
            % paramsVec    - [1,3] array.
            
            paramsVec = zeros(1,3);
            paramsVec(1) = paramsStruct.pZero;
            paramsVec(2) = paramsStruct.alpha;
            paramsVec(3) = paramsStruct.beta;
        end
        
        function paramsStruct = algoParamsVecToStruct(obj,paramsVec)
            %MODELPARAMSVECTOSTRUCT
            %
            % paramsStruct = MODELPARAMSVECTOSTRUCT(paramsVec)
            %
            % paramsVec    - [1,3] array.
            %
            % paramsStruct - Struct with fields ('pZero','alpha','beta').
            
            paramsStruct.pZero = paramsVec(1);
            paramsStruct.alpha = paramsVec(2);
            paramsStruct.beta = paramsVec(3);
        end
        
        function probArray = probArrayAtState(obj,XQuery)
            %PROBARRAYATSTATE
            %
            % probArray = PROBARRAYATSTATE(obj,XQuery)
            %
            % XQuery    -
            %
            % probArray -
            
            condn = length(XQuery) == 1;
            assert(condn,'thrunLaserModel:probArrayAtState:incorrectInput',...
                'XQuery must be one element.');
            map = XQuery.map;
            sensorPose = XQuery.sensorPose;
            [rVec,~] = map.raycast(sensorPose,obj.laser.maxRange,obj.laser.bearings);
            muVec = (1+obj.alpha)*rVec;
            sigmaVec = obj.beta*rVec;
            % out of range
            flag = rVec > obj.laser.maxRange;
            muVec(flag) = 0;
            sigmaVec(flag) = 0;
            % nan stuff
            flag = isnan(rVec);
            muVec(flag) = 0;
            sigmaVec(flag) = 0;
            
            probArray = obj.paramsToProbArray(muVec,sigmaVec);
        end
        
        function YQuery = predict(obj,XQuery)
            %PREDICT
            %
            % YQuery = PREDICT(obj,XQuery)
            %
            % XQuery - Struct array with fields ('sensorPose','map')
            %
            % YQuery - Struct array with fields ('ranges')
            
            clockLocal = tic();
            nQuery = length(XQuery);
            rangesQuery = zeros(nQuery,obj.laser.nBearings);
        
            % collect r, alpha for each x
            for i = 1:nQuery
                probArray = obj.probArrayAtState(XQuery(i));
                rangesQuery(i,:) = sampleFromHistogram(probArray,obj.laser.readingsSet,1);
            end
            
            if any(isnan(rangesQuery(:)))
                error('thrunLaserModel:predict','nan ranges predicted.');
            end
                        
            YQuery = struct('ranges',mat2cell(rangesQuery,ones(1,nQuery),obj.laser.nBearings)');
            
            obj.XQueryLast = XQuery;
            obj.YQueryLast = YQuery;
            tComp = toc(clockLocal);
            if obj.debugFlag
                fprintf('exp14LaserModel:Computation time: %.2fs.\n',tComp);
            end
        end
        
        function probArray = paramsToProbArray(obj,muVec,sigmaVec)
            %PARAMSTOPROBARRAY
            %
            % probArray = PARAMSTOPROBARRAY(obj,muVec,sigmaVec)
            %
            % muVec     -
            % sigmaVec  -
            %
            % probArray - [nVec,nBins] array.
            
            yValues = obj.laser.readingsSet();
            yValues = flipVecToRow(yValues);
            yResn = yValues(2)-yValues(1);
            
            % for bsxfun
            muVec = flipVecToColumn(muVec);
            sigmaVec = flipVecToColumn(sigmaVec);
            
            nMu = length(muVec);
            probArray = zeros(nMu,length(yValues));
            if obj.pZero == 1
                probArray(:,1) = 1;
                return;
            end
            x2 = yValues+yResn*0.5;
            x2 = repmat(x2,nMu,1);
            x2 = bsxfun(@minus,x2,muVec); 
            x2 = bsxfun(@rdivide,x2,sigmaVec);
            
            x1 = yValues-yResn*0.5;
            x1 = repmat(x1,nMu,1);
            x1 = bsxfun(@minus,x1,muVec);
            x1 = bsxfun(@rdivide,x1,sigmaVec);
            
            probArray = 0.5*(erf(x2./sqrt(2))-erf(x1./sqrt(2)));
            probArray = probArray*(1-obj.pZero);
            probArray(:,1) = probArray(:,1)+obj.pZero;
            probArray = probArray+obj.epsilonProb; % avoiding zero probability
        end
        
        function [nll,rangesProb] = negLogLike(obj,probArray,ranges)
            %NEGLOGLIKE
            %
            % nll = NEGLOGLIKE(obj,probArray,ranges)
            %
            % probArray - [nRanges,nBins] array.
            % ranges    - nRanges length vector.
            %
            % nll       -

            ySet = obj.laser.readingsSet();
            ranges = obj.laser.projectDataToReadingsSet(ranges);
            
            nYSet = length(ySet);
            nYRanges = length(ranges);
            ySet = flipVecToRow(ySet);
            ranges = flipVecToColumn(ranges);
            ySetMat = repmat(ySet,nYRanges,1);
            yRangesMat = repmat(ranges,1,nYSet);
            flag = ySetMat == yRangesMat;
            [~,setIds] = max(flag,[],2); % get the setIds
            
            % setIds are columns ids into probArray
            columnSubs = setIds;
            % sub2ind needs column and row subs same size
            rowSubs = [1:nYRanges]';
            probArrayIds = sub2ind(size(probArray),rowSubs,columnSubs);
            rangesProb = probArray(probArrayIds);
            nll = -sum(log(rangesProb));
        end
    end
    
end

