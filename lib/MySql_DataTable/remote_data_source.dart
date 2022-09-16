import 'dart:convert';
import 'package:http/http.dart' as http;

import 'employee_model.dart';

class Services {
  static const root = 'http://localhost/Employees/epddr.php';
  static const String getAction = 'GET_ALL';
  static const String createTable = 'CREATE_TABLE';
  static const String addEmployee = 'ADD_EMP';
  static const String updateEmployee = 'UPDATE_EMP';
  static const String deleteEmployee = 'DELETE_EMP';

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = getAction;
      final response = await http.post(Uri.parse(root), body: map);

      if (response.statusCode == 200) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        throw <Employee>[];
      }
    } catch (e) {
      return <Employee>[];
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  static Future<String> createTables() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = createTable;
      final response = await http.post(Uri.parse(root), body: map);
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> addEmployees(String firstName, String lastName) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = addEmployee;
      map["first_name"] = firstName;
      map["last_name"] = lastName;
      final response = await http.post(Uri.parse(root), body: map);
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> updateEmployees(
      String empId, String firstName, String lastName) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = updateEmployee;
      map["emp_id"] = empId;
      map["first_name"] = firstName;
      map["last_name"] = lastName;
      final response = await http.post(Uri.parse(root), body: map);
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> deleteEmployees(String empId) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = deleteEmployee;
      map["emp_id"] = empId;
      final response = await http.post(Uri.parse(root), body: map);

      return response.body;
    } catch (e) {
      return 'error';
    }
  }
}
