import 'package:flutter_test/flutter_test.dart';
import 'package:tw_mobile/services/api_client.dart';

void main() {
  ApiClient api = ApiClient();
  test('Test registerUser function', () async {
    const email = 'register1@name.com';
    const firstName = 'John';
    const lastName = 'Doe';
    const phoneNumber = '1234567890';
    const password = 'password123';

    await api.registerUser(email, firstName, lastName, phoneNumber, password);
  });

  test('getUserTickets should return a list of tickets', () async {
    const userId = 1;

    final tickets = await api.getUserTickets(userId);

    expect(tickets.length, 2); // Assuming there are 2 tickets in the response
    expect(tickets[0].ticketId, BigInt.from(1));
    expect(tickets[0].price, 90.30);
    expect(tickets[0].seatNumber, 1);
    expect(tickets[0].row, "1");
    expect(tickets[0].barcode, "bar1");
    expect(tickets[0].ticketType, "PDF");
    expect(tickets[0].twTicket, false);
    expect(tickets[0].sold, false);
    expect(tickets[0].activeListing, false);
    expect(tickets[0].section, "128");
    expect(tickets[0].eventId, 1);
    expect(tickets[0].ticketOwner, 1);

    expect(tickets[1].ticketId, BigInt.from(2));
    expect(tickets[1].price, 120.30);
    expect(tickets[1].seatNumber, 2);
    expect(tickets[1].row, "2");
    expect(tickets[1].barcode, "bar2");
    expect(tickets[1].ticketType, "tw_ticket");
    expect(tickets[1].twTicket, true);
    expect(tickets[1].sold, false);
    expect(tickets[1].activeListing, true);
    expect(tickets[1].section, "8");
    expect(tickets[1].eventId, 1);
    expect(tickets[1].ticketOwner, 1);
  });
}
