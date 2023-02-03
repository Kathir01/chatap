import 'package:camera/camera.dart';
import 'package:chatap/styles/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chatap/common_widgets/common_widgets.dart';
import 'package:chatap/services/services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  TextEditingController userMessageController = TextEditingController();
  final userIdController = '0';
  late DatabaseReference ref;

  final FirebaseMessaging fbm = FirebaseMessaging.instance;
  final ScrollController _scrollController = ScrollController();
  late CameraController _cameraController;
  changeData(String mes) => setState(() => notificationData = mes);
  changeBody(String mes) => setState(() => notificationBody = mes);
  changeTitle(String mes) => setState(() => notificationTitle = mes);

  @override
  void initState() {
    super.initState();

    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.stream.stream.listen(changeData);
    firebaseMessaging.body.stream.listen(changeBody);
    firebaseMessaging.title.stream.listen(changeTitle);

    ref = FirebaseDatabase.instance.ref().child('donechat');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 10,
              ),
              Text('Kumaran')
            ],
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.call),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.videocam),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.more_vert),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Scrollbar(
                thickness: 5,
                child: FirebaseAnimatedList(
                  controller: _scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  query: ref,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map value = snapshot.value as Map;

                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: (value['id'].toString() == "1"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: (value['id'].toString() == "1"
                                ? Colors.grey.shade200
                                : BoxColor.tritaryColor),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            value['mes'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Row(
                      children: [
                        const CommonButton(icons: Icons.emoji_emotions),
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: userMessageController,
                            decoration: const InputDecoration.collapsed(
                                hintText: "Message Here...",
                                hintStyle:
                                    TextStyle(color: BoxColor.primaryColor),
                                border: InputBorder.none),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () async {
                              await availableCameras().then((value) =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CameraPage(cam: value))));
                            }),
                        const CommonButton(icons: Icons.attach_file)
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: AppColor.secondaryColor,
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent,
                            );
                          } else {
                            // ignore: avoid_returning_null_for_void
                            setState(() => null);
                          }
                        });

                        setState(() {
                          Map<String, String> suser = {
                            'id': userIdController,
                            'mes': userMessageController.text,
                          };
                          ref.push().set(suser);
                          userMessageController.clear();
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
