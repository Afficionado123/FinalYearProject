import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContentsOfList {
  String title;
  IconData image;
  ContentsOfList(this.title, this.image);
}

class MyList extends StatelessWidget {
  final String title;
  final String content;
  final GoRouter router;

  const MyList({Key? key, required this.title, required this.content, required this.router})
      : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final List<ContentsOfList> infoBank = [
      ContentsOfList("Arun S", Icons.person),
      ContentsOfList("Anita P", Icons.person),
    ];
  
    return Expanded(
      child: ListView.separated(
        itemCount: infoBank.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return Text("Dd");
        },
      ),
    );
  }
}

class MyListItem extends StatelessWidget {
  final String title;
  final IconData image;
  final VoidCallback onViewRecordPressed;
  final VoidCallback onViewSummaryPressed;

  const MyListItem({
    Key? key,
    required this.title,
    required this.image,
    required this.onViewRecordPressed,
    required this.onViewSummaryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(image),
          title: Text(title),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onViewRecordPressed,
              child: Text('View all Records'),
            ),
            SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: onViewSummaryPressed,
              child: Text('View Summary'),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
class MyListItemPatientWelcome extends StatelessWidget {
  final String title;
  final IconData image;
  final VoidCallback onViewRecordPressed;
  final VoidCallback onViewSummaryPressed;

  const MyListItemPatientWelcome({
    Key? key,
    required this.title,
    required this.image,
    required this.onViewRecordPressed,
    required this.onViewSummaryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(image),
          title: Text(title),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onViewRecordPressed,
              child: Text('View Record'),
            ),
            SizedBox(width: 8.0),
            
          ],
        ),
        Divider(),
      ],
    );
  }
}