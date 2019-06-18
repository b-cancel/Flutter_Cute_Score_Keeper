import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'naturalNumberFormatter.dart';
import 'currencyUtils.dart';

import 'timerUI.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
    this.player1Name,
    this.player2Name,
    this.matchTime,
  }) : super(key: key);

  final String title;
  final String player1Name;
  final String player2Name;
  final Duration matchTime;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _timerKey = new GlobalKey<ScaffoldState>();

  /// --------------------------------------------------VARIABLE PREPARATION--------------------------------------------------

  /// DESIGN variables

  Color gradientLight = const Color.fromARGB(255, 255, 203, 174);
  Color gradientDark = const Color.fromARGB(
      255, 255, 128, 148); //const Color.fromARGB(255, 205, 139, 149);
  Color textGrey = const Color.fromARGB(255, 205, 205, 205);
  static Color textPeach = const Color.fromARGB(255, 255, 147, 160);

  TextStyle textMediumPeach = TextStyle(
    color: textPeach,
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );

  TextStyle textLargePeach = new TextStyle(
    color: textPeach,
    fontWeight: FontWeight.bold,
    fontSize: 48.0,
  );

  /// FUNCTIONALITY variables

  FocusNode player1FocusNode = new FocusNode();
  FocusNode player2FocusNode = new FocusNode();

  TextEditingController player1Controller = new TextEditingController();
  TextEditingController player2Controller = new TextEditingController();

  int player1Score = 0;
  int player2Score = 0;

  String p1ScoreString = "";
  String p2ScoreString = "";

  /// --------------------------------------------------FUNCTIONS--------------------------------------------------

  void updatedPlayer1Field(int splitCount, {bool negativeScoresAllowed: true}) {
    if (negativeScoresAllowed)
      this.player1Score = splitCount;
    else
      this.player1Score = (splitCount <= 0) ? 1 : splitCount;

    p1ScoreString =
        numberDecoration(player1Score); //NOTE: not just for debugging
  }

  void updatedPlayer2Field(int splitCount, {bool negativeScoresAllowed: true}) {
    if (negativeScoresAllowed)
      this.player2Score = splitCount;
    else
      this.player2Score = (splitCount <= 0) ? 1 : splitCount;

    p2ScoreString =
        numberDecoration(player2Score); //NOTE: not just for debugging
  }

  void reformatPlayer1Field({bool newValue: false, int value: -1}) {
    if (newValue)
      updatedPlayer1Field(value); //also updates variables internally
    p1ScoreString = numberDecoration(player1Score);

    //actually trigger changes in the form
    player1Controller.text = p1ScoreString;
  }

  void reformatPlayer2Field({bool newValue: false, int value: -1}) {
    if (newValue)
      updatedPlayer2Field(value); //also updates variables internally
    p2ScoreString = numberDecoration(player2Score);

    //actually trigger changes in the form
    player2Controller.text = p2ScoreString;
  }

  /// --------------------------------------------------OVERRIDES--------------------------------------------------

  @override
  void initState() {
    //init our parent before ourselves to avoid any strange behavior
    super.initState();

    //can be used to limit device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    //set initial value of split count
    player1Score = 0;
    player2Score = 0;

    player1Controller.text = "0";
    player2Controller.text = "0";

    player1FocusNode.addListener(() {
      if (player1FocusNode.hasFocus == false) {
        reformatPlayer1Field();
      } else {
        //TODO... temporary fix
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });

    player2FocusNode.addListener(() {
      if (player2FocusNode.hasFocus == false) {
        reformatPlayer2Field();
      } else {
        //TODO... temporary fix
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            new Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 8.0),
                    alignment: Alignment.center,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(bottom: 16.0),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: textPeach,
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      width: 90,
                      height: 4,
                    ),
                  ),
                  playerPointsSection(
                      isPlayer1: true, name: widget.player1Name),
                  playerPointsSection(
                      isPlayer1: false, name: widget.player2Name),
                  TimerExample(
                      timerKey: _timerKey, matchTime: widget.matchTime),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        border: new Border.all(color: Colors.white),
                      ),
                      child: new FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: new Text(
                          "End Match",
                          style: textMediumPeach,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playerPointsSection({bool isPlayer1, String name}) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            child: new Text(
              name,
              style: TextStyle(
                color: textGrey,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Container(
                    height: 50,
                    padding: EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(50.0)),
                      gradient: LinearGradient(
                        colors: [gradientLight, gradientDark],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.centerRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                            width: 40,
                            height: 40,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                const Radius.circular(50.0),
                              ),
                              border: new Border.all(color: Colors.white),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (isPlayer1) {
                                  reformatPlayer1Field(
                                      newValue: true, value: player1Score - 1);
                                } else {
                                  reformatPlayer2Field(
                                      newValue: true, value: player2Score - 1);
                                }
                              },
                              child: new Icon(
                                Icons.remove,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Transform.translate(
                              offset: Offset(0, 4),
                              child: new Container(
                                child: TextFormField(
                                  maxLengthEnforced: true,
                                  maxLength: 9,
                                  //1,000,000 is our limit... 7 digits, 2 spacers
                                  focusNode: (isPlayer1)
                                      ? player1FocusNode
                                      : player2FocusNode,
                                  controller: (isPlayer1)
                                      ? player1Controller
                                      : player2Controller,
                                  textAlign: TextAlign.center,
                                  autocorrect: false,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      enabled: false,
                                      contentPadding: EdgeInsets.all(0.0),
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                      ),
                                      hintText: "0",
                                      //hide the text limit
                                      helperStyle: TextStyle(
                                        height: 0,
                                        fontSize: 0,
                                        color: Colors.transparent,
                                      )),
                                  inputFormatters: [
                                    NaturalNumberFormatter((isPlayer1)
                                        ? updatedPlayer1Field
                                        : updatedPlayer2Field),
                                  ],
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  },
                                ),
                              ),
                            ),
                          ),
                          new Container(
                            width: 40,
                            height: 40,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                const Radius.circular(50.0),
                              ),
                              border: new Border.all(color: Colors.white),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (isPlayer1) {
                                  reformatPlayer1Field(
                                      newValue: true, value: player1Score + 1);
                                } else {
                                  reformatPlayer2Field(
                                      newValue: true, value: player2Score + 1);
                                }
                              },
                              child: new Icon(
                                Icons.add,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  /// --------------------------------------------------UTILITY FUNCTIONS--------------------------------------------------

  String numberDecoration(int number) {
    String numberString = number.toString();
    numberString = addSpacersString(numberString, '', ',');
    return numberString;
  }
}
