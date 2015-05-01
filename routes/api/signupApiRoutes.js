/**
 * Created by mrosen on 4/12/2015.
 */
var express = require('express');
var router = express.Router();
var moment = require('moment');

var todoUserService = require('../../services/todoUserService');
var responseFormatter = require('../../common/responseFormatter');
/*
router.get('', function (request, response) {
});

router.get('/:id', function (request, response) {
});
*/
router.post('', function (request, response) {
    var firstName = request.body.firstName;
    var lastName = request.body.lastName;
    var emailAddress = request.body.emailAddress;
    var userName = request.body.userName;
    var password1 = request.body.password1;
    var password2 = request.body.password2;
    
    todoUserService.create(firstName, lastName, emailAddress, userName, password1, password2, function (error, id) {
        responseFormatter.formatResponse(response, error, id);
    })
});
/*
router.put('/:id', function (request, response) {
});

router.delete('/:id', function (request, response) {
});
*/
module.exports = router;