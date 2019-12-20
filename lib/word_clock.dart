import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:word_clock/util.dart';

class WordClock extends StatefulWidget {
  final bool isShift;
  final int shiftCycleSecond;
  final int shiftTimeSecond;
  final bool isCircle;
  final bool isScore;
  final Color backgroundColor;
  final Color backTextColor;
  final Color textColor;

  const WordClock(
      {Key key,
      this.isShift = true,
      this.shiftCycleSecond = 30,
      this.shiftTimeSecond = 3,
      this.isCircle = true,
      this.isScore = true,
      this.backgroundColor = Colors.black,
      this.backTextColor = Colors.grey,
      this.textColor = Colors.white})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WordClockState();
}

class WordClockState extends State<WordClock> {
  bool _isCircle = true;
  bool _isShift = true;
  int _shiftCycleSecond = 30;
  int _shiftTimeSecond = 3;
  bool _isScore = true;

  int _frameRate = 16;
  Timer _timer;
  DateTime _preDateTime;
  double _transTime = 0.0;
  bool _isTrans = false;
  double _transPercent = 0.0;

  @override
  void initState() {
    _isScore = widget.isScore;
    _isShift = widget.isShift;
    _shiftCycleSecond = widget.shiftCycleSecond;
    _shiftTimeSecond = widget.shiftTimeSecond;
    _isCircle = widget.isCircle;
    if (_isShift) {
      _isScore = true;
    } else {
      if (!_isCircle) {
        _isScore = true;
      }
    }
    _preDateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isShift != widget.isShift) {
      _isShift = widget.isShift;
      _isCircle = widget.isCircle;
      _isScore = _isShift ? true : widget.isScore;
    }

    if (_shiftCycleSecond != widget.shiftCycleSecond) {
      _shiftTimeSecond = widget.shiftCycleSecond;
    }

    if (_shiftTimeSecond != widget.shiftTimeSecond) {
      _shiftTimeSecond = widget.shiftTimeSecond;
    }

    _timer = Timer(Duration(milliseconds: _frameRate), () {
      var timeNow = DateTime.now();
      if (_isShift) {
        var diff = timeNow.millisecond - _preDateTime.millisecond;
        _transTime += (diff >= 0 ? diff : diff + 1000);
        _isScore = true;
        if (_transTime >= 1000 * (_shiftCycleSecond + _shiftTimeSecond)) {
          if (_transPercent < 1.0) {
            _isTrans = true;
            _transPercent = 1.0;
          } else {
            _isTrans = false;
            _isCircle = !_isCircle;
            _transTime = 0.0;
          }
          CIRCLE_POS.clear();
          ANGLES.clear();
        } else if (_transTime >= 1000 * _shiftCycleSecond) {
          _transPercent = (_transTime - _shiftCycleSecond * 1000) /
              (_shiftTimeSecond * 1000);
          _isTrans = true;
          CIRCLE_POS.clear();
          ANGLES.clear();
        } else {
          _isTrans = false;
        }
      } else {
        _isTrans = false;
      }
      _preDateTime = timeNow;
      setState(() {});
    });
    return Container(
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(),
      color: Colors.white,
      child: CustomPaint(
          painter: _isTrans
              ? TransPainter(_transPercent, _isCircle, _preDateTime,
                  backgroundColor: widget.backgroundColor,
                  backTextColor: widget.backTextColor,
                  textColor: widget.textColor)
              : WordClockPainter(_preDateTime,
                  isScore: _isScore,
                  isCircle: _isCircle,
                  backgroundColor: widget.backgroundColor,
                  backTextColor: widget.backTextColor,
                  textColor: widget.textColor)),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void reassemble() {
    _timer?.cancel();
    super.reassemble();
  }
}

List<Offset> RECT_POS = List();
List<Offset> CIRCLE_POS = List();
List<double> ANGLES = List();
Offset _OFFSET = Offset(0, 0);

class TransPainter extends CustomPainter {
  double _animationPercent;
  bool _isCircle2Rect;
  Color _backgroundColor;
  Color _backTextColor;
  Color _textColor;
  TextPainter _textPainter;
  bool _isScore;
  bool _isCircle;
  double _secondsOffsetAngle;
  DateTime _dateTime;

