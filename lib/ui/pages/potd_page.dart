import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/ui/shared/purple_button.dart';

class PickOfTheDayPage extends StatelessWidget {
  final Color lightPurple = const Color(0xFF625BF6);
  final Event pickTicket;
  final double odds;
  final double lowestPrice;

  PickOfTheDayPage(
      {required this.pickTicket,
      required this.odds,
      required this.lowestPrice});

  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(context),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(mediaPadding.left + 15, 0,
                  mediaPadding.right + 15, mediaPadding.bottom + 15),
              child: _buildPickOfTheDayText(context),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(mediaPadding.left + 45, 0,
                  mediaPadding.right + 45, mediaPadding.bottom + 15),
              child: _buildBetInfo(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(mediaPadding.left + 45, 0,
                  mediaPadding.right + 45, mediaPadding.bottom + 15),
              child: _buildRectangle(context),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(mediaPadding.left + 45, 0,
                  mediaPadding.right + 45, mediaPadding.bottom + 15),
              child: PurpleButton(
                  buttonText: 'PURCHASE A TICKET',
                  onTap: () {
                    debugPrint('Ticket purchase tapped');
                    // TODO: implement logic
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      // alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        color: Colors.black,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildPickOfTheDayText(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        'Pick of the Day',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 45),
      ),
    );
  }

  Widget _buildBetInfo() {
    return Builder(builder: (context) {
      return Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${pickTicket.homeTeam} \t $odds',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20.0,
                ),
          ),
        ),
      );
    });
  }

  Widget _buildRectangle(BuildContext context) {
    return Container(
      width: 275,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            color: Colors.grey, // Placeholder color
          ),
          const SizedBox(height: 20),
          Text(
            '${pickTicket.homeTeam}\nVs.\n${pickTicket.awayTeam}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 25.0,
                ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'From ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 25.0,
                    ),
              ),
              Text(
                '$lowestPrice',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 25.0, color: lightPurple),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
