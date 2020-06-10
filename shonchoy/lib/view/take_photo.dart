import 'dart:io';

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

  void onCaptureButtonPressed() async {
    //on camera button press
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        '${DateTime.now()}.png',
      );
      imagePath = path;
      await _controller.takePicture(path); //take photo

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

    return Scaffold(
      body: showCapturedPhoto
          ? Center(child: Image.file(File(imagePath)))
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
                                        onCaptureButtonPressed();
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
