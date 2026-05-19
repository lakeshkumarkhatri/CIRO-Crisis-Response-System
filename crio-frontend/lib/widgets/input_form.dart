import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final TextEditingController socialController;
  final TextEditingController locationController;

  const InputForm({
    Key? key,
    required this.socialController,
    required this.locationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: socialController,
          decoration: const InputDecoration(
            labelText: 'Social media post / crisis description',
            border: OutlineInputBorder(),
            hintText: 'e.g., "Flash flood at G-10, cars stuck"',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: locationController,
          decoration: const InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(),
            hintText: 'e.g., "Islamabad, Pakistan"',
          ),
        ),
      ],
    );
  }
}