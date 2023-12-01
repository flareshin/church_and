// import 'dart:typed_data';
// import 'package:church_and/models/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:church_and/models/User.dart';
// import 'package:church_and/providers/user_provider.dart';
// import 'package:church_and/utils/colors.dart';
// import 'package:church_and/utils/utils.dart';
// import 'package:provider/provider.dart';
// import '../resources/firestore_methods.dart';

// class AddPostScreen extends StatefulWidget {
//   AddPostScreen({Key? key}) : super(key: key);

//   @override
//   State<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//   Uint8List? _file;
//   final TextEditingController _descriptionController = TextEditingController();
//   bool _isLoading = false;
//   String username = "";
//   String uid = "";

//   void getUser() async {
//     DocumentSnapshot snap = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();

//     setState(() {
//       username = (snap.data() as Map<String, dynamic>)['username'];
//       uid = (snap.data() as Map<String, dynamic>)['uid'];
//       print(s);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUser();
//   }

//   _selectImage(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return SimpleDialog(
//             title: const Text('Create a Post'),
//             children: [
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Choose from gallery'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   Uint8List file = await pickImage(
//                     ImageSource.gallery,
//                   );
//                   setState(() {
//                     _file = file;
//                   });
//                 },
//               ),
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   void postImage(String uid, String username) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       String response = await FirestoreMethods().uploadPost(
//           _descriptionController.text, _file!, uid, username, minigroup);
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//       });
//       if (response == "Post is successfully created") {
//         showSnackbar(response, context);
//       } else {
//         showSnackbar(response, context);
//       }
//       clearImage();
//     } catch (err) {
//       showSnackbar(err.toString(), context);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   void clearImage() {
//     setState(() {
//       _file = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final UserProvider userProvider = Provider.of<UserProvider>(context);
//     // String uid = userProvider.getUser.uid;
//     // String username = userProvider.getUser.username;

//     return _file == null
//         ? Center(
//             child: IconButton(
//               icon: const Icon(
//                 Icons.upload,
//               ),
//               onPressed: () => _selectImage(context),
//             ),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: mobileBackgroundColor,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: clearImage,
//               ),
//               title: const Text(
//                 'Post to',
//               ),
//               centerTitle: false,
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => postImage(uid, username),
//                   child: const Text(
//                     "Post",
//                     style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0),
//                   ),
//                 )
//               ],
//             ),
//             // POST FORM
//             body: Column(
//               children: <Widget>[
//                 _isLoading
//                     ? const LinearProgressIndicator()
//                     : const Padding(padding: EdgeInsets.only(top: 0.0)),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: TextField(
//                         controller: _descriptionController,
//                         decoration: const InputDecoration(
//                             hintText: "Write a caption...",
//                             border: InputBorder.none),
//                         maxLines: 8,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 45.0,
//                       width: 45.0,
//                       child: AspectRatio(
//                         aspectRatio: 487 / 451,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                             fit: BoxFit.fill,
//                             alignment: FractionalOffset.topCenter,
//                             image: MemoryImage(_file!),
//                           )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//               ],
//             ),
//           );
//   }
// }
