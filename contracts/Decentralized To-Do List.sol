// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DecentralizedToDoList {
    address public owner;

    struct Task {
        uint id;
        string content;
        bool completed;
        uint timestamp;
    }

    uint public nextTaskId;
    mapping(address => Task[]) private userTasks;

    constructor() {
        owner = msg.sender;
    }

    function addTask(string calldata _content) external {
        userTasks[msg.sender].push(Task({
            id: nextTaskId,
            content: _content,
            completed: false,
            timestamp: block.timestamp
        }));
        nextTaskId++;
    }

    function toggleTask(uint _taskId) external {
        Task[] storage tasks = userTasks[msg.sender];
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].id == _taskId) {
                tasks[i].completed = !tasks[i].completed;
                return;
            }
        }
        revert("Task not found");
    }

    function getMyTasks() external view returns (Task[] memory) {
        return userTasks[msg.sender];
    }

    function deleteTask(uint _taskId) external {
        Task[] storage tasks = userTasks[msg.sender];
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].id == _taskId) {
                tasks[i] = tasks[tasks.length - 1];
                tasks.pop();
                return;
            }
        }
        revert("Task not found");
    }
}
