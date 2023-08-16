import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/ui/pages/event_page/buy_popup.dart';

class SeatCatalogWidget extends StatefulWidget {
  final List<Ticket> tickets;
  final Event event;
  final bool isAllInPricing;

  const SeatCatalogWidget(
      {required this.tickets,
      required this.event,
      required this.isAllInPricing});

  @override
  _SeatCatalogWidgetState createState() => _SeatCatalogWidgetState();
}

class _SeatCatalogWidgetState extends State<SeatCatalogWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.tickets.map((ticket) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
            child: GestureDetector(
              onTap: () {
                debugPrint('Ticket: ${ticket.ticketId}');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BuyTicketPopup(ticket: ticket);
                  },
                );
              },
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0xFF6548EA),
                      blurRadius: 4,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: _buildInside(ticket),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Padding _buildInside(Ticket ticket) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTicketInfoText(ticket),
              const Text(
                'Verified Resale',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          _buildPrice(ticket, widget.isAllInPricing),
        ],
      ),
    );
  }

  Text _buildTicketInfoText(Ticket ticket) {
    return Text(
      'Section ${ticket.section} · Row ${ticket.row} · Seat ${ticket.seatNumber}',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }

  Text _buildPrice(Ticket ticket, bool isAllInPricing) {
    double finalPrice = ticket.price;
    if (isAllInPricing) {
      finalPrice = (finalPrice * 1.17);
      finalPrice = (finalPrice * 100).round() / 100;
    }

    return Text(
      '\$${finalPrice.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF853FF8),
      ),
    );
  }
}
