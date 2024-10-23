import 'package:flutter/material.dart';
import 'package:yoda_app/feather.dart';

import '../locator.dart';
import '../services/team.dart';

class MeetTheTeam extends StatefulWidget {
  const MeetTheTeam({super.key});

  @override
  State<MeetTheTeam> createState() => _MeetTheTeamState();
}

class _MeetTheTeamState extends State<MeetTheTeam> {
  late Future action;
  bool filterByDepartment = false;
  bool filterByRole = false;
  String? selectedDepartmentFilter;
  String? selectedRoleFilter;

  @override
  void initState() {
    action = locate<TeamViewService>().fetchTeam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(),
        flexibleSpace: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: const Text("Meet Our Team"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff66713e),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: PopupMenuButton<String>(
                      offset: const Offset(0, 25),
                      itemBuilder: (context) => departments
                          .map(
                            (department) => PopupMenuItem<String>(
                              value: department.name,
                              child: Text(department.displayName,
                                  style: const TextStyle(
                                      color: Color(0xff66713e))),
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedDepartmentFilter = value;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'FILTER BY DEPARTMENT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff66713e),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff66713e),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: PopupMenuButton<String>(
                        offset: const Offset(0, 35),
                        itemBuilder: (context) => roles
                            .map(
                              (role) => PopupMenuItem<String>(
                                value: role.name,
                                child: Text(role.displayName,
                                    style: const TextStyle(
                                        color: Color(0xff66713e))),
                              ),
                            )
                            .toList(),
                        onSelected: (value) {
                          setState(() {
                            selectedRoleFilter = value;
                          });
                          FilterBuilder builder = locate<TeamViewService>()
                              .filterBuilder
                            ..role = value!;
                          Filter filter = builder.byRoleFilter;
                          locate<TeamViewService>().fetchTeamWithFilters(filter);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'FILTER BY ROLE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff66713e),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: action,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ValueListenableBuilder(
                  valueListenable: locate<TeamViewService>(),
                  builder: (context, snapshot, _) {
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.team
                          .map(
                            (user) => MemberCard(
                              profilePic: user.imageBytes != null
                                  ? MemoryImage(user.imageBytes!)
                                  : null,
                              userName: "${user.firstName} ${user.lastName}",
                              designation: user.designation ?? "N/A",
                              department: user.department ?? "N/A",
                              number: user.mobile ?? "N/A",
                              gmail: user.email ?? "N/A",
                            ),
                          )
                          .toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  MemberCard(
      {super.key,
      this.loading = false,
      required this.profilePic,
      required this.userName,
      required this.designation,
      required this.department,
      required this.number,
      required this.gmail});
  final bool loading;
  final ImageProvider<Object>? profilePic;
  final String userName;
  final String designation;
  final String department;
  final String number;
  final String gmail;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 8,
          child: Container(
            color: Colors.white,
            height: 100.0,
            child: ListView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 8,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 17),
                  width: 120,
                  child: CircleAvatar(
                    backgroundImage: profilePic,
                    radius: 35,
                    child: loading ? const CircularProgressIndicator() : null,
                  ),
                ),
                SizedBox(
                  width: 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        designation,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xff6E726E)),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        department,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xff6E726E)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => scrollController
                      .jumpTo(scrollController.position.maxScrollExtent),
                  child: SizedBox(
                    width: 35,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 15,
                        ),
                        Icon(
                          FeatherIcons.arrow_right_circle,
                          color: Color.fromARGB(255, 160, 160, 160),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => scrollController.jumpTo(0.0),
                  child: Container(
                    color: const Color.fromARGB(27, 27, 43, 21),
                    width: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: const ShapeDecoration(
                                    shape: CircleBorder(), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Icon(
                                    FeatherIcons.phone_call,
                                    size: 15,
                                    color: Color.fromARGB(255, 160, 160, 160),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                number,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xffB7B8B9)),
                              ),
                              const Spacer(),
                              const Icon(
                                FeatherIcons.arrow_left_circle,
                                color: Color.fromARGB(255, 160, 160, 160),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: Colors.white,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Icon(
                                    FeatherIcons.mail,
                                    size: 15,
                                    color: Color.fromARGB(255, 160, 160, 160),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    gmail,
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xffB7B8B9)),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
