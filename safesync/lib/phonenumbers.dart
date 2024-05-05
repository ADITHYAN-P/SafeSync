import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataEntry {
  final String id;
  final String name;
  final String phoneNumber;

  DataEntry({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });
}

class DataListWidget extends StatefulWidget {
  const DataListWidget({Key? key}) : super(key: key);

  @override
  _DataListWidgetState createState() => _DataListWidgetState();
}

class _DataListWidgetState extends State<DataListWidget> {
  List<DataEntry> dataEntries = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = 'https://accident-backend-qjlv.onrender.com/phone_number';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<DataEntry> entries = responseData.map((entry) {
        return DataEntry(
          id: entry['id'].toString(),
          name: entry['name'].toString(),
          phoneNumber: entry['phone_number'].toString(),
        );
      }).toList();
      setState(() {
        dataEntries = entries;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteEntry(String id) async {
    final url = 'YOUR_DELETE_API_URL_HERE/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      // Entry deleted successfully, update UI
      fetchData();
    } else {
      throw Exception('Failed to delete entry');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataEntries.length,
      itemBuilder: (context, index) {
        final entry = dataEntries[index];
        return ListTile(
          title: Text(entry.name),
          subtitle: Text(entry.phoneNumber),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Entry?'),
                  content: const Text('Are you sure you want to delete this entry?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteEntry(entry.id);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
