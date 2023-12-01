import 'package:church_and/CustomDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:church_and/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:church_and/view_pdf.dart';

DateTime get _now => DateTime.now();

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String url = "";
  String date = DateFormat("MM-dd-yyyy").format(DateTime.now()).toString();

  uploadCalendarToFirebase() async {
    //pick pdf file
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    var pdfFile = FirebaseStorage.instance.ref().child(name).child("/.pdf");
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection("CalendarFile")
        .doc()
        .set({'fileURL': url, 'date': "행사안내 " + date});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF543d35),
        toolbarHeight: 86,
        centerTitle: false,
        title: Align(
            alignment: Alignment.topRight,
            child: Text('달력',
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 25))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadCalendarToFirebase,
        child: Icon(Icons.add),
      ),
      drawer: CustomDrawer(),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("CalendarFile").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot x = snapshot.data!.docs[i];

                  return Container(
                      height: 40,
                      child: Card(
                        color: Color(0x5Fbcb4a0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFF543d35)),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                            child: Center(
                                child: Text(x["date"],
                                    style: TextStyle(
                                        fontFamily: "cafe", fontSize: 12))),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          loadPDF(url: x['fileURL'])));
                            }),
                      ));
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}
