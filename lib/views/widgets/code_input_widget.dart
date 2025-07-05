import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  final Function(String) onSubmit;

  const CodeInputWidget({super.key, required this.onSubmit});

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            maxLength: 3,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              labelText: 'Enter Code',
              counterText: '',
            ),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.length == 3) {
              widget.onSubmit(_controller.text);
              _controller.clear();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
