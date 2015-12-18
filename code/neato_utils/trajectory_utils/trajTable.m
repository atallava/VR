classdef trajTable < handle
        
    properties (Constant = true)
        sMax = 1;
        qRange = [-pi pi];
        thRange = [-1.5*pi 1.5*pi];
        sBins = 200;
    end
    
    properties (SetAccess = private)
        scale
        nBins
        aLTable; bLTable; eLTable
        aRTable; bRTable; eRTable
        aMax; bMax; numA; numB
    end
    
    methods
        function obj = trajTable(inputData)
            % inputData fields ('scale')
            obj.scale = inputData.scale;
            obj.nBins = [round(50*126/obj.scale) round(10*126/obj.scale)];
            obj.aMax = 195.0/obj.sMax^2; obj.bMax = 440.0/obj.sMax^3;
            obj.numA = 40000/obj.scale; obj.numB = 25000/obj.scale;
            t1 = tic();
            obj.fillTables();
            fprintf('Time to fill tables: %f s\n',toc(t1));
        end
        
        function res = checkTh(obj,pose)
            res = 1;
            th = pose(3);
            if th > obj.thRange(2) || th < obj.thRange(1)
                res = 0;
            end
        end
    end
    
    methods (Access = private)
        function fillTables(obj)
            in = struct('ranges',[obj.qRange' obj.thRange'],'nBins',obj.nBins);
            obj.aLTable = scalarField(in); obj.aRTable = scalarField(in);
            obj.bLTable = scalarField(in); obj.bRTable = scalarField(in);
            in.initVal = inf;
            obj.eLTable = scalarField(in); obj.eRTable = scalarField(in); 
            
            %cubicSpiralInput.nIntervals = obj.sBins;
            %cubicSpiralInput.poseCheck = @obj.checkTh;
            for a = -obj.aMax:obj.aMax/obj.numA:obj.aMax
                for b = -obj.bMax:obj.bMax/obj.numB:obj.bMax
                    [x,y,th] = deal(0);
                    sArray = linspace(0,1,201); ds = sArray(2)-sArray(1);
                    someflag = 1;
                    energy = 0;
                    for i = 1:obj.sBins
                        k = cubicSpiral.kValue(sArray(i),[a,b,1]);
                        energy = energy+k^2;
                        th = th+k*ds;
                        if th > obj.thRange(2) || th < obj.thRange(1)
                            someflag = 0;
                            break;
                        end
                        x = x+cos(th)*ds;
                        y = y+sin(th)*ds;
                    end
                    energy = energy*ds;
                    if ~someflag
                        continue;
                    end
                    %{
                    cubicSpiralInput.params = [a,b,obj.sMax];
                    trajObj = cubicSpiral(cubicSpiralInput);
                    if ~trajObj.flag
                        continue;
                    end
                    x = trajObj.finalPose(1); y = trajObj.finalPose(2); th = trajObj.finalPose(3);
                    energy = trajObj.energy;
                    %}
                    q = atan2(y,x);
                    if q < obj.qRange(1) || q > obj.qRange(2) 
                        continue;
                    end
                    fprintf('valid solution for a,b: %f,%f\n',a,b);
                    if a < 0
                        % left turns
                        if energy < obj.eLTable.get([q,th])
                            obj.aLTable.set([q,th],a);
                            obj.bLTable.set([q,th],b);
                            obj.eLTable.set([q,th],energy);
                        end
                    else
                        % right turns
                        if energy < obj.eRTable.get([q,th])
                            obj.aRTable.set([q,th],a);
                            obj.bRTable.set([q,th],b);
                            obj.eRTable.set([q,th],energy);
                        end
                    end
                end                
            end 
        end
    end
      
end

