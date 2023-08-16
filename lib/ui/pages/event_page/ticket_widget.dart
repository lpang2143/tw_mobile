import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_mobile/ui/pages/event_page/buy_popup.dart';

class TicketButtonWidget extends StatefulWidget {
  final List<Ticket> tickets;
  final Event event;
  final bool isAllInPricing;

  const TicketButtonWidget(
      {required this.tickets,
      required this.event,
      required this.isAllInPricing});

  @override
  _TicketButtonWidgetState createState() => _TicketButtonWidgetState();
}

class _TicketButtonWidgetState extends State<TicketButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.tickets
            .map((ticket) => Padding(
                  padding: const EdgeInsets.only(right: 5.0),
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
                      child: _buildTicketButton(context, ticket)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTicketButton(BuildContext context, Ticket ticket) {
    return Container(
      height: 180,
      width: 190,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          _buildOutlineContainer(),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 25),
              _buildLogoRow(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      _buildPrice(context, ticket, widget.isAllInPricing),
                      const SizedBox(width: 10),
                      Container(
                        height: 30,
                        width: 1.25,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionText(ticket),
                      _buildRowSeatText(ticket),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineContainer() {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFF6548EA),
            blurRadius: 6,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
    );
  }

  Widget _buildPrice(BuildContext context, Ticket ticket, bool isAllInPricing) {
    double finalPrice = ticket.price;
    if (isAllInPricing) {
      finalPrice = (finalPrice * 1.17);
      finalPrice = (finalPrice * 100).round() / 100;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        '\$${finalPrice.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6548EA),
        ),
      ),
    );
  }

  Widget _buildLogoRow() {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            child: _buildLogoCircle(
                const Color(0xFF6548EA), widget.event.awayTeam.logoPath),
          ),
          Positioned(
            right: 15,
            child: _buildLogoCircle(
                const Color(0xFF6548EA), widget.event.homeTeam.logoPath),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoCircle(Color color, String logoPath) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 3,
            spreadRadius: 2,
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(logoPath, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildSectionText(Ticket ticket) {
    return Text(
      'Section ${ticket.section}',
      style: const TextStyle(
        fontSize: 10,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildRowSeatText(Ticket ticket) {
    return Text(
      'Row ${ticket.row} - Seat ${ticket.seatNumber}',
      style: const TextStyle(
        fontSize: 8,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
