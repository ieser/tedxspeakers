const mongoose = require('mongoose');

const talk_schema = new mongoose.Schema({
    id: Number,
    title: String,
    url: String,
    description: String,
    speakers: String,
    related: Array
}, { collection: 'tedx_data' });

module.exports = mongoose.model('talk', talk_schema);
