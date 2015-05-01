var exports = module.exports = {};

var fs = require('fs');  
var libxslt = require('libxslt');   
var libxmljs = libxslt.libxmljs;

module.exports = {
    transform:  function(inputxml, inputxsl, originalFileName)
    {   
	console.log(inputxml);
	console.log(inputxsl);
	console.log(originalFileName);
	var docSource = fs.readFileSync(inputxml, 'utf8');    
    var stylesheetSource = fs.readFileSync(inputxsl, 'utf8');
    var stylesheetObj = libxmljs.parseXml(stylesheetSource);
    var doc = libxmljs.parseXml(docSource);
    var stylesheet = libxslt.parse(stylesheetObj);
       
    var result = stylesheet.apply(doc).toString();
	
	result = result.replace(/^<\?xml version="1.0" encoding="UTF-8" standalone="yes"\?>\n/, '');
    fs.writeFile(originalFileName , result, function (err) {
      if (err) return console.log(err);
      console.log('Transform > Completed');
    });
        return("HTML File Created::" + originalFileName );
    }
};