import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/event_page/seat_catalog_widget.dart';
import 'package:tw_mobile/ui/pages/event_page/ticket_widget.dart';

class EventPage extends StatefulWidget {
  final Event event;

  EventPage({required this.event});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool isAllInPricing = false;
  String selectedView = 'List View';
  Color darkColor = const Color(0xFF091158);
  Color lightPurple = const Color(0xFF6548EA);
  int selectedPriceFilter = 0;
  List<Ticket> nonTwTickets = [];
  List<Ticket> twTickets = [];
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    getTicketList();
  }

  void getTicketList() async {
    int eventId = widget.event.eventId;
    List<Ticket> tix = await apiClient.getEventTickets(eventId);
    filterTWTickets(tix);
  }

  void filterTWTickets(List<Ticket> tickets) {
    var filteredTWTickets = tickets.where((ticket) => ticket.twTicket).toList();
    var filteredRegularTickets =
        tickets.where((ticket) => !ticket.twTicket).toList();

    setState(() {
      twTickets = filteredTWTickets;
      nonTwTickets = filteredRegularTickets;
    });
  }

//------------------------Start of main page method---------------------------//

  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaPadding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: mediaPadding.top),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _eventTitleText(),
                  _allInSwitch(),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _viewSwitchButtons(),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: _buildPriceFilter(),
            ),
            _headingFont('Best Deals'),
            TicketButtonWidget(
              tickets: twTickets,
              event: widget.event,
              isAllInPricing: isAllInPricing,
            ),
            _headingFont('Ticket Catalog'),
            SeatCatalogWidget(
              tickets: nonTwTickets,
              event: widget.event,
              isAllInPricing: isAllInPricing,
            )
          ],
        ),
      ),
    );
  }

//-------------------------End of main page method----------------------------//

//-------------------------Private Methods------------------------------------//

  Widget _headingFont(String heading) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20),
      child: Text(
        heading,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontFamily: 'Goldman',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Builds event text at the top of page
  Widget _eventTitleText() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event.awayTeam.teamName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@ ${widget.event.homeTeam.teamName}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // The switch for the all-in pricing, clickable
  Widget _allInSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "All-In Pricing",
          style: TextStyle(
            color: Color(0xFF853FF8),
            fontSize: 14,
          ),
        ),
        Transform.translate(
          offset: const Offset(0.0, -4.0),
          child: Transform.scale(
            scale: 1.5,
            child: Switch(
              value: isAllInPricing,
              onChanged: (value) {
                setState(() {
                  isAllInPricing = value;
                });
              },
              activeColor: darkColor,
            ),
          ),
        ),
      ],
    );
  }

  // The two buttons visible directly below the header to switch between
  // the list view and seat view
  Widget _viewSwitchButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(
          text: 'List View',
          isSelected: selectedView == 'List View',
          onTap: () => setState(() => selectedView = 'List View'),
        ),
        _buildButton(
          text: 'Seat View',
          isSelected: selectedView == 'Seat View',
          onTap: () => setState(() => selectedView = 'Seat View'),
        ),
      ],
    );
  }

  // General purpose widget to build the buttons used in the view buttons
  Widget _buildButton(
      {required String text,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        height: 45,
        decoration: ShapeDecoration(
          color: isSelected ? darkColor : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 1 : 0.50,
              color: isSelected ? darkColor : Colors.black.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x006B94FF),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Price filter buttons build from a generated list
  Widget _buildPriceFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          return GestureDetector(
            onTap: () => setState(() => selectedPriceFilter = index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: 75,
                height: 35,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: selectedPriceFilter == index ? 1 : 0.50,
                      color: selectedPriceFilter == index
                          ? lightPurple
                          : Colors.black.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    '\$' * (index + 1),
                    style: TextStyle(
                      color: lightPurple,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
