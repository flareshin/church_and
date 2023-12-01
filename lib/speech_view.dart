import 'package:church_and/CustomDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class SpeechView extends StatelessWidget {
  const SpeechView({Key? key}) : super(key: key);
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
          toolbarHeight: 86,
          backgroundColor: Color(0xFF543d35),
          centerTitle: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '말 씀',
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 22),
              )),
        ),
        drawer: CustomDrawer(),
        body: Container(
          color: Color(0xffe6d8d3),
          child: GridView.count(
            childAspectRatio: 4.1 / 2,
            shrinkWrap: true,
            mainAxisSpacing: 1.0,
            crossAxisCount: 1,
            children: <Widget>[
              Stack(fit: StackFit.expand, children: <Widget>[
                IconButton(
                    icon: Image.asset('assets/speach1.png'),
                    iconSize: 150,
                    onPressed: () {
                      const url = 'http://mobile2.catholic.or.kr/web/bible/';
                      launchURL(url);
                    }),
                Column(children: <Widget>[
                  SizedBox(height: 110),
                  Align(
                      alignment: Alignment.center,
                      child: (Text("성경",
                          style: TextStyle(
                              fontFamily: "cafe",
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
                ])
              ]),
              Stack(fit: StackFit.expand, children: <Widget>[
                IconButton(
                    icon: Image.asset('assets/speach2.png'),
                    iconSize: 150,
                    onPressed: () {
                      const url =
                          'http://mobile2.catholic.or.kr/web/divine_office/';
                      launchURL(url);
                    }),
                Column(children: <Widget>[
                  SizedBox(height: 110),
                  Align(
                      alignment: Alignment.center,
                      child: (Text("성무일도",
                          style: TextStyle(
                              fontFamily: "cafe",
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
                ])
              ]),
              Stack(fit: StackFit.expand, children: <Widget>[
                IconButton(
                    icon: Image.asset('assets/speach3.png'),
                    iconSize: 150,
                    onPressed: () {
                      const url = 'http://mobile2.catholic.or.kr/web/prayer/';
                      launchURL(url);
                    }),
                Column(children: <Widget>[
                  SizedBox(height: 110),
                  Align(
                      alignment: Alignment.center,
                      child: (Text("가톨릭 기도서",
                          style: TextStyle(
                              fontFamily: "cafe",
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
                ])
              ]),
              Stack(fit: StackFit.expand, children: <Widget>[
                IconButton(
                    icon: Image.asset('assets/speach4.png'),
                    iconSize: 150,
                    onPressed: () {
                      const url = 'http://mobile2.catholic.or.kr/web/sungga/';
                      launchURL(url);
                    }),
                Column(children: <Widget>[
                  SizedBox(height: 110),
                  Align(
                      alignment: Alignment.center,
                      child: (Text("가톨릭 성가",
                          style: TextStyle(
                              fontFamily: "cafe",
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
                ])
              ]),
            ],
          ),
        ));
  }
}
