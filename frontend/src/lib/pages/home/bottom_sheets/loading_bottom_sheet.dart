import 'dart:convert';

import 'package:TonalCreamAssistant/models/color.dart';
import 'package:animated_check/animated_check.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:image_picker/image_picker.dart';

import 'base_bottom_sheet.dart';

class LoadingBottomSheet extends StatefulWidget {
  final String host;
  final Function(ColorRead) notifyParent;
  final XFile image;

  const LoadingBottomSheet(
      {Key? key,
      required this.image,
      required this.notifyParent,
      required this.host})
      : super(key: key);

  @override
  State<LoadingBottomSheet> createState() => _LoadingBottomSheetState();
}

class _LoadingBottomSheetState extends State<LoadingBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late final String url;

  @override
  void initState() {
    super.initState();
    url = "${widget.host}/api/cv/v2/skin_tone_mediapipe";
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
  }

  Future<Response<String>> sendPhoto() async {
    Dio dio = Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    final bytes = await widget.image.readAsBytes();
    FormData formData = FormData.fromMap(
        {'image': MultipartFile.fromBytes(bytes, filename: 'image.jpg')});
    return dio.post(url, data: formData);
  }

  List<Widget> errorProcessing(DioError error) {
    List<Widget> children = [];
    if (error.response?.statusCode == 400) {
      FlutterLogs.logInfo(
          "Error", "Error sending image on server", "No face on the image!");
      children.add(Text(
        "No face on the image!",
        style: Theme.of(context).textTheme.caption,
      ));
    } else {
      FlutterLogs.logInfo(
          "Error", "Error sending image on server", "Unknown error!");
      children.add(Text(
        "Unknown error!",
        style: Theme.of(context).textTheme.headline5!.copyWith(
            color: Theme.of(context).errorColor, fontWeight: FontWeight.bold),
      ));
    }
    return children;
  }

  List<Widget> dataProcessing(Response<String> data) {
    ColorRead dataColor = ColorRead.fromJson(json.decode(data.toString()));
    List<Widget> children = [];
    children.add(AnimatedCheck(
      progress: _animation,
      color: Theme.of(context).primaryColor,
      size: 200,
      strokeWidth: 10,
    ));

    _controller.forward().whenComplete(() {
      widget.notifyParent(dataColor);
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sendPhoto(),
        builder: (context, asyncSnapshot) {
          List<Widget> children = <Widget>[];
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.none:
              children.add(const CircularProgressIndicator());
              break;
            case ConnectionState.done:
              if (asyncSnapshot.hasError) {
                children = errorProcessing(asyncSnapshot.error as DioError);
                break;
              }
              if (asyncSnapshot.hasData) {
                FlutterLogs.logInfo(
                    "Info", "Sending image to server", "Result: SUCCESS");
                children =
                    dataProcessing(asyncSnapshot.data as Response<String>);
                break;
              } else {
                FlutterLogs.logInfo("Error", "Error sending image on server",
                    "Server didn't send response :(");
                children.add(Text(
                  "Server didn't send response :(",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Theme.of(context).errorColor),
                ));
                break;
              }
          }
          return BaseBottomSheet(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ));
        });
  }
}
