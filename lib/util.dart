import 'dart:math';

import 'package:flutter/painting.dart';

import 'constants.dart';

class Util {
  static double calculateCircle(
      List<Offset> pos,
      List<double> angles,
      Size size,
      List<String> datas,
      int startPos,
      Offset offset,
      TextPainter painter,
      TextStyle textStyle,
      TextStyle darkStyle,
      {int itemCount = 0,
      double secondsOffsetAngle = 0.0}) {
    double length = 0.0;
    itemCount = itemCount == 0 ? datas.length : itemCount;
    var angle = 360 / itemCount;
    for (int i = 0; i < itemCount; i++) {
      var curAngle = ((i * angle - secondsOffsetAngle) * Util.DEG2RAD);
      if (i == 0) {
        painter.text =
            TextSpan(text: datas[(startPos + i) % itemCount], style: textStyle);
        painter.layout();
        length = painter.width;
      } else {
        painter.text =
            TextSpan(text: datas[(startPos + i) % itemCount], style: darkStyle);
        painter.layout();
      }
      angles.add(curAngle);
      pos.add(Offset(offset.dx * cos(curAngle) + size.width / 2,
          offset.dx * sin(curAngle) + size.height / 2));
    }
    return length;
  }

  static Offset calculateSquare(
      List<Offset> pos,
      List<String> datas,
      double padding,
      double maxLen,
      Offset offset,
      int curPos,
      TextPainter painter,
      TextStyle style,
      TextStyle darkStyle,
      {int itemCount = 0}) {
    itemCount = itemCount == 0 ? datas.length : itemCount;
    double preW = offset.dx - padding;
    for (int i = 0; i < itemCount; i++) {
      painter.text =
          TextSpan(text: datas[i], style: curPos == i ? style : darkStyle);
      painter.layout();
      if (preW + painter.width > maxLen) {
        preW = 0;
        offset = offset.translate(-offset.dx + padding, painter.height);
      }
      pos.add(offset);
      if (preW + painter.width < maxLen) {
        preW += painter.width;
        offset = offset.translate(painter.width, 0);
      }
    }
    return offset;
  }

  static double drawAmPm(
    bool isAm,
    Offset offset,
    Canvas canvas,
    TextPainter painter,
    TextStyle textStyle,
    TextStyle darkStyle,
  ) {
    double length = 0.0;
    double angle = (isAm ? 6 : -6);
    for (int i = 0; i < AM_PM.length; i++) {
      canvas.save();
      canvas.rotate(angle * i * Util.DEG2RAD);
      painter.text = TextSpan(
          text: AM_PM[isAm ? i : ((i + 1) % 2)],
          style: i == 0 ? textStyle : darkStyle);
      painter.layout();
      if (i == 0) {
        length = painter.width;
      }
      painter.paint(canvas, offset);
      canvas.restore();
    }
    return length;
  }

  static Offset drawSquare(
      List<String> datas,
      double padding,
      double maxLen,
      Offset offset,
      int curPos,
      Canvas canvas,
      TextPainter painter,
      TextStyle style,
      TextStyle darkStyle,
      {int itemCount = 0}) {
    itemCount = itemCount == 0 ? datas.length : itemCount;
    double preW = offset.dx - padding;
    for (int i = 0; i < itemCount; i++) {
      painter.text =
          TextSpan(text: datas[i], style: curPos == i ? style : darkStyle);
      painter.layout();
      if (preW + painter.width > maxLen) {
        preW = 0;
        offset = offset.translate(-offset.dx + padding, painter.height);
      }
      painter.paint(canvas, offset);
      if (preW + painter.width < maxLen) {
        preW += painter.width;
        offset = offset.translate(painter.width, 0);
      }
    }
    return offset;
  }

  static double drawCircle(
      List<String> datas,
      int startPos,
      Offset offset,
      Canvas canvas,
      TextPainter painter,
      TextStyle textStyle,
      TextStyle darkStyle,
      {int itemCount = 0,
      double secondsOffsetAngle = 0.0}) {
    double length = 0.0;
    itemCount = itemCount == 0 ? datas.length : itemCount;
    var angle = 360 / itemCount;
    for (int i = 0; i < itemCount; i++) {
      canvas.save();
      canvas.rotate((i * angle - secondsOffsetAngle) * Util.DEG2RAD);
      if (i == 0) {
        painter.text =
            TextSpan(text: datas[(startPos + i) % itemCount], style: textStyle);
        painter.layout();
        length = painter.width;
      } else {
        painter.text =
            TextSpan(text: datas[(startPos + i) % itemCount], style: darkStyle);
        painter.layout();
      }
      painter.paint(canvas, offset);
      canvas.restore();
    }
    return length;
  }

