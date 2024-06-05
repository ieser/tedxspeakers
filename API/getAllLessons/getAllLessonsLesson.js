const mongoose = require('mongoose');

const lesson_schema = new mongoose.Schema({
    _id: Number,
    title: String,
    link: String,
    content: String
}, { collection: 'speakingskills' });

module.exports = mongoose.model('lesson', lesson_schema);
