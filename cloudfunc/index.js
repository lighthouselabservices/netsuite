/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */
// Google cloud functions for NetSuite Interfaces
// plugins
// const gcs = require('./plugins/getfiles.server');
const api = require('./plugins/netsuiteApi');

/**
 * Background Cloud Function to be triggered by Pub/Sub.
 * This function is exported by index.js, and executed when
 * the trigger topic receives a message.
 *
 * @param {object} message The Pub/Sub message.
 * @param {object} context The event metadata.
 */
async function createCustomerPubSub(message, context) {
	const msgContent = message.data
		? Buffer.from(message.data, 'base64').toString()
		: null;

	if (!msgContent) {
		console.error('No Valid Message');
		return;
	}

	const lead = JSON.parse(msgContent);

	// object in the body does pass test return error
	if (Object.keys(lead).length === 0) {
		console.log(`Error, Message body is invalid:  ${JSON.stringify(lead)} `);
	}

	// create lead in Netsuite using data from request body
	const res = await api.createCustomer(lead);

	console.log(res);
}

module.exports = { createCustomerPubSub };
