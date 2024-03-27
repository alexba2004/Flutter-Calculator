import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      home: FlutterCalculator(),
    );
  }
}

const Color colorDark = Color.fromARGB(255, 45, 70, 101);
const Color colorLight = Color.fromARGB(255, 255, 255, 255);

class FlutterCalculator extends StatefulWidget {
  @override
  _FlutterCalculatorState createState() => _FlutterCalculatorState();
}

class _FlutterCalculatorState extends State<FlutterCalculator> {
  bool darkMode = false;
  String _expression = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            darkMode = !darkMode;
                          });
                        },
                        child: _switchMode()),
                    SizedBox(height: 80),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _expression.isEmpty ? '0' : _expression,
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: darkMode
                                ? Colors.white
                                : Color.fromARGB(255, 6, 14, 101)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              Container(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonOval(
                          title: 'sin',
                          onPressed: () => _appendCharacter('sin(')),
                      _buttonOval(
                          title: 'cos',
                          onPressed: () => _appendCharacter('cos(')),
                      _buttonOval(
                          title: 'tan',
                          onPressed: () => _appendCharacter('tan(')),
                      _buttonOval(
                          title: '%', onPressed: () => _appendCharacter('%'))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: 'C',
                          onPressed: _clearExpression,
                          textColor: darkMode
                              ? const Color.fromARGB(255, 185, 78, 78)
                              : const Color.fromARGB(255, 6, 14, 101)),
                      _buttonRounded(
                          title: '(', onPressed: () => _appendCharacter('(')),
                      _buttonRounded(
                          title: ')', onPressed: () => _appendCharacter(')')),
                      _buttonRounded(
                          title: '/',
                          onPressed: () => _appendCharacter('/'),
                          textColor: darkMode
                              ? const Color.fromARGB(255, 185, 78, 78)
                              : const Color.fromARGB(255, 6, 14, 101))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '7', onPressed: () => _appendCharacter('7')),
                      _buttonRounded(
                          title: '8', onPressed: () => _appendCharacter('8')),
                      _buttonRounded(
                          title: '9', onPressed: () => _appendCharacter('9')),
                      _buttonRounded(
                          title: 'x',
                          onPressed: () => _appendCharacter('*'),
                          textColor: darkMode
                              ? const Color.fromARGB(255, 185, 78, 78)
                              : const Color.fromARGB(255, 6, 14, 101))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '4', onPressed: () => _appendCharacter('4')),
                      _buttonRounded(
                          title: '5', onPressed: () => _appendCharacter('5')),
                      _buttonRounded(
                          title: '6', onPressed: () => _appendCharacter('6')),
                      _buttonRounded(
                          title: '-',
                          onPressed: () => _appendCharacter('-'),
                          textColor: darkMode
                              ? const Color.fromARGB(255, 185, 78, 78)
                              : const Color.fromARGB(255, 6, 14, 101))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '1', onPressed: () => _appendCharacter('1')),
                      _buttonRounded(
                          title: '2', onPressed: () => _appendCharacter('2')),
                      _buttonRounded(
                          title: '3', onPressed: () => _appendCharacter('3')),
                      _buttonRounded(
                          title: '+',
                          onPressed: () => _appendCharacter('+'),
                          textColor: darkMode
                              ? const Color.fromARGB(255, 185, 78, 78)
                              : Color.fromARGB(255, 6, 14, 101))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '0', onPressed: () => _appendCharacter('0')),
                      _buttonRounded(
                          title: ',', onPressed: () => _appendCharacter('.')),
                      _buttonRounded(
                          icon: Icons.backspace_outlined,
                          iconColor: darkMode
                              ? const Color.fromARGB(255, 185, 78, 78)
                              : const Color.fromARGB(255, 6, 14, 101),
                          onPressed: _removeLastCharacter),
                      _buttonRounded(
                          title: '=',
                          onPressed: _calculateExpression,
                          textColor: darkMode
                              ? const Color.fromARGB(255, 185, 78, 78)
                              : const Color.fromARGB(255, 6, 14, 101))
                    ],
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _appendCharacter(String character) {
    setState(() {
      _expression += character;
    });
  }

  void _removeLastCharacter() {
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    });
  }

  void _clearExpression() {
    setState(() {
      _expression = '';
    });
  }

  void _calculateExpression() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _expression = eval.toString();
      });
    } catch (e) {
      setState(() {
        _expression = 'Error';
      });
    }
  }

  Widget _buttonRounded(
      {String? title,
      double padding = 17,
      IconData? icon,
      Color? iconColor,
      Color? textColor,
      Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: NeuContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(40),
        padding: EdgeInsets.all(padding),
        onPressed: onPressed,
        child: Container(
          width: padding * 2,
          height: padding * 2,
          child: Center(
              child: title != null
                  ? Text(
                      '$title',
                      style: TextStyle(
                          color: textColor != null
                              ? textColor
                              : darkMode
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 30),
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                      size: 30,
                    )),
        ),
      ),
    );
  }

  Widget _buttonOval(
      {String? title, double padding = 17, Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: NeuContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(50),
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
        onPressed: onPressed,
        child: Container(
          width: padding * 2,
          child: Center(
            child: Text(
              '$title',
              style: TextStyle(
                  color: darkMode
                      ? const Color.fromARGB(255, 185, 78, 78)
                      : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return NeuContainer(
      darkMode: darkMode,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      borderRadius: BorderRadius.circular(0),
      onPressed: () {
        setState(() {
          darkMode = !darkMode;
        });
      },
      child: Container(
        width: 70,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(
            Icons.wb_sunny,
            color:
                darkMode ? Colors.grey : const Color.fromARGB(255, 6, 14, 101),
          ),
          Icon(
            Icons.nightlight_round,
            color: darkMode ? Color.fromARGB(255, 185, 78, 78) : Colors.grey,
          ),
        ]),
      ),
    );
  }
}

class NeuContainer extends StatefulWidget {
  final bool darkMode;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Function()? onPressed;

  NeuContainer(
      {this.darkMode = false,
      required this.child,
      required this.borderRadius,
      required this.padding,
      this.onPressed});

  @override
  _NeuContainerState createState() => _NeuContainerState();
}

class _NeuContainerState extends State<NeuContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    bool darkMode = widget.darkMode;
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
            color: darkMode ? colorDark : colorLight,
            borderRadius: widget.borderRadius,
            boxShadow: _isPressed
                ? null
                : [
                    BoxShadow(
                      color:
                          darkMode ? Colors.black54 : Colors.blueGrey.shade200,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                        color:
                            darkMode ? Colors.blueGrey.shade700 : Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0)
                  ]),
        child: widget.child,
      ),
    );
  }
}
