import 'package:app_service/utils/sharePref.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PmHistory extends StatefulWidget {
  const PmHistory({Key? key}) : super(key: key);

  @override
  State<PmHistory> createState() => _PmHistoryState();
}

class _PmHistoryState extends State<PmHistory> {
  List<dynamic>? pmHistoryData;

  @override
  void initState() {
    super.initState();
    fetchPmHistory();
  }

  Future<void> fetchPmHistory() async {
    try {
      // Call pmHistory function to fetch data
      final List<dynamic> data = await pmHistory();
      setState(() {
        pmHistoryData = data;
      });
    } catch (error) {
      // Handle errors
      print('Error fetching PM history: $error');
      setState(() {
        pmHistoryData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PM History'),
      ),
      body: pmHistoryData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : pmHistoryData!.isEmpty
              ? Center(
                  child: Text('PM history not found.'),
                )
              : ListView.builder(
                  itemCount: pmHistoryData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final pmItem = pmHistoryData![index];
                    return Card(
                      child: ListTile(
                        title: Text('Serial Number: ${pmItem['sn']}'),
                        leading: Icon(Icons.abc_rounded), // Set leading icon
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${pmItem['date'] ?? 'N/A'}'),
                            //Text('Name: ${pmItem['name'] ?? 'N/A'}'),
                            Text('PM Type: ${pmItem['pmtype'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // Function to fetch PM history data
  static Future<List<dynamic>> pmHistory() async {
    String username = AuthorizeUser.getUsername();
    final String url =
        'https://united-tsm.com/services/api/pmhistory.php?name=$username';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception(
            'Failed to fetch PM history. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
