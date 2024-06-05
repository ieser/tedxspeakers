const connect_to_db = require('./db');

// GET WATCH NEXT

const lesson = require('./Lesson');

module.exports.get_lesson_content = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {}
    if (event.body) {
        body = JSON.parse(event.body)
    }
    // set default
    if(!body.capther) {
        callback(null, {
            statusCode: 500,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Could not fetch the lesson. Capther is null.'
        })
    }
    var capther = body.capther

    connect_to_db().then(() => {
        lesson.find({"_id":capther},{link : 0})
            .then(lessons => {
                    callback(null, {
                        statusCode: 200,
                        body: JSON.stringify(lessons[0])
                    })
                }
            )
            .catch(err =>
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the selected lesson.'
                })
            );
    });
};
