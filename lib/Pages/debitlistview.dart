import 'package:expense_tracker/app_data/smstodata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mydebitlist extends StatefulWidget {
  const Mydebitlist({super.key});

  @override
  State<Mydebitlist> createState() => _MydebitlistState();
}

final SmsToData sms = Get.put(SmsToData());

class _MydebitlistState extends State<Mydebitlist> {
  @override
  void setState(VoidCallback fn) {
    sms.getdebitfilter();
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 6.0), //(x,y)
                  blurRadius: 8.0,
                )
              ],
              gradient: LinearGradient(
                stops: [0.2, 100],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 241, 92, 92),
                  Color.fromARGB(255, 197, 33, 33),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 15),
              child: Text(
                "Debited",
                style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 10.0, // shadow blur
                        color: Color.fromARGB(255, 95, 138, 97), // shadow color
                        offset:
                            Offset(1.0, 1.0), // how much shadow will be shown
                      ),
                    ],
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sms.debitfilteredMessages.length,
              itemBuilder: (BuildContext context, int i) {
                var message = sms.debitfilteredMessages[i];
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.currency_rupee_rounded,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(message.sender),
                      subtitle: Text(message.date),
                      trailing: Text("Rs.${message.amount}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
