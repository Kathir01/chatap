import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatap/styles/styles.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cam}) : super(key: key);

  final List<CameraDescription>? cam;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController camController;
  bool CamSelected = true;

  @override
  void dispose() {
    camController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cam![0]);
  }

  Future takePicture() async {
    if (!camController.value.isInitialized) {
      return null;
    }
    if (camController.value.isTakingPicture) {
      return null;
    }
    try {
      await camController.setFlashMode(FlashMode.off);
    } on CameraException {
      return null;
    }
  }

  Future initCamera(CameraDescription cam) async {
    camController = CameraController(cam, ResolutionPreset.high);
    try {
      await camController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (camController.value.isInitialized)
            ? CameraPreview(camController)
            : Container(
                color: AppColor.primaryColor,
                child: const Center(child: CircularProgressIndicator())),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 130,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: AppColor.primaryColor),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      CamSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                      color: Colors.white),
                  onPressed: () {
                    setState(() => CamSelected = !CamSelected);
                    initCamera(widget.cam![CamSelected ? 0 : 1]);
                  },
                )),
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.circle, color: Colors.white),
                )),
                const Spacer(),
              ]),
            )),
      ]),
    ));
  }
}

class PreviewPage {}
