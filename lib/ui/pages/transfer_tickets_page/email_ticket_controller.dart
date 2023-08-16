import 'package:tw_mobile/ui/pages/transfer_tickets_page/notifier/email_notifier.dart';

class EmailTicketController {
  final EmailTicketNotifier emailTicketNotifier;
  final Function onEmailChecked;

  EmailTicketController(this.emailTicketNotifier, this.onEmailChecked);

  void checkEmail(String email) {
    emailTicketNotifier.checkEmail(email);
    onEmailChecked();
  }
}
