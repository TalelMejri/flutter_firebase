import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/noteModel.dart';

class FireBaseService{
  final CollectionReference NoteCollection=FirebaseFirestore.instance.collection("notes");

   Future<String> addNote( ) async {
    final body = {
      "matricule":"dssd"
    };

    String response = "no";
    await NoteCollection.add(body).then((value) => 
      response = "ok"
    );
     return response;
  }


   Future<List<NotesModel>> getNotes() async {
     final snapshot = await NoteCollection.get();
       if (snapshot.docs.isNotEmpty) {
        final allData = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
        
      final List<NotesModel> NoteModels = allData
      .map<NotesModel>((jsonPostModel) => NotesModel.fromJson(jsonPostModel))
      .toList();

      return NoteModels;
   }else{
     return throw Exception();
   }
}


  Future<void> deleteNote(String noteId) async {
     await NoteCollection.doc(noteId).delete();
  }

 
  Future<void> UdpateNotes(String noteId,String data) async {
     await NoteCollection.doc(noteId).update({
          "matricule":data
     });
  }

}