import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class getChurchIntroductionBody extends StatelessWidget {
  final String introId;

  getChurchIntroductionBody(this.introId);

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
          return Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: Text("${data['title']}",
                  style: TextStyle(
                      fontFamily: "cafe",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)));
        }

        return Text("loading");
      },
    );
  }
}
