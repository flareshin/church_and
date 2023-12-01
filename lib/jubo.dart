import 'package:church_and/CustomDrawer.dart';
import 'package:church_and/view_pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import 'add_new_page.dart';
import 'add_pray_page.dart';
import 'add_priest_pray_page.dart';
import 'get_new_contents.dart';
import 'get_pray_contents.dart';
import 'get_pray_prist_contents.dart';

class Jubo extends StatefulWidget {
  const Jubo({Key? key}) : super(key: key);

  @override
  _JuboState createState() => _JuboState();
}

class _JuboState extends State<Jubo> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: 0,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String url = "";
  String date = DateFormat("MM-dd-yyyy").format(DateTime.now()).toString();

  uploadJuboToFirebase() async {
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
        .collection("JuboFile")
        .doc()
        .set({'fileURL': url, 'date': "금주의 주보 " + date});

    // await FirebaseFirestore.instance
    //     .collection("AnniversaryFile")
    //     .doc()
    //     .set({'fileURL': url});
  }

  uploadAnnouncementToFirebase() async {
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
        .collection("AnnouncementFile")
        .doc()
        .set({'fileURL': url, 'date': "금주의 공지 " + date});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 38,
              backgroundColor: Color(0xFF543d35),
              title: Align(
                alignment: Alignment.centerRight,
                child: Text('공지사항',
                    style: TextStyle(
                        color: Colors.white, fontFamily: "cafe", fontSize: 20)),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0x5Fbcb4a0)),
                isScrollable: true,
                tabs: [
                  Tab(
                      child: Text("주보",
                          style: TextStyle(
                              fontFamily: "cafe",
                              color: Colors.white,
                              fontSize: 12))),
                  Tab(
                      child: Text("성당 공지",
                          style: TextStyle(
                              fontFamily: "cafe",
                              color: Colors.white,
                              fontSize: 12))),
                  Tab(
                      child: Text("기도해주세요",
                          style: TextStyle(
                              fontFamily: "cafe",
                              color: Colors.white,
                              fontSize: 12))),
                  Tab(
                      child: Text("새 신자",
                          style: TextStyle(
                              fontFamily: "cafe",
                              color: Colors.white,
                              fontSize: 12))),
                  Tab(
                      child: Text("신부님 기도",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "cafe",
                              fontSize: 12))),
                ],
              ),
            ),
            floatingActionButton: _tabController.index == 0
                ? FloatingActionButton(
                    onPressed: uploadJuboToFirebase,
                    child: Icon(Icons.add),
                  )
                : _tabController.index == 1
                    ? FloatingActionButton(
                        onPressed: uploadAnnouncementToFirebase,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.add),
                      )
                    : _tabController.index == 2
                        ? FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPrayPage()));
                            },
                            backgroundColor: Colors.white,
                            child: Icon(Icons.add),
                          )
                        : _tabController.index == 3
                            ? FloatingActionButton(
                                backgroundColor: Colors.yellow,
                                child: Icon(Icons.favorite),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddNewPage()));
                                },
                              )
                            : FloatingActionButton(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.play_arrow),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddPriestPrayPage()));
                                },
                              ),
            drawer: CustomDrawer(),
            body: TabBarView(controller: _tabController, children: [
              Container(
                color: Color(0xffe6d8d3),
                child: Column(children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset('assets/annoucement1_2.png')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(295, 150, 0, 10),
                        child: Text("주보",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("JuboFile")
                        .snapshots(),
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
                                      side:
                                          BorderSide(color: Color(0xFF543d35)),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                        child: Center(
                                            child: Text(x["date"],
                                                style: TextStyle(
                                                    fontFamily: "cafe",
                                                    fontSize: 12))),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => loadPDF(
                                                      url: x['fileURL'])));
                                        }),
                                  ));
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ]),
              ),
              Container(
                color: Color(0xffe6d8d3),
                child: Column(children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset('assets/annoucement1_1.png')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(255, 150, 0, 10),
                        child: Text("성당 공지",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("AnnouncementFile")
                        .snapshots(),
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
                                      side:
                                          BorderSide(color: Color(0xFF543d35)),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                        child: Center(
                                            child: Text(x["date"],
                                                style: TextStyle(
                                                    fontFamily: "cafe",
                                                    fontSize: 12))),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => loadPDF(
                                                      url: x['fileURL'])));
                                        }),
                                  ));
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ]),
              ),
              Container(
                color: Color(0xffe6d8d3),
                child: Column(children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset('assets/annoucement1_3.png')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(235, 150, 0, 10),
                        child: Text("기도해주세요",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("PrayContents")
                        .snapshots(),
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
                                      side:
                                          BorderSide(color: Color(0xFF543d35)),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                        child: Center(
                                            child: Text(x["Title"],
                                                style: TextStyle(
                                                    fontFamily: "cafe",
                                                    fontSize: 12))),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      getPrayContents(
                                                          x["Title"])));
                                        }),
                                  ));
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ]),
              ),
              Container(
                color: Color(0xffe6d8d3),
                child: Column(children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset('assets/annoucement1_4.png')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(275, 150, 10, 10),
                        child: Text("새 신자",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("NewContents")
                        .snapshots(),
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
                                      side:
                                          BorderSide(color: Color(0xFF543d35)),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                        child: Center(
                                            child: Text(x["Title"],
                                                style: TextStyle(
                                                    fontFamily: "cafe",
                                                    fontSize: 12))),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      getNewContents(
                                                          x["Title"])));
                                        }),
                                  ));
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ]),
              ),
              Container(
                color: Color(0xffe6d8d3),
                child: Column(children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset('assets/annoucement1_5.jpg')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(260, 150, 10, 10),
                        child: Text("신부님 기도",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("PrayPriestContents")
                        .snapshots(),
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
                                      side:
                                          BorderSide(color: Color(0xFF543d35)),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                        child: Center(
                                            child: Text(x["Title"],
                                                style: TextStyle(
                                                    fontFamily: "cafe",
                                                    fontSize: 12))),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      getPrayPriestContents(
                                                          x["Title"])));
                                        }),
                                  ));
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ]),
              ),
            ])));
  }
}
