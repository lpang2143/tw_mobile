import 'package:flutter/material.dart';

class SalesHistory extends StatelessWidget {
  final List<Sale> sales;
  final int amount;

  SalesHistory({
    Key? key,
    required this.sales,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int itemCount = sales.length < amount ? sales.length : amount;

    return AspectRatio(
      aspectRatio: 1,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final sale = sales[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _saleBubble(sale.profit, sale),
          );
        },
      ),
    );
  }

  Widget _saleBubble(double price, Sale sale) {
    final bool isProfit = price >= 0;
    final Color profitColor = isProfit ? const Color(0xFF22B298) : Colors.red;
    final IconData icon =
        isProfit ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return Container(
      width: 120,
      height: 20,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: [
          BoxShadow(
            color: profitColor,
            blurRadius: 4,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: profitColor,
          ),
          Text(
            price.toString(),
            style: TextStyle(
              color: profitColor,
              fontSize: 12,
            ),
          ),
          Text(
            sale.awayTeam,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class Sale {
  final double profit;
  final String awayTeam;
  Sale({required this.profit, required this.awayTeam});
}
