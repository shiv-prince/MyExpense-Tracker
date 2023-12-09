import 'package:expense_tracker/app_data/smstodata.dart';
import 'package:expense_tracker/widgets/cardui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThisMonth extends StatefulWidget {
  const ThisMonth({super.key});

  @override
  State<ThisMonth> createState() => _ThisMonthState();
}

String? limitamount;
final SmsToData sms = Get.put(SmsToData());

class _ThisMonthState extends State<ThisMonth> {
  var mylimit = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    sms.getpermissionwithdata();
    refresh();
  }

  void refresh() async {
    final SharedPreferences preferences = await _prefs;
    setState(() {
      limitamount = preferences.getString('amount').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    double? debitSum = sms.sumList(sms.debitAmountlist);
    double? creditSum = sms.sumList(sms.creditAmountlist);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 150,
                  child: Animate(
                    effects: const [
                      FadeEffect(
                        begin: -1.0,
                        end: 1.0,
                        duration: Duration(seconds: 1),
                      ),
                    ],
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          builder: (context) {
                            return SizedBox(
                              height: 600,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Set your Limit",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Note: The limit will used to set max value in graph view.",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: mylimit,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          hintText: "your limit"),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 64, 39, 176)),
                                      onPressed: () async {
                                        final SharedPreferences preferences =
                                            await _prefs;
                                        setState(() {
                                          preferences.setString('amount',
                                              mylimit.text.toString());
                                          limitamount = preferences
                                              .getString('amount')
                                              .toString();
                                          Navigator.pop(context);
                                        });
                                        mylimit.clear();
                                      },
                                      child: const Text(
                                        "Set",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 6.0), //(x,y)
                              blurRadius: 8.0,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                          gradient: LinearGradient(
                            stops: [0.2, 100],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color.fromARGB(255, 24, 177, 131),
                              Color.fromARGB(255, 76, 64, 251),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 18, bottom: 0, right: 20, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Set Limit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              Text(
                                "Rs.$limitamount",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CardUi(
                          icon: Icons.arrow_downward_rounded,
                          amount: creditSum!,
                          bg: const Color.fromARGB(255, 25, 182, 38)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CardUi(
                          icon: Icons.arrow_upward_rounded,
                          amount: debitSum!,
                          bg: const Color.fromARGB(255, 226, 47, 47)),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  "All Transactions",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 265,
                width: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sms.filteredMessages.length,
                  itemBuilder: (BuildContext context, int i) {
                    var message = sms.filteredMessages[i];
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        child: ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0)),
                              gradient: LinearGradient(
                                stops: [0.2, 100],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color.fromARGB(255, 24, 177, 131),
                                  Color.fromARGB(255, 76, 64, 251),
                                ],
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.currency_rupee_rounded,
                                  color: Colors.white),
                            ),
                          ),
                          title: Text(message.sender),
                          subtitle: Text(DateFormat('yMMMMd')
                              .format(DateTime.parse(message.date))),
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade200,
        onPressed: () {
          setState(() {
            if (sms.creditAmountlist.isEmpty || sms.debitAmountlist.isEmpty) {
              sms.smsdatacollector();
              sms.lastmonth();
              sms.lastotlast();
              sms.last3rd();
              sms.currentMonth();
              sms.getpermissionwithdata();
              sms.getcreditfilter();
              sms.getdebitfilter();
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.refresh_rounded),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color.fromARGB(29, 224, 224, 224),
        height: 60,
        child: Row(
          children: [
            // Expanded(
            //     child: Container(
            //       color: Colors.green,
            //     )),
            // Expanded(
            //     child: Container(
            //   color: Colors.red,
            // )),
          ],
        ),
      ),
    );
  }
}
