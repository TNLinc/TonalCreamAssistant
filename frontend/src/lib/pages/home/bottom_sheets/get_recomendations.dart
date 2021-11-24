import 'dart:convert';
import 'package:animated_check/animated_check.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base_bottom_sheet.dart';

class GetRecomendations extends StatefulWidget {
  final String host;
  final Function(Map<String, dynamic>) notifyParent;
  final String data;
  final int limit;
  final int offset;

  const GetRecomendations(
      {Key? key,
      required this.data,
      required this.notifyParent,
      required this.host,
      required this.limit,
      required this.offset})
      : super(key: key);

  @override
  State<GetRecomendations> createState() => _GetRecomendations();
}

class _GetRecomendations extends State<GetRecomendations>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late final String url;

  @override
  void initState() {
    super.initState();
    url = "${widget.host}/api/vendor/v1/products/limit-offset/";
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
  }

  Future<Response<String>> sendPhoto() async {
    Dio dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    return dio.get(url, queryParameters: {
      "color": widget.data,
      "limit": widget.limit,
      "offset": widget.offset
    });
  }

  List<Widget> errorProcessing(DioError error) {
    List<Widget> children = [];
    if (error.response?.statusCode == 422) {
      children.add(Text(
        "Validation Error!",
        style: Theme.of(context).textTheme.caption,
      ));
    } else {
      children.add(Text(
        "Unknown error!",
        style: Theme.of(context).textTheme.headline5!.copyWith(
            color: Theme.of(context).errorColor, fontWeight: FontWeight.bold),
      ));
    }
    return children;
  }

  List<Widget> dataProcessing(Response<String> data) {
    Map<String, dynamic> responseJson = json.decode(data.toString());

    List<Widget> children = [];
    children.add(AnimatedCheck(
      progress: _animation,
      color: Theme.of(context).primaryColor,
      size: 200,
      strokeWidth: 10,
    ));

    _controller.forward().whenComplete(() {
      widget.notifyParent(responseJson);
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
                children =
                    dataProcessing(asyncSnapshot.data as Response<String>);
                break;
              } else {
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
