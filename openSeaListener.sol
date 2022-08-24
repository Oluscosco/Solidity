const WebSocket = require('ws');
const { OpenSeaStreamClient } = require('@Opensea/stream-js');
require("dotenv").config();

const client = new OpenSeaStreamClient({
    token: process.env.OPENSEA_TOKEN,
    connectOptions: {
        transport: WebSocket
    }
});

client.onItemListed('*', (event) => {
    console.log(event);
});


//
//client.onItemTransferred('*', (event) => {
//    console.log(event);
//});

//client.onItemListed('ens', (event) => {
//    console.log('${event.payload.item.metadata.name} listed');
//});
