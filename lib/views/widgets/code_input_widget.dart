import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  final Function(String) onSubmit;

  const CodeInputWidget({super.key, required this.onSubmit});

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  String _currentCode = '';

  void _addNumber(String number) {
    if (_currentCode.length < 3) {
      setState(() {
        _currentCode += number;
      });
    }
  }

  void _clearCode() {
    setState(() {
      _currentCode = '';
    });
  }

  void _submitCode() {
    if (_currentCode.length == 3) {
      widget.onSubmit(_currentCode);
      _clearCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display current code
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _currentCode.isEmpty ? 'Enter Code' : _currentCode.padRight(3, '_'),
            style: const TextStyle(fontSize: 24, letterSpacing: 8),
          ),
        ),
        // Number buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
            _buildNumberButton('4'),
          ],
        ),
        const SizedBox(height: 20),
        // Action buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Clear button
            ElevatedButton(
              onPressed: _currentCode.isNotEmpty ? _clearCode : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Icon(Icons.clear),
            ),
            // Submit button (tick)
            ElevatedButton(
              onPressed: _currentCode.length == 3 ? _submitCode : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () => _addNumber(number),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        number,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
