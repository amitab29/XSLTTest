var http = require('http');

http.createServer(function (req, res) {

  res.writeHead(200, {'Content-Type': 'text/plain'});

  res.end('Hello Node');
  
  var fs = require('fs');   
var libxslt = require('libxslt');   
var libxmljs = require('libxmljs');   


var docSource = fs.readFileSync('test.xml', 'utf8');    
var stylesheetSource = fs.readFileSync('sort.xsl', 'utf8');    
var stylesheet = libxmljs.parseXml(stylesheetSource);    
var result = stylesheet.apply(docSource);    
res.end(result);    

}).listen(1337, '127.0.0.1');