
use master
GO
if exists (select * from master.sys.databases where name = 'zoodb')
  drop database zoodb
GO
create database zoodb
GO
use zoodb
GO
-- 一个table是人，一个table是department
-- 人和dept的speciallization 我统一放到后面的三个表里
-- 因为咱们的specialization 没有自己的attr
-- 所以那些表里面，一个是ssn，一个是dept_name
-- 会有很多重复，但没办法
-- 就是必须要check
-- dept的primary key 我选的是name，我觉得更直接
CREATE TABLE EmployeeZ (
	ssnZ          char(9) not null,
	fname        varchar(20) not null,
	lname        varchar(20) not null,
	minitial     char(1),
	d_nameZ       varchar(20) not null,
	primary key (ssnZ)
);

CREATE TABLE DepartmentZ (
	d_id          varchar(9) not null,
	d_nameZ        varchar(20) not null,
	primary key (d_nameZ)
);

CREATE TABLE Service(
	ssnZ        char(9) not null,
    d_nameZ     varchar(20) not null,
    check     (d_nameZ='service'),
    primary key (ssnZ),
	foreign key (ssnZ) references EmployeeZ(ssnZ),
    foreign key (d_nameZ) references DepartmentZ(d_nameZ)
);

CREATE TABLE Security(
	ssnZ        char(9) not null,
    d_nameZ     varchar(20) not null,
    check     (d_nameZ='security'),
    primary key (ssnZ),
	foreign key (ssnZ) references EmployeeZ(ssnZ),
    foreign key (d_nameZ) references DepartmentZ(d_nameZ)
);

CREATE TABLE anim_serv(
	ssnZ        char(9) not null,
    d_nameZ     varchar(20) not null,
    check     (d_nameZ='animal service'),
    primary key (ssnZ),
	foreign key (ssnZ) references EmployeeZ(ssnZ),
    foreign key (d_nameZ) references DepartmentZ(d_nameZ)
);

-- 接下来是animal 和animal的所有关系
-- 这里面有一些部分有一些重复，因为没有重复的话，一个表就只有一个column了。
CREATE TABLE Animal (
	a_id         varchar(20) not null,
	species      varchar(20) not null,
	b_date       varchar(20) not null,
	gender       varchar(2),
	primary key (a_id)
);

CREATE TABLE Take_care (
	ssnZ        char(9) not null,
	a_id       varchar(20) not null,
	foreign key (ssnZ) references anim_serv(ssnZ),
    foreign key (a_id) references Animal(a_id),
	primary key (ssnZ,a_id)
);

-- 下面这部分在visitor之后，但是结构上他应该在这里
-- 没有primary key

-- CREATE TABLE visited (
	-- a_id       char(20) not null,
	-- v_id       char(20) not null,
	-- foreign key (a_id) references Animal(a_id),
	-- foreign key (v_id) references visitor(v_id)
    -- );
    
-- vistor 表，简单
CREATE TABLE visitor (
	v_id       varchar(20) not null,
    lrate       varchar(10),
    lv_date     varchar(10),
	primary key (v_id)
    );

CREATE TABLE visited (
	a_id       varchar(20) not null,
	v_id       varchar(20) not null,
	foreign key (a_id) references Animal(a_id),
	foreign key (v_id) references visitor(v_id),
	primary key (a_id,v_id)
    );
    
-- 年票表，没啥说的
CREATE TABLE annual_pass (
	v_id       varchar(20) not null,
    p_number   char(10) not null,
    exp_date    varchar(10)
	primary key (v_id,p_number),
    foreign key (v_id) references visitor (v_id)
    );

-- 这个表，我把manage 和allow to 都放进来了
-- allow to 就是Y或N
-- manage by 一个dept
CREATE TABLE Zone (
	z_id         varchar(20) not null,
    z_name       varchar(20) not null,
    manage_byZ 	 varchar(20) not null,
	allow_visit  char(1) not null,
    check (allow_visit='Y' or allow_visit='N'),
	primary key (z_id),
    foreign key (manage_byZ) references DepartmentZ (d_nameZ)
    );
    
GO

delete from EmployeeZ;
delete from DepartmentZ;
delete from Service;
delete from Security;
delete from anim_serv;
delete from Animal;
delete from Take_care;
delete from visitor;
delete from visited;
delete from annual_pass;
delete from Zone;

