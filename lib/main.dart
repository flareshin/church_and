import 'package:church_and/CustomDrawer.dart';
import 'package:church_and/announcement_view.dart';
import 'package:church_and/get_church_introduction.dart';
import 'package:church_and/get_church_introduction_body.dart';
import 'package:church_and/get_subgroup_body.dart';
import 'package:church_and/get_subgroup_title.dart';
import 'package:church_and/navpages/calendar_page.dart';
import 'package:church_and/navpages/live_page.dart';
import 'package:church_and/navpages/more_page.dart';
import 'package:church_and/speech_view.dart';
import 'package:church_and/view_pdf.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Catholic home',
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today),
        title: ("Calendar"),
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.play_arrow),
        title: ("Live"),
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.more),
        title: ("More"),
        activeColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: [
          CatholicHome(),
          const CalendarPage(),
          const LivePage(),
          const MorePage(),
        ],
        items: _navBarsItems(),
        backgroundColor: Color(0xFF543d35),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}

class CatholicHome extends StatefulWidget {
  @override
  State<CatholicHome> createState() => _CatholicHomeState();
}

class _CatholicHomeState extends State<CatholicHome> {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF543d35),
          toolbarHeight: 86,
          centerTitle: false,
          title: Container(
              child: Column(
            children: [
              const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '맨하탄 아씨시의 성 프란치스코',
                    style: TextStyle(
                        color: Colors.white, fontFamily: "cafe", fontSize: 15),
                  )),
              Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '한인 천주교회',
                    style: TextStyle(
                        color: Colors.white, fontFamily: "cafe", fontSize: 15),
                  )),
            ],
          ))),
      drawer: CustomDrawer(),
      body: Container(
        color: Color(0xffe6d8d3),
        //child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.height * 1,

                    //ios
                    //height: MediaQuery.of(context).size.height * 0.168,

                    //android
                    height: MediaQuery.of(context).size.height * 0.156,
                    child: PageView(
                        scrollDirection: Axis.horizontal,
                        physics: const PageScrollPhysics(),
                        controller: PageController(viewportFraction: 1),
                        children: <Widget>[
                          Image.asset('assets/title_1.png'),
                          Image.asset('assets/title_2.png'),
                          Image.asset('assets/title_3.png'),
                          Image.asset('assets/title_4.png'),
                        ])),
                GridView.count(
                  padding: EdgeInsets.fromLTRB(25, 24, 25, 0),
                  shrinkWrap: true,
                  mainAxisSpacing: 23.0,
                  crossAxisSpacing: 23.0,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Stack(fit: StackFit.expand, children: <Widget>[
                      IconButton(
                          icon: Image.asset('assets/main_church.png'),
                          iconSize: 125,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => introductionView()));
                          }),
                      Column(children: <Widget>[
                        SizedBox(height: 100),
                        Align(
                            alignment: Alignment.center,
                            child: (Text("공동체 소개",
                                style: TextStyle(
                                    fontFamily: "cafe",
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))),
                      ])
                    ]),
                    Stack(fit: StackFit.expand, children: <Widget>[
                      IconButton(
                          icon: Image.asset('assets/main_speech.png'),
                          iconSize: 125,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SpeechView()));
                          }),
                      Column(children: <Widget>[
                        SizedBox(height: 100),
                        Align(
                            alignment: Alignment.center,
                            child: (Text("말 씀",
                                style: TextStyle(
                                    fontFamily: "cafe",
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))),
                      ]),
                    ]),
                    Stack(fit: StackFit.expand, children: <Widget>[
                      IconButton(
                          icon: Image.asset('assets/main_group.png'),
                          iconSize: 125,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupView()));
                          }),
                      Column(children: <Widget>[
                        SizedBox(height: 100),
                        Align(
                            alignment: Alignment.center,
                            child: (Text("단체방",
                                style: TextStyle(
                                    fontFamily: "cafe",
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))),
                      ]),
                    ]),
                    Stack(fit: StackFit.expand, children: <Widget>[
                      IconButton(
                          icon: Image.asset('assets/main_annoucement.png'),
                          iconSize: 125,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnnouncementView()));
                          }),
                      Column(children: <Widget>[
                        SizedBox(height: 100),
                        Align(
                            alignment: Alignment.center,
                            child: (Text("공지사항",
                                style: TextStyle(
                                    fontFamily: "cafe",
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))),
                      ])
                    ]),
                  ],
                ),
                Center(
                    child: Image.asset('assets/main_logo.png',
                        height: 80, width: 210)),
              ],
            ),
          ],
        ),
        //  ),
      ),
    );
  }
}

