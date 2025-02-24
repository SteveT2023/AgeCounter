import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    value -= 1;
    notifyListeners();
  }

  void setValue(int newValue) {
    value = newValue;
    notifyListeners();
  }

  String get milestone {
    if (value <= 12) {
      return 'You are a child!';
    } else if (value <= 19) {
      return 'Teenager time!';
    } else if (value <= 30) {
      return 'You are a young adult!';
    } else if (value <= 50) {
      return 'You are an adult!';
    } else {
      return 'Senior';
    }
  }

  Color get milestoneColor {
    if (value <= 12) {
      return Colors.lightBlue;
    } else if (value <= 19) {
      return Colors.greenAccent;
    } else if (value <= 30) {
      return Colors.yellowAccent;
    } else if (value <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: Consumer<Counter>(
        builder: (context, counter, child) => Container(
          color: counter.milestoneColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I am ${counter.value} years old.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Milestone: ${counter.milestone}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Slider(
                  value: counter.value.toDouble(),
                  min: 0,
                  max: 99,
                  divisions: 99,
                  label: counter.value.toString(),
                  onChanged: (double newValue) {
                    counter.setValue(newValue.toInt());
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        var counter = context.read<Counter>();
                        counter.increment();
                      },
                      child: const Text('Increase Age'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        var counter = context.read<Counter>();
                        counter.decrement();
                      },
                      child: const Text('Decrease Age'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}