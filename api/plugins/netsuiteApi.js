/* eslint-disable no-unused-vars */
// this script contans functions for using Netsuite REST API
// https://github.com/ehmad11/netsuite-rest

const NsApiWrapper = require('netsuite-rest');

// TODO: get config from google bucket
const config = require('../config.js');

// Auth 1.0 Wrapper for Netsuite
NsApi = new NsApiWrapper(config);

/**
 * Creates customer or lead.
 * @param {Object} body body of POST request to create customer record.
 */
 async function createCustomer(body = {}) {
    if ( Object.keys(body).length === 0) return null;

    const res = await NsApi.request({
        path: 'record/v1/customer/',
        method: 'POST',
        body: JSON.stringify(body),
      });

      return res;
  }

  module.exports = { createCustomer };
