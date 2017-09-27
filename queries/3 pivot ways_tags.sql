

insert into ways_addresses
(

    "id",
    "housenumber",
    "city",
    "postcode",
    "state",
    "country",
    "street",
    "housename",
    "inclusion",
    "unit",
    "interpolation",
    "full",
    "place",
    "suite",
    "flats",
    "shortZip",
    "joinAddress"
)


select
    "id",
    max(case when "key" = 'housenumber' then "value" end) as "housenumber",
    max(case when "key" = 'city' then "value" end) as "city",
    max(case when "key" = 'postcode' then "value" end) as "postcode",
    max(case when "key" = 'state' then "value" end) as "state",
    max(case when "key" = 'country' then "value" end) as "country",
    max(case when "key" = 'street' then "value" end) as "street",
    max(case when "key" = 'housename' then "value" end) as "housename",
    max(case when "key" = 'inclusion' then "value" end) as "inclusion",
    max(case when "key" = 'unit' then "value" end) as "unit",
    max(case when "key" = 'interpolation' then "value" end) as "interpolation",
    max(case when "key" = 'full' then "value" end) as "full",
    max(case when "key" = 'place' then "value" end) as "place",
    max(case when "key" = 'suite' then "value" end) as "suite",
    max(case when "key" = 'flats' then "value" end) as "flats",
    max(case when "key" = 'postcode' then substr(replace("value",'AZ ',''),1,5) end) as "shortZip"

from
    ways_tags
where
    "type" = 'addr'

group by
"id"

having
    max(case when "key" = 'city' then "value" end) = 'Phoenix' and
    max(case when "key" = 'housenumber' then "value" end)  is not null
;
