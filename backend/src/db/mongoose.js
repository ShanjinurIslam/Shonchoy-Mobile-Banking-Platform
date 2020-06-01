const mongoose = require('mongoose')

mongoose.connect('mongodb://localhost/my_database', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,
});