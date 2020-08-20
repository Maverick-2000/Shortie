import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shortie',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}



class _homePageState extends State<homePage> {

  List userURL = List();
  List item = List();

 Future <List> getdata() async {
    
    //JSON Parser
    var url = 'https://api.shrtco.de/v2/shorten?url=${userURL.last}';
    var respons = await http.get(url);
    var result = jsonDecode(respons.body);
    item.add (result['result']['short_link']); //dictionary parse
    
    print(item);
    return item;
    
  }

   createAlertDialog(BuildContext context) {
    //method for alertdialog
    //promise to return string
    TextEditingController customController =
        TextEditingController(); //new texteditingc object
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter URL: "),
            content: TextField(
              controller: customController,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: Text("OK"),
                onPressed: () {
                  if (customController.text != null &&
                      customController.text != "") {
                       userURL.add(customController.text);
                    
                  }

                  setState(() {});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String temp;
    return Scaffold(
      appBar: AppBar(
        title: Text("Shortie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future : getdata(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data==null){
              return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.grey,
                    size:80,
                  ),
                  Text(
                    "No short links to display",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                      //fontWeight: FontWeight.bold
                    ),
                    
                    
                    ),
                ]
              )
              );
            } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Icon(Icons.link),
                  title: Text(snapshot.data[index]),
                  subtitle: Text(userURL[index]),
                  onTap: (){
                    Share.share('Check out the short link I just shared with the application Shortie: ${snapshot.data[index]}', subject: 'Shortie short link');
                    print (snapshot.data[index]);
                  },

                );
              },

            );
            }

          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createAlertDialog(context).then((onValue) {
            temp = onValue;
            print(temp);
          });
        },
        tooltip: 'Add URL',
        child: Icon(Icons.add),
      ),
    );
  }
}
