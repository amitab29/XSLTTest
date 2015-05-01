var http = require('http');

http.createServer(function (req, res) {

  res.writeHead(200, {'Content-Type': 'text/plain'});

  //res.end('Hello Node');
  
var fs = require('fs');  
var libxslt = require('libxslt');   
var libxmljs = libxslt.libxmljs;

   

var docSource = fs.readFileSync('test.xml', 'utf8');    
var stylesheetSource = fs.readFileSync('sort.xsl', 'utf8');
var stylesheetObj = libxmljs.parseXml(stylesheetSource);
var doc = libxmljs.parseXml(docSource);
var stylesheet = libxslt.parse(stylesheetObj);
var result = stylesheet.apply(doc);

fs.writeFile('stest.xml', result, function (err) {
  if (err) return console.log(err);
  console.log('Hello World > helloworld.txt');
});

res.end("File Created");
}).listen(1337, '127.0.0.1');