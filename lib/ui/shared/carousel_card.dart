import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselCard extends StatefulWidget {
  @override
  State<CarouselCard> createState() => CarouselCardState();
}

class CarouselCardState extends State<CarouselCard> {
  final controller = CarouselController();
  int activeIndex = 0;
  final slides = [
    const WalletSlide(),
    const Placeholder(),
    const Placeholder(),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CarouselSlider.builder(
            carouselController: controller,
            itemCount: slides.length,
            options: CarouselOptions(
              height: 350,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) =>
                  setState(() => activeIndex = index),
            ),
            itemBuilder: (context, index, realIndex) {
              final slide = slides[index];
              return buildImage(slide, index);
            },
          ),
          const SizedBox(height: 20),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: slides.length,
        onDotClicked: animateToSlide,
        effect: const JumpingDotEffect(
          activeDotColor: Color.fromRGBO(134, 64, 249, 1),
        ),
      );

  Widget buildImage(StatelessWidget image, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: image,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

class WalletSlide extends StatelessWidget {
  const WalletSlide();
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              "Less Work. More Money.",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 20,
                    color: const Color.fromRGBO(10, 17, 88, 1),
                  ),
            ),
            const SizedBox(height: 10),
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
              scale: 3,
            ),
          ],
        ),
      ),
    );
  }
}
