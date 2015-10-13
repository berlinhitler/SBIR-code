function []=demo(varargin)
% Copyright (C) 2013 by Ahmet Sacan
o=opt_set(...
  'dummy',[] ...
  ,varargin{:});

%% let's create some test files to work with.
temptabfile=io_tempfile('temp.tab');
tempcsvfile=io_tempfile('temp.csv');
stab=str_implode2D(str_rands([20,5]),tab,eol); %random tab delimited string
scsv=str_implode2D(str_rands([20,5]),',',eol); %random csv delimited string
io_write(temptabfile,stab);
io_write(tempcsvfile,scsv);


%% Basic parsing
% parse a tab file and return the contents as a structure array.
% the first line of the file is assumed to be the header with fields.
data=tabfile.readfile(temptabfile)

%%
% if the file does not contain a header row, you need to turn off 'hasheader' and manually provide the fields:
data=tabfile.readfile(temptabfile, 'hasheader',false, 'fields',{'a','b','c','d','e'})

%%
% If file extension is csv, we automatically use comma as the delimiter.
data=tabfile.readfile(tempcsvfile)


%%
% You can also manually specify the delimiter.
data=tabfile.readfile(tempcsvfile,'delim',',')

%%
% Or use the readcsvfile() function.
data=tabfile.readcsvfile(tempcsvfile)

%%
% You can parse strings instead of files, using the readstring functions,
data=tabfile.readstring(stab)

%%
% or by setting isfile=false.
data=tabfile.readfile(stab,'isfile',false)

%%
% if you want the data as a cell array instead of a structure array, use
% asstruct=false
data=tabfile.readfile(temptabfile,'asstruct',false,'hasheader',false)

%%
% if your have csv file uses quotes to enclose values (which may contain
% commas), use quoteaware=true

%let's first generate such random csv string
squotedcsv=['"' str_implode2D(str_rands([20,5]),'","',['"' eol '"']) '"']
data=tabfile.readcsvstring(squotedcsv,'quoteaware',true)

