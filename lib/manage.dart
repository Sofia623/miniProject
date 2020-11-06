import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Manage extends StatefulWidget {
  final String docid;

  const Manage({Key key, this.docid}) : super(key: key);
  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EditPage'),
      ),
      body: Center(
        child: Column (
          children: [
          Container(
            width: 250,
            child: TextField(
              controller: _name,
            ),
          ),
          Container(
            width: 250,
            child: TextField(
              controller: _price,
            ),
          ),
          Container(
            width: 250,
            child: TextField(
              controller: _address,
            ),
          ),
          RaisedButton(
            onPressed: () {
              updateHomestay();
            },
            child: Text('บันทึก'),
          ),
        ],
      ),
      ),
    );
  }

  Future<void> getInfo() async {
    await FirebaseFirestore.instance
        .collection("homestays")
        .doc(widget.docid)
        .get()
        .then((value) {
      setState(() {
        _name =
            TextEditingController(text: value.data()['name_homestay']);
        _price =
            TextEditingController(text: value.data()['price'].toString());
        _address = TextEditingController(text: value.data()['address']);
      });
    });
  }

  Future<void> updateHomestay() async {
    await FirebaseFirestore.instance
        .collection("homestays")
        .doc(widget.docid)
        .update({
      'name_homestay': _name.text,
      'price': int.parse(_price.text),
      'address': _address.text,
    }).whenComplete(() => Navigator.pop(context));
  }
}
