import 'package:expense_tracker/Pages/creditlistview.dart';
import 'package:expense_tracker/Pages/debitlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CardUi extends StatelessWidget {
  CardUi(
      {super.key, required this.icon, required this.amount, required this.bg});
  IconData icon;
  final Color? bg;
  double amount;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (bg == const Color.fromARGB(255, 226, 47, 47)) {
          Get.to(() => const Mydebitlist());
        } else {
          Get.to(() => const Mycredlist());
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: bg,
                child: Icon(color: Colors.white, icon),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Rs.${amount.toString()}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
