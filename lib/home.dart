// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/add.dart';
import 'package:firebasedemo/authen.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'manage.dart';
import 'add.dart';
// import 'package:firebasedemo/login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                signOut(context);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => Add(),
          );
          Navigator.push(context, route);
        },
      ),
      body: realTimeFood(),
    );
  }

  Widget realTimeFood() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('homestays').snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          default:
            return Column(
              children: makeListWidget(snapshot),
            );
        }
      },
    );
  }

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.docs.map<Widget>((document) {
      return Card(
        child: ListTile(
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text('คุณต้องการลบข้อมูลใช่หรือไหม'),
                            )
                          ],
                        ),
                        actions: [
                          FlatButton(
                              child: Text('ลบ'),
                              color: Colors.red,
                              onPressed: () {
                                deleleHomestay(document.id);
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text('ยกเลิก'),
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      );
                    });
              }),
          leading: Container(
              width: 100,
              child: Image.network(
                document['img'],
                fit: BoxFit.cover,
              )),
          title: Text(document['name_homestay']),
          subtitle: Text(document['price'].toString()),
          onTap: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => Manage(docid: document.id),
            );
            Navigator.push(context, route);
          },
          // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Manage(),)),
        ),
      );
    }).toList();
  }

  Future<void> deleleHomestay(id) async {
    await FirebaseFirestore.instance.collection("homestays").doc(id).delete();
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut().then((value) {
      googleSignIn.signOut();
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        ModalRoute.withName('/'));
  }
}
