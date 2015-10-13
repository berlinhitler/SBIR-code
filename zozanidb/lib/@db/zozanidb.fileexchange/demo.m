function d=demo(d,varargin)
% If an existing database object d is provided use it; otherwise, open a connection to a demo.sqlite database under the glob('datadir/db') directory.
% Provide varargin to override the parameters used to open database
% connections. e.g, use: db.demo('temp.sqlite','dbg',false)
% Copyright (C) 2012 by Ahmet Sacan

if ~exist('varargin','var'); varargin={}; end
if ~exist('d','var')||isempty(d); d=glob('datadir/demo.sqlite'); io_mkfiledirif(d); end

%% Opening a Database Connection
% if hot=true, the database structure is modified as needed. e.g, when you
% get a table with d.table('tablex'), tablex is automatically created.
% Similarly, when you insert entries into database tables, the fields are
% automatically created.
% Use dbg=true to have all the executed sql statements be printed out.
if isa(d,'db')&&~isempty(varargin); d.hot=true;
else d=db(d,'hot',true,'dbg',true,varargin{:}); end


%% Connecting to a Table
% the following creates the table if not already exists, the user table
% will be created with a single "id" field.
t=d.table('user');

% you can drop previously created tables if you need to create them afresh.
d.droptable('user');
t=d.table('user');
t.insert(struct('name','ahmet'));


%% Inserting data
%insert one/more structs
t.insert(struct('name','ahmet'));
t.insert(struct('name','tom'));
t.insert(struct('name','jerry'));
%%
%insert cell arrays. each row of cell arrays must have all fields of the
%table.
t.insert({100,'apple'});
%%
%the following would produce an integrity constraint error, because id=1
%already exists.
%t.insert(struct{1,'jerry'});
try; t.insert(struct('id',1,'name','jerry'));
catch me; dbg_errormsg(me); end

%if you need to insert if a row does not exist, but update if it does, use
%updateoninserterror, so an update() will be performed if insertion fails.
d.updateoninserterror=true;
t.insert(struct('id',1,'name','orange'));

%set it back to false so we do get errors.
d.updateoninserterror=false;


%% Getting data from tables
%Use dbtable.getby() function to select rows that meet given criteria.
%%
%get the entry with name='ahmet'.
t.getby(struct('name','ahmet'))
%%
%get name='ahmet' OR name='tom'.
t.getby(struct('name',{{'ahmet','tom'}}))
%%
t.getby(struct('name',{'ahmet','tom'}))
%%
%you can also provide full sql statements, but we recommend using
%db.query() for this instead.
t.getby('SELECT * FROM user WHERE name like "%met"')
%%
%use getall() to fetch the entire table.
t.getall()
%%
%use dumpall() to view the entire table in a fixed-width format.
t.dumpall()

%%
%getcolby() gets a single column. here, we are getting the name column.
t.getcolby('(id<3)','name')
%%
%getrowby() gets a single row
t.getrowby('(id=2)')
%%
%getcol() gets a column from the entire table.
t.getcol('name')
%%
%getfirstrow() gets a the first row of the table.
t.getfirstrow()
%%
%getnrows() gets the first n rows.
t.getnrows(2)
%%
%or from the specified row onward.
t.getnrows(1,2)

%% Getting data as dbentity objects
t.findby(struct('name','ahmet'))
%%
t.findby(struct('name',{{'ahmet','tom'}}))
%%
t.findby(struct('name',{'ahmet','tom'}))
%%
t.findby('SELECT * FROM user WHERE name like "%met"')
%%
t.findall()
%%
t.findrowby('(id=2)')
%%
t.findfirstrow()
%%
t.findnrows(2)
%%
t.findnrows(1,2)

%% Using dbentity to get/set data.
e=t.findrowbyid(2,'id');
%notice that e.name was not in the entity, but it will be fetched when you
%access it.
e.name
e.name='adam';
%%
%data is saved into database when you explicitly call save(), or automatically,
%when the object handle is deleted.
clear e

%%
e=t.findrowbyid(2,'id');
e.name='ahmet'
e.save;

%% Using yaml/json as field types, to store complex data.
t.changefieldtypeifnot('info','yaml');
e=t.findrowbyid(2,'id');
e.info=struct('age',34,'height',5.10,'weight',175);
e.info
e.save;
t.findrowbyid(2,'id').info


%% Changing table structure
% If db.hot is on, most changes to the table structure can be automatically
% performed during insert() operations. If you need more control, you can
% use the utility functions described here.
%%
% drop a field
t.dropfield('info');
%%
%add a new field
t.addfield('email','type','integer')
%%
%change the type of an existing field
t.changefieldtype('email','string','length',32)

%change an existing field
t.addfield('age');
t.changefield('age','type','decimal')


