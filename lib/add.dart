import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _address = TextEditingController();

  File _image;
  final picker = ImagePicker();

  Future<void> chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddPage'),
        // backgroundColor: Colors.yellow[300],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 250,
              child: RaisedButton(
                onPressed: () {
                  chooseImage();
                },
                child: Text('เลือกรูป'),
              ),
            ),
            Container(
              width: 250,
              height: 250,
              child: _image == null ? Text('no image') : Image.file(_image),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: _name,
                decoration: InputDecoration(labelText: 'ชื่อโฮมสเตย์'),
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: _price,
                decoration: InputDecoration(labelText: 'ราคา'),
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: _address,
                decoration: InputDecoration(labelText: 'ที่อยู่'),
              ),
            ),
            RaisedButton(
              onPressed: () {
                addHomestay();
              },
              //ปุ่ม button บันทึกการแก้ไขข้อมูล
              child: Text('UPLOAD'),
              // color: Colors.yellow[300],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addHomestay() async {
    String fileName = Path.basename(_image.path);
    StorageReference reference =
        FirebaseStorage.instance.ref().child('$fileName');
    StorageUploadTask storageUploadTask = reference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) async {
      await FirebaseFirestore.instance.collection('homestays').add({
        'name_homestay': _name.text,
        'price': _price.text,
        'address': _address.text,
        'img': value,
      }).whenComplete(() => Navigator.pop(context));
    });
  }
}
