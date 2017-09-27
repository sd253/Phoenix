select distinct 
    "streetType"
FROM    
    ways_addresses

    
union 
    select DISTINCT
        "streetPrefix"
    FROM
        ways_addresses
union 
    select DISTINCT
        "streetPostfix"
    FROM
        ways_addresses
order by 1;
/*
19th
Ave         Ave
Ave.        Ave
Avenue      Ave
Boulevard   Blvd
Circle      Cir
Drive       Dr
E.          E
East        E
Highway     Hwy
Lane        Ln       
North       N
Parkway     Pkwy
Place       Pl
Road        Rd
S           S
South       S
St          St
Street      St
Trail       Trl
Way         Way
West        W
*/

insert into find_replace(find,replace)
VALUES
('Ave','Ave'),
('Ave.','Ave'),
('Avenue','Ave'),
('Boulevard','Blvd'),
('Circle','Cir'),
('Drive','Dr'),
('E.','E'),
('East','E'),
('Highway','Hwy'),
('Lane','Ln'),
('North','N'),
('Parkway','Pkwy'),
('Place','Pl'),
('Road','Rd'),
('S','S'),
('South','S'),
('St','St'),
('Street','St'),
('Trail','Trl'),
('Way','Way'),
('West','W');

with prepAddresses as(
    select
        id,
        trim(ways_addresses."housenumber" || ' '
        || coalesce(pre.replace,ways_addresses.streetPrefix,'') || ' '
        || replace(coalesce(ways_addresses.streetName,''),"Saint","St") || ' '
        || coalesce(typ.replace,ways_addresses.streetType,'') || ' '
        || coalesce(pst.replace,ways_addresses.streetPostfix,'')) as "joinAddress"


        
    FROM
        ways_addresses left JOIN
        find_replace pre on ways_addresses.streetPrefix = pre.find left JOIN
        find_replace typ on ways_addresses.streetType = typ.find left JOIN
        find_replace pst on ways_addresses.streetPostfix = pst.find
)

update ways_addresses
set 
    "joinAddress" = (select prepAddresses."joinAddress" from prepAddresses where prepAddresses.id = ways_addresses.id);