  TransPainter(this._animationPercent, this._isCircle2Rect, this._dateTime,
      {Color backgroundColor,
      Color backTextColor,
      Color textColor,
      double secondsOffsetAngle = 0.0,
      bool isScore = false,
      bool isCircle = true}) {
    _backgroundColor = backgroundColor ?? Colors.black;
    _backTextColor = backTextColor ?? Colors.grey;
    _textColor = textColor ?? Colors.white;
    _textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    _isScore = isScore;
    _isCircle = isCircle;
    _secondsOffsetAngle = secondsOffsetAngle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(_backgroundColor, BlendMode.src);

    var dateNow = _dateTime == null ? DateTime.now() : _dateTime;
    double minLen = size.height > size.width ? size.width : size.height;
    double itemLen = (minLen / 2) / 6;
    double fontSize = _getFontSize(itemLen / 4);
    TextStyle style = TextStyle(color: _textColor, fontSize: fontSize);
    TextStyle darkStyle = TextStyle(color: _backTextColor, fontSize: fontSize);
    if (RECT_POS.length == 0) {
      _calculateRectPosition(
          size, dateNow, minLen, itemLen, fontSize, style, darkStyle);
    }

    if (CIRCLE_POS.length == 0) {
      _calculateCirclePosition(
          size, dateNow, minLen, itemLen, fontSize, style, darkStyle);
      if (CIRCLE_POS.length != RECT_POS.length) {
        RECT_POS.clear();
        _calculateRectPosition(
            size, dateNow, minLen, itemLen, fontSize, style, darkStyle);
      }
    }

    var x = -1.0;
    var y = -1.0;
    var data = "";
    var isDark = false;
    var monthDayCount = Util.calculateMonthDayCount(dateNow.month);
    for (int i = 0; i < RECT_POS.length; i++) {
      var pos = 0;
      var monthPos = (12 - dateNow.month + 1 + i) % 12;
      var datePos = (monthDayCount - dateNow.day + i - 11) % monthDayCount;
      var dayPos = (7 - dateNow.weekday + i - 11 - monthDayCount) % 7;
      var hourPos = (24 - dateNow.hour + i - 19 - monthDayCount) % 24;
      var minutePos = (60 - dateNow.minute + i - 43 - monthDayCount) % 60;
      var secondPos = (60 - dateNow.second + i - 103 - monthDayCount) % 60;
      var percent = 1.0;
      if (i < 12) {
        pos = monthPos;
        data = Util.MONTHS[i];
        isDark = i != dateNow.month - 1;
      } else if (i >= 12 && i < 12 + monthDayCount) {
        pos = datePos + 12;
        data = Util.DATES[i - 12];
        isDark = i != dateNow.day - 1 + 12;
      } else if (i >= 12 + monthDayCount && i < monthDayCount + 19) {
        pos = dayPos + 12 + monthDayCount;
        data = Util.DAYS[i - (12 + monthDayCount)];
        isDark = i != dateNow.weekday - 1 + 12 + monthDayCount;
      } else if (i >= monthDayCount + 19 && i < monthDayCount + 43) {
        pos = hourPos + monthDayCount + 19;
        data = Util.SCORE_HOURS[i - (monthDayCount + 19)];
        isDark = i != dateNow.hour + (monthDayCount + 19);
      } else if (i >= monthDayCount + 43 && i < monthDayCount + 103) {
        pos = minutePos + monthDayCount + 43;
        data = Util.MINUTES[i - (monthDayCount + 43)];
        isDark = i != dateNow.minute + monthDayCount + 43;
      } else {
        pos = secondPos + monthDayCount + 103;
        data = Util.SECONDS[i - (monthDayCount + 103)];
        isDark = i != dateNow.second + monthDayCount + 103;
      }
      if (!_isCircle2Rect) {
        percent = (RECT_POS.length - 1 - i) / (RECT_POS.length - 1) * 3.0;
      } else {
        percent = i / (RECT_POS.length - 1) * 3.0;
      }
      if (percent < 1.0) {
        percent = 1.0;
      }
      var realPercent = _animationPercent * percent;
      if (realPercent > 1.0) realPercent = 1.0;
      if (_isCircle2Rect) {
        x = (RECT_POS[i].dx - CIRCLE_POS[pos].dx) * realPercent +
            CIRCLE_POS[pos].dx;
        y = (RECT_POS[i].dy - CIRCLE_POS[pos].dy) * realPercent +
            CIRCLE_POS[pos].dy;
      } else {
        x = (CIRCLE_POS[pos].dx - RECT_POS[i].dx) * realPercent +
            RECT_POS[i].dx;
        y = (CIRCLE_POS[pos].dy - RECT_POS[i].dy) * realPercent +
            RECT_POS[i].dy;
      }
      canvas.save();
      canvas.translate(x, y);
      var realAnglePercent = 1.0;
      if (_isCircle2Rect) {
        realAnglePercent = 1 - _animationPercent * percent;
        if (realAnglePercent < 0.0) realAnglePercent = 0.0;
      } else {
        realAnglePercent = _animationPercent * percent;
        if (realAnglePercent > 1.0) realAnglePercent = 1.0;
      }
      canvas.rotate(ANGLES[pos] * realAnglePercent);
      _textPainter.text =
          TextSpan(text: data, style: (!isDark ? style : darkStyle));
      _textPainter.layout();
      _textPainter.paint(canvas, _OFFSET);
      canvas.restore();
    }
  }

