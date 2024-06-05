
const mongoose = require('mongoose');

const lesson_schema = new mongoose.Schema({
    id: Number,
    title: String,
    link: String,
    content: String
}, { collection: 'tedx_data' });

module.exports = mongoose.model('lesson', lesson_schema);
