import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:todo_task/screens/add_page.dart';
import 'package:todo_task/service/serviceGet.dart';

import '../model/ItemsModel.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTODO();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.grey));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black12,
        title: const Text(
          "Todo List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchTODO,
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index] as Map;
              final id = item['_id'] as String;
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(
                  item['title'],
                ),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'Edit') {
                     // open edit page

                      navigateToEditPage(item);
                    } else if (value == 'Delete') {
                      deleteById(id);
                    }
                    // Delete Item
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: 'Delete',

                      ),
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: 'Edit',
                      ),
                    ];
                  },
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
          navigateToAddPage();
          },
          backgroundColor: Colors.grey,
          label: Text('Add TODO')),
    );
  }

  // Future<void> fetchTodo() async {
  //   final response = await UserGetApi.fetchTodo();
  //   setState(() {
  //     list = response as List<Items?>;
  //     isLoading = false;
  //   });
  // }

  Future<void> deleteById(String id) async {
//Delete the Item
    final url = 'https://api.nstack.in/v1/todos/${id}';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = list.where((element) => element['_id'] != id).toList();
      setState(() {
        list = filtered;

      });
    } else {

    }
    final snackbar = SnackBar(content: Text("Item Deleted"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

    // Remove the item from the list
  }



  Future<void> fetchTODO() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=12';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        list = result;
      });
    }
    else{

    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(builder: (context) => Addpage(),);
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTODO();
  }
  Future<void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(builder: (context) => Addpage(todo: item ),);
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTODO();
  }
}