  void _calculateCirclePosition(Size size, DateTime dateNow, double minLen,
      double itemLen, double fontSize, TextStyle style, TextStyle darkStyle) {
    double len = itemLen;
    var monthDayCount = Util.calculateMonthDayCount(dateNow.month);
    len += Util.calculateCircle(CIRCLE_POS, ANGLES, size, Util.MONTHS,
        dateNow.month - 1, Offset(len, 0), _textPainter, style, darkStyle);

    len += Util.calculateCircle(CIRCLE_POS, ANGLES, size, Util.DATES,
        dateNow.day - 1, Offset(len, 0), _textPainter, style, darkStyle,
        itemCount: monthDayCount);

    len += Util.calculateCircle(CIRCLE_POS, ANGLES, size, Util.DAYS,
        dateNow.weekday - 1, Offset(len, 0), _textPainter, style, darkStyle);

    len += Util.calculateCircle(CIRCLE_POS, ANGLES, size, Util.SCORE_HOURS,
        dateNow.hour, Offset(len, 0), _textPainter, style, darkStyle);

    len += Util.calculateCircle(CIRCLE_POS, ANGLES, size, Util.MINUTES,
        dateNow.minute, Offset(len, 0), _textPainter, style, darkStyle);

    Util.calculateCircle(CIRCLE_POS, ANGLES, size, Util.SECONDS, dateNow.second,
        Offset(len, 0), _textPainter, style, darkStyle,
        secondsOffsetAngle: _secondsOffsetAngle);
  }

