import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;


class PdfStorage{
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadPdfFile(
      String filePath,
      String fileName
      ) async{
    File file = File(filePath);
    try{
      await storage.ref('주보/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listPdfFiles() async{
    firebase_storage.ListResult results = await storage.ref('주보').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return results;
}

  Future<String> downloadPdfURL(String pdfName) async {
    String downloadPdfURL = await storage.ref('주보/$pdfName').getDownloadURL();

    return downloadPdfURL;
  }

}