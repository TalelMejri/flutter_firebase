class NotesModel {
  String? id;
  String? matricule;

  NotesModel({
    required this.id,
    required this.matricule,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      matricule: json['matricule'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
    };
  }
}
