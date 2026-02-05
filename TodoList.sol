// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TodoList {
    struct Todo {
        uint256 id;
        address owner;
        string task;
        string description;
        bool completed;
    }

    Todo[] internal todoList;
    uint256 public todoCount;

    event TodoCreated(uint256 id, address owner, string task, string description);
    event TodoCompleted(uint256 id, address owner);

    function createTodo(string memory _task, string memory _description) public {
        todoList.push(Todo({
            id: todoCount,
            owner: msg.sender,
            task: _task,
            description: _description,
            completed: false
            }));

        emit TodoCreated(todoCount, msg.sender, _task, _description);
        todoCount++;
    }

    function markCompleted(uint256 _id) public {
        require(_id<todoCount, "Out of bounds!!");
        Todo storage currTodo = todoList[_id];

        require(currTodo.owner==msg.sender, "Not your task!!");
        require(!currTodo.completed, "Task already completed!!");

        currTodo.completed = true;
        emit TodoCompleted(_id, msg.sender);
    }

    function getMyTodos() public view returns(Todo[] memory) {
        uint256 count = 0;
        
        for(uint256 i = 0; i<todoList.length; i++){
            if(todoList[i].owner==msg.sender){
                count++;
            }
        }

        Todo[] memory myTodoList = new Todo[](count);
        uint256 idx = 0;
        for(uint256 i = 0; i<todoList.length; i++){
            if(todoList[i].owner==msg.sender){
                myTodoList[idx] = todoList[i];
                idx++;
            }
        }

        return myTodoList;
    }

    function getTodo(uint256 _id) public view returns(Todo memory){
        require(_id<todoCount, "Out of bounds!!");
        return todoList[_id]; 
    }
}