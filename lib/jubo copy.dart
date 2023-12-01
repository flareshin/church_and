import 'package:church_and/CustomDrawer.dart';
import 'package:church_and/addPost.dart';
import 'package:church_and/storage_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Jubo extends StatefulWidget {
  const Jubo({Key? key}) : super(key: key);

  @override
  _JuboState createState() => _JuboState();
}

class _JuboState extends State<Jubo> {
  String url = "";
  uploadDataToFirebase() async {}
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("Post");

  @override
  Widget build(BuildContext context) {
    final PdfStorage storage = PdfStorage();
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 38,
              backgroundColor: Color(0xFF543d35),
              title: Padding(
                padding: EdgeInsets.only(
                  left: 170,
                ),
                child: Text('주보',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddPost()));
                    },
                    child: Icon(Icons.add))
              ],
              bottom: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0x5Fbcb4a0)),
                isScrollable: true,
                tabs: [
                  Tab(
                      child: Text("주보",
                          style: TextStyle(color: Colors.white, fontSize: 12))),
                  Tab(
                      child: Text("성당 공지",
                          style: TextStyle(color: Colors.white, fontSize: 12))),
                  Tab(
                      child: Text("기도해주세요",
                          style: TextStyle(color: Colors.white, fontSize: 12))),
                  Tab(
                      child: Text("새 신자",
                          style: TextStyle(color: Colors.white, fontSize: 12))),
                ],
              ),
            ),
            drawer: CustomDrawer(),
            body: TabBarView(children: [
              Container(
                color: Color(0xffe6d8d3),
                child: Column(children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset('assets/annoucement1_2.png')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(255, 150, 10, 10),
                        child: Text("주보",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
                  SizedBox(height: 30),
                  Column(
                    children: [Text("data")],
                  )
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
                        padding: EdgeInsets.fromLTRB(255, 150, 10, 10),
                        child: Text("성당 공지",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
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
                        padding: EdgeInsets.fromLTRB(235, 150, 10, 10),
                        child: Text("기도해주세요",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
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
                        padding: EdgeInsets.fromLTRB(255, 150, 10, 10),
                        child: Text("새 신자",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ]),
                ]),
              ),
            ])));
  }
}
