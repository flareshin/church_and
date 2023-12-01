import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin

import 'package:cloud_firestore/cloud_firestore.dart';

class getSubGroupTitle extends StatelessWidget {
  final String subgroupId;

  getSubGroupTitle(this.subgroupId);

  @override
  Widget build(BuildContext context) {
    CollectionReference subgroups =
        FirebaseFirestore.instance.collection('Group');

    return FutureBuilder<DocumentSnapshot>(
      future: subgroups.doc(subgroupId).get(),
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
              padding: EdgeInsets.fromLTRB(0,30, 0, 5),
              child: Text("${data['title']}",

                  style: TextStyle(
                      fontFamily: "cafe", fontSize: 14,
                      color: Color(0xFF543d35),
                      fontWeight: FontWeight.bold)));
        }

        return Text("loading");
      },
    );
  }
}