  void _calculateRectPosition(Size size, DateTime dateNow, double minLen,
      double itemLen, double fontSize, TextStyle style, TextStyle darkStyle) {
    double padding = fontSize * 3;
    double drawWidth = minLen - padding * 2;
    double startY = (size.height -
            (Util.TOTAL_NUM_SQUARE * fontSize / drawWidth + 2) * fontSize) /
        5 *
        2;
    Offset pos = Offset(padding, startY);
    pos = Util.calculateSquare(RECT_POS, Util.MONTHS, padding, drawWidth, pos,
        dateNow.month - 1, _textPainter, style, darkStyle);
    pos = Util.calculateSquare(RECT_POS, Util.DATES, padding, drawWidth, pos,
        dateNow.day - 1, _textPainter, style, darkStyle,
        itemCount: Util.calculateMonthDayCount(dateNow.month));
    pos = Util.calculateSquare(RECT_POS, Util.DAYS, padding, drawWidth, pos,
        dateNow.weekday - 1, _textPainter, style, darkStyle);
    pos = Util.calculateSquare(RECT_POS, Util.SCORE_HOURS, padding, drawWidth,
        pos, dateNow.hour, _textPainter, style, darkStyle);
    pos = Util.calculateSquare(RECT_POS, Util.MINUTES, padding, drawWidth, pos,
        dateNow.minute, _textPainter, style, darkStyle);
    pos = Util.calculateSquare(RECT_POS, Util.SECONDS, padding, drawWidth, pos,
        dateNow.second, _textPainter, style, darkStyle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WordClockPainter extends CustomPainter {
  Color _backgroundColor;
  TextPainter _textPainter;
  Color _backTextColor;
  Color _textColor;
  bool _isScore;
  bool _isCircle;
  double _secondsOffsetAngle;
  DateTime _dateTime;

  WordClockPainter(this._dateTime,
      {Color backgroundColor,
      Color backTextColor,
      Color textColor,
      double secondsOffsetAngle = 0.0,
      bool isScore = false,
      bool isCircle = true}) {
    _backgroundColor = backgroundColor ?? Colors.black;
    _backTextColor = backTextColor ?? Colors.grey;
    _textColor = textColor ?? Colors.white;
    _textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    _isScore = isScore;
    _isCircle = isCircle;
    _secondsOffsetAngle = secondsOffsetAngle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(_backgroundColor, BlendMode.src);

    var dateNow = _dateTime == null ? DateTime.now() : _dateTime;
    if (_isCircle) {
      canvas.translate(size.width / 2, size.height / 2);
      double minLen = size.height > size.width ? size.width : size.height;

      double itemLen = (minLen / 2) / (_isScore ? 6 : 7);
      double fontSize = _getFontSize(itemLen / 4);
      double len = itemLen;
      TextStyle style = TextStyle(color: _textColor, fontSize: fontSize);
      TextStyle darkStyle =
          TextStyle(color: _backTextColor, fontSize: fontSize);
      len += Util.drawCircle(Util.MONTHS, dateNow.month - 1, Offset(len, 0),
          canvas, _textPainter, style, darkStyle);

      len += Util.drawCircle(Util.DATES, dateNow.day - 1, Offset(len, 0),
          canvas, _textPainter, style, darkStyle,
          itemCount: Util.calculateMonthDayCount(dateNow.month));

      len += Util.drawCircle(Util.DAYS, dateNow.weekday - 1, Offset(len, 0),
          canvas, _textPainter, style, darkStyle);

      if (!_isScore) {
        len += Util.drawAmPm(dateNow.hour <= 12 && dateNow.hour > 0,
            Offset(len, 0), canvas, _textPainter, style, darkStyle);

        len += Util.drawCircle(Util.HOURS, dateNow.hour % 12, Offset(len, 0),
            canvas, _textPainter, style, darkStyle);
      } else {
        len += Util.drawCircle(Util.SCORE_HOURS, dateNow.hour, Offset(len, 0),
            canvas, _textPainter, style, darkStyle);
      }

      len += Util.drawCircle(Util.MINUTES, dateNow.minute, Offset(len, 0),
          canvas, _textPainter, style, darkStyle);

      Util.drawCircle(Util.SECONDS, dateNow.second, Offset(len, 0), canvas,
          _textPainter, style, darkStyle,
          secondsOffsetAngle: _secondsOffsetAngle);
    } else {
      double minLen = size.height > size.width ? size.width : size.height;
      double itemLen = (minLen / 2) / 6;
      double fontSize = _getFontSize(itemLen / 4);
      TextStyle style = TextStyle(color: _textColor, fontSize: fontSize);
      TextStyle darkStyle =
          TextStyle(color: _backTextColor, fontSize: fontSize);

      double padding = fontSize * 3;
      double drawWidth = minLen - padding * 2;
      double startY = (size.height -
              (Util.TOTAL_NUM_SQUARE * fontSize / drawWidth + 2) * fontSize) /
          5 *
          2;
      Offset pos = Offset(padding, startY);
      pos = Util.drawSquare(Util.MONTHS, padding, drawWidth, pos,
          dateNow.month - 1, canvas, _textPainter, style, darkStyle);
      pos = Util.drawSquare(Util.DATES, padding, drawWidth, pos,
          dateNow.day - 1, canvas, _textPainter, style, darkStyle,
          itemCount: Util.calculateMonthDayCount(dateNow.month));
      pos = Util.drawSquare(Util.DAYS, padding, drawWidth, pos,
          dateNow.weekday - 1, canvas, _textPainter, style, darkStyle);
      pos = Util.drawSquare(Util.SCORE_HOURS, padding, drawWidth, pos,
          dateNow.hour, canvas, _textPainter, style, darkStyle);
      pos = Util.drawSquare(Util.MINUTES, padding, drawWidth, pos,
          dateNow.minute, canvas, _textPainter, style, darkStyle);
      pos = Util.drawSquare(Util.SECONDS, padding, drawWidth, pos,
          dateNow.second, canvas, _textPainter, style, darkStyle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

double _getFontSize(double fontSize) {
  if (fontSize < 10) return 10;
  if (fontSize > 18) return 18;
  return fontSize;
}
