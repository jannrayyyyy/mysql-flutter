import 'package:flutter/material.dart';
import 'package:test_app/MySql_DataTable/remote_data_source.dart';

import 'employee_model.dart';

class DataTableDemo extends StatefulWidget {
  const DataTableDemo({super.key});

  final String title = "Flutter Data Table";

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  List<Employee> _employees = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  Employee _selectedEmployee = Employee(id: '', firstName: '', lastName: '');
  bool _isUpdating = false;
  String _titleProgress = '';

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployees();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTables().then((result) {
      if ('success' == result) {
        _getEmployees();
        print(result);
      } else {
        print('di nag create lods');
      }
    });
  }

  _addEmployee() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      return;
    }
    _showProgress('Adding Employee...');
    Services.addEmployees(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees();
        print(result);
      } else {
        print('di nag add lods');
      }
      _clearValues();
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title);
    });
  }

  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployees(employee.id).then((result) {
      if ('success' == result) {
        setState(() {
          _employees.remove(employee);
        });
        _getEmployees();
      }
    });
  }

  _updateEmployee(Employee employee) {
    _showProgress('Updating Employee...');
    Services.updateEmployees(
            employee.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees();
        setState(() {
          _isUpdating = false;
        });
        _firstNameController.text = '';
        _lastNameController.text = '';
      }
    });
  }

  _setValues(Employee employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
    setState(() {
      _isUpdating = true;
    });
  }

  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              columns: const [
                DataColumn(
                    label: Text("ID"),
                    numeric: false,
                    tooltip: "This is the employee id"),
                DataColumn(
                    label: Text(
                      "FIRST",
                    ),
                    numeric: false,
                    tooltip: "This is the last name"),
                DataColumn(
                    label: Text("LAST"),
                    numeric: false,
                    tooltip: "This is the last name"),
                DataColumn(
                    label: Text("DELETE"),
                    numeric: false,
                    tooltip: "Delete Action"),
              ],
              rows: _employees
                  .map(
                    (employee) => DataRow(
                      cells: [
                        DataCell(
                          Text(employee.id),
                          onTap: () {
                            _setValues(employee);
                            _selectedEmployee = employee;
                          },
                        ),
                        DataCell(
                          Text(
                            employee.firstName.toUpperCase(),
                          ),
                          onTap: () {
                            _setValues(employee);
                            _selectedEmployee = employee;
                          },
                        ),
                        DataCell(
                          Text(
                            employee.lastName.toUpperCase(),
                          ),
                          onTap: () {
                            _setValues(employee);
                            _selectedEmployee = employee;
                          },
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteEmployee(employee);
                            },
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                  .toList()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _getEmployees();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _firstNameController,
              decoration: const InputDecoration.collapsed(
                hintText: "First Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _lastNameController,
              decoration: const InputDecoration.collapsed(
                hintText: "Last Name",
              ),
            ),
          ),
          _isUpdating
              ? Row(
                  children: [
                    GestureDetector(
                      child: const Text('UPDATE'),
                      onTap: () {
                        _updateEmployee(_selectedEmployee);
                      },
                    ),
                    GestureDetector(
                      child: const Text('CANCEL'),
                      onTap: () {
                        setState(() {
                          _isUpdating = false;
                        });
                        _clearValues();
                      },
                    ),
                  ],
                )
              : Container(),
          Expanded(
            child: _dataBody(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
