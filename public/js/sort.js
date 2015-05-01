var exports = module.exports = {};

var fs = require('fs');  
var libxslt = require('libxslt');   
var libxmljs = libxslt.libxmljs;

module.exports = {
    sort:  function(inputxml, inputxsl)
    {   
	try{
    var docSource = fs.readFileSync(inputxml, 'utf8'); 
    var stylesheetSource = fs.readFileSync(inputxsl, 'utf8');
    var stylesheetObj = libxmljs.parseXml(stylesheetSource);
    var doc = libxmljs.parseXml(docSource);
    var stylesheet = libxslt.parse(stylesheetObj);
    var result = stylesheet.apply(doc);
    fs.writeFileSync('./downloads/stest.xml', result);
    return ("1");
	}catch(e)
	{
	console.log(e);
	return ("-1");
	}
    }
	
};