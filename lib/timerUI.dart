import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'timer.dart' as timerWidget;

import 'duration.dart';
import 'durationDisplay.dart';
import 'durationPicker.dart';

bool startOnLoad = true;

class TimerExample extends StatelessWidget {
  var timerKey;
  Duration matchTime;

  TimerExample({
    this.timerKey,
    this.matchTime,
  });

  final timerWidget.Timer timer = new timerWidget.Timer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        timer,
        TimerUI(
          timer: timer,
          timerKey: timerKey,
          matchTime: matchTime,
        ),
      ],
    );
  }
}

class TimerUI extends StatefulWidget {
  final timerWidget.Timer timer;
  var timerKey;
  Duration matchTime;

  TimerUI({
    @required this.timer,
    this.timerKey,
    this.matchTime,
  });

  @override
  _TimerUIState createState() => _TimerUIState();
}

class _TimerUIState extends State<TimerUI> {

  DurationPicker picker;

  final running = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    widget.timer.functions.set(widget.matchTime);
    running.value = widget.timer.functions.isRunning();

    if(startOnLoad) widget.timer.functions.play();

    autoUpdate();
  }

  autoUpdate() async {
    while (true) {
      await Future
          .delayed(new Duration(microseconds: 16666)); //60 times per second
      if (running.value != widget.timer.functions.isRunning())
        running.value = widget.timer.functions.isRunning();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textPeach = const Color.fromARGB(255, 255, 147, 160);

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //-------------------------DURATION START
        new FlatButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                picker = new DurationPicker(
                  showDays: false,
                  showHours: false,
                  showMilliseconds: false,
                  showMicroseconds: false,
                  initialDuration: widget.timer.functions.getOriginalTime(),
                  onConfirm: () {
                    widget.timer.functions.set(picker.getDuration());
                    Navigator.pop(context);
                  },
                  onCancel: () => Navigator.pop(context),
                );
                return picker;
              },
            );
          },
          child: new Container(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: new DurationDisplay(
              showDays: false,
              showHours: false,
              showMilliseconds: false,
              showMicroseconds: false,
              value: widget.timer.functions.getTimeLeft,
            ),
          ),
        ),
        //-------------------------DURATION END
        new AnimatedBuilder(
            animation: running,
            builder: (context, child) {
              return new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    elevation: 0.0,
                    disabledElevation: 0,
                    highlightElevation: 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    disabledTextColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    textColor: Colors.transparent,
                    child: new Text(
                      "Reset",
                      style: TextStyle(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  new Container(
                    width: 16.0,
                    child: new Text(""),
                  ),
                  /// ----- play/pause button start
                  new FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        if (running.value)
                          widget.timer.functions.pause();
                        else
                          widget.timer.functions.play();
                      });
                    },
                    child: (running.value)
                        ? Icon(
                      Icons.pause,
                      color: textPeach,
                    )
                        : Icon(
                      Icons.play_arrow,
                      color: textPeach,
                    ),
                  ),
                  /// ----- play/pause button end
                  new Container(
                    width: 16.0,
                    child: new Text(""),
                  ),
                  new RaisedButton(
                    onPressed: () => widget.timer.functions.reset(),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    child: new Text(
                      "Reset",
                      style: TextStyle(
                        color: textPeach,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}

//-------------------------SNACKBAR-------------------------

showInSnackBar(var keyThingy, String message, String value) {
  keyThingy.showSnackBar(
    new SnackBar(
      content: new RichText(
        text: new TextSpan(
          children: [
            new TextSpan(
              text: message,
            ),
            new TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    ),
  );
}