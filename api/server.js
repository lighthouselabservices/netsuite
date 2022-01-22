// Express JS service for processing AI requests
// https://cloud.google.com/appengine/docs/standard/nodejs/building-app/writing-web-service

const express = require('express');
const bodyParser = require('body-parser');
const app = express();

// plugins
// const gcs = require('./plugins/getfiles.server');
const api = require('./plugins/netsuiteApi');

// use body parser for JSON body
app.use(bodyParser.json());

// allow requests from different domains to the service
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*'); // allow requests from any domain
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

// Create lead in Netsuite via REST API
app.post('/v1/create-customer/', async (req, res) => {
  // get config first
  // let config = null;
  // if (!config) {
  //   config = await gcs.GetFile('pp-req-ml-config', 'ml-config-payer.json');
  // }

  // get lead object from POST request
  const lead = req.body;

  // console.log(lead);

  // object in the body does pass test return error
  if ( Object.keys(lead).length === 0) {
    res.send(
      `Error, Request body is invalid:  ${JSON.stringify(lead)} `,
    );
  }

  // create lead in Netsuite using data from request body
  const resp = await api.createCustomer(lead);

// in case of error return full response
if (resp.statusCode != 204) {
  res.send(
    resp,
  );
}


// return result
  res.send(
    `LEAD CREATED: ${lead.companyName} `,
  );
});

// Echo service for testing POST requests
app.post('/v1/post-echo/', async (req, res) => {
  // get content object from POST request
  const content = req.body;

// return content back
  res.send(
    (content),
  );
});

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  // console.log(config);
  console.log(`Server listening on port ${PORT}...`);
});
