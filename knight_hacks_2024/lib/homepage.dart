import 'package:flutter/material.dart';

import 'main.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
  }
}

class ToDoPage extends StatefulWidget {
  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
    _updateToDoItem();
  }

  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    bool isHintVisible = _todoController.text.trim().isEmpty && isButtonPressed;
    Color borderColor = isHintVisible ? Colors.red : Colors.grey;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: searchBox(),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 80),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 5,
                        ),
                        child: const Text(
                          "Today's Tasks:",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                          onRenameItem: _renameToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 161, 50, 111),
                          offset: Offset(0.0, 0.0),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _todoController,
                      onChanged: (value) {
                        setState(() {
                          isHintVisible = _todoController.text.trim().isEmpty &&
                              isButtonPressed;
                          borderColor =
                              isHintVisible ? Colors.red : Colors.grey;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: isHintVisible
                            ? 'Enter a Non-Empty Task' // Display issue if the entered text is blank and the button has been pressed
                            : 'Add a new todo item',
                        hintStyle: TextStyle(
                          color: isHintVisible
                              ? Colors.red // Change hint text color to red
                              : Colors.grey, // Use default hint text color
                        ),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: borderColor), // Change border color to red
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: borderColor), // Change border color to red
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_todoController.text.trim().isNotEmpty) {
                        _addToDoItem(_todoController.text);
                        _todoController.clear(); // Clear the text field
                        setState(() {
                          isButtonPressed = false; // Reset the flag
                        });
                      } else {
                        setState(() {
                          isButtonPressed = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[250],
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 161, 50, 111),
            offset: Offset(0.0, 0.0),
            blurRadius: 2.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Color.fromARGB(255, 107, 104, 104),
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      if (!todo.isDone) {
        todo.isDone = !todo.isDone;
        final todoId = todo
            .id!; // Use the null-aware operator to assert that todo.id is not null
        markDone(todoId).then((_) {
          print('Task marked as done successfully');
        }).catchError((error) {
          print('Error marking task as done: $error');
          // Optionally, you can revert the changes made to the todo object if the marking process fails.
          todo.isDone = !todo.isDone;
        });
      }
    });
  }

  void _renameToDoItem(String id, String newText) {
    updateTask(id, newText).then((_) {
      setState(() {
        final index = todosList.indexWhere((item) => item.id == id);
        if (index != -1) {
          todosList[index].todoText = newText;
        }
      });
    }).catchError((error) {
      print('Error renaming ToDo item: $error');
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });

    if (id != '01') {
      try {
        deleteTask(id).then((_) {
          print('Task deleted successfully');
        }).catchError((error) {
          print('$error');
        });
      } catch (error) {
        print('$error');
      }
    }
  }

  Future<void> _updateToDoItem() async {
    try {
      userTodos = await searchTasks("", userId);
      for (var todo in userTodos) {
        setState(() {
          todosList.add(ToDo(
            id: todo['_id'],
            todoText: todo[
                'Task'], // Assuming 'Task' is the text field in your todo object
            isDone: todo[
                'Done'], // Assuming 'Done' indicates whether the task is done or not
          ));
        });
      }
      print('Tasks retrieved successfully');
    } catch (error) {
      print('$error');
    }
  }

  void _addToDoItem(String toDo) {
    try {
      addTask(toDo, "", false, userId).then((taskId) {
        print('Task added successfully');
        setState(() {
          todosList.add(ToDo(
            id: taskId,
            todoText: toDo,
          ));
        });
      }).catchError((error) {
        print('$error');
      });
    } catch (error) {
      print('$error');
    }

    _todoController.clear(); // Clear the text field after adding the item
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }
}