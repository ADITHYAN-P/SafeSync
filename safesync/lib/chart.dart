import 'package:flutter/material.dart';

class Charts extends StatefulWidget {
  const Charts({super.key,required Map<String,dynamic> needData});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("graph")),
    );
  }
}