classdef dbtimestampable_demo
  properties
    on='create,modify';
    oncreate;
    onmodify;
  end
  methods
    function b=dbtimestampable_demo(varargin)
      b=opt_setobj(b,varargin{:});
      b.onmodify=str_pos(b.on,'modify');
      b.oncreate=str_pos(b.on,'create');
    end
    %this is called from expandmodels.
    function ret=geteventhandlers(b)
      if b.onmodify; ret={'onbeforeinsert','onbeforeupdate'};
      elseif b.oncreate; str_pos(b.on,'create'); ret={'onbeforeinsert'};
      else ret={}; end
    end
    function [data,where]=onbeforeinsert(b,t,data,where)
      snow=datetime_now;
      for i=1:numel(data)
        if b.oncreate; data(i).created=snow; end
        if b.onmodify; data(i).modified=snow; end
      end
    end
    function [data,where]=onbeforeupdate(b,t,data,where)
      snow=datetime_now;
      for i=1:numel(data)
        data(i).modified=snow;
      end
    end
  end
end
