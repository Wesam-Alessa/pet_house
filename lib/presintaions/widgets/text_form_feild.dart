import 'package:flutter/material.dart'; 

class TextFormFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
   final bool number;
   const TextFormFieldWidget(
      {Key? key, required this.title, required this.controller, this.number = false })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: number? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.grey.shade700),
      cursorColor: Colors.grey.shade700,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: title,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: Colors.grey.shade700),
        ),
      ),
    );
  }
}
