#!/bin/sh

# porkbun api key and secret
# create this key/secret pair at https://porkbun.com/account/api
apikey=
apisec=

# define domain name and record (sudomain) to update
# make sure that 'api access' is enabled for the domain on porkbun.com!
domain=
record=

if [ -z "$apikey" ] || [ -z "$apisec" ]; then echo "api key and secret code must be provided" && exit; fi
if [ -z "$domain" ] || [ -z "$record" ]; then echo "domain and record to update must be specified" && exit; fi

# use ifconfig to get our current ip address, may have to update your interface (bce0) to match your setup
ourip=$(ifconfig bce0 | awk '$1 == "inet" {print $2}')
if [ -z "$ourip" ]; then echo "could not get our WAN ip address from ifconfig" && exit; fi

# update dns record
# make sure the A record exists first!
curl -X POST "https://porkbun.com/api/json/v3/dns/editByNameType/$domain/A/$record" \
  -H "Content-Type: application/json" \
  --data "{ \"apikey\": \"$apikey\", \"secretapikey\": \"$apisec\", \"content\": \"$ourip\", \"ttl\": \"600\" }"
