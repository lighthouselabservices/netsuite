// test Netsuite API functions

const api = require('./plugins/netsuiteApi.js');

// sample lead
const lead = {
	firstName:'FirstNameTest',
	lastName:'LastNameTest',
	companyName: `VkTest from CloudFunc ${Date().toString().substring(0, 25)} `,
	email: 'test@cloudfunc.com',
	entityStatus: '6',
	isPerson: true,
	leadSource: '-6',
	subsidiary: '2',
};

// create lead in Netsuite
api
	.createCustomer(lead)
	.then((resp) =>
		console.log(
			resp.statusCode === 204 ?
				'LEAD CREATED: ' + lead.companyName :
				'ERROR CODE:' + resp.statusCode,
		),
	)
	.catch((e) => console.log(e));
