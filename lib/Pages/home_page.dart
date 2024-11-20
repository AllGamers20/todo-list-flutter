import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/Pages/all_tasks.dart';
import 'package:todoapp/Pages/create_task.dart';
import 'package:todoapp/Themes/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<Services>(context, listen: false).getFetchData();
    super.initState();
  }

  final GlobalKey<ScaffoldState> bsheet = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final mProvider = Provider.of<Services>(context);
    List taskList = Provider.of<Services>(context).taskList;
    return Scaffold(
      key: bsheet,
      backgroundColor: kDarkPurple,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kRustyRed,
        foregroundColor: kSilver,
        onPressed: () {
          bsheet.currentState!.showBottomSheet(
            backgroundColor: kDarkPurple2,
            (context) => CreateTask(),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: kDarkPurple,
        title: Column(
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(
                color: kSilver,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text(
              'Hussein Mbarak',
              style: TextStyle(
                color: kElectricBlue,
                fontSize: 15,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kRustyRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      DateFormat.yMMMMEEEEd().format(
                        DateTime.now(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Services().getFetchData();
                  },
                  icon: Icon(
                    FontAwesomeIcons.arrowsRotate,
                    color: kSilver,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Text('Today`s Task'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllTasks(),
                      ),
                    );
                  },
                  child: Text(
                    'see all',
                    style: TextStyle(
                      color: kSilver,
                    ),
                  ),
                )
              ],
            ),
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
                                shape: const CircleBorder(),
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
}
