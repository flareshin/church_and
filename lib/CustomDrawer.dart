import 'package:church_and/screens/signin.dart';
import 'package:church_and/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:church_and/main.dart';
import 'package:church_and/announcement_view.dart';
import 'package:church_and/speech_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      const DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xffe6d8d3),
          ),
          child: Text('Menu')),
      CustomListTile(
          Icons.home,
          '메인 메뉴',
          () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CatholicHome()))
              }),
      CustomListTile(Icons.key, 'Sign in', () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }),
      CustomListTile(
          Icons.church,
          '공동체 소개',
          () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => introductionView()))
              }),
      CustomListTile(
          Icons.chrome_reader_mode,
          '말씀',
          () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SpeechView()))
              }),
      CustomListTile(
          Icons.insert_photo_rounded,
          '단체방',
          () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GroupView()))
              }),
      CustomListTile(
          Icons.announcement,
          '공지사항',
          () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnnouncementView()))
              }),
    ]));
  }
}
