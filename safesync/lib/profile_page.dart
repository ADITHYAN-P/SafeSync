import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String url = "https://accident-backend-qjlv.onrender.com";
  final List<Map<String, dynamic>> phoneNum = [];
  int avgspeed = 0;
  List<MapEntry<String, dynamic>> dataList = [
    MapEntry("29/04", "Rash"),
    MapEntry("28/04", "Normal"),
    MapEntry("27/04", "Rash"),
    MapEntry("26/04", "Rash")
  ];

  Future<void> fetchavgSpeed() async {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString();

    try {
      final response =
          await http.get(Uri.parse('$url/average-speed/$year/$month'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final avd_speed = data['average_speed'];

        setState(() {
          avgspeed = avd_speed.round();
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

  Future<void> fetchPhone() async {
    try {
      final response = await http.get(Uri.parse('$url/phone_number'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        // Clear phoneNumList before adding new data
        phoneNum.clear();

        // Iterate over the list of objects and add each object to phoneNumList
        for (var data in dataList) {
          if (data is Map<String, dynamic>) {
            phoneNum.add(data);
          }
        }
      } else {
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error fetching phone: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  Future<void> removeNum(String phone) async {
    try {
      final response = await http.delete(Uri.parse('$url/phone_number/$phone'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("successfully deleted phone number");
        setState(() {
          phoneNum.remove(phone);
        });
      } else {
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error fetching phone: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchavgSpeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchPhone(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 100, // Adjust the height of the SizedBox as needed
                    child: phoneNum.isEmpty
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    addPhone();
                                  },
                                  icon: Icon(Icons.add),
                                ),
                                Text("Add phone number"),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: phoneNum.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Text(phoneNum[index].values.elementAt(1)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(phoneNum[index]
                                        .values
                                        .elementAt(0)
                                        .toString()),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        removeNum(phoneNum[index]
                                            .values
                                            .elementAt(0));
                                        setState(() {
                                          phoneNum.remove(phoneNum[index]
                                              .keys
                                              .elementAt(0));
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  // Additional widgets can be added below the ListView.builder
                  // For example:
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 10.0,
                        animation: true,
                        percent: 60 / 100.0,
                        center: Text(
                          "Rash\n" + "60%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        footer: const Text(
                          "Driving Behaviour\n Month",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 17.0,
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: 60 > 50 ? Colors.red : Colors.green,
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 10.0,
                        animation: true,
                        percent: avgspeed / 100.0,
                        center: Text(
                          "Speed\n" + avgspeed.toString() + " Kmph",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        footer: const Text(
                          "Average Speed\n Month",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 17.0,
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor:
                            avgspeed > 50 ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                  // Charts(
                  //   needData: {"27/04": "rash"},
                  // )
                  // ,
                  // ElevatedButton(onPressed: (){
                  //   Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => AccidentN()),
                  //       );

                  // }, child: Text("Accident"))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void addPhone() {
    TextEditingController phoneNumController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add phone number"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: phoneNumController,
                decoration: InputDecoration(hintText: "Phone number"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.post(
                    Uri.parse('$url/phone'),
                    headers: {
                      "Content-Type": "application/json",
                      "accept": "application/json",
                    },
                    body: json.encode({
                      "name": nameController.text,
                      "phoneNumber": phoneNumController.text,
                    }),
                  );

                  if (response.statusCode == 200) {
                    // Add the new phone number to the list
                    setState(() {
                      phoneNum.add({
                        "name": nameController.text,
                        "phone": phoneNumController.text,
                      });
                    });
                    // Close the dialog
                    Navigator.of(context).pop();
                  } else {
                    throw Exception(
                        'Failed to add phone: ${response.statusCode}');
                  }
                } catch (e) {
                  print('Error adding phone: $e');
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
