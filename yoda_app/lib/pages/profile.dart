import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yoda_app/locator.dart';
import 'package:yoda_app/widgets/widgets.dart';

import '../feather.dart';
import '../services/services.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late Future action;
  late ProfileViewType type;
  DateFormat dateFormat = DateFormat.yMd();

  late TabController tabController;

  @override
  void initState() {
    action = locate<UserViewService>().fetchUser();
    type = ProfileViewType.basic;
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: "Profile"),
      body: FutureBuilder(
        future: action,
        builder: (context, snapshot) {
          final user = locate<UserViewService>().value;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || user == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Not found", style: Theme.of(context).textTheme.titleMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text("User could not be found", style: Theme.of(context).textTheme.caption),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => setState(() {
                      action = locate<UserViewService>().fetchUser();
                    }),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ProfileAvatar(
                        image: locate<UserViewService>().profileImage,
                        name: "${user.firstName} ${user.lastName}",
                        title: user.designation ?? "N/A",
                        department: user.department ?? "N/A",
                        employeeId: user.employeeNumber,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await locate<AuthViewService>().endSession();
                        if (!mounted) return;
                        context.go("/auth", extra: {"autoAuth": false});
                      },
                      icon: const Icon(FeatherIcons.log_out),
                    )
                  ],
                ),
              ),
              const Divider(),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: AnimatedBuilder(
                  animation: tabController,
                  builder: (context, child) {
                    return ProfileViewTypeSelector(
                      value: tabController.index == 0 ? ProfileViewType.basic : ProfileViewType.work,
                      onSelect: (item) => setState(() => tabController.index = item == ProfileViewType.basic ? 0 : 1),
                    );
                  },
                ),
              ),
              const Divider(),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ProfileDataView(
                      items: [
                        ProfileDataViewItem("Employee ID", [user.employeeNumber ?? "N/A"]),
                        ProfileDataViewItem("First Name", [user.firstName ?? "N/A"]),
                        ProfileDataViewItem("Last Name", [user.lastName ?? "N/A"]),
                        ProfileDataViewItem("Email", [user.email ?? "N/A"]),
                        ProfileDataViewItem("DOB", [user.dateOfBirth ?? "N/A"]),
                        ProfileDataViewItem("Contact Number", [user.mobile ?? "N/A"]),
                      ],
                    ),
                    ProfileDataView(
                      items: [
                        ProfileDataViewItem("Department", [user.department ?? "N/A"]),
                        ProfileDataViewItem("Designation", [user.designation ?? "N/A"]),
                        ProfileDataViewItem("Date of Joining",
                            [user.joiningDate != null ? dateFormat.format(user.joiningDate!) : "N/A"]),
                        ProfileDataViewItem("Employment Type", ["N/A"]),
                        ProfileDataViewItem("Reporting Manager", ["N/A"]),
                        ProfileDataViewItem("Subordinates", ["N/A"]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key? key,
    required this.name,
    required this.title,
    required this.department,
    this.image,
    this.employeeId,
  }) : super(key: key);

  final String name;
  final String title;
  final String department;
  final String? employeeId;
  final Future<ImageProvider?>? image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(image: image, radius: 25),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
              ),
              Text(department, style: Theme.of(context).textTheme.caption)
            ],
          ),
        ),
      ],
    );
  }
}

enum ProfileViewType { basic, work }

class ProfileViewTypeSelector extends StatelessWidget {
  const ProfileViewTypeSelector({Key? key, required this.value, required this.onSelect}) : super(key: key);

  final ProfileViewType value;
  final Function(ProfileViewType) onSelect;

  Widget _buildItem(BuildContext context, ProfileViewType type, String text) {
    TextStyle textStyle = TextStyle(color: Theme.of(context).colorScheme.onSecondary);
    BoxDecoration decoration = BoxDecoration(color: Theme.of(context).colorScheme.secondary);

    if (type == value) {
      textStyle = textStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary);
      decoration = decoration.copyWith(color: Theme.of(context).colorScheme.primary);
    }

    return GestureDetector(
      onTap: () => onSelect(type),
      child: ChevronCrumb(
        decoration: decoration,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Text(text, style: textStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 15),
      scrollDirection: Axis.horizontal,
      children: [
        _buildItem(context, ProfileViewType.basic, "Basic Information"),
        _buildItem(context, ProfileViewType.work, "Work Information"),
      ],
    );
  }
}

class ChevronCrumb extends StatelessWidget {
  const ChevronCrumb({
    Key? key,
    required this.child,
    this.decoration,
    this.offset = 15.0,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final Decoration? decoration;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ChevronClipper(offset: offset),
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        decoration: decoration,
        child: child,
      ),
    );
  }
}

class ChevronClipper extends CustomClipper<Path> {
  ChevronClipper({this.offset = 10.0});

  final double offset;

  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, 0)
      ..lineTo(offset, size.height / 2)
      ..lineTo(0, size.height)
      ..lineTo(size.width - offset, size.height)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width - offset, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ProfileDataViewItem {
  String name;
  List<String> value;

  ProfileDataViewItem(this.name, this.value);
}

class ProfileDataView extends StatelessWidget {
  const ProfileDataView({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<ProfileDataViewItem> items;

  Widget _buildRow(BuildContext context, String name, List<String> values) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.25),
          offset: const Offset(0, 5), // changes position of shadow
          blurRadius: 5,
        ),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(height: 5),
          Column(
              children: values
                  .map((value) =>
                      Text(value, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption))
                  .toList())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      children: items
          .map((item) =>
              Padding(padding: const EdgeInsets.only(bottom: 20), child: _buildRow(context, item.name, item.value)))
          .toList(),
    );
  }
}

class WorkInformationView extends StatelessWidget {
  const WorkInformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
