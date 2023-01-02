#!/usr/bin/env python3
import shodan
import sys

# requirements for execution:
# read -p " shodan: please entry your api_key -==> " API_KEY
# echo "$API_KEY" > .env

# initializes
shodankey= open('.env').readline().strip('\n')
api = shodan.Shodan(shodankey)
FACETS = ['country=MX']
ics_services = api.count('tag:ics')
print('[:] Industrial Control Systems: {}'.format(ics_services['total']))

# only first argument
if len(sys.argv) == 1:
	print('Usage %s <search query>' % sys.argv[0])
	sys.exit(1)
try:
	query = ' '.join(sys.argv[1:])
	results = api.search(query, facets=FACETS)
	print('Results found: {}'.format(results['total']))
	for result in results['matches']:
		print('IP: {}'.format(result['ip_str']))
		print(result['data'])
		print('')

except shodan.APIError as e:
	print('Error: {}'.format(e))
	sys.exit(1)

