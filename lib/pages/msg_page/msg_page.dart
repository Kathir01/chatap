import 'package:flutter/material.dart';
import 'package:chatap/common_widgets/common_widgets.dart';
import 'package:chatap/styles/styles.dart';

class MsgPage extends StatefulWidget {
  const MsgPage({super.key});

  @override
  State<MsgPage> createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: const Text('Chats'),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.search),
            )
          ],
          bottom: const TabBar(
              indicatorColor: AppColor.secondaryColor,
              tabs: [Tab(text: 'Message'), Tab(text: 'Status')]),
        ),
        body: ListView(
          shrinkWrap: true,
          children: const <Widget>[
            CommonList(),
            CommonList(),
            CommonList(),
            CommonList(),
            CommonList(),
            CommonList(),
          ],
        ),
      ),
    );
  }
}
