import 'package:chatap/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:chatap/pages/pages.dart';

class CommonList extends StatefulWidget {
  const CommonList({super.key});

  @override
  State<CommonList> createState() => _CommonListState();
}

class _CommonListState extends State<CommonList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Transform.translate(
        offset: const Offset(-30, 0),
        child: const CircleAvatar(
          radius: 50,
          child: Icon(Icons.person),
        ),
      ),
      title: Transform.translate(
        offset: const Offset(-40, 0),
        child: const Text('Kumaran'),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      subtitle: Transform.translate(
        offset: const Offset(-40, 0),
        child: const Text('Hey.....'),
      ),
      trailing: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: const [
          Text('05.45 am'),
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColor.primaryColor,
            child: Text('1'),
          )
        ]),
      ),
    );
  }
}
