const dotenv = require('dotenv').config();
var NsApiWrapper = require('./netsuite-rest.js');

describe('Netsuite Rest Webservices', () => {
  jest.setTimeout(10000);
  let NsApi;
  let NsApiBaseUrl;

  beforeAll(async () => {
    NsApi = new NsApiWrapper({
      consumer_key: process.env.consumer_key,
      consumer_secret_key: process.env.consumer_secret_key,
      token: process.env.token,
      token_secret: process.env.token_secret,
      realm: process.env.realm
    });

// with base_url
NsApiBaseUrl = new NsApiWrapper({
    consumer_key: process.env.consumer_key,
    consumer_secret_key: process.env.consumer_secret_key,
    token: process.env.token,
    token_secret: process.env.token_secret,
    realm: process.env.realm,
    base_url: process.env.base_url
  });

});

afterAll(async () => {});

it('should check env and NsApi', () => {
  expect(process.env.consumer_key).toBeDefined();
  expect(process.env.consumer_secret_key).toBeDefined();
  expect(process.env.token).toBeDefined();
  expect(process.env.token_secret).toBeDefined();
  expect(process.env.realm).toBeDefined();
  expect(NsApi).toBeDefined();
});

test('should make test request', () => {
  expect.assertions(1);
  return NsApi.request({
      method: "OPTIONS"
    })
    .then(response => expect(response.statusCode).toEqual(204))
    .catch(() => {
      console.log("Test request failed.")
    });
});

// test('should make GET request - GET Customers', () => {
//   expect.assertions(1);
//   return NsApi.request({
//       path: 'record/v1/customer/'
//     })
//     .then(response => expect(response.statusCode).toEqual(200))
//     .catch(() => {
//       console.log("GET request failed.")
//     });
// });

test('should make POST request - through Postman', () => {
  expect.assertions(1);
  return NsApi.request({
      path: 'https://5256042-sb1.suitetalk.api.netsuite.com/services/rest/record/v1/customer',
      method: "POST",
      body: {
        'companyName': `VK Test Co1}`,
        'email': 'vitali@company.com',
        'entityStatus': '6',
        'isPerson': false,
        'leadSource': '-6',
        'subsidiary': '2',
      },
      headers:  {
        'Content-Type': 'application/json',
        'Authorization': 'OAuth realm="5256042_SB1",oauth_consumer_key="4a03f7d35834eea6cd0d0c71d7516b96a15da3f535db53bbb064b6ccef7fa7ac",oauth_token="2e4469e18bda6852418248b55322e2a940c2e5a979c2420a666d9d69106bd07e",oauth_signature_method="HMAC-SHA256",oauth_timestamp="1642567184",oauth_nonce="K1GihPe59aQ",oauth_version="1.0",oauth_signature="CoNFyh%2BxRiaMttLi3yxCIsmNURAn8dpZJWWhK7qZS%2Bw%3D"',
        'Cookie': 'NS_ROUTING_VERSION=LAGGING',

      }
    })
    .then(response => expect(response.statusCode).toEqual(200))
    .catch(() => {
      console.log("POST request failed.")
    });
});


test('should work with base_url', () => {
  expect.assertions(2);
  expect(process.env.base_url).toBeDefined();
  return NsApiBaseUrl.request({
      method: "OPTIONS"
    })
    .then(response => expect(response.statusCode).toEqual(204))
    .catch(() => {
      console.log("Test request failed.")
    });
});

});
