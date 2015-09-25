classdef ImageProcessing
    %ImageProcessing Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Width = 0;
        Height = 0;
        binI; 
        startR; startC; originalR; originalC; nextR; nextC;
        endFlag;
        template1;
        template2;
    end   
    properties (Constant)
        directionU = [-1,1,-1,0,-1,-1,0,-1,1,-1,1,0,1,1,0,1];
        directionD = [1,-1,1,0,1,1,0,1,-1,1,-1,0,-1,-1,0,-1];
        neighborR  = [ -1,1, -1,1, -1,1, 0,0,1,-1, 1,-1, -1,1, -1,1,-1,1, 0,0, 1,-1, 1,-1 ];
		neighborC  = [ 0,0, -1,1, -1,1, -1,1,-1,1, -1,1, 0,0, -1,1,-1,1, -1,1, -1,1, -1,1 ];
		neighborR2 = [ -1,1,  -1,1,  0,0,  1,-1,-1,1,  -1,1,  0,0,  1,-1 ];
		neighborC2 = [0,0,  -1,1, -1,1,  -1,1,0,0,  -1,1, -1,1,  -1,1 ];
        maxNo = 50000;
    end
    
    methods
        function readImage(pict, sw)
        template1        =  [100,100,100,100,100;100,100,100,100,100;0,0,0,0,0;-100,-100,-100,-100,-100;-100, -100, -100, -100, -100];
		template1(:,:,2) = 	[100,  100,  100,  100,  100;100,  100,  100,   78,  -32;100,   92,    0,  -92, -100;32,  -78, -100, -100, -100;-100, -100, -100, -100, -100];
		template1(:,:,3) =  [100,  100,  100,   32, -100;100,  100,   92,  -78, -100;100,  100,    0, -100, -100;100,   78,  -92, -100, -100;100,  -32, -100, -100, -100]; 
		template1(:,:,4) = 	[100,  100, 0, -100, -100;100,  100, 0, -100, -100;100,  100, 0, -100, -100;100,  100, 0, -100, -100;100,  100, 0, -100, -100];
		template1(:,:,5) = 	[100,  -32, -100, -100, -100;100,   78,  -92, -100, -100;100,  100,    0, -100, -100;100,  100,   92,  -78, -100;100,  100,  100,   32, -100]; 
		template1(:,:,6) = 	[-100, -100, -100, -100, -100;32,  -78, -100, -100, -100;100,   92,    0,  -92, -100;100,  100,  100,   78,  -32;100,  100,  100,  100,  100];
        
        template2        = [100,  100,  100;0,    0,    0;-100, -100, -100]; 
		template2(:,:,2) = [100,  100,    0;100,    0, -100;0, -100, -100]; 
		template2(:,:,3) = [100,    0, -100;100,    0, -100;100,    0, -100]; 
		template2(:,:,4) = 	[0, -100, -100;100,    0, -100;100,  100,    0 ];
        end
    end
    
    methods %generate_Lin
        function generate_Lin(pict, sz)
            sw = fopen(sz,'w');
            process(pict,3,sw);
            fclose(sw);
        end
        
        function process(pict, argC,sw)
            obj.Height=size(pict,1);
            obj.Width=size(pict,2);
            count = -1;
            pict(pict>=100)=255;
            n = numel(pict);
            for ending = 1:n
                if pict(ending)==255
                    obj.binI = 1;
                    selectedEnd(ending,pict);
                    traceBoundary(ending,pict,sw);
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
        
        function traceBoundary(ending, pict,sw)
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
            fprintf(sw, '%d %d\n', int64(obj.startR), int64(obj.startC));
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
                fprintf(sw, '%d %d\n', int64(obj.nextR), int64(obj.nextC));
                garBin(obj.binI) = obj.startR;
                obj.binI = obj.binI + 1;
                garBin(obj.binI) = obj.startC;
                obj.binI = obj.binI + 1;
                if obj.nextR == obj.originalR && obj.nextC == obj.originalC
                    %write (-1)
                    fprintf(fid, '%d\n',-1);
                   break;
                end
                pict(obj.nextR, obj.nextC) = 250;
                obj.startR = obj.nextR;
                obj.startC = obj.nextC;
            end
            %write (-1)
            fprintf(fid, '%d\n',-1);
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
    
    methods %generate_thin
        function generate_thin(pic, max5, pict)
            intA = zeros(obj.Height,obj.Width);
            intA2 = zeros(obj.Height,obj.Width);
            intA3 = zeros(obj.Height,obj.Width);
            intA4 = zeros(obj.Height,obj.Width);
            dirA = zeros(obj.Height,obj.Width);
            dirA2 = zeros(obj.Height,obj.Width);
            dirA3 = zeros(obj.Height,obj.Width);
            temp = zeros(obj.Height,obj.Width);
            navet(pic, intA, dirA);
            max1 = getMax(intA);
            navet2(pic, intA2, dirA2);
            max2 = getMax(intA2);
            intA4(:)=intA2;
            combine(intA,intA2,dirA,dirA2,max1,max2,intA3,dirA3);
            thinEd(intA,dirA);
            thinEd2(intA4,dirA2);
            combine2(intA,intA4,intA3,max1,max2);
            intA4(:) = 0;
            intA4(intA3(:) >= max5) = 255;
            
            %beforethin...
        end
        
        function navet(pict, intA, dirA)
            intA(:) = 0;
            dirA(:) = 0;
            v = 0;
            for i = 3:obj.Height-2
                for j = 3:obj.Width-2
                    maxValue = 0;
                    dir = 0;
                    for k=1:6
                        v = 0;
                        for p = 1:5
                            m = i-2 +(p-1);
                            for q = 1:5
                                n = i-2+(q-1);
                                v = v + (obj.template1(p,q,k) * pict(m,n));
                            end
                        end
                        if abs(v) > maxValue
                            maxValue = abs(v);
                            dir = k;
                            if v < 0 
                                dir = dir+6;
                            end
                        end
                    end
                    intA(i,j) = maxValue;
                    dirA(i,j) = dir;
                end
            end
            intA(:) = int64(intA(:)/1000);
        end
        
        function navet2(pict, intA, dirA)
            intA(:) = 0;
            dirA(:) = 0;
            v = 0;
            for i = 2:obj.Height-1
                for j = 2:obj.Width-1
                    maxValue = 0;
                    dir = 0;
                    for k=1:4
                        v = 0;
                        for p = 1:3
                            m = i-1 +(p-1);
                            for q = 1:3
                                n = i-1+(q-1);
                                v = v + (obj.template2(p,q,k) * pict(m,n));
                            end
                        end
                        if abs(v) > maxValue
                            maxValue = abs(v);
                            dir = k;
                            if v < 0
                                dir = dir+4;
                            end
                        end
                    end
                    intA(i,j) = maxValue;
                    dirA(i,j) = dir;
                end
            end
            intA(:) = int64(intA(:)/300);
        end
        
        function m = getMax(mat)
            k=0;
            for i = 1:size(mat,1)
                for j = 1:size(mat,2)
                    m = mat(i,j);
                    if k<m
                        k=m;
                    end
                    if m > 255
                        mat(i,j)=255;
                    end
                end
            end
        end
        
        function combine(intA, intA2, dirA, dirA2, max1, max2, intA3, dirA3)
            ratio = float(max1/max2);
            intA2(:) = int64(intA2(:) * ratio);
            for i=2:obj.Height-1
                for j=2:obj.Width-1
                    if intA2(i,j) > intA(i,j)
                        intA3(i,j)=intA2(i,j);
                        m = dirA(i,j);
                        n = dirA2(i,j);
                        switch n
                            case 1
                                if m==2 || m==12
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 1;
                                end
                                break;
                            case 2
                                if m==2 || m==3
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 2;
                                end
                                break;
                            case 3
                                if m==3 || m==5
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 4;
                                end
                                break;
                            case 4
                                if m==5 || m==6
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 5;
                                end
                                break;
                            case 5
                                if m==6 || m==8
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 7;
                                end
                                break;
                            case 6
                                if m==8 || m==9
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 8;
                                end
                                break;
                            case 7
                                if m==9 || m==11
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 10;
                                end
                                break;
                            case 8
                                if m==11 || m==12
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 11;
                                end
                                break;
                            otherwise
                                break;
                        end
                    else
                        intA3(i,j) = intA(i,j);
                        dirA3(i,j) = dirA(i,j);
                    end
                end
            end
        end
        
        function combine2(intA, intA2, intA3, max1, max2)
            ratio = float(max1/max2);
            intA2(:) = int64(intA2(:) * ratio);
            for i = 2:obj.Height - 1
                for j = 2:obj.Width - 1
                    if intA2(i,j) > intA(i,j)
                        intA3(i,j) = intA2(i,j);
                    else
                        intA3(i,j) = intA2(i,j);
                    end
                end
            end
        end
        
        function thinEd(intA, dirA)
            yes = zeros(obj.Height,obj.Width);
            for i = 2:obj.Height-1
                for j=2:obj.Width-1
                    dir = dirA(i,j);
                    if dir >= 1
                        index = bitshift(dir,1);
                        inten = intA(i,j);
                        for k=1:2
                            index = index + 1;
                            r = i + obj.neighborR(index);
                            c = j + obj.neighborC(index);
                            if inten < intA(r,c)
                                break;
                            end
                            dir2 = dirA(r,c);
                            if(dir2 >= 1)
                                dir2 = abs(dir2-dir);
                                if dir2 > 3 && dir2 <11
                                    break;
                                end
                            end
                        end
                        if k >= 3
                            yes(i,j) = 1;
                        end
                    end
                end
            end
            intA(yes==0) = 0;
        end
        
        function thinEd2(intA, dirA)
            yes = zeros(obj.Height,obj.Width);
            for i = 2:obj.Height-1
                for j=2:obj.Width-1
                    dir = dirA(i,j);
                    if dir >= 1
                        index = bitshift(dir,1);
                        inten = intA(i,j);
                        for k=1:2
                            index = index + 1;
                            r = i + obj.neighborR2(index);
                            c = j + obj.neighborC2(index);
                            if inten < intA(r,c)
                                break;
                            end
                            dir2 = dirA(r,c);
                            if(dir2 >= 1)
                                dir2 = abs(dir2-dir);
                                if dir2 > 2 && dir2 <8
                                    break;
                                end
                            end
                        end
                        if k >= 3
                            yes(i,j) = 1;
                        end
                    end
                end
            end
            intA(yes==0) = 0;
        end
    end
end

