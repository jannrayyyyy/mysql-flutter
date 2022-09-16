import 'package:flutter/material.dart';
import 'MySql_DataTable/data_table_demo.dart';

void main() {
  runApp(
    const HomeApp(),
  );
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataTableDemo(),
    );
  }
}
