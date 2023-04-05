import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyModal extends StatelessWidget {
  final String title;
  final String content;
  final GoRouter router;

  const MyModal({Key? key, required this.title, required this.content, required this.router})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    router.pop(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
            Center(
              child: Column(
                children: [
                  Text(content),
                  Icon(Icons.check, color: Colors.green)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
