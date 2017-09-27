
with parsedAddresses as (
select
        id,
        "prefix",
        case when "suffixNeeded"  = 1 then 
            trim("s1" || ' ' || "s2" ) 
            else trim("s1" || ' ' || "s2" || ' ' || "s3") end as "streetName",
        case when "suffixNeeded" = 1 THEN
            trim("s3") ELSE
            trim(substr("unparsed",1)) end  as "streetType",
        case when "suffixNeeded" = 1 then 
            trim(substr("unparsed",1))  end as "suffix"

    from
        (SELECT
                id,
                street,
                "prefix",
                "s1",
                "s2",
                substr("unparsed",1,instr("unparsed",' ')-1) as "s3",
                substr("unparsed",instr("unparsed",' ')+1) as "unparsed",
                case when 
                    substr("unparsed",instr("unparsed",' ')+1) in ('North','East','South','West') 
                then 1
                else 0 end as "suffixNeeded"

        FROM
            (select
                id,
                street,
                "prefix",
                "s1",
                substr("unparsed",1,instr("unparsed",' ')-1) as "s2",
                substr("unparsed",instr("unparsed",' ')+1) as "unparsed"

            from
                (select
                        id,
                        street,
                        "prefix",
                        substr("unparsed",1,instr("unparsed",' ')-1) as "s1",
                        substr("unparsed",instr("unparsed",' ')+1) as "unparsed"


                    from
                        (select
                            *,
                            substr(trim(replace("street",'   ','')),1,instr("street",' ')-1) as "prefix",
                            substr(trim(replace("street",'   ','')),instr("street",' ')+1) as "unparsed"
                        from 
                            ways_addresses
                        ) as split1
                ) as split2
            )as split3
        )as split4



)
update ways_addresses
set
    "streetPrefix" = (select parsedAddresses."prefix" from parsedAddresses where parsedAddresses.id = ways_addresses.id),
    "streetName" = (select parsedAddresses."streetName" from parsedAddresses where parsedAddresses.id = ways_addresses.id),
    "streetType" = (select parsedAddresses."streetType" from parsedAddresses where parsedAddresses.id = ways_addresses.id),
    "streetPostfix" = (select parsedAddresses."suffix" from parsedAddresses where parsedAddresses.id = ways_addresses.id)


select * from parsedAddresses



update ways_addresses
set
    "streetPrefix" = parsed."prefix",
    "streetName" = parsed."streetName",
    "streetType" = parsed."streetType",
    "streetPostfix" = parsed."suffix"
select
   ways_addresses inner join
    (select
        id,
        "prefix",
        case when "suffixNeeded"  = 1 then 
            trim("s1" || ' ' || "s2" ) 
            else trim("s1" || ' ' || "s2" || ' ' || "s3") end as "streetName",
        case when "suffixNeeded" = 1 THEN
            trim("s3") ELSE
            trim(substr("unparsed",1)) end  as "streetType",
        case when "suffixNeeded" = 1 then 
            trim(substr("unparsed",1))  end as "suffix"

    from
        (SELECT
                id,
                street,
                "prefix",
                "s1",
                "s2",
                substr("unparsed",1,instr("unparsed",' ')-1) as "s3",
                substr("unparsed",instr("unparsed",' ')+1) as "unparsed",
                case when 
                    substr("unparsed",instr("unparsed",' ')+1) in ('North','East','South','West') 
                then 1
                else 0 end as "suffixNeeded"

        FROM
            (select
                id,
                street,
                "prefix",
                "s1",
                substr("unparsed",1,instr("unparsed",' ')-1) as "s2",
                substr("unparsed",instr("unparsed",' ')+1) as "unparsed"

            from
                (select
                        id,
                        street,
                        "prefix",
                        substr("unparsed",1,instr("unparsed",' ')-1) as "s1",
                        substr("unparsed",instr("unparsed",' ')+1) as "unparsed"


                    from
                        (select
                            *,
                            substr(trim(replace("street",'   ','')),1,instr("street",' ')-1) as "prefix",
                            substr(trim(replace("street",'   ','')),instr("street",' ')+1) as "unparsed"
                        from 
                            ways_addresses
                        ) as split1
                ) as split2
            )as split3
        )as split4
  ) as parsed on ways_addresses.id = parsed.id
   ;

   with c as (
       select * from ways_addresses
   )

   select * from c

