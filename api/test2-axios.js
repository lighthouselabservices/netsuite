/* eslint-disable linebreak-style */
/* eslint-disable max-len */
/* eslint-disable linebreak-style */
// copy from Postman

// Copy of Successful Postman Call Axios

const axios = require('axios');
const data = JSON.stringify({
  'companyName': `VK Test Co1}`,
  'email': 'vitali@company.com',
  'entityStatus': '6',
  'isPerson': false,
  'leadSource': '-6',
  'subsidiary': '2',
});

const config = {
  method: 'post',
  url: 'https://5256042-sb1.suitetalk.api.netsuite.com/services/rest/record/v1/customer',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'OAuth realm="5256042_SB1",oauth_consumer_key="4a03f7d35834eea6cd0d0c71d7516b96a15da3f535db53bbb064b6ccef7fa7ac",oauth_token="2e4469e18bda6852418248b55322e2a940c2e5a979c2420a666d9d69106bd07e",oauth_signature_method="HMAC-SHA256",oauth_timestamp="1642567184",oauth_nonce="K1GihPe59aQ",oauth_version="1.0",oauth_signature="CoNFyh%2BxRiaMttLi3yxCIsmNURAn8dpZJWWhK7qZS%2Bw%3D"',
    'Cookie': 'NS_ROUTING_VERSION=LAGGING',
  },
  data: data,
};

axios(config)
.then(function (response) {
  console.log(JSON.stringify(response.data));
})
.catch(function (error) {
  console.log(JSON.stringify(error));
});
