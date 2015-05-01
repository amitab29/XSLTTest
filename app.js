/*Define dependencies.*/

var express = require("express");
var multer = require('multer');
var path = require('path');
var app = express();
var done = false;
var sort = require('./public/js/sort.js');
var http = require('http');
var transform = require('./public/js/transform.js');
var s_filename, o_filename;
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'html');

//app.use(express.static(path.join(__dirname, 'public')));
//app.use('/public', express.static('./public'));

/*Configure the multer.*/
app.use(multer({
    dest: './uploads/',
    rename: function (fieldname, filename) {
        o_filename = filename + '.htm';
        s_filename = filename + Date.now()
        return s_filename;
    },
    onFileUploadStart: function (file) {
        console.log(file.originalname + ' is starting ...')
    },
    onFileUploadComplete: function (file) {
        console.log(file.name + ' uploaded to  ' + file.path)
        done = true;
    }
}));

/*Handling routes.*/
app.get('/', function (req, res) {
    //res.sendFile("index.html");
    res.sendFile('index.html', { root: __dirname + '/views' });
});

app.post('/actionUpload', function (req, res) {
    if (done == true) {
        console.log(req.files);
        var files = JSON.stringify(req.files);
        console.log("Files: " + s_filename);
        console.log('Sort > Started');
        var output = sort.sort('./uploads/' + s_filename + '.dita', './public/xsl/sort.xsl');
        if (output == -1)
		{
            res.end("Error in Parsing Source File, Please check your file");
		}
		else 
		{
		console.log(output);
        console.log('htm transform > Started');
        transform.transform('./downloads/stest.xml', './public/xsl/FullAttributes.xsl', './downloads/'+o_filename);
        res.send('<ul>' 
    + '<li>Download your File:: <a href='+'./downloads/'+o_filename+ '>'+ o_filename+'</a>.</li>' 
    
    + '</ul>');
        
        res.end();
		}
    }
});

app.get('/:file(*)', function (req, res, next) {
    var file = req.params.file
    , path = __dirname + '/' + file;
    console.log(path);
    res.download(path);
});

// error handling middleware. Because it's
// below our routes, you will be able to
// "intercept" errors, otherwise Connect
// will respond with 500 "Internal Server Error".
app.use(function (err, req, res, next) {
    // special-case 404s,
    // remember you could
    // render a 404 template here
    if (404 == err.status) {
        res.statusCode = 404;
        res.send('Cant find that file, sorry!');
    } else {
        next(err);
    }
});
/*Run the server.*/
app.listen(3000, function () {
    console.log("Working on port 3000");
});