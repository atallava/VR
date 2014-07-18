classdef timingObjective < handle
    %timingObjective
    
    properties (Constant = true)
        orientationMultiplier = 1.0 % TODO: calibrate. Based on time taken by scan to match. 
    end

    properties (SetAccess = private)
        tEnc = 1/30; tLaser = 1/5;
        tProcEnc = 5e-4;
        n = 2;
        f; g        
        lambda = 10;
        initError = 0;
    end

    methods
        function obj = timingObjective(inputStruct)
            % inputStruct fields ('tEnc','tLaser','tProcEnc','n','f','g','lambda')
            % default (0.03,0.2,5e-4,2,@errorFromEncoders,@errorAfterScanMatch,10)
            if isfield(inputStruct,'tEnc')
                obj.tEnc = inputStruct.tEnc;
            else
            end
            if isfield(inputStruct,'tLaser')
                obj.tLaser = inputStruct.tLaser;
            else
            end
            if isfield(inputStruct,'tProcEnc')
                obj.tProcEnc = inputStruct.tProcEnc;
            else
            end
            if isfield(inputStruct,'n')
                obj.n = inputStruct.n;
            else
            end
            if isfield(inputStruct,'f')
                obj.f = inputStruct.f;
            else
                tempObj = errorFromEncoders();
                obj.f = @tempObj.getError;
            end
            if isfield(inputStruct,'g')
                obj.g = inputStruct.g;
            else
                tempObj = errorAfterScanMatch();
                obj.g = @tempObj.getError;
            end
            if isfield(inputStruct,'lambda')
                obj.lambda = inputStruct.lambda;
            else
            end
        end
        
        function res = value(obj,kEnc,kLaser,tProcLaser)
            tEncEff = kEnc*obj.tEnc;
            tLaserEff = kLaser*obj.tLaser;
            nEncInLaser = floor(tLaserEff/tEncEff);
            errorNStep = obj.errorAfterNScanMatch(obj.initError,tProcLaser,nEncInLaser,tEncEff);
            tProcN = obj.totalProcTime(tProcLaser,nEncInLaser);
            tLagN = obj.timeLag(tProcN,tLaserEff);
            res = errorNStep+obj.lambda*tLagN;
        end
        
        function res = errorAfterNScanMatch(obj,initError,tProcLaser,nEncInLaser,tEncEff)
            err = initError;
            for i = 1:obj.n
                res = obj.g(tProcLaser,err);
                err = res+obj.f(nEncInLaser,tEncEff);
            end
        end
        
        function res = totalProcTime(obj,tProcLaser,nEncInLaser)
            res = obj.n*(tProcLaser+nEncInLaser*obj.tProcEnc);
        end
        
        function res = timeLag(obj,tProcN,tLaserEff)
            res = max(floor(tProcN/tLaserEff),obj.n)-obj.n;
            res = res*tLaserEff;
        end
        
        function hfig = plot(obj,kEnc,kLaser,tProcLaser)
            hfig = figure; 
            hs1 = subplot(2,1,1); hold on;
            num = floor(obj.n*obj.tLaser*kLaser/obj.tEnc);
            tMax = max(num*obj.tEnc,obj.n*kLaser*obj.tLaser);
            for i = 1:num
                x = obj.tEnc*(i-1)*[1 1];
                plot(x,[0 0.5],'b','linewidth',1);
                if mod(i-1,kEnc) == 0
                    plot(x,[0 1],'b','linewidth',2);
                end
            end
            xlim([-0.1 tMax]); ylim([0 1.5]); 
            xlabel('t (s)'); title('encoders');
            hold off; set(hs1,'ytick',[]);
                    
            hs2 = subplot(2,1,2); hold on;
            num = obj.n*kLaser;
            for i = 1:num
                x = obj.tLaser*(i-1)*[1 1];
                plot(x,[0 0.5],'r','linewidth',1);
                if mod(i-1,kLaser) == 0
                    plot(x,[0 1],'r','linewidth',2);
                    x(2) = x(1)+tProcLaser;
                    plot(x,[1.25 1.25],'g-x','linewidth',3);
                end
            end
            xlim([-0.1 tMax]); ylim([0 1.5]);
            xlabel('t (s)'); title('laser');
            hold off; set(hs2,'ytick',[]);
        end
    end

    methods (Static = true)
    end

end
