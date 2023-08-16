import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/shared/break_even.dart';
import 'package:tw_mobile/ui/shared/price_projection.dart';
import 'package:tw_mobile/ui/shared/sales_history.dart';
import 'package:tw_mobile/ui/theme/themes.dart';
import 'package:tw_mobile/data/mock_price_data.dart';
import 'package:tw_mobile/data/mock_sales_data.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _BuildTopBanner(),
              const SizedBox(height: 15),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  int itemCount = constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: itemCount,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GlowContainer(
                          text: 'Price Projection',
                          button: _priceProjectionButton(),
                          child: LineChartWidget(pricePoints),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GlowContainer(
                          text: 'Sales History',
                          child: SalesHistory(sales: sales, amount: 4),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GlowContainer(
                          text: 'Break Even',
                          child: BreakEven(),
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildTopBanner extends StatelessWidget {
  const _BuildTopBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'lib/assets/title_banner.png',
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Positioned.fill(
          left: 10,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Stats',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: defaultTheme,
      home: const StatsPage(),
    );
  }
}

class GlowContainer extends StatelessWidget {
  final Widget child;
  final String? text;
  final Widget? button;

  const GlowContainer({Key? key, required this.child, this.text, this.button})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      height: 200,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFF6B94FF),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                text!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: child,
            ),
          ),
          if (button != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: button,
            ),
        ],
      ),
    );
  }
}

Widget _priceProjectionButton() {
  return GestureDetector(
    onTap: () {
      debugPrint('Choose game button tapped.');
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
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'CHOOSE GAME',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
