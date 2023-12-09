import 'package:expense_tracker/Pages/graph.dart';
import 'package:expense_tracker/Pages/thismonth.dart';
import 'package:flutter/material.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Expense Tacker",
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            overlayColor: MaterialStatePropertyAll(Colors.grey),
            tabs: [
              Tab(text: "All Expense"),
              Tab(
                text: "Graph",
              ),
            ],
          ),
          actions: [
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              iconSize: 28,
              color: Colors.black,
              onPressed: () {},
            )
          ],
        ),
        body: TabBarView(
          children: [
            ThisMonth(),
            GraphPage(),
          ],
        ),
      ),
    );
  }
}
