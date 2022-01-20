/* eslint-disable require-jsdoc */
// make prediction call to Google AI
// predict insurance payer from member id
// https://cloud.google.com/ai-platform-unified/docs/start/client-libraries
// https://googleapis.dev/nodejs/aiplatform/latest/index.html
// https://cloud.google.com/ai-platform-unified/docs/reference/rpc

// google auth
// https://github.com/googleapis/google-auth-library-nodejs#choosing-the-correct-credential-type-automatically

'use strict';

const axios = require('axios');
const { GoogleAuth } = require('google-auth-library');

// get Google Access Token
async function getGoogleAuthToken() {
  const auth = new GoogleAuth({
    scopes: 'https://www.googleapis.com/auth/cloud-platform',
  });
  const client = await auth.getClient();
  // console.log(client);

  const tokenObj = await client.getAccessToken();
  return tokenObj.token;
}

// make feature for prediction request
// returns object of feature:value
// version 1 - characters only
function makeFeatures(memberId = '', nVars = 24) {
  if (!memberId) return null;

  const memberArray = memberId.split('');
  const res = {};
  for (let varId = 0; varId < nVars; varId++) {
    const val = memberArray[varId] || '_';
    const key = `V${varId + 1}`;
    res[key] = val.toUpperCase();
  }

  return res;
}

// returns object of feature:value
// version 2 - characters + pattern + length
function makeFeatures2(memberId = '', nVars = 15) {
  if (!memberId) return null;

  const memberArray = memberId.split('');
  const res = {};
  const patternArray = [];
  for (let varId = 0; varId < nVars; varId++) {
    const val = memberArray[varId] || '_';

    // value pattern
    let valPattern = val === '_' ? 'S' : 'D';
    if (valPattern === 'D') {
      if (isNaN(parseInt(val))) {
        valPattern = 'W';
      }
    }
    patternArray.push(valPattern);

    const key = `V${varId + 1}`;
    res[key] = val.toUpperCase();
  }

  // add pattern
  res.pattern = patternArray.join('');

  // add length
  res.len = memberId.length.toString();

  return res;
}

// make prediction request to the model hosted on Google Cloud
async function makeRequest(
  memberId = '',
  endpointId = '5018593281634729984',
  project = 'pp-req',
  location = 'us-central1',
) {
  // get features
  const features = makeFeatures2(memberId);
  // console.log(JSON.stringify(features, null, '\t'));

  const instances = [features];

  // create request
  const request = {
    instances,
  };

  // const request = require("../data/test-request.json");

  // console.log(JSON.stringify(request, null, "\t"));

  // get google token
  const gToken = await getGoogleAuthToken();
  // console.log("google token: ", gToken);

  // make request using axios
  axios.defaults.headers.common = { Authorization: `Bearer ${gToken}` };

  // predict request
  const response = await axios.post(
    `https://us-central1-prediction-aiplatform.googleapis.com/v1alpha1/projects/${project}/locations/${location}/endpoints/${endpointId}:explain`,
    request,
  );

  // console.log(JSON.stringify(response.data, null, "\t"));
  const res = response.data;
  return res;
}

// get payer
async function getPayer(memberId = '', explain = false, config = null) {
  const predict = await makeRequest(memberId);
  const attributions = predict.explanations[0].attributions[0];
  // console.log(JSON.stringify(attributions, null, '\t'));

  let res = {};

  // if config is available use it
  if (config) {
    res = config[attributions.outputDisplayName];
    // res = config["WRONG"]; // negative testing
    if (res === undefined) res = {};
  }

  res.memberId = memberId;
  res.confidence = attributions.instanceOutputValue || null;

  if (res.commonId === undefined) {
    res.commonId = attributions.outputDisplayName;
  }

  res.error = attributions.approximationError || null;

  if (explain) res.explain = predict;
  res['powered-by'] = 'pinnacleservice.co';

  return res;
}

module.exports = { makeFeatures, makeFeatures2, makeRequest, getPayer };

// [TEST]

// getPayer('VMPV37000288').then((res) => {
//   console.log(JSON.stringify(res, null, '\t'));
// });
