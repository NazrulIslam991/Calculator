import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Calculator(), debugShowCheckedModeBanner: false);
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool isResultShown = false;
  final List<String> buttons = [
    'C',
    '⌫',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '.',
    '0',
    '00',
    '=',
  ];

  final List<Color> buttonColors = [
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.blue,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.blue,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.blue,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.grey[800]!,
    Colors.blue,
  ];

  String history = '';
  String result = '0';

  void onButtonPress(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        history = '';
        result = '0';
        isResultShown = false;
      } else if (buttonText == '⌫') {
        if (history.isNotEmpty) {
          history = history.substring(0, history.length - 1);
        }
        if (history.isEmpty) {
          result = '0';
        }
        isResultShown = false;
      } else if (buttonText == '=') {
        if (!isResultShown) {
          try {
            String finalExpression = history
                .replaceAll('%', '')
                .replaceAll('×', '*')
                .replaceAll('÷', '/');
            Parser p = Parser();
            Expression exp = p.parse(finalExpression);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);
            result = eval.toString();
            isResultShown = true;
          } catch (e) {
            result = 'error';
          }
        } else {
          history = result;
          result = '0';
          isResultShown = false;
        }
      } else if (buttonText == '%') {
        try {
          if (history.contains('×') &&
              !history.contains('+') &&
              !history.contains('-') &&
              !history.contains('÷')) {
            List<String> parts = history.split('×');
            if (parts.length == 2) {
              double firstOperand = double.parse(parts[0]);
              double secondOperand = double.parse(parts[1]);

              double percentResult = firstOperand * (secondOperand / 100);
              result = percentResult.toString();
              history += '%';
            } else {
              result = 'error';
            }
          } else {
            result = 'error';
          }
          isResultShown = true;
        } catch (e) {
          result = 'error';
        }
      } else {
        if (isResultShown) {
          history = buttonText;
          isResultShown = false;
        } else {
          history += buttonText;
        }
        result = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // History container
            Container(
              height: 110,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.bottomRight,
              color: Colors.black38,
              child: Text(
                history, // Show history
                style: TextStyle(color: Colors.grey[400], fontSize: 24),
              ),
            ),

            // Result container
            Container(
              height: 90,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.bottomRight,
              color: Colors.black26,
              child: Text(
                result, // Show result
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            SizedBox(height: 30),

            // Grid of buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.08,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    return _calcButton(buttons[index], buttonColors[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Button widget
  Widget _calcButton(String buttonText, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color, // Button color
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () => onButtonPress(buttonText), // Handle button press
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
