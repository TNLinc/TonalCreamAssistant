import 'package:TonalCreamAssistant/pages/home/components/step_list.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_sheets/home_bottom_sheet.dart';
import 'bottom_sheets/loading_bottom_sheet.dart';
import 'bottom_sheets/recommendation_bottom_sheet.dart';
import 'components/header.dart';
import 'components/step_list.dart';

class HomePage extends StatefulWidget {
  final String host;

  const HomePage({Key? key, required this.host}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String>? _data;
  XFile? _image;
  int activeStep = 1;

  loadImage(XFile? image) {
    setState(() {
      _image = image;
    });
  }

  loadData(Map<String, dynamic> data) {
    setState(() {
      _data = {'color': data['color']};
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
            case 3:
              {
                return RecommendationBottomSheet(
                  data: _data!,
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
