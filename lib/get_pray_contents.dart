import 'package:church_and/CustomDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class getPrayContents extends StatelessWidget {
  final String prayContents;

  getPrayContents(this.prayContents);

  @override
  Widget build(BuildContext context) {
    CollectionReference groups =
        FirebaseFirestore.instance.collection('PrayContents');
    print(prayContents);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 38,
          backgroundColor: Color(0xFF543d35),
          title: Padding(
            padding: EdgeInsets.only(
              left: 150,
            ),
            child: Text('기도해주세요',
                style: TextStyle(
                    color: Colors.white, fontFamily: "cafe", fontSize: 20)),
          ),
        ),
        drawer: CustomDrawer(),
        body: Container(
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
                            fontFamily: "cafe",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ]),
              FutureBuilder<DocumentSnapshot>(
                future: groups.doc("$prayContents").get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                        child: Column(children: [
                          Text("${data['Title']}",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 30,
                                  color: Color(0xFF543d35),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 20),
                          Text("${data['body']}",
                              style: TextStyle(
                                  fontFamily: "cafe",
                                  fontSize: 20,
                                  color: Color(0xFF543d35)))
                        ]));
                  }
                  return Text("loading");
                },
              )
            ])));
  }
}

// print("${data['Title']}");
//           print("${data['body']}");
