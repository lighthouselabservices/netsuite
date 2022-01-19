// Copy of Successful Postman Call using Request

const authorizationLine = 'OAuth realm="5256042_SB1",oauth_consumer_key="4a03f7d35834eea6cd0d0c71d7516b96a15da3f535db53bbb064b6ccef7fa7ac",oauth_token="2e4469e18bda6852418248b55322e2a940c2e5a979c2420a666d9d69106bd07e",oauth_signature_method="HMAC-SHA256",oauth_timestamp="1642571364",oauth_nonce="T6BdMze5acl",oauth_version="1.0",oauth_signature="vTtH6AP3FeppD0iILvTuO9sUkahp7%2BCP1Snqzy%2BCG%2Bs%3D"';

const request = require('request');
const options = {
  'method': 'POST',
  'url': 'https://5256042-sb1.suitetalk.api.netsuite.com/services/rest/record/v1/customer',
  'headers': {
    'Content-Type': 'application/json',
    'Authorization': authorizationLine,
    'Cookie': 'NS_ROUTING_VERSION=LAGGING',
    'Connection': 'keep-alive',
    'User-Agent': 'PostmanRuntime/7.29.0',
    'Cache-Control': 'no-cache',
    'Host': '5256042-sb1.suitetalk.api.netsuite.com',
    'Postman-Token': '4b740f2a-efbb-422f-b633-e46743f5dd76',
  },
  'body': JSON.stringify({
    'companyName': 'Company 1642570115',
    'email': 'customer@company.com',
    'entityStatus': '6',
    'isPerson': false,
    'leadSource': '-6',
    'subsidiary': '2',
  }),

};
request(options, function (error, response) {
  if (error) throw new Error(error);
  console.log(response.body);
});

