import 'package:flutter/material.dart';
import 'package:score_keeper/durationDisplay.dart';
import 'package:score_keeper/durationPicker.dart';
import 'dart:async';
import 'mainPage.dart';

void main() => runApp(new BackButtonOverrideDemoWidget());

///------------------------------Override the Back Button So Only the [Start Match] and [End Match] buttons Navigate

class BackButtonOverrideDemoWidget extends StatefulWidget {
  @override
  _BackButtonOverrideDemoWidgetState createState() =>
      new _BackButtonOverrideDemoWidgetState();
}

class _BackButtonOverrideDemoWidgetState
    extends State<BackButtonOverrideDemoWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didPopRoute() {
    return new Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return new HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  /// DESIGN variables

  Color gradientLight = const Color.fromARGB(255, 255, 203, 174);
  Color gradientDark = const Color.fromARGB(255, 255, 128, 148);

  static Color textPeach = const Color.fromARGB(255, 255, 147, 160);

  TextStyle textMediumPeach = TextStyle(
    color: textPeach,
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );

  /// LOGIC Variables

  TextEditingController player1Name = TextEditingController();
  TextEditingController player2Name = TextEditingController();
  Duration matchTime = new Duration(minutes: 5);

  DurationPicker picker;

  /// For Duration Picker In Start Screen

  /// Overrides
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Score Keeper',
        home: Builder(
          builder: (context) {
            Widget mainWidget() {
              return new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: new Text(
                      "Cute Score Keeper",
                      style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 48.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: playerNameSetter(player1Name, "Player 1")),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: playerNameSetter(player2Name, "Player 2")),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: new FlatButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            picker = new DurationPicker(
                              showDays: false,
                              showHours: false,
                              showMilliseconds: false,
                              showMicroseconds: false,
                              initialDuration: matchTime,
                              onConfirm: () {
                                matchTime = picker.getDuration();
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
                          value: () {
                            return matchTime;
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      border: new Border.all(color: Colors.white),
                    ),
                    child: new FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: "Match Points",
                                  player1Name: ((player1Name.text ?? "") == "")
                                      ? "Player 1"
                                      : player1Name.text,
                                  player2Name: ((player2Name.text ?? "") == "")
                                      ? "Player 2"
                                      : player2Name.text,
                                  matchTime: matchTime,
                                ),
                          ),
                        );
                      },
                      child: new Text(
                        "Start Match",
                        style: textMediumPeach,
                      ),
                    ),
                  )
                ],
              );
            }

            return new Scaffold(
              body: new Container(
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradientLight, gradientDark],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    mainWidget(),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget playerNameSetter(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      autocorrect: false,
      style: TextStyle(
        fontSize: 28,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        enabled: false,
        contentPadding: EdgeInsets.all(6.0),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gapPadding: 16.0),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 4,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gapPadding: 16.0),
        hintStyle: TextStyle(
          fontSize: 28,
          color: Colors.white,
        ),
        hintText: hint,
      ),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      onFieldSubmitted: (newValue) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      onSaved: (newValue) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }
}
