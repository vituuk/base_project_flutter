import 'package:demo_2/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ListMenu extends StatefulWidget {
  const ListMenu({super.key});

  @override
  State<ListMenu> createState() => _ListMenuState();
}

class _ListMenuState extends State<ListMenu> {

  int counts = 0;
 
 @override
 void initState() {
  super.initState();
   
 }

 @override
 void didChangeDependencies() {
  super.didChangeDependencies();
 }
 
 void onIncreaseCounter(){
  setState((){
    counts++;
  });
 }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(0,0,20,0),
          child: Row(
            children: [
              IconButton(onPressed: ()=>Get.toNamed(AppRoutes.home), icon: Icon(Icons.home)),
              Text('Home'),
            ],
          ),
          
          
        ),
          Container(
          child: Row(
            children: [
              IconButton(onPressed: ()=>Get.toNamed(AppRoutes.detail), icon: Icon(Icons.details)),
              Text('Detail'),
            ],
          ),
          
          
        ),
          Container(
          child: Row(
            children: [
              IconButton(onPressed: ()=>Get.toNamed(AppRoutes.user), icon: Icon(Icons.usb_rounded)),
              Text('User'),
            ],
          ),
          
          
        )
      ],
    ) ;
    
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Text('Counter is : $counts'),
    //     IconButton(onPressed: onIncreaseCounter, icon: Icon(Icons.add)),
    //   ],
    // );
  }
}