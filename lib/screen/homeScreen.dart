import 'package:flutter/material.dart';
import 'package:ohayo/display.dart';
import 'package:ohayo/setting.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreentwo(), // should point to HomeScreentwo, not itself
    );
  }
}

class HomeScreentwo extends StatefulWidget {
  const HomeScreentwo({super.key}); // missing semicolon








  @override
  State<HomeScreentwo> createState() => _HomeScreentwoState();
}

class _HomeScreentwoState extends State<HomeScreentwo> {




  void privacy(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Privacy and Policy"),
          content: Text(" Thee chuhcu"),
          actions: [
            TextButton(onPressed: (){
                Navigator.pop(context);
            },
              child:
              Text("Close"),
            )
          ],
        )
    );




  }
void Add(){
    showDialog(context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            decoration: InputDecoration(
              hintText: "Add task here..."
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            },
                child: Text("Cancel")
            ),
            TextButton(onPressed: (){
              Navigator.pop(context);
            },
                child: Text("Add"))
          ],
        )
    );
}
void completed(){
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text("Completed Tasks "),
          content: Container(
            height: 300,
            width: double.infinity,
            child: Center(
              child: Text("No completed Tasks yet"),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            },
                child: 
            Text("Close"))
          ],

        )
    );


}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black.withOpacity(0.5),
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(

                ),
              child: Text("Menu",
              style: TextStyle(
                color: Colors.white
              ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.font_download),
              title: Text("Display",
              style: TextStyle(
                color: Colors.white
              ),),
                onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Display() ),
                );
                },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting",
              style: TextStyle(
                color: Colors.white
              ),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Setting() ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text("privacy and Policy",
              style: TextStyle(
                color: Colors.white
              ),),
              onTap: (){
                privacy();

              },
            ),



          ],

        ),



      ),


      backgroundColor: Color(0xFF836664),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(128, 57, 41, 1.0),
        elevation: 20,
        title: Container(
              child: Text("To-Do List",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                    fontSize: 24,
                color: Colors.white
              ),

              )),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [

              Container(
                height: 800,
                width: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF836664), Color(0xFFCA5750)])
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, //para mapunta sa upper left
                      children: [

                        ElevatedButton(onPressed: (){
                          Navigator.pop(context);

                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white
                            ),



                            child:
                            Text("Tasks",
                              style: TextStyle(
                                color: Colors.black


                              ),
                            )



                        ),
                        ElevatedButton(onPressed: (){
                          completed();
                        },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white
                            ),
                            child:
                        Text("Completed",
                          style:TextStyle(
                            color: Colors.black
                          ) ,))


                      ],
                    ),
                    ElevatedButton(onPressed: (){
                      Add();
                    },
                        child: Container(
                            width: 100,

                            child: Center(
                                child: Text("  + ")
                            )
                        ),

                    ),

                    Expanded(
                      child: Center(
                          child: Text("Add a task by clicking the +")),
                    )

                  ],
                ),



              ),






          ],
        ),
      ),


    );

  }
}