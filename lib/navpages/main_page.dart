import 'package:church_and/navpages/more_page.dart';
import 'package:church_and/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List pages = [
    CatholicHome(),
    Container(),
    Container(),
    MorePage(),
  ];

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      if (index == 1) {
        launch('https://calendar.google.com/calendar/u/0/r');
        currentIndex = 0;
      } else if (index == 2) {
        launch('https://www.youtube.com/channel/UC1bATOvNkBAa0pKeH4UBW1Q');
        currentIndex = 0;
      } else {
        currentIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF543d35),
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF543d35),
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF543d35),
            icon: Icon(Icons.youtube_searched_for),
            label: "Live",
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF543d35),
            icon: Icon(Icons.more),
            label: "More",
          ),
        ],
      ),
    );
  }
}
