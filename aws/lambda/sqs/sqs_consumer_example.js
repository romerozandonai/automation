// author: Bruno Romero Costa Zandonai
// version: 0.1.2
// date: 07/11/2023
// description: consume SQS queue and delivery content to an external API Endpoint
// use case: import script on AWS Lambda, and attach a SQS trigger to start the execution. The data from the SQS message comes on the event.Records[].body
// impacted services: SQS, Lambda
// possible improvments: TO.DO

const https = require('https');
const AWS = require("aws-sdk");
const sqs = new AWS.SQS();

exports.handler = async (event) => {
    try {

        // parameters to get from SSM parameter store
        const parameterNames = [
            "/path/to/endpoint",
            "/path/to/api-key",
            "/path/to/authorization",
            "/path/to/sqs-queue"
        ];

        // get the parameters from SSM parameter store
        const params = await getParameters(parameterNames);

        // assemble variables
        const endpoint = `${params[parameterNames[0]]}`;
        const queueUrl = params[parameterNames[3]];

        // API options
        const options = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Api-Key' : params[parameterNames[1]],
                'X-Authorization': params[parameterNames[2]],            
                'User-Agent': 'aws/sqs'
            }
        };

        // statusCode & responseBody, for finished requests.
        let statusCode = 0;
        let responseBody;

        // start reading the Records on the Event
        for (const record of event.Records) {
                
            const response = await sendHttpRequest(endpoint, options, record.body);
        
            console.log('responseWebHookUpdate', response);
        
            statusCode = response.statusCode;

            // if statusCode == 200, remove message from the queue
            if(statusCode === 200) {
                
                const deleteParams = {
                    QueueUrl: queueUrl,
                    ReceiptHandle: record.receiptHandle
                };
            
                await sqs.deleteMessage(deleteParams).promise();
                
            } else {
                
                // print the return, in case statusCode != 200
                responseBody = JSON.stringify(response.data);
                let _return = {
                    statusCode: statusCode,
                    body: responseBody
                };
    
                console.log('status code != 200', _return);
                
            }
        }
    
    } catch (error) {
        console.log(error);
        return {
            statusCode: 500,
            body: error.message
        };
    }
}

// get parameters from parameters store, passed as function parameter
async function getParameters(parameterNames) {

    const ssm = new AWS.SSM();
    const params = await Promise.all(
        parameterNames.map(async (paramName) => {
            const response = await ssm.getParameter({
                Name: paramName,
                WithDecryption: true,
            }).promise();
    
            return {
                name: paramName,
                value: response.Parameter.Value,
            }
        })
    );

    const paramValues = {};
    
    params.forEach((param) => {
        paramValues[param.name] = param.value;
    });

    return paramValues;
}

// send the http request to the API Endpoint
function sendHttpRequest(url ,options, requestBody) {
    return new Promise((resolve, reject) => {
        const req = https.request(url, options, (res) => {
            let responseData = '';

            res.on('data', (chunk) => {
                responseData += chunk;
            });

            res.on('end', () => {
                const response = {
                    statusCode: res.statusCode,
                    data: responseData
                };
                resolve(response);
            });
        });

        req.on('error', (error) => {
            reject(error);
        });

        req.write(requestBody);
        
        req.end();
    });
}