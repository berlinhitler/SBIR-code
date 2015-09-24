classdef ImageProcessing
    %ImageProcessing Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Width = 0;
        Height = 0;
        binI; 
        startR; startC; originalR; originalC; nextR; nextC;
        endFlag;
    end   
    properties (Constant)
        directionU = [-1,1,-1,0,-1,-1,0,-1,1,-1,1,0,1,1,0,1];
        directionD = [1,-1,1,0,1,1,0,1,-1,1,-1,0,-1,-1,0,-1];
        maxNo = 50000;
    end
    
    methods
        function generate_Lin(pic, sz)
        end
        
        function process(pict, argC)
            obj.Height=size(pict,1);
            obj.Width=size(pict,2);
            count = -1;
            pict(pict>=100)=255;
            n = numel(pict);
            for ending = 1:n
                if pict(ending)==255
                    obj.binI = 1;
                    selectedEnd(ending,pict);
                    traceBoundary(ending,pict);
                    if obj.binI >= obj.maxNo
                        return;
                    end
                    if argC == 2
                        count = mod(count+1,8);
                    end
                end
            end
        end
        
        function selectedEnd(ending, pict)
            pictmark = zeros(obj.Height,obj.Width);
            [j,k]=ind2sub([obj.Height,obj.Width],ending);
            while 1
                endPoint = 1;
                for i = 1:2:16
                    j = j + obj.directionU(i);
                    k = k + obj.directionU(i+1);
                    if j>=1 && j <= obj.Height && k>=1 && k<=obj.Width && pict(j,k) == 255 && pictmark(j,k) ~= 200
                        ending = sub2ind([obj.Height,obj.Width],j,k);
                        pictmark(ending) = 200;
                        endPoint = 0;
                        break;
                    end
                end
                if endPoint==1
                    return;
                end
            end
        end
        
        function traceBoundary(ending, pict)
            [r,c]=ind2sub([obj.Height,obj.Width],ending);
            [obj.startR, obj.originalR] = deal(r);
            [obj.startC, obj.originalC] = deal(c);
            obj.nextR = 0;
            obj.nextC = 0;
            pict(obj.startR,obj.startC) = 250;
            if singlePixel(pict, obj.startR, obj.startC)
                return;
            end
            %sw.WriteLine(startR.ToString()+" "+startC.ToString());
            garBin = int32.empty(obj.maxNo,0);
            garBin(obj.binI) = obj.startR;
            obj.binI = obj.binI + 1;
            garBin(obj.binI) = obj.startC;
            obj.binI = obj.binI + 1;
            obj.endFlag = 0;
            while 1
                nextBoundaryPt(pict);
                if obj.endFlag == 1
                    obj.endFlag = 0;
                    return;
                end
                %sw.WriteLine(nextR.ToString()+" "+nextC.ToString());
                garBin(obj.binI) = obj.startR;
                obj.binI = obj.binI + 1;
                garBin(obj.binI) = obj.startC;
                obj.binI = obj.binI + 1;
                if obj.nextR == obj.originalR && obj.nextC == obj.originalC
                    %write (-1)
                   break;
                end
                pict(obj.nextR, obj.nextC) = 250;
                obj.startR = obj.nextR;
                obj.startC = obj.nextC;
            end
            %write (-1)
        end
        
        function sp = singlePixel(pict, r, c)
            sp = true;
            for i = 1:2:16
                j = obj.directionD(i) + r;
                k = obj.directionD(i+1) + c;
                if j>=1 && j<=obj.Height && k>=1 && k<=obj.Width && pict(j,k)==255
                    sp = false;
                end
            end
        end
        
        function nextBoundaryPt(pict)
            p = obj.startR;
            q = obj.startC;
            for i = 1:2:16
                j = obj.directionD(i) + p;
                k = obj.directionD(i+1) + q;
                if j>=1 && j<=obj.Height && k>=1 && k<=obj.Width && pict(j,k)==255
                    obj.nextR = p;
                    obj.nextC = q;
                    return;
                end
            end
            
            for i = 1:2:16
                j = obj.directionD(i) + p;
                k = obj.directionD(i+1) + q;
                if pict(j,k)==250
                    obj.endFlag = 1;
                    return;
                end
            end
        end
    end
end

