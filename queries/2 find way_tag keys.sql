select distinct "type" from ways_tags;


regular
tiger
addr
old
b'regular
turn
destination
maxspeed
parking
mtb
is_in
name
lanes
cycleway
b'tiger
surface
oneway
hgv
source
hundred
note
sidewalk
ref
bridge
heritage
gnis
FIXME
golf
building
generator
roof
access
b'note
nhd
capacity
en
wikipedia
height
b'wheelchair
glolf
souce
internet_access
b'addr
plant
b'FIXME
disused
abandoned
recycling
toilets
fuel
cinema
drink
motorcycle
contact
currency
healthcare
railway
epa
payment
service
tesla
animal_keeping
bicycle
motor_vehicle
social_facility
tower
survey
reversible
was
garden
theatre
area
b'fuel
ramp

--fix type starting with b'

update ways_tags
set "type" = substr("type",3)
 where type like 'b''%';
