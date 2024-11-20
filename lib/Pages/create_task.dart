import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Controllers/task_controller.dart';
import 'package:todoapp/Providers/provider.dart';
import 'package:todoapp/Themes/colors.dart';

class CreateTask extends StatefulWidget {
  Map? itemData;
  CreateTask({super.key, this.itemData});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  bool isEdit = false;
  @override
  void initState() {
    final data = widget.itemData;
    if (widget.itemData != null) {
      isEdit = true;
      txtTitle.text = data!['title'];
      txtDesc.text = data['description'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uProvider = Provider.of<Services>(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Task Title'),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: txtTitle,
              cursorColor: kSilver,
              decoration: InputDecoration(
                hintText: 'Your task title here',
                hintStyle: TextStyle(color: kSilver),
                fillColor: kDarkPurple2,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kRustyRed),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Task Descreption'),
            const SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 5,
              controller: txtDesc,
              cursorColor: kSilver,
              decoration: InputDecoration(
                hintText: 'Your Description here',
                hintStyle: TextStyle(color: kSilver),
                fillColor: kDarkPurple2,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kRustyRed),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRustyRed,
                      foregroundColor: kSilver,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      isEdit
                          ? uProvider.updateFetchData(
                              uid: widget.itemData!['_id'],
                              uTitle: txtTitle.text,
                              uDesc: txtDesc.text,
                              context: context)
                          : Provider.of<Services>(context, listen: false)
                              .postFetchData(
                                  lstTitle: txtTitle.text,
                                  lstDesc: txtDesc.text,
                                  context: context);
                    },
                    child: Text(isEdit ? 'Update Task' : 'Add Task'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
