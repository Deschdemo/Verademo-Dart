import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verademo_dart/controllers/blab_controller.dart';
import 'package:verademo_dart/utils/constants.dart';
import 'package:verademo_dart/utils/shared_prefs.dart';
import 'package:verademo_dart/widgets/app_bar.dart';
import 'package:verademo_dart/widgets/profile_image.dart';

class BlabPage extends StatefulWidget {
  //implement some comments variable

  final Map blabInfo;
  final controller = TextEditingController();

  BlabPage({super.key, required this.blabInfo});

  @override
  State<BlabPage> createState() => _BlabPageState();
}

class _BlabPageState extends State<BlabPage> {

  late Future<List<Widget>> _commentdata;
  @override
  initState()
  {
    super.initState();
    _commentdata = getData(widget.blabInfo['blabid']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VAppBar('Blab'),
      body: Padding(
        padding: VConstants.pagePadding,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            BlabBox(widget.blabInfo['username'], widget.blabInfo['blab_name'], widget.blabInfo['content'], widget.blabInfo['timestamp']),
            const SizedBox(height: 10,),
            CommentBar(),
            const SizedBox(height: 10,),
            Text("Comments", style: Theme.of(context).textTheme.headlineLarge,),
            const SizedBox(height: 10,),
            FutureBuilder<List<Widget>>(
              future: _commentdata,
              builder: (context, snapshot) {
                if (snapshot.hasError)
                {
                  final error = snapshot.error;

                  return Text('Error: $error');
                } else if (snapshot.hasData) {
                  List<Widget> commentdata = snapshot.data as List<Widget>;
                  return Column(children: commentdata,);
                }
                else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: VConstants.veracodeBlue,));
                }
              },
            ),
          ],),
      ),
    );
  }

  Future<List<Widget>> getData(blabid) async {
 
    print("Building API call to /posts/getBlabComments");
    const url1 = "${VConstants.apiUrl}/posts/getBlabComments";
    final uri1 = Uri.parse(url1);
    final body = jsonEncode(<String, int> {
        "blabId": blabid
      });
    final Map<String, String> headers1 = {
      "content-type": "application/json",
      "Authorization": "${VSharedPrefs().token}"
    };
    
    
    final response = await http.post(uri1, headers: headers1, body: body);
    // Convert output to JSON
    final data = jsonDecode(response.body)["data"] as List;

    // Build API call for getUsers
    print("Building API call to /users/getUsers/");
    const url2 = "${VConstants.apiUrl}/users/getUsers/";
    final uri2 = Uri.parse(url2);
    final Map<String, String> headers2 = {
      "content-type": "application/json",
      "Authorization": "${VSharedPrefs().token}"
    };

    await Future.delayed(const Duration(seconds: 2));
    // Execute API call for getUsers
    final userResponse = await http.get(uri2, headers: headers2);
    if (userResponse.statusCode == 200) {
      // getUsers successful

      // Convert output to JSON
      final userData = jsonDecode(userResponse.body)["data"];

      List<Widget> items = [];
      for (int i=0; i<data.length; i++)
      {
        items.add(buildCommentItem(data[i], userData));
      }
      return items;
    }
    else {
      return [];
    }
    
    
  }


  // ignore: non_constant_identifier_names
  Widget CommentBar(){
    return Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Add comment...',
                  filled: true,
                  fillColor: VConstants.darkNeutral2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            const SizedBox(width: 8,),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  BlabController.addBlabComment(widget.blabInfo['blabid'],widget.controller.text,context);
                  _commentdata = getData(widget.blabInfo['blabid']);
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
  }
}

Widget buildCommentItem(data, userData) {
  final username = data['blabber'];
  final content = data['content'];
  final timestamp = data['timestamp'];
  final blabName = userData.where((user) => user['username'] == username).single;
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: BlabBox(username, blabName['blab_name'], content, timestamp),
  );
}

// ignore: non_constant_identifier_names
Container BlabBox(username, blabber, content, timestamp){
  return Container(
    decoration: BoxDecoration(
        color: VConstants.darkNeutral2,
        borderRadius: BorderRadius.circular(10),
      ),
      
    width: double.infinity,
    child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlabberHeader(username: username, blabName: blabber, timestamp: timestamp,),
              const SizedBox(height: 10,),
              Text(content, softWrap: true,),
        ]),
      ),);
  
}

class BlabberHeader extends StatelessWidget {
  
  final String username;
  final String blabName;
  final String timestamp;
  const BlabberHeader({
    super.key,
    required this.username,
    required this.blabName,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      VAvatar(username, radius:30),
      const SizedBox(width: 10,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(blabName,
            style: Theme.of(context).textTheme.headlineMedium, ),
          Text(timestamp, 
            style: Theme.of(context).textTheme.labelSmall),
        ],
                ), 
              ],);
  }
}

// TODO: Implement comment retrieval
/*
Map getBlabComments(blabID)
async {
  Map results = {};

  print("Building API call to /posts/getBlabComments/");
    const url = "${VConstants.apiUrl}/posts/getBlabComments/";
    final uri = Uri.parse(url);
    final body = jsonEncode(<String, String> {
      "blabID":blabID
    });
    final Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": VSharedPrefs().token ?? "",
    };

    // Execute API call for updateProfile/
    final response = await http.post(uri, headers: headers, body: body);
    print("Executed API call to updateProfile");

  return results
}
*/