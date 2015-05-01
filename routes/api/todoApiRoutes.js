/**
 * Created by dbutch on 3/31/2015.
 */
var express = require('express');
var router = express.Router();
var moment = require('moment');

var todoService = require('../../services/todoService');
var responseFormatter = require('../../common/responseFormatter');

router.get('', function (request, response) {

    var showPretty = request.query.pretty;

    todoService.retrieveAll(function (error, listOfToDos) {
        if (showPretty != null && listOfToDos != null){
            listOfToDos = formatDates(listOfToDos);
        }

        responseFormatter.formatResponse(response, error, listOfToDos);
    })
});

router.get('/:id', function (request, response) {

    var id = request.param("id");

    todoService.retrieve(id, function (error, todo) {
        responseFormatter.formatResponse(response, error, todo);
    })
});

router.post('', function (request, response) {
    var title = request.body.title;
    var description = request.body.description;
    var dueDate = request.body.due_date;

    todoService.create(title, description, dueDate, function (error, id) {
        responseFormatter.formatResponse(response, error, id);
    })
});

router.put('/:id', function (request, response) {

    var id = request.param("id");
    var title = request.body.title;
    var description = request.body.description;
    var dueDate = request.body.due_date;

    todoService.update(id, title, description, dueDate, function (error) {
        responseFormatter.formatResponse(response, error, null);
    })
});

router.delete('/:id', function (request, response) {

    var id = request.param("id");
    todoService.remove(id, function (error) {
        responseFormatter.formatResponse(response, error, null);
    })
});

function formatDates (listOfDos){

    var newListOfToDos = [];
    for(index in listOfDos){

        var todo = listOfDos[index];
        todo.elapse_due_date = moment(todo.due_date).fromNow();

        var newToDo = {
            id : todo.id,
            completed : todo.is_completed,
            create_date: todo.create_date,
            elapse_due_date: moment(todo.due_date).fromNow(),
            title: todo.title,
            description: todo.description
        };

        newListOfToDos.push(newToDo);
    }
    return newListOfToDos
};

module.exports = router;