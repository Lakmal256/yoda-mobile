import 'package:flutter/material.dart';

class LeaveTracker extends StatefulWidget {
  const LeaveTracker({super.key});

  @override
  State<LeaveTracker> createState() => _LeaveTrackerState();
}

class _LeaveTrackerState extends State<LeaveTracker> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: TimeTrackerTable(),
        ),
      ),
    );
  }
}

class TimeTrackerTable extends StatelessWidget {
  const TimeTrackerTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        heightFactor: 3,
        child: Table(
          border: TableBorder.all(color: Colors.white),
          children: [
            TableRow(
                children: ['Type', 'Total', 'Available', 'Utilized', 'Pending'].map((cell) {
              return Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(218, 56, 83, 20),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Center(
                        heightFactor: 2,
                        child: Text(
                          cell,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      )));
            }).toList()),
            buildRow(['Casual', ' ', ' ', ' ', ' ']),
            buildRow(['Annual', '  ', ' ', ' ', ' ']),
            buildRow(['Lieu', ' ', ' ', ' ', ' ']),
          ],
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells) => TableRow(
        children: cells.map((cell) {
          return Container(
            height: 39,
            decoration: const BoxDecoration(
              color: Color.fromARGB(218, 139, 156, 92),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Center(
                child: Text(
                  cell,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
}
