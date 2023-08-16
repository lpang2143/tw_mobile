import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/transfer_tickets_page/email_ticket_controller.dart';
import 'package:tw_mobile/ui/pages/transfer_tickets_page/notifier/email_notifier.dart';

class EmailPopup extends StatefulWidget {
  final List<SeatObject> selectedSeats;

  EmailPopup({
    required this.selectedSeats,
  });

  @override
  _EmailPopupState createState() => _EmailPopupState();
}

class _EmailPopupState extends State<EmailPopup> {
  final EmailTicketNotifier emailTicketNotifier = EmailTicketNotifier();
  final TextEditingController _emailController = TextEditingController();
  final ApiClient apiClient = ApiClient();

  void _onEmailChecked() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    EmailTicketController emailTicketController =
        EmailTicketController(emailTicketNotifier, _onEmailChecked);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                errorText: emailTicketNotifier.validEmail
                    ? null
                    : 'Please enter a valid email',
              ),
              onChanged: emailTicketController.checkEmail,
            ),
            ElevatedButton(
              onPressed: emailTicketNotifier.validEmail
                  ? () async {
                      String jsonData = seatsToJson(widget.selectedSeats);
                      String recipientEmail = _emailController.text;
                      await apiClient.transferTickets(jsonData, recipientEmail);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
