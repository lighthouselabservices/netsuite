/* eslint-disable require-jsdoc */
/* eslint-disable max-len */
// This script creates new lead in Netsuite using REST API and Auth1.0 authorization
// info https://netsuite.custhelp.com/app/answers/detail/a_id/86925

const axios = require('axios');

// TODO: change hardcoded data to variables

async function createLead(config = {}, data = {}) {
  const body = config;
  body.data = data;

  axios(config)
    .then(function (response) {
      console.log(JSON.stringify(response.data));
      return response;
    })
    .catch(function (error) {
      console.log(error);
    });
}

module.exports = { createLead };
