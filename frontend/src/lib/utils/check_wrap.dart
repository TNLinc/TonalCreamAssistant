import 'package:flutter/material.dart';

bool checkWrap(BuildContext context) {
  return !(MediaQuery.of(context).size.width >= 489);
}
