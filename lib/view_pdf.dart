import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class loadPDF extends StatelessWidget {
  final url;

  loadPDF({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 38,
          backgroundColor: Color(0xFF543d35),
          title: Align(
            alignment: Alignment.centerRight,
            child: Text('PDF',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        body: PdfViewPinch(
            controller: PdfControllerPinch(
                document: PdfDocument.openData(InternetFile.get(url)))));
  }
}