%% (Unique) Indexes and primary keys.
%%
%you usually need to set a uniqueness constraint, to prevent duplicate rows
t.adduniqueindexifnotexists('name,email');

%create an index on a field, to speed up queries that check values in this
%column.
t.addindex('email')

%You can add/remove a field to the list of primary keys, to generate composite
%primary keys.
%an autoincrement key implies non-composite primary key, so you need to remove
%autoincrement before you can generate a composite primary key.
t.changefield('id','autoincrement',false);
t.addprimarykey('name'); %this will make (id,name) pair the new composite primary key.

%set the primary key to one or more fields (not combining with existing primary keys).
%You must ensure that existing values in this column are unique.
t.setprimarykey('id');


%% Using db.query() to run sql queries
%results of the query, if available are returned as structs.
d.query('select * FROM user')
%%
%you can use question marks to fill values into the sql statement, with
%proper quoting.
% * ? is replaced with quoted value.
% * ?? is replaced with quoted field. use this as placeholder for table and field names.
% * ??? is replaced with the provided string, without any change.
d.query('select * FROM ?? WHERE name=? AND ???','user','ahmet','id<3')

%%
%you can use the same usage with db.fillquery() function, to construct
%your own sql queries.
d.fillquery('select * FROM ?? WHERE name=? AND ???','user','ahmet','id<3')
d.fillquery('select * FROM ?? WHERE name=? AND ???','user',5,'id<3')


%% Helper Function for Constructing SQL Queries
% strings, structs, and cells can be used to construct sql queries.
% multiple values (given as cell array) for the same field are OR'ed,
% whereas multiple fields are AND'ed.
d.whereclause(struct('id',3))
%%
d.whereclause(struct('id',{{3,5}}))
%%
d.whereclause(struct('id',{{3,5}},'name',{{'tom','jerry'}}))

%%
%the second argument specifies whether we prepend the phrase with 'WHERE'
%or not.
d.whereclause(struct('id',3),false)
%%
d.whereclause(struct('id',3,'name',{{'tom','jerry'}},'lastname','sacan'))
%%
d.whereclause({'id=3','age=32',struct('name','ahmet')})
%%
d.whereclause({'id=3','age=32',struct('name','ahmet','lastname','sacan')})
%%
%use 'X___1','X___2',etc. as field names for the proceeding sql phrases.
d.whereclause(struct('name','ahmet','X___1','lastname LIKE "saca%"'))

%%
%insert and update clauses can be constructed similarly. 
d.insertclause(struct('id',3,'name','ahmet','lastname','sacan'))
%%
d.insertclause({3,'ahmet','sacan'})
%%
d.updateclause(struct('id',3,'name','ahmet','lastname','sacan'))
%


%% Creating associations
%You can create associations between tables using
%db.addmanytoone/addmanytomany/addonetoone functions. You need to provide
%the names of the tables being associated. The fieldnames will be
%automatically determined with an '_id' postfix, e.g., "tablex_id". Keep
%db.hot=true so the fields and join tables can be automatically created in
%the database.
d.table('user');
d.table('car');
d.addmanytomany('user','car');

% Let's fill in some example data.
% Let's fill in some example data.
d.table('user').insertorupdate(struct('id',{50,60,70},'name',{'agent50','agent60','agent70'}));
d.table('car').insertorupdate(struct('id',{5,10,15,20},'name',{'bmw','mercedes','honda','toyota'}));
d.table('user_car').insertorupdate(struct('user_id',50,'car_id',{5 10}));
d.table('user_car').insertorupdate(struct('user_id',60,'car_id',{10 20}));
d.table('user_car').insertorupdate(struct('user_id',70,'car_id',{5 15}));

e=d.table('user').findby(struct('name','agent50'))
%%
f=e.car
%%
f.dump
%%
e.car.name

%% Dynamic Behaviors
% Behaviors are managed in each table model's "behavior" field.
% We look for a class with the name 'db[behaviorname]'
% Behaviors are setup during db.expandmodels and register themselves into
% onbeforeinsert, onafterinsert, e.g., table events.
% db.modelpatchfile is a good place for the behaviors to be specified. You can
% also add behaviors using dbtable.addbehavior.
t=d.user;
t.addbehavior('timestampable_demo');
t.insert(struct('id',55,'name','apple'));
t.getrowby(struct('id',55))
pause(2) %pause 2 seconds, so we get a different modification time.
t.update(struct('id',55,'name','orange'));
t.getrowby(struct('id',55))



%% Constructing and populating a large database / Bulk loading.
%If you need to perform many inserts, use the following recipe:
d=db(d.dsn,'hot',true,'ignoreinserterror',true,'fastmode',true,'dbg',false);
%use dbg=false, so sql statements are not printed.
%if you know the database structure is finalized, you can set hot=false.
