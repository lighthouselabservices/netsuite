/* eslint-disable new-cap */
/* eslint-disable max-len */
/* eslint-disable require-jsdoc */
// This plugin gets data from Google Buckets
// Imports the Google Cloud client library.
const { Storage } = require('@google-cloud/storage');

// make full file name from bucket and file
// eslint-disable-next-line require-jsdoc
function MakeFileName(folder, file) {
	folder = folder || '';
	const fileName = folder === '' ? file : folder + '/' + file;
	return fileName;
}

// get file from google bucket
// ---------------------------------------
async function GetFile(bucketName, fileName) {
	const storage = new Storage();
	const myBucket = storage.bucket(bucketName);
	const file = myBucket.file(fileName);

	// check if file exists
	const fileExists = await file.exists();

	// get file content
	let fileContent = {};
	if (fileExists[0]) {
		const res = await file.download();
		fileContent = JSON.parse(res[0]);
		return fileContent;
	} else {
		console.warn(
			`File Loading: File ${fileName} in bucket ${bucketName} does not exists`,
		);
		return null;
	}
}



// check if file exists
async function fileExists(bucketName, fileName) {
	const storage = new Storage();
	const myBucket = storage.bucket(bucketName);
	const file = myBucket.file(fileName);

	// check if file exists
	const fileExists = await file.exists();

	return fileExists[0];
}


module.exports = { GetFile, fileExists, MakeFileName };
