
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/bolum.dart';
import 'model/book.dart';
class YerelVeriTabani{
  Database? _veriTabani;

  Future<Database?> _veriTabaniniGetir() async{
    if(_veriTabani !=null){
      return _veriTabani;
    }
    String dosyaYolu=await getDatabasesPath();
    String veriTabaniYolu = join(dosyaYolu,'person.db');
    _veriTabani=await openDatabase(veriTabaniYolu,version: 2,onCreate:tabloOlustur

    ,onUpgrade: tabloGuncelle


    );
    return _veriTabani;
  }

  void tabloOlustur(Database db, int version) async{
    await db.execute(
      '''
      CREATE TABLE kitaplar (
      
      id INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
      bookName TEXT NOT NULL,
      bookCreatedAt INTEGER
      
      
      );
      
      
      '''


    );
    await db.execute(
        '''
      CREATE TABLE bolumler (
      
      id INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
      bookId INTEGER NOT NULL,
      bolumBaslik TEXT,
      bolumIcerik TEXT,
      olusturulmaTarihi INTEGER CURRENT_TIMESTAMP,
      FOREIGN KEY('bookId') REFERENCES 'kitaplar'('id') ON UPDATE CASCADE ON DELETE CASCADE
      );
      
      '''

    );
  }
  void tabloGuncelle (Database db, int oldVersion, int newVersion) async{
    await db.execute(

      'ALTER TABLE kitaplar ADD COLUMN kategori INTEGER DEFAULT 0'


    );
  }

  Future<int> createBook (Book book) async{
    Database? db =await _veriTabaniniGetir();
    if(db!=null){
      return await db.insert('kitaplar', book.toMap());
    }
    else {
      return -1;
    }
  }
  Future<List<Book>> readBook(int kategoriId) async{
    List<Book> books = [];
    Database? db = await _veriTabaniniGetir();
    if(db!=null){
      List<Map<String,dynamic>> kitaplarMap = await db.query('kitaplar',where: 'kategori = ?',whereArgs: [kategoriId]);
      for(var m in kitaplarMap){
        Book book =Book.fromMap(m);
        books.add(book);
      }
    }
    return books;
  }
  Future<int> updateBook(Book book)async{
    int? kitapId = book.id;
    Database? db = await _veriTabaniniGetir();
    if(db!=null){
     return await db.update('kitaplar', book.toMap(),where:'id = ?',whereArgs: [kitapId] );
    }
    else {
      return 0;
    }
  }
  Future<int> deleteBook(Book book)async{
    int? kitapId = book.id;
    Database? db = await _veriTabaniniGetir();
    if(db!=null){
     return await db.delete('kitaplar',where: 'id = ?',whereArgs: [kitapId]);
    }else {
      return 0;
    }
  }
  Future<int> createBolum (Bolum bolum) async{
    Database? db =await _veriTabaniniGetir();
    if(db!=null){
      return await db.insert('bolumler', bolum.toMap());
    }
    else {
      return -1;
    }
  }
  Future<List<Bolum>> readBolum(int kitapId) async{
    List<Bolum> bolumler = [];
    Database? db = await _veriTabaniniGetir();
    if(db!=null){
      List<Map<String,dynamic>> bolumlerMap = await db.query('bolumler',where: 'bookId = ?',whereArgs: [kitapId]);
      for(var m in bolumlerMap){
        Bolum bolum =Bolum.fromMap(m);
        bolumler.add(bolum);
      }
    }
    return bolumler;
  }
  Future<int> updateBolum(Bolum bolum)async{
    int? bolumId = bolum.id;
    Database? db = await _veriTabaniniGetir();
    if(db!=null){
      return await db.update('bolumler', bolum.toMap(),where:'id = ?',whereArgs: [bolumId] );
    }
    else {
      return 0;
    }
  }
  Future<int> deleteBolum(Bolum bolum)async{
    int? bolumId = bolum.id;
    Database? db = await _veriTabaniniGetir();
    if(db!=null){
      return await db.delete('bolumler',where: 'id = ?',whereArgs: [bolumId]);
    }else {
      return 0;
    }
  }
}