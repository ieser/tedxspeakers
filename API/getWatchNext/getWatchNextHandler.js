const connect_to_db = require('./db');

// GET WATCH NEXT

const talk = require('./Talk');

module.exports.get_watch_next = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {}
    if (event.body) {
        body = JSON.parse(event.body)
    }
    if(!body.slug) {
        callback(null, {
            statusCode: 500,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Could not fetch the talks. Slug is null.'
        })
    }
    connect_to_db().then(() => {
        talk.find({"slug": body.slug})
            .then(talks => {
                var related = talks[0].related
                    callback(null, {
                        statusCode: 200,
                        body: JSON.stringify(related)
                    })
                }
            )
            .catch(err =>
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the talks.'
                })
            );
    });
};
