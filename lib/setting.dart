import 'package:flutter/material.dart';
import 'package:ohayo/screen/homeScreen.dart';

class Setting extends StatelessWidget{
  const Setting ({super.key});
  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.red.withOpacity(0.5),
     appBar: AppBar(
       title: Text("Setting"),
     ),
     body: Container(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Row(
           
           children: [
             Icon(Icons.dark_mode),
             Text(" Dark Mode ",
             style: TextStyle(
               color: Colors.white
             ),),
           ],
         ),
       ),
       
     ),
   );
  }
}