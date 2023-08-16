import 'package:flutter/material.dart';

class BreakEven extends StatefulWidget {
  @override
  _BreakEvenState createState() => _BreakEvenState();
}

class _BreakEvenState extends State<BreakEven> {
  double _totalCost = 0;
  double _numberOfGames = 0;
  bool _isCostEntered = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: _isCostEntered ? _showSlider() : _enterCost(),
    );
  }

  Widget _enterCost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildEnterCostForm(),
        const SizedBox(
          height: 10,
        ),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildEnterCostForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Enter total cost of season tickets',
          style: TextStyle(fontSize: 16),
        ),
        TextFormField(
          decoration: const InputDecoration(
            hintText: '\$0.00',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _totalCost = double.parse(value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCostEntered = true;
        });
      },
      child: Container(
        width: 125,
        height: 25,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0xFF6B94FF),
              blurRadius: 10,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: const Center(
          child: Text(
            'Submit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Games to attend: ${_numberOfGames.toInt()}',
          style: const TextStyle(fontSize: 12),
        ),
        Slider(
          value: _numberOfGames,
          min: 0,
          max: 100, // adjust the max value according to your season games
          divisions: 100,
          label: _numberOfGames.round().toString(),
          onChanged: (double value) {
            setState(() {
              _numberOfGames = value;
            });
          },
        ),
        Text(
          'Total cost: \$$_totalCost',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
