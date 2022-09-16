import 'dart:convert';
import 'package:http/http.dart' as http;

import 'employee_model.dart'; // add the http plugin in pubspec.yaml file.

// $full_name = $_POST['full_name'];
// $email = $_POST['email'];
// $gender = $_POST['gender'];
// $contact_number = $_POST['contact_number'];
// $location_address = $_POST['location_address'];
// $pass = $_POST['pass'];
// $coordinates = $_POST['coordinates'];
class Services {
  static const root = 'http://www.lanuzapp.elementfx.com/connection.php';

  static const _ADD_EMP_ACTION = 'REGISTER';
  static const _CREATE_TABLE_ACTION = 'CREATE_USER_TABLE';

  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  // static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = <String, dynamic>{};
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(Uri.parse(root), body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(root), body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        return <Employee>[];
      }
    } catch (e) {
      return <Employee>[]; // return an empty list on exception/error
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  // lagay mo string lahat dapat
  static Future<String> registerUser(String fullName, String email) async {
    try {
// $full_name = $_POST['full_name'];
// $email = $_POST['email'];
// $gender = $_POST['gender'];
// $contact_number = $_POST['contact_number'];
// $location_address = $_POST['location_address'];
// $pass = $_POST['pass'];
// $coordinates = $_POST['coordinates'];
      var map = <String, dynamic>{};
      map['action'] = _ADD_EMP_ACTION;
      map['full_name'] = 'KARL S. REGINALDO';
      map['email'] = 'reginaldokarlsjan@gmail.com';
      map['gender'] = 'MALE';
      map['contact_number'] = '+63928232';
      map['location_address'] = 'GENTREE';
      map['pass'] = 'PASWORDKTO';
      map['coordinates'] = '2323,1232';
      final response = await http.post(Uri.parse(root), body: map);
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateEmployee(
      String empId, String firstName, String lastName) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(Uri.parse(root), body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(Uri.parse(root), body: map);
      print('deleteEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
