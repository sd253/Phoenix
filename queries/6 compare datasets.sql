with openMaps as(
    select 
        *
    FROM
        ways_addresses
),
cityOfPhoenix as(
    select 
        *,
        trim(replace(replace(replace(upper(substr("ADDRESS",1,instr("ADDRESS",'  ')-1)),'  ',' '),'  ',' '),'  ',' ')) as "joinAddress",
        substr("zip_code",1,5) as "shortCityZip"
    FROM
        CityParcels
    WHERE
        "CITY" = 'PHOENIX' AND
        "ADDRESS" <> 'Address Not Available'
),
zipFix ("originalZip","fixZip","city","reason")as(
    values
        (82158,85016,'Phoenix','invalid'),
        (85052,85032,'Phoenix','invalid'),
        (85250,85250,'Scottsdale','Wrong City'),
        (85254,85254,'Scottsdale','Wrong City'),
        (85302,85302,'Glendale','Wrong City')
),
joinDataSets as(
    select * FROM
    openMaps inner join
    cityOfPhoenix on openMaps."joinAddress" = cityOfPhoenix."joinAddress"
),
openMapsMiss as(
    --exposed "Saint" in openMaps dataset is "St" in city dataset, fixed in "5 find replace.sql"
    --10825 N Tatum BLVD appears to be valid and missing from the cities data set
    --6135 W BETHANY HOME RD not found on USPS.com
    select
        *
    FROM
        openMaps left join
        joinDataSets on joinDataSets.id = openMaps.id
    WHERE
        joinDataSets.id is null
        and 
        openMaps."shortZip" not in (select "originalZip" from zipFix where "reason" = 'Wrong City')
),
aggregatedComparison as(
    select 
        (select count(*) from openMaps) "openMapsCount",
        (select count(*) from openMaps where shortZip in  (select "originalZip" from zipFix where "reason" = 'Wrong City') ) "openMapsWrongCity",
        (select count(*) from cityOfPhoenix) "cityOfPhoenixCount",
        (select count(distinct id) from joinDataSets) "matches"
),
zipMismatch as (
    select distinct
        "joinAddress",
        "shortZip",
        "shortCityZip"
    from 
        joinDataSets
    WHERE
        "shortZip" <> "shortCityZip"
),
zipCompare as(
    --82158 not a valid zip 
        --select * from ways_addresses where "shortzip" = 82158
        --should be 85016 per usps.com
    --85052 not a valid zip 
        --select * from ways_addresses where "shortzip" = 82158
        --should be 85032 per usps.com
    --85201 - Mesa AZ 
    --85250 - Scottsdale AZ
    --85254 - Scottsdale AZ
    --85302 - Glendale AZ



    SELECT
        "shortZip",
        sum("openMapsCount") as "openMapsCount",
        sum("cityCount") as "cityCount",
        cast(sum("openMapsCount") * 100  as float)/cast(sum("cityCount") as float) as "percent"
    FROM
        (select
            "shortZip",
            0 as "cityCount",
            count(*) as "openMapsCount"
        from
            openMaps 
        group BY
            "shortZip"
    union
        select
            "shortCityZip" as "shortZip",
            count(*) as "cityCount",
            0 as "openMapsCount"
        from
            cityOfPhoenix 
        group BY
            "shortCityZip")x
    GROUP BY
        "shortZip"
),
suggestedChanges as (
    select
        openMaps.id, 
        MAX(openMaps."housenumber" || ' ' || openMaps."street") as "orginalAddress",
        MAX(openMaps."joinAddress") as "suggestedAddress" ,
        MAX(coalesce(cityOfPhoenix.ZIP_CODE,zipFix."fixZip",openMaps."postcode")) as "suggestedZip",
        MAX(coalesce(cityOfPhoenix.CITY,zipFix."city",openMaps."city")) as "suggestedCity"
    
     FROM
        openMaps left join
        zipFix on zipFix."originalZip" = openMaps."joinAddress" left join
        cityOfPhoenix on openMaps."joinAddress" = cityOfPhoenix."joinAddress" 

    group by 
        openMaps.openMaps.id
       
)


--select count(*) from
select * FROM
--openMaps
--cityOfPhoenix
--openMapsMiss
joinDataSets
--aggregatedComparison
--zipCompare
--zipMismatch
--zipFix
--suggestedChanges

--limit(100)
;
