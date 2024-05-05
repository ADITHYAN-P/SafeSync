import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:safe/chart.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  int _rashPercent = 0;
  int _avgSpeed = 0;
  final String url = "https://accident-backend-qjlv.onrender.com";
  final Map<String, dynamic> rashData = {};

  Future<void> fetchSpeed() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final response = await http.get(Uri.parse('$url/speed/$formattedDate'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final avg_speed = data['speed'];

        setState(() {
          _avgSpeed = avg_speed.round();
        });
        print(_avgSpeed);
      } else {
        throw Exception('Failed to fetch speed: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  Future<void> fetchAnalysis() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final response = await http.get(Uri.parse('$url/pattern/$formattedDate'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rash_percent = data['rash_percent'];

        setState(() {
          _rashPercent = rash_percent.round();
        });
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  List<MapEntry<String, dynamic>> dataList = [];

  Future<void> fetchTarget() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final response =
          await http.get(Uri.parse('$url/rash_data/$formattedDate'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        setState(() {
          rashData.addAll(data);
        });

        //covert rashdata to list
        dataList = rashData.entries.toList();
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAnalysis();
    fetchSpeed();
    fetchTarget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Analysis',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 10.0,
                animation: true,
                percent: _rashPercent / 100.0,
                center: Text(
                  "Rash\n" + _rashPercent.toString() + "%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                footer: const Text(
                  "Driving Behaviour",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 17.0,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: _rashPercent > 50 ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: _avgSpeed > 60
                      ? BorderSide(color: Colors.red)
                      : BorderSide(color: Colors.green),
                ),
                title: Text('Average Speed'),
                trailing: Text(_avgSpeed.toString() + " km/h"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey),
                ),
                title: Text('Time'),
                trailing: Text("Driving Behaviour"),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = dataList[index].key;
                    dynamic value = dataList[index].value;
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: dataList[index].value == "Rash"
                              ? BorderSide(color: Colors.red)
                              : BorderSide(color: Colors.grey),
                        ),
                        title: Text(key),
                        trailing: Text(value.toString()),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //chart here
            // Charts(needData: {"27/04":"rash"},)
          ],
        ));
  }
}
