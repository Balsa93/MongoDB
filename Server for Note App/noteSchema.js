var mongoose = require('mongoose')

var note = new mongoose.Schema({
    note: String,
    title: String,
    date: String,
})

const Data = mongoose.model("data", note)

module.exports = Data