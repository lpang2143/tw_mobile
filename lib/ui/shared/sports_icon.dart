import 'package:flutter/material.dart';

class SportData {
  final String label;
  final Widget logo;

  SportData({required this.label, required this.logo});
}

class SportsIcons extends StatefulWidget {
  final List<SportData> sportsData;
  final void Function(String sport) updateFunction; // New callback

  SportsIcons({
    required this.sportsData,
    required this.updateFunction,
  });

  @override
  SportsIconsState createState() => SportsIconsState();
}

class SportsIconsState extends State<SportsIcons> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.sportsData.length,
        itemBuilder: (context, index) {
          final data = widget.sportsData[index];
          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: SportButton(
              label: data.label,
              logo: data.logo,
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.updateFunction(data.label); // Pass the selected sport
                debugPrint('${data.label} pressed!');
              },
              isSelected: isSelected,
            ),
          );
        },
      ),
    );
  }
}

class SportButton extends StatelessWidget {
  final String label;
  final Widget logo;
  final VoidCallback onPressed;
  final bool isSelected;

  const SportButton({
    required this.label,
    required this.logo,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: isSelected
              ? const Color.fromRGBO(98, 91, 246, 1)
              : const Color.fromRGBO(242, 242, 242, 1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        backgroundColor:
            isSelected ? const Color.fromRGBO(98, 91, 246, 0.3) : Colors.white,
        shadowColor: Colors.transparent,
      ),
      child: Row(
        children: [
          SizedBox(height: 35, width: 25, child: logo),
          // const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
