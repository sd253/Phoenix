# OpenStreetMap Data compared to City of Phoenix data
### Map Area
Phoenix, AZ, United States


## OpenStreetMap Data cleanup
1. My python code created text file with each column wrapped in b''.  I used a regular expression to remove the wrapper before loading into Sqlite.
2. Next I pivoted the address data from 1 row per key to 1 row per address with each key being a column.
3. The postcode column was inconsitant.  Sometimes it contained zip + 5, sometimes zip and state, sometimes just the 5 digit zip code. I added a column to show jsut the fisrt five digits of the zip code





## City of Phoenix Data cleanup
1. The addresses in the dataset were in a consitant format.
2. The dataset does contain more than one row per street address when their are multiple buildgs on the same property
3. Surprisingly, there were some valid addresses that where not in the city of Phoenix
4. Some of the rows had "Address not availble" listed as the address. I filtered these out before merging.

## Preparing data for merging into single dataset
1. The city dataset used abbreviations for the street direction and street type. The OpenMaps dataset was inconsitant.  I converted the OpenMaps addresses into the 
2. The city dataset used abbreviations for the direction and street type.  The OpenMaps dataset was inconsitant.


## Comparing datasets 
* Surprisingly, there were some valid addresses that where not in the city of Phoenix
### Zip Codes
    There were zip codes with addresses in OpenMaps and no Addresses in the city data set.  According to usps.com, 3 of these belong to neighboring cities and 2 of these are invalid.

    There are 140 addresss where the two datasets disagree on the zip code.  I checked 14 of these on usps.gov.  The website agreed with the city's zip code on all 14.

    I compared the ratio of address in the datasets per zip.  None of the zipcodes were well representsed in OpenMaps dataset.  The highest ratio was  0.1 to 1 for 85023.  Most were under 0.01 to 1


## Process comparison
<!-- SQL Server Adding the ability to write stored procedures in Python and R was one of the reasons for taking this class. -->
While I'm enjoying learning Python, I feel that this process would have gone smoother by avoiding Pyhton and doing all the steps within SQL Server.  Python was very slow at parsing the XML file and producing the csv files.

I normally work with SQL Server, DB2, Vertica, and MongoDB.  I chose to do this project in sqlite so I could compare it to those databases.

I ran into lots of missing features that I use in other databases.  
* OLAP Functions
* Outer joins
* Regular expressions
* JSON Support
* Cross Apply
* Soundex

Some of these features are optional in sqlite.  I tried to compile it with soundex and json1 features enabled, but was not successful.  While I would definitely use sqlite for smaller applications, I would not use it for a project with this amount of data.  I may recreate this project in SQL Server using Python stored procedures.  That combination might give me the best of both worlds.