insert into EmployeeZ values ('112233445', 'John', 'Henry','A', 'service');
insert into EmployeeZ values ('222233445', 'Alice', 'Johnson','T', 'service');
insert into EmployeeZ values ('122233445', 'Jeremy', 'Tom','D', 'security');
insert into EmployeeZ values ('112333445', 'Emily', 'Stone','C', 'animal service');
insert into EmployeeZ values ('113333445', 'Eric', 'Henderson','P', 'security');
insert into EmployeeZ values ('112234445', 'Michael', 'Curry','B', 'animal service');
insert into EmployeeZ values ('112244445', 'Miller', 'Tyler','C', 'service');
insert into EmployeeZ values ('223344556', 'Erica', 'Thomas','C', 'service');
insert into EmployeeZ values ('233344556', 'Henderson', 'Potter','F', 'animal service');
insert into EmployeeZ values ('223444556', 'Johnny', 'Harry','J', 'service');
insert into EmployeeZ values ('224444556', 'Jennifer', 'Lawrence','D', 'animal service');
insert into EmployeeZ values ('223345556', 'Mike', 'Johnson','P', 'security');
insert into EmployeeZ values ('223355556', 'John', 'Henry','A', 'service');

insert into DepartmentZ values ('1', 'service')
insert into DepartmentZ values ('2', 'security')
insert into DepartmentZ values ('3', 'animal service')

insert into Service values ('112233445', 'service');
insert into Service values ('222233445', 'service');
insert into Service values ('112244445', 'service');
insert into Service values ('223344556', 'service');
insert into Service values ('223444556', 'service');
insert into Service values ('223355556', 'service');

insert into Security values ('122233445','security');
insert into Security values ('113333445','security');
insert into Security values ('223345556','security');

insert into anim_serv values ('112333445','animal service');
insert into anim_serv values ('112234445','animal service');
insert into anim_serv values ('233344556','animal service');
insert into anim_serv values ('224444556','animal service');

insert into Animal values ('1', 'duck', '03152015', 'F');
insert into Animal values ('2', 'duck', '01142014', 'M');
insert into Animal values ('3', 'elephant', '05062011', 'F');
insert into Animal values ('4', 'elephant', '08192008', 'M');
insert into Animal values ('5', 'snake', '10032009', 'F');
insert into Animal values ('6', 'snake', '11202010', 'M');
insert into Animal values ('7', 'horse', '06232009', 'M');
insert into Animal values ('8', 'horse', '03042010', 'F');
insert into Animal values ('9', 'panda', '02152007', 'F');
insert into Animal values ('10', 'panda', '05172006', 'M');

insert into Take_care values ('112333445', '1');
insert into Take_care values ('112333445', '2');
insert into Take_care values ('112234445', '3');
insert into Take_care values ('112234445', '4');
insert into Take_care values ('233344556', '5');
insert into Take_care values ('233344556', '6');
insert into Take_care values ('224444556', '7');
insert into Take_care values ('224444556', '8');
insert into Take_care values ('224444556', '9');
insert into Take_care values ('224444556', '10');

insert into visitor values ('01', '8', '03262015');
insert into visitor values ('02', '9', '02142016');
insert into visitor values ('03', '8.5', '11102016');
insert into visitor values ('04', '7.5', '12102017');
insert into visitor values ('05', '8', '09102018');
insert into visitor values ('06', '9', '12302018');
insert into visitor values ('07', '9', '05302019');


insert into visited values ('1','01')
insert into visited values ('3','01')
insert into visited values ('5','01')
insert into visited values ('1','02')
insert into visited values ('2','02')
insert into visited values ('4','02')
insert into visited values ('5','03')
insert into visited values ('7','03')
insert into visited values ('10','03')
insert into visited values ('1','04')
insert into visited values ('8','05')
insert into visited values ('9','06')
insert into visited values ('2','07')
insert into visited values ('6','07')

insert into annual_pass values ('01', '1234567890', '02302020');
insert into annual_pass values ('02', '1234567891', '12302019');
insert into annual_pass values ('05', '1234567892', '04152020');

insert into Zone values ('01', 'restaurant', 'service', 'Y');
insert into Zone values ('02', 'parking lot', 'security', 'Y');
insert into Zone values ('03', 'bathroom', 'service', 'Y');
insert into Zone values ('04', 'animal present', 'animal service', 'Y');
insert into Zone values ('05', 'Tour bus stop', 'service', 'Y');
insert into Zone values ('06', 'animal clinic', 'animal service', 'N');
insert into Zone values ('07', 'animal food storage', 'animal service', 'N');









