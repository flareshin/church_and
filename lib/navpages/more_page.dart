import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:church_and/CustomDrawer.dart';
import 'package:church_and/navpages/Text_field.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);
  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final _formKey = GlobalKey<FormState>();
  bool _enableBtn = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // DefaultTabController(
        // length: 2,
        // child:
        Scaffold(
            appBar: AppBar(
              toolbarHeight: 86,
              backgroundColor: Color(0xFF543d35),
              centerTitle: false,
              title: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '문의사항',
                    style: TextStyle(
                        color: Colors.white, fontFamily: "cafe", fontSize: 22),
                  )),
            ),
            drawer: CustomDrawer(),
            body: Container(
                color: Color(0xffe6d8d3),
                child: Column(children: <Widget>[
                  Form(
                    key: _formKey,
                    onChanged: (() {
                      setState(() {
                        _enableBtn = _formKey.currentState!.validate();
                      });
                    }),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFields(
                              controller: subjectController,
                              name: "Subject",
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              })),
                          TextFields(
                              controller: emailController,
                              name: "Email",
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                } else if (!value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              })),
                          TextFields(
                              controller: messageController,
                              name: "Message",
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  // setState(() {
                                  //   _enableBtn = true;
                                  // });
                                  return 'Message is required';
                                }
                                return null;
                              }),
                              maxLines: null,
                              type: TextInputType.multiline),
                          Padding(
                              padding: EdgeInsets.all(20.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5);
                                        else if (states
                                            .contains(MaterialState.disabled))
                                          return Colors.grey;
                                        return Colors
                                            .blue; // Use the component's default.
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ))),
                                onPressed: _enableBtn
                                    ? (() async {
                                        final Email email = Email(
                                          body: messageController.text,
                                          subject: subjectController.text,
                                          recipients: ["stfranciskr@gmail.com"],
                                          isHTML: false,
                                        );
                                        await FlutterEmailSender.send(email);
                                      })
                                    : null,
                                child: Text('Submit'),
                              )),
                        ],
                      ),
                    ),
                  ),
                ]))
            // ]
            // )
            // ),
            );
  }
}
