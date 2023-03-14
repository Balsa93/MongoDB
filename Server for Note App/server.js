const express = require('express')
const mongoose = require('mongoose')
var app = express()
var Data = require('/Users/balsa/Downloads/API Projects/MongoDB/Server for Note App/noteSchema.js')

mongoose.connect('mongodb://localhost/newDB')
mongoose.connection.once("open", function(){
    console.log("Connected to DB!")
}).on("error", (error) => {
    console.log("Failed to connect " + error)
})

// Create a note - POST request
app.post("/create", (req, res) => {
    var note  = new Data ({
        note: req.get("note"),
        title: req.get("title"),
        date: req.get("date")
    })

    note.save().then(() => {
        if (note.isNew == false) {
            console.log("Saved data!")
            res.send("Saved data!")
        } else {
            console.log("Failed to save data.")
        }
    })
})

// http://192.168.0.29:8081/create
var server = app.listen(8081, "192.168.1.7", () => {
    console.log("Server is running!")
})

// Delete a note - POST request
app.post("/delete", async(req, res) => {
    const result = await Data.findByIdAndRemove({
        _id: req.get("id")
    })
    
    res.send("Deleted!")
})

// Update a note - POST request
app.post('/update',  async(req, res) => {
    const result = await Data.findOneAndUpdate({
        _id: req.get("id")
    }, {
        note: req.get("note"),
        title: req.get("title"),
        date: req.get("date")
    })

    res.send("Updated!")
})

// Fetch all notes - GET request
app.get("/fetch", (req, res) => {
    Data.find({ }).then((DBitems) => {
        res.send(DBitems)
    })
})