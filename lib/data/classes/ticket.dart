import 'dart:convert';

class Ticket {
  int ticketId;
  double price;
  int seatNumber;
  String row;
  String barcode;
  String ticketType;
  bool twTicket;
  int eventId;
  int ticketOwner;
  bool sold;
  bool activeListing;
  String section;

  Ticket({
    required this.ticketId,
    required this.price,
    required this.seatNumber,
    required this.row,
    required this.barcode,
    required this.ticketType,
    required this.twTicket,
    required this.eventId,
    required this.ticketOwner,
    required this.sold,
    required this.activeListing,
    required this.section,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticket_id'],
      price: double.parse(json['price']),
      seatNumber: json['seat_number'],
      row: json['row'],
      barcode: json['barcode'],
      ticketType: json['ticket_type'],
      twTicket: json['tw_ticket'],
      eventId: json['event_id'],
      ticketOwner: json['ticket_owner'],
      sold: json['sold'],
      activeListing: json['active_listing'],
      section: json['section'],
    );
  }

  // USAGE:
  // List<dynamic> jsonList = jsonDecode(jsonListString);
  // List<Ticket> leagues = Ticket.fromJsonList(jsonList);
  static List<Ticket> fromJsonList(dynamic jsonData) {
    if (jsonData is List<dynamic>) {
      return jsonData.map((json) => Ticket.fromJson(json)).toList();
    } else if (jsonData is Map<String, dynamic>) {
      return [Ticket.fromJson(jsonData)];
    } else {
      throw Exception('Invalid JSON data');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId.toString(),
      'price': price,
      'seat_number': seatNumber,
      'row': row,
      'barcode': barcode,
      'ticket_type': ticketType,
      'tw_ticket': twTicket,
      'event_id': eventId,
      'ticket_owner': ticketOwner,
      'sold': sold,
      'active_listing': activeListing,
      'section': section,
    };
  }

  int getTicketId() {
    return ticketId;
  }

  double getPrice() {
    return price;
  }

  int getSeatNumber() {
    return seatNumber;
  }

  String getRow() {
    return row;
  }

  String getBarcode() {
    return barcode;
  }

  String getTicketType() {
    return ticketType;
  }

  bool isTwTicket() {
    return twTicket;
  }

  int getEventId() {
    return eventId;
  }

  int getTicketOwner() {
    return ticketOwner;
  }

  bool isSold() {
    return sold;
  }

  bool hasActiveListing() {
    return activeListing;
  }

  String getSection() {
    return section;
  }
}

class SeatObject {
  int ticketId;
  String section;
  String row;
  int seatNumber;
  bool selected;
  String barcode;

  SeatObject({
    required this.ticketId,
    required this.seatNumber,
    this.row = '',
    this.section = '',
    this.selected = false,
    this.barcode = '',
  });
}

String seatsToJson(List<SeatObject> seats, {int? recipientId}) {
  List<int> ticketIds = seats
      .where((seat) => seat.selected)
      .map((seat) => seat.ticketId)
      .toList();

  var jsonData = {'ticket_ids': ticketIds};

  if (recipientId != null) {
    jsonData['recipient_id'] = [recipientId];
  }

  String jsonTicketIds = jsonEncode(jsonData);
  return jsonTicketIds;
}

List<Ticket> getTicketsByEventId(List<Ticket> tickets, int eventId) {
  return tickets.where((ticket) => ticket.eventId == eventId).toList();
}

List<SeatObject> mapTicketsToSeats(List<Ticket> tickets) {
  List<SeatObject> seats = [];

  for (Ticket ticket in tickets) {
    seats.add(SeatObject(
      ticketId: ticket.ticketId,
      seatNumber: ticket.seatNumber,
      row: ticket.row,
      section: ticket.section,
      selected: false,
      barcode: ticket.barcode,
    ));
  }

  return seats;
}

String getAttributeValueById(
    List<Ticket> tickets, int ticketId, String attributeName) {
  for (Ticket ticket in tickets) {
    if (ticket.getTicketId() == ticketId) {
      switch (attributeName) {
        case 'price':
          return ticket.getPrice().toString();
        case 'seatNumber':
          return ticket.getSeatNumber().toString();
        case 'row':
          return ticket.getRow();
        case 'barcode':
          return ticket.getBarcode();
        case 'ticketType':
          return ticket.getTicketType();
        case 'twTicket':
          return ticket.isTwTicket().toString();
        case 'eventId':
          return ticket.getEventId().toString();
        case 'ticketOwner':
          return ticket.getTicketOwner().toString();
        case 'sold':
          return ticket.isSold().toString();
        case 'activeListing':
          return ticket.hasActiveListing().toString();
        case 'section':
          return ticket.getSection();
        default:
          return '';
      }
    }
  }
  return '';
}
