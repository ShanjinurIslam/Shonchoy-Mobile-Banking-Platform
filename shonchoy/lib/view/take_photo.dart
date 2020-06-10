import 'dart:io';
import 'package:image/image.dart' as DartImage;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePhoto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TakePhotoState();
  }
}

class TakePhotoState extends State<TakePhoto> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var imagePath;

  void onCaptureButtonPressed(GlobalKey key) async {
    //on camera button press
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        '${DateTime.now()}.png',
      );
      imagePath = path;
      await _controller.takePicture(path); //take photo

      RenderBox box = key.currentContext.findRenderObject();
      Offset position = box.localToGlobal(Offset.zero);
      var image = DartImage.decodeImage(File(imagePath).readAsBytesSync());
      var rotate = DartImage.copyRotate(image, 90);
      var cropped = DartImage.copyCrop(
          rotate, position.dx.toInt(), position.dy.toInt(), 700, 500);
      File(imagePath)..writeAsBytesSync(DartImage.encodePng(cropped));

      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    GlobalKey key = GlobalKey();
    return Scaffold(
      backgroundColor: Colors.black,
      body: showCapturedPhoto
          ? SafeArea(
              child: Center(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Center(
                  child: Image.file(
                    File(imagePath),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            showCapturedPhoto = false;
                          });
                        },
                        child: Text(
                          'Retake',
                          style: TextStyle(color: Colors.white),
                        )),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            )))
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return Transform.scale(
                      scale: _controller.value.aspectRatio / deviceRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            children: <Widget>[
                              CameraPreview(_controller),
                              Align(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      key: key,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width:
                                              1, //                   <--- border width here
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 200,
                                      width: MediaQuery.of(context).size.width *
                                          .75,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Place ID inside this frame',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                              ),
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Align(
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        onCaptureButtonPressed(key);
                                      },
                                      child: Icon(CupertinoIcons.photo_camera)),
                                  alignment: Alignment.bottomCenter,
                                ),
                              )
                            ],
                          ), //cameraPreview
                        ),
                      ));
                } else {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Otherwise, display a loading indicator.
                }
              },
            ),
    );
  }
}
