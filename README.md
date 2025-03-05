# Drop Animation

A simple Flutter package that provides a drop animation widget to create beautiful water drop effects in your Flutter applications.
![832738ac-2714-4c08-9b0d-a5339b27c3a3](https://github.com/user-attachments/assets/f3c495a3-3a73-418d-a3ad-587b8b72662c)

## Features

- **Animated Drop Effect:** Simulate a falling drop with a smooth splash effect.
- **Customizable:** Easily adjust the drop's size, color, fall height, and animation duration.
- **Dynamic Interaction:** Trigger new drops dynamically via a global method.
- **Easy Integration:** Designed for quick integration into your existing Flutter projects.

## Getting Started

1. **Add Dependency:**  
   Add `drop_animation` to your project's `pubspec.yaml` file:

   ```yaml
   dependencies:
     drop_animation: ^0.0.1
   ```

2. **Install the Package:**  
   Run the following command in your terminal:
   
   ```bash
   flutter pub get
   ```

## Usage

Import the package in your Dart file and use the `DropAnimationScreen` widget. For example:

```dart
import 'package:flutter/material.dart';
import 'package:my_drop_animation/drop_animation.dart';

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
            children: [
              Expanded(child: DropAnimationScreen()),
              ElevatedButton(
                onPressed: () {
                  // Trigger a new drop animation.
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
```

For a more complete example, check the `/example` folder included in the package.

## Additional Information

- **Repository:**  
  For more details, to contribute, or to file issues, please visit the [GitHub repository](https://github.com/mustafakilic097/drop_animation.git).

- **Contributing:**  
  Contributions are welcome! Feel free to open issues or submit pull requests with improvements.

- **License:**  
  This package is released under the MIT License. See the [LICENSE](LICENSE) file for details.
