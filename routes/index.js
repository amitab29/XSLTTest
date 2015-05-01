var express = require('express');
var router = express.Router();

/* GET home page. */


router.get('/', function (req, res, next) {
    req.session.lastpage = '/index';
    res.render('index');
});

router.get('/home', function (req, res, next) {
    req.session.lastpage = '/home';
    res.render('parts/home');
});

router.get('/about', function (req, res, next) {
    req.session.lastpage = '/about';
    res.render('parts/about');
});

router.get('/upload', function (req, res, next) {
    req.session.lastpage = '/upload';
    res.render('parts/upload');
});


module.exports = router;
