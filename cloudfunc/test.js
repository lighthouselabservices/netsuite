// test Netsuite API functions

const api = require('./plugins/netsuiteApi.js');
const cnf = require('./plugins/getfiles.server');

// sample lead
const  v = Date().toString().substring(19, 25);

const lead = {
	firstName: `${v}`,
	lastName:'CouldFunc',
	companyName: `VkTest from CloudFunc ${Date().toString().substring(0, 25)} `,
	email: 'test@cloudfunc.com',
	entityStatus: '6',
	isPerson: true,
	leadSource: '-6',
	subsidiary: '2',
};

// Get config from google bucket
cnf.GetFile('lh-app-config', 'config-api-netsuite.json').then(config =>{console.log(config);});

// create lead in Netsuite
api
	.createCustomer(lead)
	.then((resp) =>
		console.log(
			resp.statusCode === 204 ?
				'LEAD CREATED: ' + lead.firstName + lead.lastName +  lead.companyName :
				'ERROR CODE:' + resp.statusCode,
		),
	)
	.catch((e) => console.log(e));
