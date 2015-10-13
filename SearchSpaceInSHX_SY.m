classdef SearchSpaceInSHX_SY < handle
    %SearchSpaceInSHX_SY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        children = [];
        isInteresting;
        maxSHX, minSHX, maxSY, minSY, ld;
    end
    
    methods
        function obj = SearchSpaceInSHX_SY(varargin)
            if nargin == 0
                obj.isInteresting=false;
                obj.maxSHX=1;
                obj.minSHX=1;
                obj.maxSY=1;
                obj.minSY=1;
                obj.ld=0.2;%结束区间宽度
            elseif isa(varargin{1},'SearchSpaceInSHX_SY')
                source = varargin{1};
                obj.maxSHX=source.maxSHX;
                obj.minSHX=source.obj.minSHX;
                obj.maxSY=source.maxSY;
                obj.minSY=source.minSY;
                obj.ld=source.ld;
                obj.isInteresting=source.isInteresting;
            end
        end
        
        function Initial(obj)
            obj.maxSHX=0.2;%默认的Shx范围
			obj.minSHX=-0.2;
			obj.maxSY=1.5;
			obj.minSY=0.5;
			obj.ld=0.2;
        end
        
        function Divid(obj)
            obj.children = [];
            obj.children(1).maxSHX=(obj.maxSHX+obj.minSHX)/2;
			obj.children(1).obj.minSHX=obj.minSHX;
			obj.children(1).maxSY=(obj.maxSY+obj.minSY)/2;
			obj.children(1).minSY=obj.minSY;
			obj.children(1).ld=obj.ld;
			obj.children(2).maxSHX=obj.maxSHX;
			obj.children(2).obj.minSHX=(obj.maxSHX+obj.minSHX)/2;
			obj.children(2).maxSY=(obj.maxSY+obj.minSY)/2;
			obj.children(2).minSY=obj.minSY;
			obj.children(2).ld=obj.ld;
			obj.children(3).maxSHX=obj.maxSHX;
			obj.children(3).obj.minSHX=(obj.maxSHX+obj.minSHX)/2;
			obj.children(3).maxSY=obj.maxSY;
			obj.children(3).minSY=(obj.maxSY+obj.minSY)/2;
			obj.children(3).ld=obj.ld;
			obj.children(4).maxSHX=(obj.maxSHX+obj.minSHX)/2;
			obj.children(4).obj.minSHX=obj.minSHX;
			obj.children(4).maxSY=obj.maxSY;
			obj.children(4).minSY=(obj.maxSY+obj.minSY)/2;
			obj.children(4).ld=obj.ld;
        end
        
        function b = isSmallEnough(obj)
            b = false;
            minlSHX = obj.ld;
            minlSY = obj.ld;
            if abs(obj.maxSHX - obj.minSHX) < minlSHX && abs(obj.maxSY - obj.minSY) < minlSY
                b = true;
                return
            end
            return
        end
    end
    
end

