import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class TakeSelfie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TakeSelfieState();
  }
}

class TakeSelfieState extends State<TakeSelfie> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var imagePath;

  void onCaptureButtonPressed(BuildContext context, GlobalKey key) async {
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        '${DateTime.now()}.jpg',
      );
      imagePath = path;
      await _controller.takePicture(path); //take photo

      ScopedModel.of<MyModel>(context).currentPhoto = new File(imagePath);

      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras[1];
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Current Photo',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Spacer(),
                Center(
                  child: Image.file(
                    File(imagePath),
                    scale: 2,
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/apply');
                      },
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
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Align(
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        onCaptureButtonPressed(context, key);
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
