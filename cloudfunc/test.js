// test Netsuite API functions

const api = require('./plugins/netsuiteApi.js');

// sample lead
const lead = {
  firstName: 'Vitali',
  lastName: 'Test',
  companyName: `VK viaAPI1 ${Date().toString().substring(0, 25)} `,
  email: 'apitest1@company.com',
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
