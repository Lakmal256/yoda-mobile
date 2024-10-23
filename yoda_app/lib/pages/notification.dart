import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../feather.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: const [
          NotificationBaseCard(
            body: NotificationTitle(
              title: 'Prasad Rtahnayake ',
              subTitle:
                  'has applied for a casual leave  has applied for a casual leave  ',
              time: '2hr ago',
            ),
            prefix: UserNotification(
              profilePic: 'assets/images/pic.png',
            ),
          ),
          NotificationBaseCard(
              body: NotificationTitle(
                title: '2023. 01. 06  ',
                subTitle: 'is a poya holiday  ',
                time: '5hrs ago',
              ),
              prefix: CalendarNotification()),
        ],
      ),
    );
  }
}

class UserNotification extends StatelessWidget {
  const UserNotification({super.key, required this.profilePic});
  final String profilePic;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                profilePic,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CalendarNotification extends StatelessWidget {
  const CalendarNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        children: const [
          Icon(
            FeatherIcons.calendar,
            size: 40,
          ),
        ],
      ),
    );
  }
}

class NotificationTitle extends StatelessWidget {
  const NotificationTitle(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.time});
  final String title;
  final String subTitle;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                text: title,
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: subTitle,
                      style: const TextStyle(fontWeight: FontWeight.w400))
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            time,
            style: const TextStyle(fontSize: 14, color: Color(0xffB7B8B9)),
          ),
        )
      ],
    );
  }
}

class NotificationBaseCard extends StatelessWidget {
  const NotificationBaseCard(
      {super.key, required this.prefix, required this.body});

  final Widget prefix;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Visibility(
            visible: true,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xff4974A5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          prefix,
          Expanded(
            child: body,
          )
        ],
      ),
    );
  }
}