class GroupView extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color(0xFF543d35),
              toolbarHeight: 86,
              title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white, fontFamily: "cafe", fontSize: 22)),
              )),
          drawer: CustomDrawer(),
          body: Container(
            color: Color(0xffe6d8d3),
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              childAspectRatio: 2.9 / 2.2,
              //shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                Stack(fit: StackFit.expand, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group1.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView1()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("전례분과",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ])
                ]),
                Stack(fit: StackFit.expand, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group2.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView2()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("교육분과",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ])
                ]),
                Stack(fit: StackFit.passthrough, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group3.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView3()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("선교, 홍호분과",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ]),
                ]),
                Stack(fit: StackFit.expand, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group4.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView4()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("청년회",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ])
                ]),
                Stack(fit: StackFit.expand, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group5.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView5()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("연령회",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ])
                ]),
                Stack(fit: StackFit.expand, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group6.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView6()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("요셉회",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ])
                ]),
                Stack(fit: StackFit.expand, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group7.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView7()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("성모회",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ])
                ]),
                Stack(fit: StackFit.expand, children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/group8.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubGroupView8()));
                      }),
                  Column(children: <Widget>[
                    SizedBox(height: 80),
                    Align(
                        alignment: Alignment.center,
                        child: (Text("심신단체",
                            style: TextStyle(
                                fontFamily: "cafe",
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                  ])
                ]),
              ],
            ),
          ),
        ));
  }
}

class introductionView extends StatefulWidget {
  @override
  State<introductionView> createState() => _introductionViewState();
}