  static int calculateMonthDayCount(int month) {
    if (month <= 0 || month > 12) {
      throw Exception();
    }

    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 2:
        int year = DateTime.now().year;
        int count = 28;
        if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
          count = 29;
        }
        return count;
      default:
        return 30;
    }
  }

  static const int TOTAL_NUM_SQUARE = 613;

  static const DEG2RAD = pi / 180;

  static List<String> MONTHS = List()
    ..add(Constants.JAN)
    ..add(Constants.FEB)
    ..add(Constants.MAR)
    ..add(Constants.APR)
    ..add(Constants.MAY)
    ..add(Constants.JUN)
    ..add(Constants.JUL)
    ..add(Constants.AUG)
    ..add(Constants.SEP)
    ..add(Constants.OCT)
    ..add(Constants.NOV)
    ..add(Constants.DEC);

  static List<String> DATES = List()
    ..add(Constants.DATE_1)
    ..add(Constants.DATE_2)
    ..add(Constants.DATE_3)
    ..add(Constants.DATE_4)
    ..add(Constants.DATE_5)
    ..add(Constants.DATE_6)
    ..add(Constants.DATE_7)
    ..add(Constants.DATE_8)
    ..add(Constants.DATE_9)
    ..add(Constants.DATE_10)
    ..add(Constants.DATE_11)
    ..add(Constants.DATE_12)
    ..add(Constants.DATE_13)
    ..add(Constants.DATE_14)
    ..add(Constants.DATE_15)
    ..add(Constants.DATE_16)
    ..add(Constants.DATE_17)
    ..add(Constants.DATE_18)
    ..add(Constants.DATE_19)
    ..add(Constants.DATE_20)
    ..add(Constants.DATE_21)
    ..add(Constants.DATE_22)
    ..add(Constants.DATE_23)
    ..add(Constants.DATE_24)
    ..add(Constants.DATE_25)
    ..add(Constants.DATE_26)
    ..add(Constants.DATE_27)
    ..add(Constants.DATE_28)
    ..add(Constants.DATE_29)
    ..add(Constants.DATE_30)
    ..add(Constants.DATE_31);

  static List<String> DAYS = List()
    ..add(Constants.MON)
    ..add(Constants.TUE)
    ..add(Constants.WED)
    ..add(Constants.THU)
    ..add(Constants.FEB)
    ..add(Constants.SAT)
    ..add(Constants.SUN);

  static List<String> HOURS = List()
    ..add(Constants.TIME_12)
    ..add(Constants.TIME_1)
    ..add(Constants.TIME_2)
    ..add(Constants.TIME_3)
    ..add(Constants.TIME_4)
    ..add(Constants.TIME_5)
    ..add(Constants.TIME_6)
    ..add(Constants.TIME_7)
    ..add(Constants.TIME_8)
    ..add(Constants.TIME_9)
    ..add(Constants.TIME_10)
    ..add(Constants.TIME_11);

  static List<String> SCORE_HOURS = List()
    ..add(Constants.TIME_24)
    ..add(Constants.TIME_1)
    ..add(Constants.TIME_2)
    ..add(Constants.TIME_3)
    ..add(Constants.TIME_4)
    ..add(Constants.TIME_5)
    ..add(Constants.TIME_6)
    ..add(Constants.TIME_7)
    ..add(Constants.TIME_8)
    ..add(Constants.TIME_9)
    ..add(Constants.TIME_10)
    ..add(Constants.TIME_11)
    ..add(Constants.TIME_12)
    ..add(Constants.TIME_13)
    ..add(Constants.TIME_14)
    ..add(Constants.TIME_15)
    ..add(Constants.TIME_16)
    ..add(Constants.TIME_17)
    ..add(Constants.TIME_18)
    ..add(Constants.TIME_19)
    ..add(Constants.TIME_20)
    ..add(Constants.TIME_21)
    ..add(Constants.TIME_22)
    ..add(Constants.TIME_23);

  static List<String> MINUTES = List()
    ..add("${Constants.NUM_0}${Constants.MINUTE}")
    ..add("${Constants.NUM_1}${Constants.MINUTE}")
    ..add("${Constants.NUM_2}${Constants.MINUTE}")
    ..add("${Constants.NUM_3}${Constants.MINUTE}")
    ..add("${Constants.NUM_4}${Constants.MINUTE}")
    ..add("${Constants.NUM_5}${Constants.MINUTE}")
    ..add("${Constants.NUM_6}${Constants.MINUTE}")
    ..add("${Constants.NUM_7}${Constants.MINUTE}")
    ..add("${Constants.NUM_8}${Constants.MINUTE}")
    ..add("${Constants.NUM_9}${Constants.MINUTE}")
    ..add("${Constants.NUM_10}${Constants.MINUTE}")
    ..add("${Constants.NUM_11}${Constants.MINUTE}")
    ..add("${Constants.NUM_12}${Constants.MINUTE}")
    ..add("${Constants.NUM_13}${Constants.MINUTE}")
    ..add("${Constants.NUM_14}${Constants.MINUTE}")
    ..add("${Constants.NUM_15}${Constants.MINUTE}")
    ..add("${Constants.NUM_16}${Constants.MINUTE}")
    ..add("${Constants.NUM_17}${Constants.MINUTE}")
    ..add("${Constants.NUM_18}${Constants.MINUTE}")
    ..add("${Constants.NUM_19}${Constants.MINUTE}")
    ..add("${Constants.NUM_20}${Constants.MINUTE}")
    ..add("${Constants.NUM_21}${Constants.MINUTE}")
    ..add("${Constants.NUM_22}${Constants.MINUTE}")
    ..add("${Constants.NUM_23}${Constants.MINUTE}")
    ..add("${Constants.NUM_24}${Constants.MINUTE}")
    ..add("${Constants.NUM_25}${Constants.MINUTE}")
    ..add("${Constants.NUM_26}${Constants.MINUTE}")
    ..add("${Constants.NUM_27}${Constants.MINUTE}")
    ..add("${Constants.NUM_28}${Constants.MINUTE}")
    ..add("${Constants.NUM_29}${Constants.MINUTE}")
    ..add("${Constants.NUM_30}${Constants.MINUTE}")
    ..add("${Constants.NUM_31}${Constants.MINUTE}")
    ..add("${Constants.NUM_32}${Constants.MINUTE}")
    ..add("${Constants.NUM_33}${Constants.MINUTE}")
    ..add("${Constants.NUM_34}${Constants.MINUTE}")
    ..add("${Constants.NUM_35}${Constants.MINUTE}")
    ..add("${Constants.NUM_36}${Constants.MINUTE}")
    ..add("${Constants.NUM_37}${Constants.MINUTE}")
    ..add("${Constants.NUM_38}${Constants.MINUTE}")
    ..add("${Constants.NUM_39}${Constants.MINUTE}")
    ..add("${Constants.NUM_40}${Constants.MINUTE}")
    ..add("${Constants.NUM_41}${Constants.MINUTE}")
    ..add("${Constants.NUM_42}${Constants.MINUTE}")
    ..add("${Constants.NUM_43}${Constants.MINUTE}")
    ..add("${Constants.NUM_44}${Constants.MINUTE}")
    ..add("${Constants.NUM_45}${Constants.MINUTE}")
    ..add("${Constants.NUM_46}${Constants.MINUTE}")
    ..add("${Constants.NUM_47}${Constants.MINUTE}")
    ..add("${Constants.NUM_48}${Constants.MINUTE}")
    ..add("${Constants.NUM_49}${Constants.MINUTE}")
    ..add("${Constants.NUM_50}${Constants.MINUTE}")
    ..add("${Constants.NUM_51}${Constants.MINUTE}")
    ..add("${Constants.NUM_52}${Constants.MINUTE}")
    ..add("${Constants.NUM_53}${Constants.MINUTE}")
    ..add("${Constants.NUM_54}${Constants.MINUTE}")
    ..add("${Constants.NUM_55}${Constants.MINUTE}")
    ..add("${Constants.NUM_56}${Constants.MINUTE}")
    ..add("${Constants.NUM_57}${Constants.MINUTE}")
    ..add("${Constants.NUM_58}${Constants.MINUTE}")
    ..add("${Constants.NUM_59}${Constants.MINUTE}");

  static List<String> SECONDS = List()
    ..add("${Constants.NUM_0}${Constants.SECOND}")
    ..add("${Constants.NUM_1}${Constants.SECOND}")
    ..add("${Constants.NUM_2}${Constants.SECOND}")
    ..add("${Constants.NUM_3}${Constants.SECOND}")
    ..add("${Constants.NUM_4}${Constants.SECOND}")
    ..add("${Constants.NUM_5}${Constants.SECOND}")
    ..add("${Constants.NUM_6}${Constants.SECOND}")
    ..add("${Constants.NUM_7}${Constants.SECOND}")
    ..add("${Constants.NUM_8}${Constants.SECOND}")
    ..add("${Constants.NUM_9}${Constants.SECOND}")
    ..add("${Constants.NUM_10}${Constants.SECOND}")
    ..add("${Constants.NUM_11}${Constants.SECOND}")
    ..add("${Constants.NUM_12}${Constants.SECOND}")
    ..add("${Constants.NUM_13}${Constants.SECOND}")
    ..add("${Constants.NUM_14}${Constants.SECOND}")
    ..add("${Constants.NUM_15}${Constants.SECOND}")
    ..add("${Constants.NUM_16}${Constants.SECOND}")
    ..add("${Constants.NUM_17}${Constants.SECOND}")
    ..add("${Constants.NUM_18}${Constants.SECOND}")
    ..add("${Constants.NUM_19}${Constants.SECOND}")
    ..add("${Constants.NUM_20}${Constants.SECOND}")
    ..add("${Constants.NUM_21}${Constants.SECOND}")
    ..add("${Constants.NUM_22}${Constants.SECOND}")
    ..add("${Constants.NUM_23}${Constants.SECOND}")
    ..add("${Constants.NUM_24}${Constants.SECOND}")
    ..add("${Constants.NUM_25}${Constants.SECOND}")
    ..add("${Constants.NUM_26}${Constants.SECOND}")
    ..add("${Constants.NUM_27}${Constants.SECOND}")
    ..add("${Constants.NUM_28}${Constants.SECOND}")
    ..add("${Constants.NUM_29}${Constants.SECOND}")
    ..add("${Constants.NUM_30}${Constants.SECOND}")
    ..add("${Constants.NUM_31}${Constants.SECOND}")
    ..add("${Constants.NUM_32}${Constants.SECOND}")
    ..add("${Constants.NUM_33}${Constants.SECOND}")
    ..add("${Constants.NUM_34}${Constants.SECOND}")
    ..add("${Constants.NUM_35}${Constants.SECOND}")
    ..add("${Constants.NUM_36}${Constants.SECOND}")
    ..add("${Constants.NUM_37}${Constants.SECOND}")
    ..add("${Constants.NUM_38}${Constants.SECOND}")
    ..add("${Constants.NUM_39}${Constants.SECOND}")
    ..add("${Constants.NUM_40}${Constants.SECOND}")
    ..add("${Constants.NUM_41}${Constants.SECOND}")
    ..add("${Constants.NUM_42}${Constants.SECOND}")
    ..add("${Constants.NUM_43}${Constants.SECOND}")
    ..add("${Constants.NUM_44}${Constants.SECOND}")
    ..add("${Constants.NUM_45}${Constants.SECOND}")
    ..add("${Constants.NUM_46}${Constants.SECOND}")
    ..add("${Constants.NUM_47}${Constants.SECOND}")
    ..add("${Constants.NUM_48}${Constants.SECOND}")
    ..add("${Constants.NUM_49}${Constants.SECOND}")
    ..add("${Constants.NUM_50}${Constants.SECOND}")
    ..add("${Constants.NUM_51}${Constants.SECOND}")
    ..add("${Constants.NUM_52}${Constants.SECOND}")
    ..add("${Constants.NUM_53}${Constants.SECOND}")
    ..add("${Constants.NUM_54}${Constants.SECOND}")
    ..add("${Constants.NUM_55}${Constants.SECOND}")
    ..add("${Constants.NUM_56}${Constants.SECOND}")
    ..add("${Constants.NUM_57}${Constants.SECOND}")
    ..add("${Constants.NUM_58}${Constants.SECOND}")
    ..add("${Constants.NUM_59}${Constants.SECOND}");

  static List<String> AM_PM = List()..add(Constants.AM)..add(Constants.PM);
}
