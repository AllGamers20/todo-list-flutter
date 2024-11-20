import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/Controllers/task_controller.dart';
import 'package:todoapp/Themes/colors.dart';

class Services with ChangeNotifier {
  List taskList = [];
  List allList = [];
  var url = 'https://api.nstack.in/v1/todos';
  // List get getPData => _pdata;
  //?get
  getFetchData() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> lstData = jsonDecode(response.body);
      taskList = lstData['items'];
      final tskFilter = taskList
          .where(
            (element) => (DateFormat.yMMMEd()
                    .format(DateTime.parse(element['created_at'])) ==
                DateFormat.yMMMEd().format(
                  DateTime.now(),
                )),
          )
          .toList();

      taskList = tskFilter;
      allList = lstData['items'];

      notifyListeners();
    }
  }

  //?post
  postFetchData(
      {required String lstTitle,
      required String lstDesc,
      required BuildContext context}) async {
    final body = {
      "title": txtTitle.text,
      "description": txtDesc.text,
      "is_completed": false,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'task created',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: kElectricBlue,
        ),
      );
      getFetchData();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Somethig goes wrong',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: kRustyRed,
        ),
      );
    }
  }

  //?update
  updateFetchData(
      {required String uid,
      required String uTitle,
      required uDesc,
      required BuildContext context}) async {
    final id = uid;
    final body = {
      "title": uTitle,
      "description": uDesc,
      "is_completed": false,
    };

    final response = await http.put(
      Uri.parse('$url+/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'task Updated',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: kElectricBlue,
        ),
      );
      getFetchData();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Somethig goes wrong',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: kRustyRed,
        ),
      );
    }
  }

  //*Update Api Method
  updateCheck(
      {required check,
      required String mid,
      required String title,
      required String description}) async {
    final id = mid;
    final body = {
      "title": title,
      "description": description,
      'is_completed': check,
    };

    final response = await http.put(
      Uri.parse('$url+/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    Services().getFetchData();
  }

  //*DeletApi Method
  delTask(String id) async {
    await http.delete(
      Uri.parse('$url+/$id'),
    );
    Services().getFetchData();
  }

  deleteAlert(
      BuildContext context, Services mProvider, Map<String, dynamic> data) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
          title: const Text('Are you sure'),
          iconPadding: const EdgeInsets.all(12),
          iconColor: Colors.grey,
          icon: const Icon(
            FontAwesomeIcons.triangleExclamation,
            size: 70,
          ),
          backgroundColor: kRustyRed,
          actions: [
            TextButton(
              onPressed: () {
                mProvider.delTask(data['_id']);
                Navigator.pop(context);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }
}
