/* eslint-disable max-len */
/* eslint-disable no-unused-vars */

const api = require('./plugins/createLead.js');

// config for createing lead
// TODO change hardcoding to variables
const config = {
  method: 'post',
  url: 'https://5256042-sb1.suitetalk.api.netsuite.com/services/rest/record/v1/customer',
  headers: {
    'Content-Type': 'application/json',
    // eslint-disable-next-line quote-props
    Authorization:
      'OAuth realm="5256042_SB1",oauth_consumer_key="4a03f7d35834eea6cd0d0c71d7516b96a15da3f535db53bbb064b6ccef7fa7ac",oauth_token="2e4469e18bda6852418248b55322e2a940c2e5a979c2420a666d9d69106bd07e",oauth_signature_method="HMAC-SHA256",oauth_timestamp="1642563724",oauth_nonce="VHLTs4uWTG9",oauth_version="1.0",oauth_signature="hsDZu5hyUrCkiyZL2f%2FEhe%2BdM5vrCOIOzg2zdHcsfgg%3D"',
  },
};

// Data for creating lead
const data = JSON.stringify({
  companyName: 'VK Test ',
  email: 'vitali@company.com',
  entityStatus: '6',
  isPerson: false,
  leadSource: '-6',
  subsidiary: '2',
});

// Create Lead via API
api.createLead(config, data)
  .then(function (response) {
    console.log(JSON.stringify(response.data));
  })
  .catch(function (error) {
    console.log(error);
  });
