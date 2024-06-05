const connect_to_db = require('./db');

// GET WATCH NEXT

const lesson = require('./Lesson');

module.exports.get_all_lessons = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {}
    if (event.body) {
        body = JSON.parse(event.body)
    }
    
    if (!body.doc_per_page) {
        body.doc_per_page = 10
    }
    if (!body.page) {
        body.page = 1
    }
    
    const sort = { _id: 1 }
    const fields = { content: 0, link:0 }

    connect_to_db().then(() => {
        lesson.find({},fields)
            .sort(sort)
            .skip((body.doc_per_page * body.page) - body.doc_per_page)
            .limit(body.doc_per_page)
            .then(lessons => {
                    callback(null, {
                        statusCode: 200,
                        body: JSON.stringify(lessons)
                    })
                }
            )
            .catch(err =>
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch lessons.'
                })
            );
    });
};
