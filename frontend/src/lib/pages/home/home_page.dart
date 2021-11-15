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
  final String host;

  const HomePage({Key? key, required this.host}) : super(key: key);

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

  getRecomendations(List<dynamic> data) {
    setState(() {
     // _products = data;
      // It is temporary for testing
      dynamic _products1 =   {
        "name": "string1",
        "type": "TONAL_CREAM1",
        "color": "string1",
        "vendor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      };
      dynamic _products2 =   {
        "name": "string2",
        "type": "TONAL_CREAM2",
        "color": "string2",
        "vendor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      };
      _products = [_products1, _products2];
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
                  host: widget.host,
                  image: _image!,
                  notifyParent: loadData,
                );
              }
            case 4:
              {
                return GetRecomendations(
                  host: widget.host,
                  data: _color!['color']!,
                  notifyParent: getRecomendations,
                );
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
