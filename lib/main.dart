import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:numbers_to_words_russian/numbers_to_words_russian.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Random number'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final minController = TextEditingController();
  final maxController = TextEditingController();
  int randomNumber = 0;
  var visibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: minController,
              onChanged: (value) {
                minController.text = value.isNotEmpty
                    ? formatNumber(num.parse(value.replaceAll(' ', '')))
                    : '';
                setState(() {});
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: 'min',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                maxController.text = value.isNotEmpty
                    ? formatNumber(num.parse(value.replaceAll(' ', '')))
                    : '';
                setState(() {});
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: 'max',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Number: ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: randomNumber == 0 ? '' : formatNumber(randomNumber),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  visibility = !visibility;
                  setState(() {});
                },
                icon:
                    Icon(visibility ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Number in russian: ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: randomNumber != 0 && visibility
                        ? NumbersToWordsRussian.convert(randomNumber)
                        : '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  if (minController.text.isNotEmpty &&
                      maxController.text.isNotEmpty) {
                    var min = int.parse(minController.text.replaceAll(' ', ''));
                    var max = int.parse(maxController.text.replaceAll(' ', ''));
                    randomNumber = min + Random().nextInt(max + 1 - min);
                  } else {
                    randomNumber = 0;
                  }
                  visibility = false;
                  setState(() {});
                },
                child: const Text('Generate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatNumber(num number) {
  final String stringValue = number.toString();
  final bool isNegative = (number).isNegative;

  final List<String> parts = stringValue.split('.');
  final String wholePart = parts[0];
  final String decimalPart = parts.length > 1 ? parts[1] : '';

  final RegExp regex = RegExp(r'\B(?=(\d{3})+(?!\d))');
  String formattedWholePart =
      wholePart.replaceAllMapped(regex, (match) => '${match.group(0)} ');

  if (isNegative) {
    formattedWholePart = '-$formattedWholePart';
  }

  if (decimalPart == '0') {
    return formattedWholePart;
  } else if (decimalPart.isNotEmpty) {
    return '$formattedWholePart.$decimalPart';
  } else {
    return formattedWholePart;
  }
}
