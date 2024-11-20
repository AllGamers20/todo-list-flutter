import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Pages/create_task.dart';
import 'package:todoapp/Providers/provider.dart';
import 'package:todoapp/Themes/colors.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> bsheet = GlobalKey<ScaffoldState>();
  List taskList = [];
  @override
  Widget build(BuildContext context) {
    final mProvider = Provider.of<Services>(context, listen: false);
    List taskList = Provider.of<Services>(context).allList;
    return Scaffold(
      key: bsheet,
      backgroundColor: kDarkPurple,
      appBar: AppBar(
        foregroundColor: kSilver,
        backgroundColor: kDarkPurple,
        centerTitle: true,
        title: const Text('All Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = taskList.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kDarkPurple2,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data['title'],
                                style: TextStyle(
                                    decorationThickness: 3.0,
                                    decorationColor: kDarkPurple,
                                    decoration: data['is_completed']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontSize: 20,
                                    color: kSilver),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data['description'],
                                  style: TextStyle(
                                    color: kElectricBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  DateFormat.yMMMEd()
                                      .format(
                                          DateTime.parse(data['created_at']))
                                      .toString(),
                                  style: TextStyle(
                                    color: kElectricBlue,
                                  )),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  bsheet.currentState!.showBottomSheet(
                                    backgroundColor: kDarkPurple2,
                                    (context) => CreateTask(
                                      itemData: data,
                                    ),
                                  );
                                },
                                icon: Icon(
                                  FontAwesomeIcons.pen,
                                  color: kElectricBlue,
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  mProvider.deleteAlert(
                                      context, mProvider, data);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.trash,
                                  color: kRustyRed,
                                  size: 20,
                                ),
                              ),
                              Checkbox(
                                activeColor: kRustyRed,
                                focusColor: kSilver,
                                checkColor: kSilver,
                                value: data['is_completed'],
                                onChanged: (value) {
                                  mProvider.updateCheck(
                                    check: value!,
                                    mid: data['_id'],
                                    title: data['title'],
                                    description: data['description'],
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: taskList.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  // updateCheck(bool check, String _id, String title, String description) async {
  //   final id = _id;
  //   final body = {
  //     "title": title,
  //     "description": description,
  //     'is_completed': check,
  //   };
  //   final url = Uri.parse('https://api.nstack.in/v1/todos/$id');
  //   final response = await http.put(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(body),
  //   );
  //   Services().getFetchData();
  // }

  // delTask(String id) async {
  //   final url = Uri.parse('https://api.nstack.in/v1/todos/$id');
  //   await http.delete(url);
  //   Services().getFetchData();
  // }
}
