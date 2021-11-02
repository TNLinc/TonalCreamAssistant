import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'base_bottom_sheet.dart';

class HomeBottomSheet extends StatefulWidget {
  final Function(XFile) notifyParent;
  final XFile? initImage;

  const HomeBottomSheet({Key? key, required this.notifyParent, this.initImage})
      : super(key: key);

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  CameraController? controller;

  getCameraController(CameraController? controller) {
    this.controller = controller;
  }

  @override
  void initState() {
    super.initState();
    _image = widget.initImage;
  }

  getImageGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    if (image != null) {
      widget.notifyParent(image);
    }
  }

  getImageCamera() async {
    // If already have image (Take another button)
    if (_image != null) {
      setState(() {
        _image = null;
      });
      return;
    }

    final image = await controller?.takePicture();
    setState(() {
      _image = image;
    });

    if (image != null) {
      widget.notifyParent(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ImagePreview(image: _image, notifyParent: getCameraController),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomSheetButton(
                  icon: Icons.add_photo_alternate,
                  text: 'Gallery',
                  onPressed: getImageGallery),
              BottomSheetButton(
                  icon: _image == null ? Icons.camera : Icons.repeat,
                  text: _image == null ? "Camera" : "Take another",
                  onPressed: getImageCamera),
            ],
          ),
        ),
      ],
    ));
  }
}

class ImagePreview extends StatefulWidget {
  final XFile? image;
  final Function(CameraController?) notifyParent;

  const ImagePreview({Key? key, this.image, required this.notifyParent})
      : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  List<CameraDescription>? cameras;
  CameraController? controller;

  getCameras() async {
    cameras = await availableCameras();
    controller = CameraController(
        kIsWeb
            ? cameras!.first
            : cameras!.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.high);
    await controller?.initialize();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCameras(),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Flexible(
                  child: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
              widget.notifyParent(controller);

              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8, right: 8, bottom: 5),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: Container(
                        //If we don't chose the image
                        color: Theme.of(context).disabledColor,
                        child:
                            // If has image
                            widget.image != null
                                ? kIsWeb
                                    // If web platform
                                    ? Image.network(
                                        widget.image!.path,
                                        fit: BoxFit.fitHeight,
                                      )
                                    :
                                    // If android platform
                                    Image.file(
                                        File(widget.image!.path),
                                        fit: BoxFit.fitHeight,
                                      )
                                :
                                // If don't have image enable camera
                                !asyncSnapshot.hasError &&
                                        controller!.value.isInitialized
                                    ? Center(
                                        // Has camera access
                                        child: Flexible(
                                            child: CameraPreview(controller!)),
                                      )
                                    :
                                    // Moc icon
                                    const Icon(Icons.add_photo_alternate)),
                  ),
                ),
              );
          }
        });
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
