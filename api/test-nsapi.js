/* eslint-disable no-unused-vars */
/* eslint-disable camelcase */
// test Netsuite AUth 1.0 using package netsuite-rest
// https://github.com/ehmad11/netsuite-rest

const NsApiWrapper = require('netsuite-rest');

// data
const consumer_key =
  '4a03f7d35834eea6cd0d0c71d7516b96a15da3f535db53bbb064b6ccef7fa7ac';
const consumer_secret_key =
  '9b8c19153f1714c0d5e8af74111807b1de4cb6b79974ada84e6cebff7cac1548';
const token =
  '2e4469e18bda6852418248b55322e2a940c2e5a979c2420a666d9d69106bd07e';
const token_secret =
  '1c8d045504304508a7893db130732139c4ccdc38409b8d9abc9504fb6c226ffd';
const realm = '5256042_SB1';
const base_url = 'https://5256042-sb1.suitetalk.api.netsuite.com';

// Auth Wrapper
NsApi = new NsApiWrapper({
  consumer_key: consumer_key,
  consumer_secret_key: consumer_secret_key,
  token: token,
  token_secret: token_secret,
  realm: realm,
  base_url: base_url,
});

//  Test Options
NsApi.request({
  path: '*',
  method: 'OPTIONS',
})
  .then((response) => {
    console.log('-------------------- Auth 1.0 SUCCESS! -------------------');
    // console.log(response);
    console.log('^^^^^^^^^^^^  Auth 1.0 SUCCESS! ^^^^^^^^^^^^^');
  })
  .catch((err) => {
    console.log('-------------------- Auth 1.0 ERROR! -------------------');
    console.log(err);
    console.log('^^^^^^^^^^^^  Auth 1.0 ERROR! ^^^^^^^^^^^^^');
  });

// create lead
const lead = {
  companyName: `VK FromJS ${Date().toString().substring(0, 25)} `,
  email: 'vitali@company.com',
  entityStatus: '6',
  isPerson: false,
  leadSource: '-6',
  subsidiary: '2',
};

console.log(lead);

// make request
NsApi.request({
  path: 'record/v1/customer/',
  method: 'POST',
  body: JSON.stringify(lead),
})
  .then((response) => console.log(response))
  .catch((err) => console.log(err));
