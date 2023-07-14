import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
class ImageViewer extends StatefulWidget {
  final BuildContext context;
   ImageViewer({LocalKey? key, required this.context}): super(key: key);
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/ehrproj-406af.appspot.com/o/8831188673335771519729636284730893037.pdf?alt=media&token=48895a5e-8f43-4415-8bf3-e9e39405b6b0';
  
  Future<void> _fetchImage() async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      setState(() {
        // Update the URL to the fetched image
        imageUrl = response.body;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return Scaffold(
     
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
        // Do something when the back arrow is pressed.
         router.go('/welcomePatient');
          },
        ),
      ),
      
            SingleChildScrollView(
              child: Center(
                child: Image.network(imageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
