// Express JS service for processing AI requests 
// https://cloud.google.com/appengine/docs/standard/nodejs/building-app/writing-web-service

const express = require('express');
const app = express();

// plugins
const gcs = require('./plugins/getfiles.server');
const api = require('./plugins/netsuiteApi')

app.use(function (req, res, next) {
  // allow requests from any domain
  res.header('Access-Control-Allow-Origin', '*'); // update to match the domain you will make the request from
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept',
  );
  next();
});

// processing calls
app.get('/', (req, res) => {
  res.send(
    `Lighthouse Lab Service API gateway. Use service request route format: "/version/service/",  example: "/v1/create-customer/".  For information and support visit https://www.lighthouselabservices.com/ `,
  );
});

app.post('/v1/create-customer/', async (req, res) => {

  // get config first
  let config = null;
  if (!config) {
    config = await gcs.GetFile('pp-req-ml-config', 'ml-config-payer.json');
  }
});

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  // console.log(config);
  console.log(`Server listening on port ${PORT}...`);
});
