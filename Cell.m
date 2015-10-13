classdef Cell < handle
    %Cell Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MaxX,MinX,MaxY,MinY,MaxL,MinL,MaxTheta,MinTheta;
        isInteresting;
    end
    
    methods
        function obj = Cell(varargin)
            if nargin == 0
                obj.MaxX=0;
                obj.MinX=0;
                obj.MaxY=0;
                obj.MinY=0;
                obj.MaxTheta=0;
                obj.MinTheta=0;
                obj.isInteresting=false;
            elseif isa(varargin{1},'Cell')
                cell = varargin{1};
                obj.MaxX=cell.MaxX;
                obj.MinX=cell.MinX;
                obj.MaxY=cell.MaxY;
                obj.MinY=cell.MinY;
                obj.MaxL=cell.MaxL;
                obj.MinL=cell.MinL;
                obj.MaxTheta=cell.MaxTheta;
                obj.MinTheta=cell.MinTheta;
                obj.isInteresting=cell.isInteresting;
            end
        end
    end
    
end

