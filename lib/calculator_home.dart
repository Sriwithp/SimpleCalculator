import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  var expression = "";
  var result = "0";
  @override
  Widget build(BuildContext context) {
    List padValue = [
      "AC",
      "!",
      "%",
      "⌫",
      "7",
      "8",
      "9",
      "÷",
      "4",
      "5",
      "6",
      "x",
      "1",
      "2",
      "3",
      "-",
      "0",
      ".",
      "=",
      "+",
    ];
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: mediaQuery.width,
            height: mediaQuery.height * .3,
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.width * 0.08,
              horizontal: mediaQuery.width * 0.06,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 20.0,
                  child: Text(expression, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(height: 10.0),
                const Divider(),
                const SizedBox(height: 10.0),
                Text(
                  result,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.pink,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GridView.builder(
              primary: false,
              reverse: false,
              itemCount: padValue.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15.0),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5.0,
                // childAspectRatio: 1.3,
                mainAxisSpacing: 5.0,
                crossAxisCount: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: padValue[index] == "="
                          ? const MaterialStatePropertyAll(Colors.green)
                          : null),
                  onPressed: () {
                    addInput(padValue[index]);
                  },
                  child: Text(padValue[index],
                      style: const TextStyle(
                          // color: padValue[index] == "=" ? Colors.pink : null,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addInput(String value) {
    if (value == "AC") {
      expression = "";
      result = "0";
    } else if (value == "⌫") {
      expression = expression.substring(0, expression.length - 1);
    } else if (value == "=") {
      if (expression.endsWith("+") ||
          expression.endsWith("-") ||
          expression.endsWith("x") ||
          expression.endsWith("÷")) {
        expression = expression.substring(0, expression.length - 1);
      }
    }
    //else if (expression.startsWith("%") ||
    //     expression.startsWith("x") ||
    //     expression.startsWith("÷")) {

    // }
    else {
      expression += value;
    }
    setState(() {
      if (expression.isNotEmpty &&
              !expression.endsWith("+") &&
              !expression.endsWith("-") &&
              !expression.endsWith("x") &&
              !expression.endsWith("÷") ||
          expression.endsWith("%")) {
        var expressions = expression
            .replaceAll("x", "*")
            .replaceAll("÷", "/")
            .replaceAll("%", "/100");
        Parser parser = Parser();
        Expression exp = parser.parse(expressions);
        result = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
        if (result.endsWith(".0")) {
          result = result.substring(0, result.length - 2);
        }
      }
    });
  }
}
