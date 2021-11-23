import 'package:TonalCreamAssistant/pages/home/components/step_list.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_sheets/home_bottom_sheet.dart';
import 'bottom_sheets/loading_bottom_sheet.dart';
import 'bottom_sheets/recommendation_bottom_sheet.dart';
import 'bottom_sheets/get_recomendations.dart';
import 'components/header.dart';
import 'components/step_list.dart';

class HomePage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String cv_host;
  // ignore: non_constant_identifier_names
  final String vendor_host;
  final int limit;
  final int offset;

  // ignore: non_constant_identifier_names
  const HomePage(
      {Key? key,
      required this.cv_host,
      required this.vendor_host,
      required this.limit,
      required this.offset})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String>? _color;
  late List<dynamic> _products;
  XFile? _image;
  int activeStep = 1;

  loadImage(XFile? image) {
    setState(() {
      _image = image;
    });
  }

  loadData(Map<String, dynamic> data) {
    setState(() {
      _color = {'color': data['color']};
      activeStep = 4;
    });
  }

  getRecomendations(Map<String, dynamic> data) {
    setState(() {
      _products = data['items'];
      activeStep = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (activeStep == 1) {
          return Future.value(true);
        }
        setState(() {
          activeStep -= 1;
        });
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(children: [
          const Header(text: 'Tonal assistant'),
          // Body
          Padding(
            padding: EdgeInsets.only(top: 0.028.sh),
            child: StepList(activeStep: activeStep),
          ),
          const Spacer(),
        ])),
        // Footer
        bottomSheet: Builder(builder: (context) {
          switch (activeStep) {
            case 1:
              {
                return HomeBottomSheet(
                    initImage: _image, notifyParent: loadImage);
              }
            case 2:
              {
                return LoadingBottomSheet(
                  host: widget.cv_host,
                  image: _image!,
                  notifyParent: loadData,
                );
              }
            case 4:
              {
                return GetRecomendations(
                    host: widget.vendor_host,
                    data: _color!['color']!,
                    notifyParent: getRecomendations,
                    limit: widget.limit,
                    offset: widget.offset);
              }
            case 3:
              {
                return RecommendationBottomSheet(
                  data_color: _color!,
                  data_products: _products,
                );
              }
            default:
              {
                return const Center(
                  child: Text('Wrong state'),
                );
              }
          }
        }),
        floatingActionButton: _image != null && activeStep == 1
            ? FloatingActionButton(
          elevation: 10,
              onPressed: () {
                setState(() {
                  activeStep = 2;
                });
              },
              child: const Icon(
                Icons.arrow_forward_ios,
              ),
            )
            : null,
      ),
    );
  }
}
