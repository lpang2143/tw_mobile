import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/ui/shared/ticket_dialog.dart';

class ScanSide extends StatefulWidget {
  final List<SeatObject> seatObjects;
  final Event event;
  ScanSide({
    Key? key,
    required this.seatObjects,
    required this.event,
  }) : super(key: key);

  @override
  State<ScanSide> createState() => _ScanSideState();
}

class _ScanSideState extends State<ScanSide> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 500,
          width: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.seatObjects.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      widget.seatObjects[index].barcode,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    QrImageView(
                      data: widget.seatObjects[index].barcode,
                      version: QrVersions.auto,
                      size: 275,
                      gapless: false,
                      errorStateBuilder: (context, error) {
                        return Container(
                          child: const Center(
                            child: Text(
                              'Something went wrong.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      '${widget.seatObjects[index].section} · Row ${widget.seatObjects[index].row} · Seat ${widget.seatObjects[index].seatNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 10,
          top: MediaQuery.of(context).size.height / 2,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _currentIndex == 0
                ? null
                : () {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
          ),
        ),
        Positioned(
          right: 10,
          top: MediaQuery.of(context).size.height / 2,
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _currentIndex == widget.seatObjects.length - 1
                ? null
                : () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 45,
          right: 0,
          left: 0,
          child: BuildBottomText(event: widget.event),
        )
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
