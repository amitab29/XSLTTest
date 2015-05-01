/**
 * Created by mrosen on 4/12/2015.
 */
var express = require('express');
var router = express.Router();
var moment = require('moment');

var todoUserService = require('../../services/todoUserService');
var responseFormatter = require('../../common/responseFormatter');

router.post('', function (request, response) {
    
    var userName = request.body.userName;
    var password = request.body.password;
    
   var result =  todoUserService.signin(userName, password, request, function (error, todoUser) {
        if (error != null) {
        }
        else {
            request.session.usersName = todoUser[0]._doc.firstName + ' ' + todoUser[0]._doc.lastName;
        }
        responseFormatter.formatResponse(response, error, todoUser);
    })
});

module.exports = router;