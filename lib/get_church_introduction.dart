import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class getChurchIntroduction extends StatelessWidget {
  final String introId;

  getChurchIntroduction(this.introId);

  @override
  Widget build(BuildContext context) {
    CollectionReference subgroups =
        FirebaseFirestore.instance.collection('Intro');

    return FutureBuilder<DocumentSnapshot>(
      future: subgroups.doc(introId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(45, 20, 45, 10),
                      child: Text("${data['body']}",
                          style: TextStyle(fontFamily: "cafe", fontSize: 12))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
                      child: Text("${data['body2']}",
                          style: TextStyle(fontFamily: "cafe", fontSize: 12))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
                      child: Text("${data['body3']}",
                          style: TextStyle(fontFamily: "cafe", fontSize: 12))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
                      child: Text("${data['body4']}",
                          style: TextStyle(fontFamily: "cafe", fontSize: 12)))
                ],
              ));
        }

        return Text("loading");
      },
    );
  }
}
