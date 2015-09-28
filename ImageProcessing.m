classdef ImageProcessing
    %ImageProcessing Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Width = 0;
        Height = 0;
        binI; 
        startR, startC, originalR, originalC, nextR, nextC;
        endFlag;
        template1;template2;
        head;
        ptD;
        SCALEreciprocol = 4;
        da;
        nMinusOne;n;
        d,d1,d0,d2,d05,minusD,minusD1,plusD1,dSq,rMax,rb,Db,cosw,tanw,d10,d06;
        minIncr,itNo, d0Scale;
        multiple;
        perpenDist;
    end   
    properties (Constant)
        directionU = [-1,1,-1,0,-1,-1,0,-1,1,-1,1,0,1,1,0,1];
        directionD = [1,-1,1,0,1,1,0,1,-1,1,-1,0,-1,-1,0,-1];
        neighborR  = [ -1,1, -1,1, -1,1, 0,0,1,-1, 1,-1, -1,1, -1,1,-1,1, 0,0, 1,-1, 1,-1 ];
		neighborC  = [ 0,0, -1,1, -1,1, -1,1,-1,1, -1,1, 0,0, -1,1,-1,1, -1,1, -1,1, -1,1 ];
		neighborR2 = [ -1,1,  -1,1,  0,0,  1,-1,-1,1,  -1,1,  0,0,  1,-1 ];
		neighborC2 = [0,0,  -1,1, -1,1,  -1,1,0,0,  -1,1, -1,1,  -1,1 ];
        maxNo = 50000;
        STEP = 1600;
        SMALLa = single(0.2);
    end
    
    methods
        function obj = ImageProcessing(pict,h,sz)
        obj.head = h;
        obj.ptD(21,obj.maxNo) = PointD();
        obj.da = single.empty(20,0);
        obj.perpenDist = single.empty(100000,0);
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
        function generate_Lin(obj,pict, sz)
            sw = fopen(sz,'w');
            obj.process(pict,3,sw);
            fclose(sw);
        end
        
        function process(obj,pict, argC,sw)
            obj.Height=size(pict,1);
            obj.Width=size(pict,2);
            count = -1;
            pict(pict>=100)=255;
            n = numel(pict);
            for ending = 1:n
                if pict(ending)==255
                    obj.binI = 1;
                    obj.selectedEnd(ending,pict);
                    obj.traceBoundary(ending,pict,sw);
                    if obj.binI >= obj.maxNo
                        return;
                    end
                    if argC == 2
                        count = mod(count+1,8);
                    end
                end
            end
        end
        
        function selectedEnd(obj,ending, pict)
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
        
        function traceBoundary(obj,ending, pict,sw)
            [r,c]=ind2sub([obj.Height,obj.Width],ending);
            [obj.startR, obj.originalR] = deal(r);
            [obj.startC, obj.originalC] = deal(c);
            obj.nextR = 0;
            obj.nextC = 0;
            pict(obj.startR,obj.startC) = 250;
            if obj.singlePixel(pict, obj.startR, obj.startC)
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
                obj.nextBoundaryPt(pict);
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
        
        function sp = singlePixel(obj,pict, r, c)
            sp = true;
            for i = 1:2:16
                j = obj.directionD(i) + r;
                k = obj.directionD(i+1) + c;
                if j>=1 && j<=obj.Height && k>=1 && k<=obj.Width && pict(j,k)==255
                    sp = false;
                end
            end
        end
        
        function nextBoundaryPt(obj,pict)
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
    
    methods %generate_Thin
        function generate_Thin(obj,pic, max5, pict)
            intA = zeros(obj.Height,obj.Width);
            intA2 = zeros(obj.Height,obj.Width);
            intA3 = zeros(obj.Height,obj.Width);
            intA4 = zeros(obj.Height,obj.Width);
            dirA = zeros(obj.Height,obj.Width);
            dirA2 = zeros(obj.Height,obj.Width);
            dirA3 = zeros(obj.Height,obj.Width);
            tmp = zeros(obj.Height,obj.Width);
            obj.navet(pic, intA, dirA);
            max1 = obj.getMax(intA);
            obj.navet2(pic, intA2, dirA2);
            max2 = obj.getMax(intA2);
            intA4(:)=intA2;
            obj.combine(intA,intA2,dirA,dirA2,max1,max2,intA3,dirA3);
            obj.thinEd(intA,dirA);
            obj.thinEd2(intA4,dirA2);
            obj.combine2(intA,intA4,intA3,max1,max2);
            intA4(:) = 0;
            intA4(intA3(:) >= max5) = 255;
            obj.beforeThin(intA4, tmp);
            obj.thining(tmp,pict,obj.Height,obj.Width,1,0);
            obj.afterThin(pict);
        end
        
        function navet(obj,pict, intA, dirA)
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
        
        function navet2(obj,pict, intA, dirA)
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
        
        function m = getMax(obj,mat)
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
        
        function combine(obj,intA, intA2, dirA, dirA2, max1, max2, intA3, dirA3)
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
        
        function combine2(obj,intA, intA2, intA3, max1, max2)
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
        
        function thinEd(obj,intA, dirA)
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
        
        function thinEd2(obj,intA, dirA)
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
        
        function beforeThin(obj,ip,jp)
            jp(:) = 0;
            jp(ip>0) = 1;
        end
        
        function afterThin(obj,jp)
            jp(:) = jp(:) * 255;
        end
        
        function can = canThin(obj,pic, i,j)
            can = false;
            temp = zeros(3,3);
            v = 1;
            %copy the centre pixel and its neighbors to temp array.
            for a = 0:2
                for b = 0:2
                    temp(a+1,b+1) = pic(i+a,j+b);
                end
            end
            %secure the connectivity.
            horizontal = temp(2,1) + temp(2,2) + temp(2,3);
            vertical   = temp(1,2) + temp(2,2) + temp(3,2);
            
            if horizontal == 1
                if temp(1,1) + temp(1,2) + temp(1,3) == 1 && temp(3,1) + temp(3,2) + temp(3,3) == 1
                    return;
                end
            end
            
            if vertical == 1
                if temp(1,1) + temp(2,1) + temp(3,1) == 1 && temp(1,3) + temp(2,3) + temp(3,3) ==1
                    return;
                end
            end
            %set the center of temp to 0
            temp(2,2) = 0;
            %check non-zero pixels in temp
            for a = 1:3
                for b = 1:3
                    if temp(a,b) == v;
                        temp(a,b) = 0;
                        no_neighbor = 1;
                        for c = 0:2
                            for d = 0:2
                                if (a+c) >= 1 && (a+c) <= 3 && (b+d) >= 1 && (b+d) <= 3
                                    if temp(a+c,b+d) == v
                                        no_neighbor = 0;
                                    end
                                end
                            end
                        end
                        temp(a,b) = v;
                        if no_neighbor == 1
                            return;
                        end
                    end
                end
            end
            can = true;
        end
        
        function thining(obj,pic, pict, height, width, threshold, once_only)
            pict(:) = pic;
            not_finished = 1;
            while not_finished==1
                if (once_only == 1)
                    not_finished = 0;
                end
                big_count = 0;
                %left to right
                for i = 2:height-1
                    for j = 2:width-1
                        if pic(i,j-1) == 0 && pic(i,j) == 1
                            count = 0;
                            for a = 0:2
                                for b = 0:2
                                    if pic(i+a,j+b) == 0
                                        count = count+1;
                                    end
                                end
                            end
                            if count > threshold
                                if obj.canThin(pic,i,j)
                                    pict(i,j) = 0;
                                    big_count = big_count+1;
                                end
                            end
                        end
                    end
                end
                pic(:) = pict;
                %right to left
                for i = 2:height-1
                    for j = 2:width-1
                        if pic(i,j+1)==0 && pic(i,j) == 1
                            count = 0;
                            for a = 0:2
                                for b = 0:2
                                    if pic(i+a,j+b) == 0
                                        count = count + 1;
                                    end
                                end
                            end
                            if count > threshold
                                if obj.canThin(pic,i,j)
                                    pict(i,j) = 0;
                                    big_count = big_count+1;
                                end
                            end
                        end
                    end
                end
                pic(:) = pict;
                %top to bottom
                for i = 2:height-1
                    for j = 2:width-1
                        if pic(i-1,j)==0 && pic(i,j) == 1
                            count = 0;
                            for a = 0:2
                                for b = 0:2
                                    if pic(i+a,j+b) == 0
                                        count = count + 1;
                                    end
                                end
                            end
                            if count > threshold
                                if obj.canThin(pic,i,j)
                                    pict(i,j) = 0;
                                    big_count = big_count+1;
                                end
                            end
                        end
                    end
                end
                pic(:) = pict;
                %bottom to top
                for i = 2:height-1
                    for j = 2:width-1
                        if pic(i+1,j)==0 && pic(i,j) == 1
                            count = 0;
                            for a = 0:2
                                for b = 0:2
                                    if pic(i+a,j+b) == 0
                                        count = count + 1;
                                    end
                                end
                            end
                            if count > threshold
                                if obj.canThin(pic,i,j)
                                    pict(i,j) = 0;
                                    big_count = big_count+1;
                                end
                            end
                        end
                    end
                end
                pic(:) = pict;
                if big_count == 0
                    not_finished = 0;
                end
            end
        end
    end
    
    methods %generate_FPM
        function generate_FPM(obj,sz)
            debug = 0;
            halfWidth = single(0.2);
            meritDisplay = 1;
            sw = fopen(sz,'w');
            fs = fopen([obj.head,'dyn2S.rlt'],'w');
            fclose(fs);
            fsis = fopen([obj.head,'dyn2S-is.rlt'],'w');
            fclose(fsis);
            row = zeros(obj.maxNo);
            col = zeros(obj.maxNo);
            k = 0;
            while true
                while true
                    ptI = 0;
                    line = '';
                    try
                        line = fgetl(sw);
                        row(ptI) = int32(line(1:strfind(line,' ')-1));
                        col(ptI) = int32(line(strfind(line,' ')+1:length(line)));
                    catch
                        break;
                    end
                    ptI = ptI + 1;
                end
                k = k+1;
                if ptI == 0
                    break;
                end
                obj.dyn2S % doing
            end
            fclose(sw);
        end
        
        function dyn2S(obj,nn,scale, scales, stripRatioo, arX, arY, meritDisplay)
            if arX(0) == arX(nn-1) && arY(0) == arY(nn-1)
                nn = nn-1;
                closedCurve = 1;
            else
                closedCurve = 0;
            end
            obj.n = nn;
            stripRatio = stripRatioo;
            fs = fopen([obj.head,'dyn2S.rlt'],'a');
            if obj.n<=3
                for i = 1:obj.n
                    obj.ptD(1,i).merit = -200;
                    obj.ptD(1,i).meritL = -200;
                    obj.ptD(1,i).meritR = -200;
                    obj.ptD(1,i).leftStep = -200;
                    obj.ptD(1,i).rightStep = -200;
                    obj.ptD(1,i).step = -200;
                    obj.ptD(1,i).angle = -200;
                    obj.ptD(1,i).yes = 10;
                end
                %output(1,1,1,arX,arY,sw)
                fclose(fs);
                return;
            end
            if obj.n > 100000
                return;
            end
            for i = 1:obj.n
                obj.ptD(1,i).merit = 0;
                    obj.ptD(1,i).meritL = 0;
                    obj.ptD(1,i).meritR = 0;
                    obj.ptD(1,i).leftStep = 0;
                    obj.ptD(1,i).rightStep = 0;
                    obj.ptD(1,i).step = 0;
                    obj.ptD(1,i).angle = 0;
            end
            obj.d0 = arX(2)-arX(1);
            if obj.d0 == 0
                obj.d0 = arY(2)-arY(1);
            end
            if obj.d0 == 0
                return;
            end
            if obj.d0 < 0
                obj.d0 = -obj.d0;
            end
            obj.minIncr = single(obj.d0 * 0.2);
            obj.d0 = single(obj.d0 * 0.5);
            obj.d05 = obj.d0;
            obj.itNo = int32((scale2-scale) * obj.SCALEreciprocol);
            if obj.itNo > 20
                obj.itNo = 20;
            end
            obj.d1 = obj.d0 * scale2;
            obj.d0Scale = obj.d0 * scale;
            obj.d0 = obj.d0Scale;
            fprintf(fs,'Half widths of the strips = \n');
            for i = 1:obj.itNo
                obj.da(i) =obj.d0 + obj.d05*i/obj.SCALEreciprocol;
                if mod(i,8)==0
                    fprintf(fs,'\n');
                end
                fprintf(fs,[num2str(obj.da(i)),' ']);
            end
            fprintf(fs,'\n');
            fprintf(fs,'\n');
            
            obj.nMinusOne = obj.n - 1;
            obj.multiple = obj.STEP/ obj.SMALLa;
            obj.perpenDist(1) = single(0.0);
        end
        
    end
    
end

