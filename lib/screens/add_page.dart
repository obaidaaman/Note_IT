import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_task/model/ItemsModel.dart';
import 'package:todo_task/screens/todo_list.dart';
import 'package:todo_task/service/service_post.dart';
import 'package:http/http.dart' as http;

class Addpage extends StatefulWidget {
  final Map? todo;

  const Addpage({super.key,
    this.todo});

  @override
  State<Addpage> createState() => _AddPageState();
}

class _AddPageState extends State<Addpage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final todo = widget.todo;
    if (widget.todo != null) {
      isEdit = true;
      final title = todo?['title'];
      final description = todo?['description'];
      titleController.text= title!;
      descController.text= description!;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Scaffold(
      drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(
            isEdit ? "Edit Todo" : "Add Todo",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(padding: EdgeInsets.all(20), children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: "Title",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(11))),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(

                hintText: "Description",
                focusedBorder: OutlineInputBorder(

                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(11)
                )
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () {
                isEdit ? updateData() : submitData();

                titleController.clear();

                descController.clear();

                },
              child: Text(isEdit ? "Update" : "Submit"),
              style: ButtonStyle(

                backgroundColor: MaterialStateProperty.all<Color>(

                    Colors.grey), // Set the button color

              )),
        ]));
  }

  void submitData() async {
    //Get the data from form
    final title = titleController.text;

    final desc = descController.text;

    FocusScope.of(context).unfocus();
    // display it in the api
    final message = await ServicePost(title: title, desc: desc).servicesApi();

// show success or fail message
    showMessage(message);

  }

  void showMessage(String message) {

    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
  Future<void> updateData() async {
    final todo = widget.todo;
   if(todo == null){
     print("You cannot call updated withoud todo data");
     return;
   }

   final id= todo['_id'];
final title = titleController.text;
final description = descController.text;
final body = {
  "title" : title,
  "description" : description,
  "is _completed" : false
};

FocusScope.of(context).unfocus();

final url = "https://api.nstack.in/v1/todos/$id";

final uri = Uri.parse(url);
    try {
final response = await http.put(uri,
body: jsonEncode(body),
headers: {"Content-Type": 'application/json'}
);

    if (response.statusCode == 200) {

      print(response.statusCode);

     showMessage("Updation Success");

    }
    else
    {
      print("Failed to upload data. Status code: ${response.statusCode}");

      showMessage( "Updation Failed ");

    }

  }
  catch (error)
  {

  print("Error uploading data: $error");

  showMessage("Error Updation");

  }
}
  }




