classdef PointM < handle
    %PointM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x,y;
        angle;
        length;
    end
    
    methods
        function obj = PointM(varargin)
            if nargin == 0
                obj.x = 0;
                obj.y = 0;
                obj.angle = 0;
                obj.length = 0;
            elseif isa(varargin{1},'PointM')
                obj.x = varargin{1}.x;
                obj.y = varargin{1}.y;
                obj.angle = varargin{1}.angle;
                obj.length = varargin{1}.length;
            elseif nargin == 4
                obj.x = varargin{1};
                obj.y = varargin{2};
                obj.angle = varargin{3};
                obj.length = varargin{4};
            end
        end 
    end
end

