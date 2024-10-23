import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yoda_app/services/services.dart';

import '../feather.dart';
import '../locator.dart';
import '../util/greet.dart';
import '../widgets/widgets.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FE),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // GreetingBanner(),
            HomeHeaderWithData(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Launcher(),
            ),
            // SizedBox(
            //   height: 15,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 18),
            //   child: NewHireCard(),
            // ),
            SizedBox(
              height: 15,
            ),
            Padding(padding: EdgeInsets.symmetric()),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeaderWithData extends StatelessWidget {
  const HomeHeaderWithData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locate<UserViewService>().fetchUser(),
      builder: (context, snapshot) {
        return ValueListenableBuilder(
          valueListenable: locate<UserViewService>(),
          builder: (context, value, _) {
            return HomeHeader(
              loading: snapshot.connectionState == ConnectionState.waiting,
              image: locate<UserViewService>().profileImage,
              name: "${value?.firstName ?? ""} ${value?.lastName ?? ""}",
              designation: value?.designation ?? "",
            );
          },
        );
      },
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
    required this.name,
    required this.designation,
    this.loading = false,
    this.image,
  }) : super(key: key);

  final bool loading;
  final String name;
  final String designation;
  final Future<ImageProvider?>? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Avatar(image: image, radius: 35),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    designation,
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                ],
              ),
            ),
          ),
        ),
        Stack(
          children: [
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: .5,
                child: Container(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x10000000),
                          offset: Offset(0, 5),
                        )
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: locate<UserViewService>(),
                                  builder: (context, user, _) {
                                    return Text(
                                      "${greet()}, ${user?.firstName ?? ""}",
                                    );
                                  },
                                ),
                                Text(
                                  "00:00 Hours",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                            // ElevatedButton(
                            //   onPressed: () {},
                            //   child: const Text("CHECK IN"),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class Launcher extends StatelessWidget {
  const Launcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: const [
        // LauncherItem(
        //   path: "/leave",
        //   icon: Icon(
        //     FeatherIcons.briefcase,
        //     color: Colors.white,
        //   ),
        //   color: Color(0xff6064A2),
        //   text: "Leave",
        // ),
        LauncherItem(
          path: "/calendar",
          icon: Icon(
            FeatherIcons.calendar,
            color: Colors.white,
          ),
          color: Color(0xff08AF8A),
          text: "Calendar",
        ),
        LauncherItem(
          path: "/profile",
          icon: Icon(
            FeatherIcons.user,
            color: Colors.white,
          ),
          color: Color(0xffF2A828),
          text: "Profile",
        ),
        LauncherItem(
          path: "/timeEntry",
          icon: Icon(
            FeatherIcons.clock,
            color: Colors.white,
          ),
          color: Color(0xffA480E5),
          text: "Time Entry",
        ),
        LauncherItem(
          path: "/meetTheTeam",
          icon: Icon(
            FeatherIcons.users,
            color: Colors.white,
          ),
          color: Color(0xffEA4E8E),
          text: "Meet The Team",
        ),
      ],
    );
  }
}

class LauncherItem extends StatelessWidget {
  const LauncherItem({
    Key? key,
    required this.path,
    required this.icon,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String path;
  final Widget icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => GoRouter.of(context).push(path),
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FractionallySizedBox(
                heightFactor: .9,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 17),
                    decoration: ShapeDecoration(
                      color: color,
                      shape: const CircleBorder(),
                    ),
                    child: icon,
                  ),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 5,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GreetingBanner extends StatefulWidget {
  const GreetingBanner({Key? key}) : super(key: key);

  @override
  State<GreetingBanner> createState() => _GreetingBannerState();
}

class _GreetingBannerState extends State<GreetingBanner> {
  @override
  void initState() {
    locate<UserViewService>().fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                      valueListenable: locate<UserViewService>(),
                      builder: (context, user, _) {
                        return Text(
                          "${greet()}, ${user?.firstName ?? ""}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }),
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor,
          ),
          child: Text(
            "Today: ${DateFormat.MMMMd().format(DateTime.now())}",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class NewHireCard extends StatelessWidget {
  const NewHireCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: .5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("New Hires"),
            SizedBox(
              height: 15,
            ),
            NewHireListItem(
              image: NetworkImage("https://ui-avatars.com/api/?name=John+Doe"),
              title: "INT • 010 • John Doe",
              subtitle: "UI/UX Designer • Intern • California",
              mobile: "+1879453762",
            ),
            SizedBox(
              height: 10,
            ),
            NewHireListItem(
              image: NetworkImage("https://ui-avatars.com/api/?name=Ann+Stacy"),
              title: "039 • Ann Stacy",
              subtitle: "Business Analyst • Engineering • SriLanka",
              mobile: "+9457221039",
            ),
          ],
        ),
      ),
    );
  }
}

class NewHireListItem extends StatelessWidget {
  final ImageProvider<Object> image;
  final String title;
  final String? subtitle;
  final String mobile;

  const NewHireListItem({
    Key? key,
    required this.image,
    required this.title,
    this.subtitle,
    required this.mobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: image,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              Row(
                children: [
                  const Icon(
                    Icons.call_outlined,
                    size: 15,
                  ),
                  Text(mobile)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
