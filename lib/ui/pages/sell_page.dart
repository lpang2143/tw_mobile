import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/pages/stats_page.dart';
import 'package:tw_mobile/ui/pages/list_tickets_page/list_tickets_page.dart';

Map<String, ButtonType> buttonTypes = {
  'UPLOAD': const ButtonType(
    buttonIcon: Icon(Icons.arrow_upward, color: Colors.white, size: 40),
    buttonLabel: 'UPLOAD',
    buttonColor: Color(0xFFCA92DE),
  ),
  'SELL': const ButtonType(
    buttonIcon: Icon(Icons.attach_money_sharp, color: Colors.white, size: 40),
    buttonLabel: 'SELL',
    buttonColor: Color(0xFF30C5BD),
  ),
  'STATS': const ButtonType(
    buttonIcon: Icon(Icons.query_stats_sharp, color: Colors.white, size: 40),
    buttonLabel: 'STATS',
    buttonColor: Color(0xFFDF7070),
  ),
  'ACTIVE': const ButtonType(
    buttonIcon: Icon(Icons.av_timer, color: Colors.white, size: 25),
    buttonLabel: 'ACTIVE LISTINGS',
    buttonColor: Color(0xFF676C98),
  ),
  'SOLD': const ButtonType(
    buttonIcon: Icon(Icons.check, color: Colors.white, size: 25),
    buttonLabel: 'SOLD',
    buttonColor: Color(0xFF676C98),
  ),
};

class ButtonType {
  const ButtonType({
    required this.buttonIcon,
    required this.buttonLabel,
    required this.buttonColor,
  });

  final Icon buttonIcon;
  final String buttonLabel;
  final Color buttonColor;
}

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: mediaPadding.top),
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                const Positioned.fill(
                  top: 220,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(107, 149, 255, 1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          topRight: Radius.circular(70)),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const WalletImage(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Actions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const ActionsButtonRow(),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'My Tickets',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const MyTicketsButtonRow(),
                    const SizedBox(height: 50),
                    InstructionLine(side: 'top'),
                    SizedBox(height: 15),
                    Text(
                      'Sell Tickets in 3 Easy Steps',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const InstructionRow(),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See More',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    InstructionLine(side: 'bottom'),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WalletImage extends StatelessWidget {
  const WalletImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Less Work. More Money.",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 25,
                color: const Color.fromRGBO(10, 17, 88, 1),
              ),
        ),
        const SizedBox(height: 5),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "Sell your tickets smarter \nusing our ",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 18.2,
                    color: const Color.fromRGBO(10, 17, 88, .47),
                  ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'AI pricing',
                  style: TextStyle(color: Color.fromRGBO(98, 91, 246, 1)),
                ),
              ]),
        ),
        const SizedBox(height: 25),
        Image.asset(
          "lib/assets/carousel/wallet.png",
          scale: 4,
        ),
      ],
    );
  }
}

class InstructionLine extends StatelessWidget {
  const InstructionLine({super.key, required this.side});

  final String side;

  @override
  Widget build(BuildContext context) {
    if (side == 'top') {
      return CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 35),
        painter: InstructionPainterTop(),
      );
    }
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 35),
      painter: InstructionPainterBottom(),
    );
  }
}

class InstructionPainterTop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8
      ..color = const Color(0xFF8640F9);

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF8640F9).withOpacity(0.08)
      ..strokeWidth = 8;

    path.moveTo(0, size.height * 1);
    path.lineTo(size.width * 3 / 16, size.height * 1);
    path.lineTo(size.width * 4 / 16, size.height * 0);
    path.lineTo(size.width * 12 / 16, size.height * 0);
    path.lineTo(size.width * 13 / 16, size.height * 1);
    path.lineTo(size.width * 1, size.height * 1);

    canvas.drawPath(path, paint);
    canvas.drawPath(path.shift(const Offset(0, -3)), paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class InstructionPainterBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8
      ..color = const Color(0xFF8640F9);

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF8640F9).withOpacity(0.08)
      ..strokeWidth = 8;

    path.moveTo(0, size.height * 0);
    path.lineTo(size.width * 3 / 16, size.height * 0);
    path.lineTo(size.width * 4 / 16, size.height * 1);
    path.lineTo(size.width * 12 / 16, size.height * 1);
    path.lineTo(size.width * 13 / 16, size.height * 0);
    path.lineTo(size.width * 1, size.height * 0);

    canvas.drawPath(path, paint);
    canvas.drawPath(path.shift(const Offset(0, 3)), paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class InstructionRow extends StatelessWidget {
  const InstructionRow({super.key});

  // String interpolation for filepaths will be added
  // final String baseImagePath = 'lib/assets/sell_page_images/';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InstructionColumn(
              imagePath: 'lib/assets/sell_page_images/iphonex.png',
              label: 'Upload'),
          InstructionColumn(
              imagePath: 'lib/assets/sell_page_images/doorbell.png',
              label: 'Tap Sell'),
          InstructionColumn(
              imagePath: 'lib/assets/sell_page_images/stackofmoney.png',
              label: 'Get Paid'),
        ],
      ),
    );
  }
}

class MyTicketsButtonRow extends StatelessWidget {
  const MyTicketsButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyTicketsButtonColumn(
          type: buttonTypes['ACTIVE']!,
          onTap: () {
            debugPrint('Active tapped.');
          },
        ),
        MyTicketsButtonColumn(
          type: buttonTypes['SOLD']!,
          onTap: () {
            debugPrint('Sold tapped.');
          },
        ),
      ],
    );
  }
}

class ActionsButtonRow extends StatelessWidget {
  const ActionsButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ActionButtonColumn(
          type: buttonTypes['UPLOAD']!,
          onTap: () {
            debugPrint('Upload tapped.');
          },
        ),
        ActionButtonColumn(
          type: buttonTypes['SELL']!,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListTicketsPage()));
          },
        ),
        ActionButtonColumn(
          type: buttonTypes['STATS']!,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StatsPage()));
          },
        ),
      ],
    );
  }
}

class ActionButtonColumn extends StatelessWidget {
  const ActionButtonColumn({
    super.key,
    required this.type,
    required this.onTap,
  });

  final ButtonType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 100,
            width: 100,
            child: MaterialButton(
                onPressed: onTap,
                color: type.buttonColor,
                padding: const EdgeInsets.all(15),
                shape: const CircleBorder(),
                elevation: 0,
                child: type.buttonIcon)),
        const SizedBox(height: 8),
        Text(type.buttonLabel,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }
}

class MyTicketsButtonColumn extends StatelessWidget {
  const MyTicketsButtonColumn({
    super.key,
    required this.type,
    required this.onTap,
  });

  final ButtonType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 80,
            width: 150,
            child: MaterialButton(
                onPressed: onTap,
                color: type.buttonColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11))),
                elevation: 0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: type.buttonColor,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          )),
                    ),
                    type.buttonIcon
                  ],
                ))),
        const SizedBox(height: 8),
        Text(type.buttonLabel,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }
}

class InstructionColumn extends StatelessWidget {
  const InstructionColumn(
      {super.key, required this.imagePath, required this.label});

  final String imagePath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 0.5)),
            ),
            Image(
              image: AssetImage(imagePath),
              height: 30,
              width: 30,
            ),
          ],
        ),
        Text(label, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}

// Uncomment and run this to test just the sell page
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: defaultTheme,
//       home: const SellPage(),
//     );
//   }
// }
