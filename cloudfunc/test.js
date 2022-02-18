// test Netsuite API functions

const api = require('./plugins/netsuiteApi.js');

// sample lead
const lead = {
  companyName: `VK viaAPI ${Date().toString().substring(0, 25)} `,
  email: 'apitest@company.com',
  entityStatus: '6',
  isPerson: false,
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
