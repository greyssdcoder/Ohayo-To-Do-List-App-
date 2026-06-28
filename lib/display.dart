import 'package:flutter/material.dart';
import 'package:ohayo/screen/homeScreen.dart';

class Display extends StatefulWidget{
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(" Display "),

      ),
      body: Container(
        child: Padding(

          padding: const EdgeInsets.only(
            bottom:   40,
            top: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" Style ",
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Row(
                  children: [
                    Icon(Icons.font_download),
                    Text("Font",
                    style: TextStyle(
                      fontSize: 20,

                    ),
                    ),
                  ],

                ),
              ),
              Container(
                  child:
                  Row(
                    children: [
                      Icon(Icons.format_size),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Font Size",
                        style: TextStyle(
                          fontSize: 20
                        ),
                        ),
                      ),
                    ],
                  )
              )

            ],

          ),


        ),



      ),





    );
  }
}