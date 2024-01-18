import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/firebase_service.dart';
import 'package:flutter_firebase/noteModel.dart';
import 'firebase_options.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
 FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Crud Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FireBaseService service=FireBaseService();
  late List<NotesModel> notes=[]; 
  late String updatevalue="";


  Future<void> OpenAlert(NotesModel note)async{
    await showDialog(context: context, builder: (BuildContext context){
       return AlertDialog(
             content:TextFormField(
              initialValue: note.matricule,
              onChanged: (value) {
               setState(() {
                 updatevalue=value;
               });
              },
             ),
             actions: [
              ElevatedButton(onPressed: (){
                 service.UdpateNotes(note.id.toString(), updatevalue);
                 setState(() {
                   notes=[];
                 });
                 getNotes();
                 Navigator.pop(context);
              }, child: const Text("Update"))
             ],
       );
    });
  }

  getNotes()async{
    final res=await service.getNotes();
    setState(() {
      notes=res;
    });
  }
  @override
  void initState() {
    getNotes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:ListView.builder(
         itemCount: notes.length,
         itemBuilder: (context,index){
          final NotesModel note=notes[index];
            return ListTile(
              title: Text(note.matricule.toString()),
              trailing: ElevatedButton(child: Text("delete"),onPressed: (){
                  service.deleteNote(note.id.toString());
                  setState(() {
                    notes=[];
                  });
                  getNotes();
              },),
              leading: ElevatedButton(child: Text("Update"),onPressed: (){
                 OpenAlert(note);
              },),
            );
         },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          service.addNote();
           getNotes();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
