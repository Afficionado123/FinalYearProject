import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class PdfViewPage extends Page<dynamic> {
  final String pdfPath;
  // final BuildContext context;
  const PdfViewPage({LocalKey? key,required this.pdfPath}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return PdfViewScreen(pdfPath: pdfPath);
      },
    );
  }
}

class PdfViewScreen extends StatefulWidget {
  final String pdfPath;

  const PdfViewScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  late Future<String> _pdfPathFuture;

  @override
  void initState() {
    super.initState();
    _pdfPathFuture = loadPDF();
  }
Future<String> loadPDF() async {
  final decodedPath = Uri.decodeComponent(widget.pdfPath);
  print("Decoded path");
  print(decodedPath);
   final bytes = await rootBundle.load('assets/DocumentToBeSummarized.pdf');
   print('Bytes length: ${bytes.lengthInBytes}');
   print(bytes);
  try {
  final tempDir = await getTemporaryDirectory();
  final bytes = await rootBundle.load('assets/DocumentToBeSummarized.pdf');
  final buffer = bytes.buffer;
  final appDocDir = await getApplicationDocumentsDirectory();
final filePath = '${appDocDir.path}/filename.extension';
// await File(filePath).writeAsBytes(bytes);

   await File(filePath).writeAsBytes(buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

  // final file = await File('${tempDir.path}/$decodedPath').writeAsBytes(bytes.buffer.asUint8List());
  // final filePath = path.join(tempDir.path, decodedPath);
  // final file = await File(filePath).writeAsBytes(bytes.buffer.asUint8List());

  // print('File path: ${filePath}');
  return "fil";
} catch (e) {
  print('Error writing file: $e');
  return "ERROR"; // or handle the error accordingly
}

  // final tempDir = await getTemporaryDirectory();
  // final file = await File('${tempDir.path}/$decodedPath').writeAsBytes(bytes.buffer.asUint8List());
  
  // return file.path;
  //  return ;
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _pdfPathFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('PDF Viewer'),
            ),
            body: PDFView(
              filePath: snapshot.data!,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              onError: (e) {
                print(e);
              },
              onRender: (pages) {
                print('Rendered $pages pages');
              },
              onViewCreated: (PDFViewController vc) {},
              onPageChanged: (int? page, int? total) {},
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading PDF'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