class _introductionViewState extends State<introductionView> {
  final pdfPinchController = PdfControllerPinch(
    document: PdfDocument.openAsset('assets/book.pdf'),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 38,
            backgroundColor: Color(0xFF543d35),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text('공동체 소개',
                  style: TextStyle(
                      color: Colors.white, fontFamily: "cafe", fontSize: 20)),
            ),
            bottom: TabBar(
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0x5Fbcb4a0)),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("공동체 소개",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("공동체 연혁",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("25주년 기념집",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("오시는 길",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
              color: Color(0xffe6d8d3),
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Image.asset('assets/introduction1.png')),
                  getChurchIntroductionBody('Intro'),
                  getChurchIntroduction('Intro'),
                ]),
              ),
            ),
            Container(
                color: Color(0xffe6d8d3),
                child: (Stack(children: <Widget>[
                  Row(children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffe6d8d3), child: Column()),
                        flex: 1),
                    Expanded(
                        child: Image.asset('assets/introduction2.png',
                            color: Colors.white.withOpacity(0.5),
                            colorBlendMode: BlendMode.modulate,
                            height: MediaQuery.of(context).size.height * 1,
                            fit: BoxFit.fill),
                        flex: 1),
                  ]),
                  SingleChildScrollView(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        SizedBox(width: 30),
                        Column(children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text("한인 공동체 연혁",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "cafe",
                                      fontSize: 13,
                                      color: Color(0xFF543d35)))),
                          SizedBox(height: 20),
                          Text("1997년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 25),
                          Text("1998년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 32),
                          Text("1999년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 31),
                          Text("2000년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 10),
                          Text("2001년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 33),
                          Text("2002년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 10),
                          Text("2003년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 22),
                          Text("2004년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 21),
                          Text("2005년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 20),
                          Text("2006년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 10),
                          Text("2007년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 22),
                          Text("2008년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 10),
                          Text("2010년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 32),
                          Text("2013년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 22),
                          Text("2014년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 29),
                          Text("2016년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 22),
                          Text("2017년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                          SizedBox(height: 22),
                          Text("2020년",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 11,
                                  color: Color(0xFF543d35))),
                        ]),
                        SizedBox(width: 10),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 52),
                              Text("03월 02일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("06월 15일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 15),
                              Text("02월 08일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("03월 29일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("09월 27일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("04월 24일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("05월 09일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("10월 03일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("03월 26일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("02월 25일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("08월 05일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("09월 05일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("12월 29일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("10월 20일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("11월 22일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("04월 04일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("08월 15일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("01월 31일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("12월 18일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("06월 03일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("01월 28일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("07월 30일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("02월 06일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("04월 10일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("09월 08일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("09월 24일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("05월 26일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("11월 24일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("05월 11일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("06월 26일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("11월 09일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("01월 02일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("02월 28일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("02월 26일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("05월 07일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("03월 15일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("07월 05일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("12월 09일",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                            ]),
                        SizedBox(width: 50),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 52),
                              Text("첫 미사",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("평신도 사도직 협의회 발족",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 15),
                              Text("연령회 발족",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("성모회 발족",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("레지오 마리애 'Pr.구세주의 모후' 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("신성길 니콜라오 신부님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("첫 바자회",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("청년회 발족",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("레지오 마리애 'Pr.바다의 별' 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("성소 후원회 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("김난희 요나 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("레지오 마리애 'Pr.바다의 별' 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("요셉회 발족",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("도재선 아델라 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("제 1회 사랑의 음악회",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("레지오 마리애 'Pr.구세주의 모후' 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("청년 레지오 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("은총의 샘 꾸리아 창단 회합",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("강현숙 아브라함 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("천상의 모후 쁘레시디움 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("김병두 베르나르도 신부님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("현인실 에피파니아 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("김상욱 요셉 신부님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("레지오 마리애 'Pr.우리 즐거움의 원천' 창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("김정숙 엠마 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("황지원 안드레아 신부님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("정경미 하상 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("레지오 마리에 'Pr.사랑의 샘'창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("조상연 스테파노 신부님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("레지오 마리에 'Pr.희망의 모후'창단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("권영순 레지나 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("김성인 미카엘 신부님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("한국학교 개교",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("한인 공동체 설립 20주년 미사",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("김도경 첼레스틴 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              SizedBox(height: 10),
                              Text("COVID-19로 인한 미사 중단",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("미사재개",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                              Text("김진열 가롤로 신부님, 박순호 티모테아 수녀님 부임",
                                  style: TextStyle(
                                      fontFamily: "cafe",
                                      fontSize: 11,
                                      color: Color(0xFF543d35))),
                            ]),
                      ]))
                ]))),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("AnniversaryFile")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        QueryDocumentSnapshot x = snapshot.data!.docs[i];
                        return Container(
                          color: Color(0xffe6d8d3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          loadPDF(url: x['fileURL'])));
                            },
                            child: Image.asset('assets/introduction3.png',
                                width: MediaQuery.of(context).devicePixelRatio *
                                    100,
                                fit: BoxFit.fill),
                          ),
                        );
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            // Container(
            //   color: Color(0xffe6d8d3),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => readPdf()));
            //     },
            //     child: Image.asset('assets/introduction3.png',
            //         width: MediaQuery.of(context).devicePixelRatio * 100,
            //         fit: BoxFit.fill),
            //   ),
            // ),
            Container(
              color: Color(0xffe6d8d3),
              child: Stack(children: <Widget>[
                Image.asset('assets/introduction4.png',
                    height: MediaQuery.of(context).size.height * 1,
                    fit: BoxFit.fill),
              ]),
            ),
          ]),
        ));
  }
}

class SubGroupView1 extends StatefulWidget {
  @override
  State<SubGroupView1> createState() => _SubGroupView1State();
}

class _SubGroupView1State extends State<SubGroupView1> {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("선교. 홍보분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(8),
                          childAspectRatio: 3.5 / 2,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,
                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  iconSize: 135,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  iconSize: 135,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  iconSize: 135,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class SubGroupView2 extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("선교. 홍호분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class SubGroupView3 extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("선교. 홍호분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class SubGroupView4 extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("선교. 홍호분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class SubGroupView5 extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("선교. 홍호분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class SubGroupView6 extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("선교. 홍호분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class SubGroupView7 extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("선교. 홍호분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class SubGroupView8 extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 46,
            backgroundColor: Color(0xFF543d35),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text('단체방',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "cafe",
                        fontSize: 20))),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0x5Fbcb4a0),
              ),
              isScrollable: true,
              tabs: [
                Tab(
                    child: Text("신심단체",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("전례분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("교육분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("선교. 홍호분과",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("청년회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("연령회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("요셉회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
                Tab(
                    child: Text("성모회",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "cafe",
                            fontSize: 13))),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(children: [
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup8'),
                                getSubGroupBody('subgroup8'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView14()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성령기도회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView15()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가정회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup4_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView16()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("학부모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup1'),
                                getSubGroupBody('subgroup1'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView1()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("제의실",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView2()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 전례부",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup1_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView3()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성가대",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup2'),
                                getSubGroupBody('subgroup2'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView4()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("예비자 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView5()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("견진 교리반",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView6()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("주일학교",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup2_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView7()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("봉사자",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup3'),
                                getSubGroupBody('subgroup3'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView8()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("양업회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView9()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("꾸리아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_3.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView10()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("울뜨레아",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup3_4.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView11()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("풍물패 신명",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup4'),
                                getSubGroupBody('subgroup4'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 3.5 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_1.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView12()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년성서모임",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/subgroup6_2.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView13()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("청년 찬양팀",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ])
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup5'),
                                getSubGroupBody('subgroup5'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group5.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView17()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("연령회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup6'),
                                getSubGroupBody('subgroup6'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group6.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView18()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("요셉회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
            Container(
                color: Color(0xffe6d8d3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: Color(0xffb1a09a),
                            child: Column(
                              children: [
                                getSubGroupTitle('subgroup7'),
                                getSubGroupBody('subgroup7'),
                              ],
                            )),
                        flex: 3),
                    Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: 3 / 2,

                          //shrinkWrap: true,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Stack(fit: StackFit.expand, children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/group7.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MinorGroupView19()));
                                  }),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                    child: (Text("성모회",
                                        style: TextStyle(
                                            fontFamily: "cafe",
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                              )
                            ]),
                          ],
                        ),
                        flex: 5),
                  ],
                )),
          ]),
        ));
  }
}

class MinorGroupView1 extends StatefulWidget {
  const MinorGroupView1({Key? key}) : super(key: key);

  @override
  State<MinorGroupView1> createState() => _MinorGroupView1State();
}

class _MinorGroupView1State extends State<MinorGroupView1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "제의실",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1YDIcy7EhtNhXrmEHA9tcNKW3GJeLjxUo?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView2 extends StatelessWidget {
  const MinorGroupView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "청년 전례부",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1IOwFBIlNiw2GZ8p76vTvyGJeV8Jj72Xl?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView3 extends StatelessWidget {
  const MinorGroupView3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "성가대",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/17sDxOuDCs4FFsXiN5l3iJZZ6mnSDOhlQ?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView4 extends StatelessWidget {
  const MinorGroupView4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "예비자 교리반",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1XieTpB-HBBzpmM-4DIITRhrf3Vwn_lpX?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView5 extends StatelessWidget {
  const MinorGroupView5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "견진 교리반",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1KLt5pQ6g71FyhaXpY0YvJrpNikc8SBKC?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView6 extends StatelessWidget {
  const MinorGroupView6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "주일학교",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1apUL0ypcm58b0hxpUXJLfxD4lU9gT0Zw?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView7 extends StatelessWidget {
  const MinorGroupView7({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "봉사자",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1jjewmjUB_SJH189iuUMEQPy9Js_Mzl_v?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView8 extends StatelessWidget {
  const MinorGroupView8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "양업회",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/15QCBM2MqTT6iPXtc0wi6oeLdmRO_XIrp?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView9 extends StatelessWidget {
  const MinorGroupView9({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "꾸리아",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1ROZZADWoR1qGC7fZbsQ0zr1pGFd-znBk?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView10 extends StatelessWidget {
  const MinorGroupView10({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "울뜨레아",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1an1xpg6uywOnth87bTvofK0ChalamiXI?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView11 extends StatelessWidget {
  const MinorGroupView11({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "풍물패 신명",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1fp-7DpmAqy6gw5ZMUOJ7iCRUG4R_oTOc?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView12 extends StatelessWidget {
  const MinorGroupView12({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "청년성서모임",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1dXRQzvHr0Q5-kp0eUhUXzdSMwbspcfZ3?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView13 extends StatelessWidget {
  const MinorGroupView13({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "청년 찬양팀",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1rPFQUvQgCE8kJ5x5cmnCtQJiDa3fOQUn?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView14 extends StatelessWidget {
  const MinorGroupView14({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "성령기도회",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1IOwFBIlNiw2GZ8p76vTvyGJeV8Jj72Xl?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView15 extends StatelessWidget {
  const MinorGroupView15({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "성가정회",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1XprcomzT5gTR_bIwo4_OFvZ7GofrPk15?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView16 extends StatelessWidget {
  const MinorGroupView16({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "학부모회",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/19vTq0QDUccwHJzGtcTgg6kjsZ9LdMKG2?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView17 extends StatelessWidget {
  const MinorGroupView17({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "연령회",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/17YJTk9oqFOFD74W6SoL93pmbDXNGY5eG?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView18 extends StatelessWidget {
  const MinorGroupView18({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "요셉회",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/12uYFPH_FDBRVQQKncuPIweTQ3I6YYvTp?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class MinorGroupView19 extends StatelessWidget {
  const MinorGroupView19({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "성모회",
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        body: WebView(
          initialUrl:
              'https://drive.google.com/drive/folders/1XA1TFhbxN8_AS15H7udInComkGZc59Nx?usp=sharing',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

class readPdf extends StatelessWidget {
  const readPdf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF543d35),
          title: Align(
            alignment: Alignment.centerRight,
            child: Text('25주년 책',
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 25)),
          ),
        ),
        drawer: CustomDrawer(),
        body: Container(
            color: Color(0xffe6d8d3),
            child: PdfViewPinch(
                controller: PdfControllerPinch(
                    document: PdfDocument.openAsset('assets/book.pdf')))));
  }
}
