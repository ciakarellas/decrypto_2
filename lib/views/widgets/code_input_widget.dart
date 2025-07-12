import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  final Function(String) onSubmit;

  const CodeInputWidget({super.key, required this.onSubmit});

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  final List<String> _selectedNumbers = [];

  void _toggleNumber(String number) {
    setState(() {
      if (_selectedNumbers.contains(number)) {
        // Remove number if already selected
        _selectedNumbers.remove(number);
      } else if (_selectedNumbers.length < 3) {
        // Add number if less than 3 are selected
        _selectedNumbers.add(number);
      }

      // Auto-submit when exactly 3 numbers are selected
      if (_selectedNumbers.length == 3) {
        final code = _selectedNumbers.join();
        widget.onSubmit(code);
      }
    });
  }

  bool _isSelected(String number) {
    return _selectedNumbers.contains(number);
  }

  String _getDisplayCode() {
    if (_selectedNumbers.isEmpty) {
      return 'Select 3 numbers';
    }

    final code = _selectedNumbers.join();
    return code.padRight(3, '_');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display current code
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Text(
            _getDisplayCode(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Number buttons in a grid layout
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildToggleButton('1'),
            _buildToggleButton('2'),
            _buildToggleButton('3'),
            _buildToggleButton('4'),
          ],
        ),
        const SizedBox(height: 16),
        // Instructions
        Text(
          'Select exactly 3 numbers',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String number) {
    final isSelected = _isSelected(number);
    final canSelect = _selectedNumbers.length < 3 || isSelected;

    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        onPressed: canSelect ? () => _toggleNumber(number) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Colors.green
              : Theme.of(context).colorScheme.surface,
          foregroundColor: isSelected
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          elevation: isSelected ? 8 : 2,
          shadowColor: isSelected ? Colors.green.withValues(alpha: 0.5) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: isSelected
                ? Colors.green
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
        child: Text(
          number,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
