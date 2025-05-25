class Bolum {
  int? id;
  int kitapId;
  String title;
  String icerik;

  Bolum({this.id,required this.kitapId,required this.title,required this.icerik});

  Map<String,dynamic> toMap() => {'id':id,'bookId':kitapId,'bolumBaslik':title,'bolumIcerik':icerik};
  factory Bolum.fromMap(Map map) => Bolum(kitapId: map['bookId'], title: map['bolumBaslik'], icerik: map['bolumIcerik'],id: map['id']);

}