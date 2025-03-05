import 'package:drop_animation/drop_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drop Animation Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Drop Animation Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasyon widget'ı
              Expanded(child: DropAnimationScreen()),
              // Butona basıldığında yeni damla eklenir
              ElevatedButton(
                onPressed: () {
                  DropAnimationScreen.triggerAddDrop();
                },
                child: const Text('Add Drop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
