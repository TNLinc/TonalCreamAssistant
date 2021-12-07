import 'dart:convert';

import 'package:TonalCreamAssistant/models/product.dart';
import 'package:TonalCreamAssistant/pages/home/components/product_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

class RecommendationList extends StatefulWidget {
  final String color;
  final String host;

  const RecommendationList({Key? key, required this.color, required this.host})
      : super(key: key);

  @override
  _RecommendationListState createState() => _RecommendationListState();
}

class _RecommendationListState extends State<RecommendationList> {
  List<ProductRead>? _products;
  final ScrollController _scrollController = ScrollController();
  Future<Response<String>>? _future;
  late final String url;

  @override
  void initState() {
    super.initState();
    url = "${widget.host}/api/vendor/v1/products/default/";
    _future = getRecommendations();
  }

  Future<Response<String>> getRecommendations() async {
    Dio dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    return dio.get(url,
        queryParameters: {"color": widget.color, "page": 1, "size": 15});
  }

  List<Widget> errorProcessing(DioError error) {
    List<Widget> children = [];
    if (error.response?.statusCode == 422) {
      FlutterLogs.logInfo("Error", "Error getting recommendations products",
          "Validation Error!");
      children.add(Text(
        "Validation Error!",
        style: Theme.of(context).textTheme.headline5!.copyWith(
            color: Theme.of(context).errorColor, fontWeight: FontWeight.bold),
      ));
    } else {
      FlutterLogs.logInfo(
          "Error", "Error getting recommendations products", "Unknown error!");
      children.add(Text(
        "Unknown error!",
        style: Theme.of(context).textTheme.headline5!.copyWith(
            color: Theme.of(context).errorColor, fontWeight: FontWeight.bold),
      ));
    }
    return children;
  }

  List<Widget> dataProcessing(Response<String> data) {
    List<Widget> children = [];
    _products = json
        .decode(data.toString())['items']
        .map<ProductRead>((e) => ProductRead.fromJson(e))
        .toList();

    children.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _products!.length,
              itemBuilder: (context, index) {
                ProductRead product = _products![index];
                return ProductCard(name: product.name, color: product.color);
              }),
        ),
      ),
    ));
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          List<Widget> children = <Widget>[];
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              children.add(const Center(child: CircularProgressIndicator()));
              break;

            case ConnectionState.done:
              if (snapshot.hasError) {
                children = errorProcessing(snapshot.error as DioError);
              } else if (snapshot.hasData) {
                FlutterLogs.logInfo("Info",
                    "getting recommendations from server", "Result: SUCCESS");
                children = dataProcessing(snapshot.data as Response<String>);
                break;
              } else {
                FlutterLogs.logInfo(
                    "Error",
                    "Error getting recommendations products",
                    "Server didn't send response :(");
                children.add(Text(
                  "Server didn't send response :(",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Theme.of(context).errorColor),
                ));
              }
          }
          return Flexible(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children));
        });
  }
}
