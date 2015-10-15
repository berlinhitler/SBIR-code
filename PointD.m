classdef PointD < handle
    %PointD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        merit;
        meritL;
        meritR;
        leftStep;
        rightStep;
        step;
        angle;
        yes;
    end
    
    methods
        function obj = PointD(varargin)
            if nargin == 0
            elseif nargin == 8
                obj.merit = varargin{1};
                obj.meritL = varargin{2};
                obj.meritR = varargin{3};
                obj.leftStep = varargin{4};
                obj.rightStep = varargin{5};
                obj.step = varargin{6};
                obj.angle = varargin{7};
                obj.yes = varargin{8};
            end
        end
    end
    
end

