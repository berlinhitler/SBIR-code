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
        da,dir;
        iMax,n,growI,gIMax,upFlag,nMinusOne,d1Flag,itNo,iL,iR;
        d,d1,d0,d2,d05,minusD,minusD1,plusD1,dSq,rMax,rb,Db,cosw,tanw,d10,d06,dx,dy;
        minIncr, d0Scale;
        multiple, distance;
        rotateDownA, rotateUpA,upDist,lowDist;
        perpenDist;
        deg120,deg165,deg170,deg190,deg195;
        formerI,globalI,endL,endR,spinFlag,endI;
        startX, startY, dletaX, deltaYm, signn, r, negativeSign, subst,errorV, errorV2, subst2;
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
        twoPi = single(2 * pi);
        deg10=single(0.174532925);
        artTan = [0.000000,0.002500,0.005000,0.007500,0.010000,0.012499,0.014999,0.017498,0.019997,0.022496,0.024995,0.027493,0.029991,0.032489,0.034986,0.037482,0.039979,0.042474,0.044970,0.047464,0.049958,0.052452,0.054945,0.057437,0.059928,0.062419,0.064909,0.067398,0.069886,0.072373,0.074860,0.077345,0.079830,0.082314,0.084796,0.087278,0.089758,0.092238,0.094716,0.097193,0.099669,0.102143,0.104617,0.107089,0.109560,0.112029,0.114497,0.116964,0.119429,0.121893,0.124355,0.126816,0.129275,0.131733,0.134189,0.136643,0.139096,0.141547,0.143996,0.146444,0.148890,0.151334,0.153776,0.156217,0.158655,0.161092,0.163527,0.165959,0.168390,0.170819,0.173246,0.175670,0.178093,0.180513,0.182932,0.185348,0.187762,0.190174,0.192583,0.194991,0.197396,0.199798,0.202199,0.204597,0.206992,0.209385,0.211776,0.214164,0.216550,0.218934,0.221314,0.223693,0.226068,0.228441,0.230812,0.233180,0.235545,0.237907,0.240267,0.242624,0.244979,0.247330,0.249679,0.252025,0.254368,0.256708,0.259046,0.261380,0.263712,0.266040,0.268366,0.270689,0.273009,0.275325,0.277639,0.279950,0.282257,0.284562,0.286863,0.289162,0.291457,0.293749,0.296038,0.298323,0.300606,0.302885,0.305161,0.307434,0.309703,0.311969,0.314232,0.316491,0.318748,0.321000,0.323250,0.325496,0.327739,0.329978,0.332214,0.334446,0.336675,0.338900,0.341122,0.343341,0.345556,0.347767,0.349975,0.352179,0.354380,0.356577,0.358771,0.360961,0.363147,0.365330,0.367509,0.369684,0.371856,0.374024,0.376189,0.378349,0.380506,0.382660,0.384809,0.386955,0.389097,0.391236,0.393370,0.395501,0.397628,0.399751,0.401871,0.403986,0.406098,0.408206,0.410310,0.412410,0.414507,0.416599,0.418688,0.420773,0.422854,0.424931,0.427004,0.429073,0.431139,0.433200,0.435258,0.437311,0.439361,0.441407,0.443448,0.445486,0.447520,0.449550,0.451576,0.453598,0.455616,0.457630,0.459640,0.461646,0.463648,0.465646,0.467640,0.469630,0.471616,0.473598,0.475575,0.477549,0.479519,0.481485,0.483447,0.485405,0.487359,0.489308,0.491254,0.493196,0.495133,0.497067,0.498996,0.500922,0.502843,0.504761,0.506674,0.508583,0.510488,0.512389,0.514287,0.516180,0.518069,0.519953,0.521834,0.523711,0.525584,0.527452,0.529317,0.531178,0.533034,0.534887,0.536735,0.538579,0.540420,0.542256,0.544088,0.545916,0.547740,0.549560,0.551376,0.553188,0.554996,0.556800,0.558599,0.560395,0.562187,0.563974,0.565758,0.567538,0.569313,0.571085,0.572852,0.574616,0.576375,0.578131,0.579882,0.581630,0.583373,0.585112,0.586848,0.588579,0.590307,0.592030,0.593750,0.595465,0.597177,0.598884,0.600588,0.602287,0.603983,0.605675,0.607362,0.609046,0.610726,0.612402,0.614074,0.615742,0.617406,0.619066,0.620722,0.622375,0.624023,0.625668,0.627308,0.628945,0.630578,0.632207,0.633832,0.635453,0.637070,0.638684,0.640293,0.641899,0.643501,0.645099,0.646693,0.648284,0.649870,0.651453,0.653032,0.654607,0.656179,0.657746,0.659310,0.660870,0.662426,0.663979,0.665527,0.667072,0.668614,0.670151,0.671685,0.673215,0.674741,0.676263,0.677782,0.679297,0.680809,0.682317,0.683821,0.685321,0.686818,0.688311,0.689800,0.691286,0.692768,0.694246,0.695721,0.697192,0.698660,0.700124,0.701584,0.703041,0.704494,0.705944,0.707390,0.708832,0.710271,0.711706,0.713138,0.714566,0.715991,0.717412,0.718830,0.720244,0.721655,0.723062,0.724466,0.725866,0.727263,0.728656,0.730046,0.731432,0.732815,0.734195,0.735571,0.736943,0.738313,0.739678,0.741041,0.742400,0.743756,0.745108,0.746457,0.747802,0.749145,0.750484,0.751819,0.753151,0.754480,0.755806,0.757128,0.758447,0.759763,0.761075,0.762384,0.763690,0.764993,0.766292,0.767588,0.768881,0.770171,0.771457,0.772741,0.774021,0.775297,0.776571,0.777842,0.779109,0.780373,0.781634,0.782892,0.784147,0.785398,0.785398]
        Sin =    [0.000000,0.003927,0.007854,0.011781,0.015707,0.019634,0.023560,0.027486,0.031411,0.035336,0.039260,0.043184,0.047107,0.051029,0.054950,0.058871,0.062791,0.066709,0.070627,0.074544,0.078459,0.082373,0.086286,0.090198,0.094108,0.098017,0.101924,0.105830,0.109734,0.113637,0.117537,0.121436,0.125333,0.129228,0.133121,0.137012,0.140901,0.144788,0.148672,0.152555,0.156434,0.160312,0.164187,0.168059,0.171929,0.175796,0.179661,0.183522,0.187381,0.191237,0.195090,0.198940,0.202787,0.206631,0.210472,0.214309,0.218143,0.221974,0.225801,0.229625,0.233445,0.237262,0.241075,0.244884,0.248690,0.252492,0.256289,0.260083,0.263873,0.267659,0.271440,0.275218,0.278991,0.282760,0.286525,0.290285,0.294040,0.297791,0.301538,0.305280,0.309017,0.312749,0.316477,0.320200,0.323917,0.327630,0.331338,0.335040,0.338738,0.342430,0.346117,0.349799,0.353475,0.357146,0.360811,0.364470,0.368125,0.371773,0.375416,0.379052,0.382683,0.386309,0.389928,0.393541,0.397148,0.400749,0.404344,0.407932,0.411514,0.415090,0.418660,0.422223,0.425779,0.429329,0.432873,0.436409,0.439939,0.443462,0.446979,0.450488,0.453990,0.457486,0.460974,0.464456,0.467930,0.471397,0.474856,0.478309,0.481754,0.485191,0.488621,0.492044,0.495459,0.498866,0.502266,0.505657,0.509041,0.512418,0.515786,0.519146,0.522499,0.525843,0.529179,0.532507,0.535827,0.539138,0.542442,0.545736,0.549023,0.552301,0.555570,0.558831,0.562083,0.565327,0.568562,0.571788,0.575005,0.578214,0.581413,0.584604,0.587785,0.590958,0.594121,0.597275,0.600420,0.603556,0.606682,0.609799,0.612907,0.616005,0.619094,0.622173,0.625243,0.628303,0.631353,0.634393,0.637424,0.640445,0.643456,0.646457,0.649448,0.652429,0.655400,0.658361,0.661312,0.664252,0.667183,0.670103,0.673013,0.675912,0.678801,0.681679,0.684547,0.687404,0.690251,0.693087,0.695913,0.698727,0.701531,0.704325,0.707107,0.709878,0.712639,0.715388,0.718126,0.720854,0.723570,0.726275,0.728969,0.731651,0.734323,0.736982,0.739631,0.742268,0.744894,0.747508,0.750111,0.752702,0.755282,0.757850,0.760406,0.762950,0.765483,0.768004,0.770513,0.773010,0.775496,0.777969,0.780430,0.782880,0.785317,0.787742,0.790155,0.792556,0.794944,0.797321,0.799685,0.802036,0.804376,0.806703,0.809017,0.811319,0.813608,0.815885,0.818150,0.820401,0.822641,0.824867,0.827081,0.829281,0.831470,0.833645,0.835807,0.837957,0.840094,0.842217,0.844328,0.846426,0.848510,0.850582,0.852640,0.854685,0.856718,0.858736,0.860742,0.862734,0.864713,0.866679,0.868632,0.870570,0.872496,0.874408,0.876307,0.878192,0.880063,0.881921,0.883766,0.885596,0.887413,0.889217,0.891007,0.892782,0.894545,0.896293,0.898028,0.899748,0.901455,0.903148,0.904827,0.906492,0.908143,0.909780,0.911403,0.913012,0.914607,0.916188,0.917755,0.919307,0.920845,0.922370,0.923880,0.925375,0.926857,0.928324,0.929776,0.931215,0.932639,0.934049,0.935444,0.936825,0.938191,0.939543,0.940881,0.942204,0.943512,0.944806,0.946085,0.947350,0.948600,0.949836,0.951057,0.952263,0.953454,0.954631,0.955793,0.956940,0.958073,0.959191,0.960294,0.961382,0.962455,0.963514,0.964557,0.965586,0.966600,0.967599,0.968583,0.969552,0.970506,0.971446,0.972370,0.973279,0.974173,0.975053,0.975917,0.976766,0.977600,0.978419,0.979223,0.980012,0.980785,0.981544,0.982287,0.983016,0.983729,0.984427,0.985109,0.985777,0.986429,0.987066,0.987688,0.988295,0.988886,0.989463,0.990024,0.990569,0.991100,0.991615,0.992115,0.992599,0.993068,0.993522,0.993961,0.994384,0.994792,0.995185,0.995562,0.995924,0.996270,0.996602,0.996917,0.997218,0.997503,0.997772,0.998027,0.998266,0.998489,0.998697,0.998890,0.999067,0.999229,0.999376,0.999507,0.999622,0.999722,0.999807,0.999877,0.999931,0.999969,0.999992,1.000000,1.000000]
        artSin = [0.000000,0.002500,0.005000,0.007500,0.010000,0.012500,0.015001,0.017501,0.020001,0.022502,0.025003,0.027504,0.030005,0.032506,0.035007,0.037509,0.040011,0.042513,0.045015,0.047518,0.050021,0.052524,0.055028,0.057532,0.060036,0.062541,0.065046,0.067551,0.070057,0.072564,0.075071,0.077578,0.080086,0.082594,0.085103,0.087612,0.090122,0.092632,0.095144,0.097655,0.100167,0.102680,0.105194,0.107708,0.110223,0.112739,0.115255,0.117772,0.120290,0.122808,0.125328,0.127848,0.130369,0.132891,0.135413,0.137937,0.140461,0.142987,0.145513,0.148040,0.150568,0.153097,0.155627,0.158159,0.160691,0.163224,0.165758,0.168293,0.170830,0.173367,0.175906,0.178446,0.180986,0.183529,0.186072,0.188616,0.191162,0.193709,0.196257,0.198807,0.201358,0.203910,0.206464,0.209019,0.211575,0.214133,0.216692,0.219252,0.221814,0.224378,0.226943,0.229510,0.232078,0.234647,0.237219,0.239791,0.242366,0.244942,0.247520,0.250099,0.252680,0.255263,0.257848,0.260434,0.263022,0.265612,0.268204,0.270798,0.273393,0.275990,0.278590,0.281191,0.283794,0.286399,0.289006,0.291616,0.294227,0.296840,0.299456,0.302073,0.304693,0.307314,0.309938,0.312565,0.315193,0.317824,0.320457,0.323092,0.325729,0.328369,0.331012,0.333656,0.336304,0.338953,0.341605,0.344260,0.346917,0.349577,0.352239,0.354904,0.357571,0.360241,0.362914,0.365590,0.368268,0.370949,0.373633,0.376319,0.379009,0.381701,0.384397,0.387095,0.389796,0.392501,0.395208,0.397918,0.400632,0.403348,0.406068,0.408791,0.411517,0.414246,0.416979,0.419715,0.422454,0.425197,0.427943,0.430692,0.433445,0.436202,0.438962,0.441726,0.444493,0.447264,0.450038,0.452817,0.455599,0.458385,0.461174,0.463968,0.466765,0.469567,0.472372,0.475182,0.477995,0.480813,0.483635,0.486461,0.489291,0.492125,0.494964,0.497807,0.500655,0.503507,0.506363,0.509224,0.512090,0.514960,0.517835,0.520714,0.523599,0.526488,0.529382,0.532281,0.535185,0.538094,0.541008,0.543927,0.546851,0.549780,0.552715,0.555655,0.558601,0.561551,0.564508,0.567470,0.570437,0.573410,0.576389,0.579374,0.582364,0.585361,0.588363,0.591371,0.594386,0.597406,0.600433,0.603466,0.606506,0.609552,0.612604,0.615663,0.618729,0.621801,0.624880,0.627966,0.631059,0.634159,0.637266,0.640380,0.643501,0.646630,0.649766,0.652909,0.656061,0.659219,0.662386,0.665560,0.668743,0.671933,0.675132,0.678338,0.681553,0.684777,0.688009,0.691249,0.694498,0.697756,0.701023,0.704299,0.707584,0.710879,0.714183,0.717496,0.720819,0.724151,0.727494,0.730846,0.734209,0.737582,0.740965,0.744358,0.747763,0.751178,0.754604,0.758041,0.761489,0.764949,0.768420,0.771903,0.775397,0.778904,0.782423,0.785954,0.789498,0.793055,0.796624,0.800207,0.803802,0.807412,0.811034,0.814671,0.818322,0.821987,0.825667,0.829361,0.833070,0.836795,0.840535,0.844290,0.848062,0.851850,0.855654,0.859475,0.863313,0.867168,0.871041,0.874932,0.878841,0.882769,0.886715,0.890681,0.894666,0.898671,0.902696,0.906742,0.910809,0.914897,0.919008,0.923140,0.927295,0.931474,0.935675,0.939901,0.944152,0.948428,0.952729,0.957057,0.961411,0.965793,0.970202,0.974640,0.979108,0.983605,0.988133,0.992692,0.997283,1.001907,1.006565,1.011258,1.015985,1.020749,1.025551,1.030391,1.035270,1.040189,1.045150,1.050154,1.055202,1.060296,1.065436,1.070624,1.075862,1.081152,1.086494,1.091891,1.097345,1.102858,1.108431,1.114068,1.119770,1.125539,1.131380,1.137294,1.143284,1.149354,1.155508,1.161749,1.168080,1.174508,1.181036,1.187669,1.194413,1.201274,1.208259,1.215375,1.222630,1.230034,1.237595,1.245325,1.253236,1.261342,1.269660,1.278206,1.287002,1.296072,1.305443,1.315150,1.325231,1.335735,1.346721,1.358265,1.370461,1.383440,1.397374,1.412517,1.429257,1.448245,1.470755,1.500071,1.570796,1.570796]
    end
    
    methods
        function obj = ImageProcessing(pict,h,sz)
        obj.head = h;
        obj.ptD(21,obj.maxNo) = PointD();
        obj.da = single.empty(20,0);
        obj.perpenDist = single.empty(100000,0);
        obj.distance = single.empty(100000,0);
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
                        return
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
                        break
                    end
                end
                if endPoint==1
                    return
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
                return
            end
            %sw.WriteLine(startR.ToString()+" "+startC.ToString());
            fprintf(sw, '%d %d\n', int32(floor(obj.startR)), int32(floor(obj.startC)));
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
                    return
                end
                %sw.WriteLine(nextR.ToString()+" "+nextC.ToString());
                fprintf(sw, '%d %d\n', int32(floor(obj.nextR)), int32(floor(obj.nextC)));
                garBin(obj.binI) = obj.startR;
                obj.binI = obj.binI + 1;
                garBin(obj.binI) = obj.startC;
                obj.binI = obj.binI + 1;
                if obj.nextR == obj.originalR && obj.nextC == obj.originalC
                    %write (-1)
                    fprintf(fid, '%d\n',-1);
                   break
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
                    return
                end
            end
            
            for i = 1:2:16
                j = obj.directionD(i) + p;
                k = obj.directionD(i+1) + q;
                if pict(j,k)==250
                    obj.endFlag = 1;
                    return
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
            intA(:) = int32(floor(intA(:)/1000));
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
            intA(:) = int32(floor(intA(:)/300));
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
            return
        end
        
        function combine(obj,intA, intA2, dirA, dirA2, max1, max2, intA3, dirA3)
            ratio = float(max1/max2);
            intA2(:) = int32(floor(intA2(:) * ratio));
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
                                break
                            case 2
                                if m==2 || m==3
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 2;
                                end
                                break
                            case 3
                                if m==3 || m==5
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 4;
                                end
                                break
                            case 4
                                if m==5 || m==6
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 5;
                                end
                                break
                            case 5
                                if m==6 || m==8
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 7;
                                end
                                break
                            case 6
                                if m==8 || m==9
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 8;
                                end
                                break
                            case 7
                                if m==9 || m==11
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 10;
                                end
                                break
                            case 8
                                if m==11 || m==12
                                    dirA3(i,j) = m;
                                else
                                    dirA3(i,j) = 11;
                                end
                                break
                            otherwise
                                break
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
            intA2(:) = int32(floor(intA2(:) * ratio));
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
                                break
                            end
                            dir2 = dirA(r,c);
                            if(dir2 >= 1)
                                dir2 = abs(dir2-dir);
                                if dir2 > 3 && dir2 <11
                                    break
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
                                break
                            end
                            dir2 = dirA(r,c);
                            if(dir2 >= 1)
                                dir2 = abs(dir2-dir);
                                if dir2 > 2 && dir2 <8
                                    break
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
                    return
                end
            end
            
            if vertical == 1
                if temp(1,1) + temp(2,1) + temp(3,1) == 1 && temp(1,3) + temp(2,3) + temp(3,3) ==1
                    return
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
                            return
                        end
                    end
                end
            end
            can = true;
            return
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
                    ptI = 1;
                    line = '';
                    try
                        line = fgetl(sw);
                        row(ptI) = int32(floor(line(1:strfind(line,' ')-1)));
                        col(ptI) = int32(floor(line(strfind(line,' ')+1:length(line))));
                    catch
                        break
                    end
                    ptI = ptI + 1;
                end
                k = k+1;
                if ptI == 1
                    break
                end
                %obj.dyn2S % doing
            end
            fclose(sw);
        end
        
        function dyn2S(obj,nn,scale, scale2, stripRatioo, arX, arY, meritDisplay)
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
                obj.output(1,2,2,arX,arY,fs);
                fclose(fs);
                return
            end
            if obj.n > 100000
                return
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
                return
            end
            if obj.d0 < 0
                obj.d0 = -obj.d0;
            end
            obj.minIncr = single(obj.d0 * 0.2);
            obj.d0 = single(obj.d0 * 0.5);
            obj.d05 = obj.d0;
            obj.itNo = int32(floor((scale2-scale) * obj.SCALEreciprocol));
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
            obj.deg120 = single(obj.deg10 * 12);
            obj.deg165 = single(obj.deg10 * 16.5);
            obj.deg170 = single(obj.deg10 * 17);
            obj.deg190 = single(obj.deg10 * 19);
            obj.deg195 = single(obj.deg10 * 19.5);
            obj.ESA(arX,arY);
            obj.eliminate0(sacle2,arX,arY);
            k = 0;
            for i = 1:obj.n
                if obj.ptD(1,i).yes == 1
                    k = k+1;
                    %computemerit(i,arX,arY);
                end
            end
            if closedCurve == 0
               obj. ptD(1,1).angle = 0;
                obj.ptD(1,obj.n).angle = 0;
                obj.ptD(1,1).merit = 50000;
                obj.ptD(1,obj.n).merit = 50000;
            end
            obj.eliminate01(scale,scale2,obj.itNo,arX,arY);
            if closedCurve == 0
                obj.ptD(1,1).angle = 0;
                obj.ptD(1,obj.n).angle = 0;
                obj.ptD(1,1).merit = 50000;
                obj.ptD(1,obj.n).merit = 50000;
            end
            k = 0;
            for i = 1:obj.n
                if obj.ptD(1,i).yes == 1
                    k = k+1;
                end
            end
            obj.eliminate1(arX,arY);
            k = 0;
            for i = 1:obj.n
                if obj.ptD(1,i).yes == 1
                    k = k+1;
                end
            end
            for i = 1:obj.itNo
                %eliminate3(i,arX,arY)
            end
            k = 0;
            for i = 1:obj.n
                if obj.ptD(1,i).yes == 1
                    k = k+1;
                end
            end
            for i = 1:obj.itNo
                %complement(i,arX,arY);
            end
            k = 0;
            for i = 1:obj.n
                if obj.ptD(1,i).yes == 1
                    k = k+1;
                end
            end
            for i = 1:obj.itNo
                obj.d0 = obj.da(i)/2;
                %eliminate2(i,arX,arY);
            end
            k = 0;
            for i = 1:obj.n
                if obj.ptD(1,i).yes == 1
                    k = k+1;
                end
            end
            obj.d0 = obj.d05 * scale;
            obj.output(1,1,obj.itNo,arX,arY,fs);
            if stripRatio > 0
                fclose(fs);
                %gloabal(arX,arY,meritDisplay);
            else
                fclose(fs);
            end
        end
        
        function output(obj, numb,start, ends, arX, arY, sw)
            previousI = 1;
            j = 1;
            i = 1;
            for k = start:ends
                fprintf(sw,'generation # %d\n',k);
                lineNo = 0;
                for i = 1:obj.n
                    if obj.ptD(k,i).yes >= numb
                        j = i;
                        previousI = i;
                        angle = single(180.0/pi * obj.ptD(k,i).angle);
                        fprintf(sw,'%d\t%f\t%f\n',i,arX(i),arY(i));
                        lineNo = 1;
                        break
                    end
                end
                iPlus = i + 1;
                for i = iPlus:obj.n
                    if obj.ptD(k,i).yes>=numb
                        angle = single(180.0/pi * obj.ptD(k,i).angle);
                        fprintf(sw,'%d\t%f\t%f\n',i,arX(i),arY(i));
                        lineNo = lineNo+1;
                        previousI = i;
                    end
                end
                if lineNo<2 || arX(previousI)~=arX(j) || arY(previousI)~=arY(j)
                    if lineNo>0
                        fprintf(sw,'%d\t%f\t%f\n',j,arX(j),arY(j));
                    end
                end
                if k<ends
                    fprintf(sw,' --------------------------------------------------------------\n');
                else
                    fprintf(sw,' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                end
            end
            fprintf(sw,'end\n\n');
        end
        
        function ESA(obj,arX, arY)
            obj.d10 = obj.d0/10;
            obj.dSq = obj.d10*obj.d10;
            obj.globalI = 1;
            obj.formerI = 1;
            while true
                if obj.globalI > obj.n
                    break
                end
                if ~obj.getInitialCL2(arX,arY)
                    break
                end
                if ~obj.growWithESA2(arX,arY)
                    break
                end
                obj.ptD(1,obj.formerI).step = obj.n-obj.formerI;
            end
        end
        
        function bool = getInitialCL2(obj,arX,arY)
            bool = false;
            obj.r = 0;
            if obj.globalI > 1
                obj.ptD(1,obj.formerI).step = obj.globalI - obj.formerI;
                obj.formerI = obj.globalI;
            end
            obj.startX = arX(obj.globalI);
            obj.startY = arY(obj.globalI);
            globalIPlus = obj.globalI + 1;
            for i = globalIPlus:obj.n
                obj.globalI = i;
                obj.deltaX = arX(i) - obj.startX;
                obj.deltaY = arY(i) - obj.startY;
                obj.r = obj.deltaX*obj.deltaX + obj.deltaY*obj.deltaY;
                if obj.r > obj.dSq+1
                    break
                end
            end
            if i > obj.n
                obj.globalI = obj.globalI - 1;
                bool = false;
                return
            end
            obj.r = single(sqrt(obj.r));
            obj.cosw = deltaX/obj.r;
            if deltaY >= 0
                obj.signn = 1;
            else
                obj.signn = -1;
            end
            if deltaY~=0
                obj.tanw = deltaY/deltaX;
            end
            obj.rMax = obj.r;
            bool = true;
            return
        end
        
        function boolean = growWithESA2(obj, arX, arY)
            boolean = true;
            obj.iMax = obj.globalI;
            while obj.globalI <= obj.n
                obj.globalI = obj.globalI + 1;
                obj.dx = arX(obj.globalI) - obj.startX;
                obj.dy = arY(obj.globalI) - obj.startY;
                if obj.deltaX == 0
                    obj.Db = (obj.dy - obj.tanw * obj.dx) * obj.cosw;
                    obj.rb = obj.Db * obj.tanw + obj.dx / obj.cosw;
                end
                if obj.rb < obj.rMax - obj.d10
                    obj.globalI = obj.iMax;
                    return
                else
                    if obj.Db >= 0.0
                        obj.dd = obj.Db;
                    else
                        obj.dd = -obj.Db;
                    end
                    if obj.dd > obj.d10
                        obj.globalI = obj.globalI - 1;
                        break
                    end
                    if obj.rb > obj.rMax
                        obj.rMax = obj.rb;
                        obj.iMax = obj.globalI;
                    end
                end
            end
            if obj.globalI > obj.n
                boolean = false;
                return
            end
            boolean = true;
            return
        end
        
        function eliminate0(obj, scale, arX, arY)
           scale = scale * 2;
           k = obj.n;
           i = 1;
           while i <= k
              j = obj.ptD(1,i).step;
              obj.ptD(1,i).yes = 1;
              if j <= scale
                  m=1;
                  while m < j && i <= k
                      obj.ptD(1,i).yes = 1;
                      m = m+1;
                      i = i+1;
                  end
              else
                  m=1;
                  while m < j && i <= k
                      obj.ptD(1,i).yes = 0;
                      obj.ptD(1.i).angle = single(pi);
                      m = m+1;
                      i = i+1;
                  end
              end
           end
           obj.ptD(0,k).yes = 1;
        end
        
        function eliminate01(obj, scale, scale2, itNo, arX, arY)
           scale = scale * 4;
           scale2 = scale2 * 2;
           increase = (scale2-scale)/itNo;
           if incease < 0
               scale = scale2;
               increase = 0;
           end
           k = obj.n;
           for p = 1:itNo
               i = 1;
               while i <= k
                   j = obj.ptD(1,1i).step;
                   obj.ptD(p, 1i).yes = 1;
                   if j <= scale
                       m=1;
                       while m<j
                           obj.ptD(p,i).yes = 1;
                           m = m + 1;
                           i = i + 1;
                       end
                   else
                       while m < j
                           obj.ptD(p,i).yes = 0;
                           obj.ptD(p,i).angle = single(pi);
                       end
                   end
               end
               obj.ptD(p,k).yes = 1;
               scale = scale + increase;
           end
        end
        
        function eliminate1(obj,arX, arY)
            for i = 1:obj.n
                for m = 1:obj.itNo
                    if obj.ptD(m,i).yes == 1
                        angle = obj.ptd(m,i).angle;
                        if angle < obj.deg190 && angle > obj.deg170
                            obj.ptD(m,i).yes = 0;
                        end
                        j = i-1;
                        if j < 1
                            j = obj.n;
                        end
                        k = i+1;
                        if k > obj.n
                            k = 1;
                        end
                        merit = obj.ptD(m,i).merit;
                        while true
                            flag = 0;
                            if merit > obj.ptD(m,k).merit
                                obj.findEndL(i,k,m,angle,arX,arY);
                                flag = flag + 10;
                            end
                            if merit > obj.ptD(m,j).merit
                                obj.findEndR(i,j,m,angle,arX,arY);
                                flag = flag -1;
                            end
                            if flag == 0;
                                break
                            end
                            obj.elim1(i,m,flag,arX,arY);
                            break
                        end
                    end
                end
            end
        end
        
        function elim1(obj,i,p,flag,arX,arY)
            merit = obj.ptD(p,i).merit;
            if flag < 10
                 meritT = single(obj.ptD(p,i).meritR * 1.5);
                 l = mod((i-obj.endR+obj.n),obj.n);
                 k = i - 1;
                 stepC = 1;
                 for step = 1:l
                     if k < 1
                         k = obj.n;
                     end
                     if obj.ptD(p,k).yes == 1
                         if obj.ptD(p,k).meritR > meritT
                             break
                         end
                         j = obj.ptD(p,k).rightStep;
                         if single(stepC)/single(j) < 0.5
                             break
                         end
                         if obj.ptD(p,k).merit < merit
                             obj.ptD(p,k).yes = 0;
                         end
                     end
                     k = k - 1;
                 end
            end
            
            if flag >= 9
                meritT = single(obj.ptD(p,i).meritL * 1.5);
                l = mod((obj.endL - i + obj.n),obj.n);
                stepC = 1;
                for step = 1:l
                    if k > obj.n
                        k = 1;
                    end
                    if obj.ptD(p,k).yes == 1
                        if obj.ptD(p,k).meritL > meritT
                            break
                        end
                        j = obj.ptD(p,k).leftStep;
                        if single(stepC)/single(j) < 0.5
                            break
                        end
                        if obj.ptD(p,k).merit < merit
                            obj.ptD(p,k).yes = 0;
                        end
                    end
                    k = k + 1;
                end
            end
        end
        
        function findEndL(obj,i,k,p,angle,arX,arY)
            ratio = obj.ptD(p,i).meritL / obj.ptD(p,i).leftStep /2;
            m = obj.ptD(p,i).leftStep + i;
            if(m > obj.n)
                m = m-obj.n;
            end
            ends = m;
            if angle > pi
                angle = obj.twopi - angle;
            end
            if angle < obj.deg120
                while true
                    if k>obj.n
                        k=1;
                    end
                    if k==m
                        obj.ends = localMaxL(i,k,p,arX,arY);
                        break
                    end
                    angle2 = obj.ptD(p,k).angle;
                    if angle2 > pi;
                        angle2 = twopi - angle2;
                    end
                    if angle2 < angle
                        if angle2 + obj.deg10< angle && ratio < obj.ptD(p,k).meritL/obj.ptD(p,k).leftStep
                            ends = k;
                            k = -10;
                            break
                        end
                    else
                        angle = angle2;
                    end
                    if angle2 > obj.deg120
                        ends = k;
                        break
                    end
                    k = k+1;
                end
            end
            
            if k~=-10 && k~= m
                k = k+1;
                while true
                    if k > obj.n
                        k = 1;
                    end
                    if k == m
                        obj.ends = localMaxL(i,k,p,arX,arY);
                        break
                    end
                    angle2 = obj.ptD(p,k).angle;
                    if angle2> pi
                        angle2 = twopi - angle2;
                    end
                    if angle2 < obj.deg120
                        ends = k;
                        break
                    end
                    k =k+1;
                end
            end
            if ends~=m
                j = m;
                angle = obj.ptD(p,m).angle;
                if angle > pi
                    angle = twopi - angle;
                end
                if angle < obj.deg120
                    m = m - 1;
                    while true
                        if m < 1
                            m = obj.n;
                        end
                        if ends == m
                            break
                        end
                        angle2 = obj.ptD(p,m).angle;
                        if angle2 > pi
                            angle2 = twopi - angle2;
                        end
                        if angle2 < angle
                            if angle2+obj.deg10 < angle
                                break
                            end
                        else angle = angle2;
                        end
                        if angle2 > obj.deg120
                            break
                        end
                        m = m-1;
                    end
                end
                if ends == m
                    obj.ends = localMaxL(i,k,pa,arX,arY);
                end
            end
            ends = ends - 1;
            if ends < 1
                ends = obj.n;
                obj.endL = ends;
            end
        end
        
        function findEndR(obj,i,k,p,angle,arX,arY)
        ratio = obj.ptD(p,i).meritR / obj.ptD(p,i).rightStep /2;
            m = i - obj.ptD(p,i).rightStep;
            if(m < 1)
                m = m+obj.n;
            end
            ends = m;
            if angle > pi
                angle = obj.twopi - angle;
            end
            if angle < obj.deg120
                while true
                    if k<1
                        k=obj.n;
                    end
                    if k==m
                        obj.ends = localMaxR(i,k,p,arX,arY);
                        break
                    end
                    angle2 = obj.ptD(p,k).angle;
                    if angle2 > pi;
                        angle2 = twopi - angle2;
                    end
                    if angle2 < angle
                        if angle2 + obj.deg10< angle && ratio < obj.ptD(p,k).meritR/obj.ptD(p,k).rightStep
                            ends = k;
                            k = -10;
                            break
                        end
                    else
                        angle = angle2;
                    end
                    if angle2 > obj.deg120
                        ends = k;
                        break
                    end
                    k = k-1;
                end
            end
            
            if k~=-10 && k~= m
                k = k-1;
                while true
                    if k < 1
                        k = obj.n;
                    end
                    if k == m
                        obj.ends = localMaxR(i,k,p,arX,arY);
                        break
                    end
                    angle2 = obj.ptD(p,k).angle;
                    if angle2> pi
                        angle2 = twopi - angle2;
                    end
                    if angle2 < obj.deg120
                        ends = k;
                        break
                    end
                    k =k-1;
                end
            end
            if ends~=m
                j = m;
                angle = obj.ptD(p,m).angle;
                if angle > pi
                    angle = twopi - angle;
                end
                if angle < obj.deg120
                    m = m + 1;
                    while true
                        if m > obj.n
                            m = 1;
                        end
                        if ends == m
                            break
                        end
                        angle2 = obj.ptD(p,m).angle;
                        if angle2 > pi
                            angle2 = twopi - angle2;
                        end
                        if angle2 < angle
                            if angle2+obj.deg10 < angle
                                break
                            end
                        else angle = angle2;
                        end
                        if angle2 > obj.deg120
                            break
                        end
                        m = m+1;
                    end
                end
                if ends == m
                    obj.ends = localMaxR(i,k,pa,arX,arY);
                end
            end
            ends = ends + 1;
            if ends > obj.n
                ends = 1;
                obj.endR = ends;
            end
        end
        
        function k = localMaxL(obj,i,k,p,arX,arY)
           j = k-1;
           if or(p>20,k>50000,p<1,k<1)
               k = 1;
               return
           end
           merit1 = obj.ptD(p,k).merit;
           while i~=j
               if (j < 1)
                   j = obj.n;
               end
               merit2 = obj.ptD(p,j).merit;
               if merit1 > merit2
                   return
               end
               merit1 = merit2;
               k = j;
               j = j -1;
           end
           k = i + 1;
           if k > obj.n
               k = 0;
               return
           else
               return
           end
        end
        
        function k = localMaxR(obj,i,k,p,arX,arY)
            j = k+1;
           if or(p>20,k>50000,p<1,k<1)
               k = 1;
               return
           end
           merit1 = obj.ptD(p,k).merit;
           while i~=j
               if (j > obj.n)
                   j = 1;
               end
               merit2 = obj.ptD(p,j).merit;
               if merit1 > merit2
                   return
               end
               merit1 = merit2;
               k = j;
               j = j + 1;
           end
           k = i - 1;
           if k < 1
               k = obj.n;
               return
           else
               return
           end
        end
        
        function eliminate2(obj, p, arX, arY)
           level = 0;
           obj.d = obj.d0;
           obj.minusD = -obj.d;
           obj.minusD1 = -obj.d - 1;
           obj.plusD1 = obj.d + 1;
           obj.dSq = obj.d * obj.d;
           while true
               flag = 0;
               for i = 1:obj.n
                   if obj.ptD(p,i).yes == 1 && obj.corner(i,level,p,arX,arY)
                       if level >= 0
                           obj.ptd(p,i).yes = 4;
                       else
                           obj.ptd(p,i).yes = 3;
                       end
                       if obj.iL >= 0;
                           obj.elim2(i,p,arX,arY);
                       end
                       flag = 1;
                   end
               end
               if flag == 0
                   if level < 0
                       break
                   else
                       level = - 100000;
                   end
               end
               level = level + 1;
           end
        end
        
        function b = corner(obj,i,level,p,arX,arY)
            b = true;
            obj.iL = -1;
            obj.iR = -1;
            merit = obj.ptD(p,i).merit;
            yesFlag = 0;
            j = i + 1;
            while true
                if j > obj.n
                     j = 1;
                end
                if i == j
                    return
                end
                if obj.ptd(p,j).yes ==0 || (arX(i)==arY(j) && arY(i)==arX(j))
                    %keep here blank
                else
                    if obj.ptD(p,j).yes >=3
                        yesFlag = yesFlag + 1;
                        break
                    end
                    if obj.ptD(p,j).merit > merit
                        b = false;
                        return
                    end
                    break
                end
                j = j +1;
            end
            
            k = i - 1;
            while true
                if k < 1
                    k = obj.n;
                end
                if obj.ptd(p,k).yes ==0 || (arX(i)==arY(k) && arY(i)==arX(k))
                    %keep here blank
                else
                    if obj.ptD(p,k).yes >=3
                        yesFlag = yesFlag + 1;
                        break
                    end
                    if obj.ptD(p,k).merit > merit
                        b = false;
                        return
                    end
                    break
                end
                k = k -1;
            end
            
            obj.iL = j;
            obj.iR = k;
            if yesFlag == 0
                % blank here
            elseif level == 1|| yesFlag == 2
                return;
            end
            if level >= 0
                angle1 = obj.angleCal(i,j,arX,arY);
                angle2 = obj.angleCal(i,k,arX,arY);
                angle1 = angle1 - angle2;
                if angle1 <0
                    angle1 = -angle1;
                end
                if angle1 > obj.deg165 && angle1 < obj.deg195
                    b=false;
                    return
                end
            end
            return
        end
        
        function angle = angleCal(obj,i,j,arX,arY)
            x = arX(j) - arX(i);
            y = arY(j) - arY(i);
            ii = x;
            jj = y;
            if x < 0
                x = -x;
            end
            if y < 0
                y = -y;
            end
            if x > y
                p = x;
                q = y;
            else
                p = y;
                q = x;
            end
            temp = q/p;
            temp = temp * 400;
            k = int32(floor(temp));
            angle1 = single(obj.artTan(k));
            angle2 = single(obj.artTan(k+1));
            temp = temp - k;
            angle = angle1 + (angle2 - angle1) * temp;
            if x<y
                angle = single(pi/2-angle);
            end
            if jj < 0
                if ii < 0 
                    angle = single(angle +pi);
                else
                    angle = single(twopi-angle);
                end
            elseif ii < 0
                angle = single(pi - angle);
            end
            return;
        end
        
        function elim2(obj,i,z,arX,arY)
            j = 1;
            for k = 1:obj.n
                if obj.ptD(z,k).yes == 1
                    j = j+1;
                end
            end
            if j < 4
                return
            end
            
            merit = obj.ptD(z,i).merit;
            obj.spinFlag = 0;
            obj.perpenDist(1) = single(0.0);
            obj.dir = 0;
            obj.subst = obj.n;
            obj.errorV = 0;
            obj.errorV2 = obj.n+1;
            obj.subst = 1;
            if obj.getInitialCL4(i,obj.iR,z,arX,arY)
                while true
                    if ~obj.growWithESA4(i,z,arX,arY)
                        break
                    end
                    if obj.spinFlag == 1
                        obj.spinFlag = 0;
                        break
                    end
                    if obj.angleViolate4(arX,arY)
                        break
                    end
                    obj.computeNewCL4(arX,arY);
                end
            else
                return
            end
            k = obj.endI;
            j = j+1;
            while true
                if j > obj.n
                    j = 1;
                end
                if k == j
                    break;
                end
                if obj.ptD(z,j).yes ==1
                    merit2 = obj.ptD(z,j).merit;
                    if merit > merit2
                        obj.ptD(z,j).yes = 0;
                        merit = merit2;
                    else
                        break;
                    end
                end
                j = j+1;
            end
        end
        
        function b = getInitialCL4(obj,i,j,z,arX,arY)
            b= true;
            obj.rotateDownA = single(10.0);
            obj.rotateUpA = single(10.0);
            obj.startX = single(arX(i));
            obj.startY = single(arY(i));
            while true
                if j == obj.errorV
                    j = obj.subst;
                end
                if i==j || obj.ptD(z,j).yes == 4
                    obj.endI = j;
                    b = false;
                    return
                end
                if obj.ptD(z,j).yes == 1
                    obj.deltaX = single(arX(j)) - obj.startX;
                    obj.deltaY = single(arY(j)) - obj.startY;
                    obj.r = obj.dletaX*obj.deltaX + obj.deltaY*obj.deltaY;
                    if obj.r > obj.dSq
                        break
                    end
                end
                j = j +obj.dir;
            end
            if obj.deltaX >=0.0
                x = obj.deltaX;
            else
                x = -obj.deltaX;
            end
            if obj.deltaY >=0.0
                y = obj.deltaY;
            else
                y = -obj.deltaY;
            end
            
            if x > y
                obj.r = single(obj.artTan(int32(floor(y/x * 400.0+0.5))));
                if obj.r ~= 0.0
                    obj.r = y / single(obj.Sin(int32(floor(obj.r * 254.6479089 + 0.5))));
                else
                    obj.r = y;
                end
            end
            
            obj.cosw = obj.deltaX/obj.r;
            if deltaY >= 0;
                obj.signn = 1;
            else
                obj.signn = -1;
            end
            obj.negativeSign = -obj.signn;
            if obj.deltaX ~= 0.0
                obj.tanw = obj.deltaY/deltaX;
            end
            obj.growI = 1;
            obj.distance(obj.growI) = obj.r;
            obj.rMax = obj.r;
            obj.endI = j;
            b = true;
            return
        end
        
        function b = growWithESA4(obj,i,z,arX,arY)
            b=false;
            obj.iMax = obj.endL;
            obj.endI = obj.endI + obj.dir;
            while true
                if obj.endI == obj.errorV
                    obj.endI = obj.subst;
                end
                if i == obj.endI
                    return
                end
                if obj.ptD(z,obj.endI).yes == 1 || obj.ptD(z,obj.endI).yes == 4
                    obj.growI = obj.growI+1;
                    obj.dx = single(arX(obj.endI))-obj.startX;
                    obj.dy = single(arY(obj.endI))-obj.startY;
                    if deltaX == 0.0
                        obj.Db = obj.negativeSgin * obj.dx;
                        obj.rb = obj.dy * obj.signn;
                    else
                        obj.Db = (obj.dy - obj.tanw * obj.dx) * obj.cosw;
                        obj.rb = obj.Db * obj.tanw + obj.dx / obj.cosw;
                    end
                    obj.distance(obj.growI) = obj.rb;
                    obj.perpenDist(obj.growI) = obj.Db;
                    if obj.rb < obj.rMax - obj.d
                        obj.spinFlag = 1;
                        obj.endI = obj.iMax;
                        b = true;
                        return
                    else
                        if obj.Db >= 0.0
                            if obj.Db > obj.d
                                break
                            end
                        elseif obj.Db< obj.minusD
                            break
                        end
                        if obj.rb > rb.rMax
                            obj.rMax = obj.rb;
                            obj.iMax = obj.endI;
                        end
                    end
                    if obj.ptD(z,obj.ednI).yes == 4
                        return
                    end
                end
            	obj.endI = obj.endI + obj.dir;
            end
            b = true;
            return
        end
        
        function b = angleViolate4(obj,arX,arY)
            b= true;
            perpend = obj.perpenDist(obj.growI);
            if perpend > 0.0
                obj.upFlag = 1;
                obj.lowDist = obj.plusD1;
                dist2 = single(0);
                j = obj.growI;
                while j > 0
                    t = obj.perpenDist(j);
                    if t <= 0.0
                        break
                    end
                    tt = obj.distance(j);
                    if t < obj.lowDist || tt > dist2
                        temp = t/tt;
                        if temp < 1.0
                            temp = single(obj.artTan(int32(floor(temp * 400.0 + 0.5))));
                            if temp < 0.0
                                break
                            end
                            ddist = t / single(obj.Sin(int32(floor(temp*254.6479089 + 0.5))));
                            angle = single(obj.artSin(int32(floor(obj.d/ddist * 400.0 + 0.5)))) + temp;
                            if angle < obj.rotateUpA
                                obj.lowDist = t;
                                dist2 = tt;
                                obj.rotateUpA = angle;
                            end
                        end
                    end
                    j = j -1;
                end
                
                while j>0
                    t = obj.perpenDist(j);
                    if t <=0.0
                        tt = obj.distance(j);
                        if t< obj.lowDist || tt > dist2
                            angle = -t/tt;
                            if angle < 1.0
                                angle = single(obj.artTan(int32(floor(angle * 400 + 0.5))));
                                if angle ~=0.0
                                    ddist = -t/ single(obj.Sin(int32(floor(angle * 254.6479089 + 0.5))));
                                else
                                    ddist = tt;
                                end
                                temp = single(obj.artSin(int32(floor(d/ddist * 400.0 + 0.5))))-angle;
                                if temp < obj.rotateUpA
                                    obj.lowDist = t;
                                    dist2 = tt;
                                    obj.rotateUpA = temp;
                                end
                            end
                        end
                    end
                    j=j-1;
                end
                angle = obj.perpend/ obj.distance(obj.growI);
                if angle >=1.0
                    obj.endI = obj.iMax;
                    return;
                end
                angle = single(obj.artTan(int(floor(angle * 400.0 + 0.5))));
                ddist = obj.perpend / single(obj.Sin(int32(floor(angle * 254.6479089 + 0.5))));
                temp = single(obj.artSin(int32(floor(d/ddist * 400.0 + 0.5))));
                tt = angle + temp;
                if tt < obj.rotateUpA
                    obj.rotateUpA = tt;
                end
                angle = angle - temp;
                if obj.rotateUpA < angle
                    obj.endI = obj.iMax;
                    return
                end
                temp = obj.rotateUpA;
                obj.rotateDownA = obj.rotateUpA-angle;
                obj.rotateUpA = single(0);
                angle = temp;
            else
                
                %continue working...
                
            end
        end
        
        function computeNewCL4(obj,arX,arY)
        end
        
    end
    
end

