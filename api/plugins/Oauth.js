/* eslint-disable new-cap */
/* eslint-disable camelcase */
/* eslint-disable require-jsdoc */
// imported modules below using "npm i -save request oauth-1.0a crypto"

const request = require('request');
const OAuth = require('axios-oauth-1.0a');
const crypto = require('crypto'); // dependency package for OAuth-1.0a

// Token request function
function generateToken() {
    const oauth = OAuth({
        consumer: {
        key: '4a03f7d35834eea6cd0d0c71d7516b96a15da3f535db53bbb064b6ccef7fa7ac', // Access key
        secret: '9b8c19153f1714c0d5e8af74111807b1de4cb6b79974ada84e6cebff7cac1548', // Secret key
        },
        signature_method: 'HMAC-SHA256',
        hash_function(base_string, key) {
            return crypto
                .createHmac('sha256', key)
                .update(base_string)
                .digest('base64');
        },
    });
    // Building  the request object.
    const request_data = {
        url: 'https://5256042-sb1.suitetalk.api.netsuite.com/services/rest/auth/oauth2/v1/token',
        method: 'POST',
        data: { grant_type: 'client_credentials' },
    };
    // Sending the request to get the access_token
    request(
        {
            url: request_data.url,
            method: request_data.method,
            form: request_data.data,
            headers: oauth.toHeader(oauth.authorize(request_data)),
        },
        function (error, response, body) {
            if (response.statusCode == 200) {
                result = JSON.parse(response.body);
                console.log('Token', result);
            }
        },
    );
}

// Calling this function to get the access token

generateToken();
