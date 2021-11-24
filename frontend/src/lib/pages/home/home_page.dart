import 'package:TonalCreamAssistant/models/color.dart';
import 'package:TonalCreamAssistant/pages/home/bottom_sheets/recommendation_bottom_sheet.dart';
import 'package:TonalCreamAssistant/pages/home/components/step_list.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'bottom_sheets/home_bottom_sheet.dart';
import 'bottom_sheets/loading_bottom_sheet.dart';
import 'components/header.dart';
import 'components/step_list.dart';

class HomePage extends StatefulWidget {
  final String cvHost;
  final String vendorHost;

  // ignore: non_constant_identifier_names
  const HomePage({Key? key, required this.cvHost, required this.vendorHost})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ColorRead? _color;
  XFile? _image;
  int activeStep = 1;

  loadImage(XFile? image) {
    setState(() {
      _image = image;
    });
  }

  getColor(ColorRead colorData) {
    setState(() {
      _color = colorData;
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
          StepList(activeStep: activeStep),
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
                  host: widget.cvHost,
                  image: _image!,
                  notifyParent: getColor,
                );
              }
            case 3:
              {
                return RecommendationBottomSheet(
                  host: widget.vendorHost,
                  dataColor: _color!,
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
