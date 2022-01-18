// Express JS service for processing AI requests
// https://cloud.google.com/appengine/docs/standard/nodejs/building-app/writing-web-service

const express = require('express');
const app = express();

// plugins
const pp = require('./plugins/predict-payer');
const gcs = require('./plugins/getfiles.server');

app.use(function (req, res, next) {
  // allow requests from any domain
  res.header('Access-Control-Allow-Origin', '*'); // update to match the domain you will make the request from
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept'
  );
  next();
});

app.get('/', (req, res) => {
  res.send(
    `Paypredict Services. Use service request route format: "/version/service/",  example: "/v0/get-payer/".  For information and support visit Pinnacle Services Corporation www.pinnacleservice.co`
  );
});

app.get('/v0/get-payer/:memberId', async (req, res) => {
  const memberId = req.params.memberId;

  // provision result
  let result = null;

  // explain from query
  const explain = !!req.query.explain;

  // check if common id is already provided
  const commonId = req.query.commonId || null;

  // console.log(`Got member id ${memberId}`);
  // console.log(`Explain? ${explain}`);

  // get config first
  let config = null;
  if (!config) {
    config = await gcs.GetFile('pp-req-ml-config', 'ml-config-payer.json');
  }

  // don't check if common id is given
  if (commonId) {
    // console.log('common Id: ', commonId);
    // console.log('config ', config);
    const lookup = config[decodeURI(commonId).toUpperCase()];
    // console.log('lookup ', lookup);

    if (lookup !== undefined) {
      lookup['confidence'] = 1;
      lookup['powered-by'] = 'pinnacleservice.co';
      result = lookup;
    }
  }

  // get predictions
  if (!result) result = await pp.getPayer(decodeURI(memberId), explain, config);

  res.send(result);
});

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  // console.log(config);
  console.log(`Server listening on port ${PORT}...`);
});
