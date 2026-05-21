import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int counter = 0;
  String result= "";
  int a=3;
  int b=5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void onIncreaseCounter() {
    setState(() {
      counter++;
    });
  }

  void calulate(){
    setState(() {
      result = (a+b).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Counter: $counter"),
        IconButton(onPressed: onIncreaseCounter, icon: Icon(Icons.add)),
        Text("Result: $result"),
        
        IconButton(onPressed: calulate, icon: Icon(Icons.calculate)),
      ],
    );
  }
}
