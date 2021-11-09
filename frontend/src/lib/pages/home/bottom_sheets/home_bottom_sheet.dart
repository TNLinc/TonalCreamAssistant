import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'base_bottom_sheet.dart';

class HomeBottomSheet extends StatefulWidget {
  final Function(XFile?) notifyParent;
  final XFile? initImage;

  const HomeBottomSheet({Key? key, required this.notifyParent, this.initImage})
      : super(key: key);

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet>
    with WidgetsBindingObserver {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription>? cameras;
  CameraController? controller;
  Future? _future;

  @override
  void initState() {
    super.initState();
    _image = widget.initImage;
    _future = getCameras();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _future = controller?.initialize();
    }
  }

  getCameras() async {
    cameras = await availableCameras();
    controller = CameraController(
        kIsWeb
            ? cameras!.first
            : cameras!.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.max);
    await controller?.initialize();
  }

  _getImageGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    if (image != null) {
      widget.notifyParent(image);
    }
  }

  _getImageCamera() async {
    // If already have image (Take another button)
    if (_image != null) {
      setState(() {
        _future = controller?.initialize();
        _image = null;
      });
    } else {
      final image = await controller?.takePicture();
      setState(() {
        _image = image;
      });
    }

    widget.notifyParent(_image);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
        child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
            future: _future,
            builder: (context, asyncSnapshot) {
              switch (asyncSnapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                case ConnectionState.done:
                  if (_image != null) {
                    return ImagePreview(image: _image!);
                  }
                  if (!asyncSnapshot.hasError &&
                      controller!.value.isInitialized) {
                    // Has camera access
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: CameraPreview(controller!),
                        ),
                      ),
                    );
                  } else {
                    // Moc icon
                    return const Icon(Icons.add_photo_alternate);
                  }
              }
            }),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomSheetButton(
                  icon: Icons.add_photo_alternate,
                  text: 'Gallery',
                  onPressed: _getImageGallery),
              BottomSheetButton(
                  icon: _image == null ? Icons.camera : Icons.repeat,
                  text: _image == null ? "Camera" : "Take another",
                  onPressed: _getImageCamera),
            ],
          ),
        ),
      ],
    ));
  }
}

class ImagePreview extends StatelessWidget {
  final XFile image;

  const ImagePreview({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 5),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Container(
                //If we don't chose the image
                color: Theme.of(context).disabledColor,
                child: kIsWeb
                    ?
                    // If web platform
                    Image.network(
                        image.path,
                        fit: BoxFit.fitHeight,
                      )
                    :
                    // If android platform
                    Image.file(
                        File(image.path),
                        fit: BoxFit.fitHeight,
                      ))),
      ),
    );
  }
}

class BottomSheetButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final IconData icon;

  const BottomSheetButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ElevatedButton.icon(
          icon: Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
          ),
          label: Text(
            text,
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
