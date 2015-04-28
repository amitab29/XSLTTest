var http = require('http');

http.createServer(function (req, res) {

  res.writeHead(200, {'Content-Type': 'text/plain'});

  //res.end('Hello Node');
  
var fs = require('fs');  
var libxslt = require('libxslt');   
var libxmljs = libxslt.libxmljs;

   
/*
var docSource = fs.readFileSync('test.xml', 'utf8');    
var stylesheetSource = fs.readFileSync('sort.xsl', 'utf8');
var stylesheetObj = libxmljs.parseXml(stylesheetSource);
var doc = libxmljs.parseXml(docSource);
var stylesheet = libxslt.parse(stylesheetObj);
var result = stylesheet.apply(doc);

fs.writeFile('s_test.xml', result, function (err) {
  if (err) return console.log(err);
  console.log('Hello World > helloworld.txt');
});
*/
var docSource1 = fs.readFileSync('s_test.xml', 'utf8');    
var stylesheetSource1 = fs.readFileSync('FullAttributes.xsl', 'utf8');  
var stylesheetObj1 = libxmljs.parseXml(stylesheetSource1);
    var doc1 = libxmljs.parseXml(docSource1);
    var stylesheet1 = libxslt.parse(stylesheetObj1);
   var result1= stylesheet1.apply(doc1);
console.log('Hello World 1 > helloworld.txt');
/*var result1 =stylesheet1.apply(doc1);
stylesheet1.apply(doc1, function(err,result1)
{
if (err) return console.log(err);
console.log(result1 );
});

*/

fs.writeFile('s_test.htm', result1, function (err) {
  if (err) return console.log(err);
  console.log('Hello World > helloworld.txt');
});

res.end('File Created');
//res.end(res.write(result1.toString()));

}).listen(1337, '127.0.0.1');