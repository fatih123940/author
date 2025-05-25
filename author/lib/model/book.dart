class Book {
  int? id;
  String name;
  DateTime createdAt;
  int? kategori;

  Book({this.id,required this.name,required this.createdAt,this.kategori});


  Map<String,dynamic> toMap() =>{'id':id,'bookName':name,'bookCreatedAt':createdAt.millisecondsSinceEpoch,'kategori':kategori};
  factory Book.fromMap(Map map) => Book(name: map['bookName'], createdAt: DateTime.fromMillisecondsSinceEpoch(map['bookCreatedAt']),id: map['id'],kategori: map['kategori']);
}