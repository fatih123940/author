import 'package:author/sabitler.dart';
import 'package:author/yerel_veri_tabani.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';
import 'bolumler_sayfasi.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  YerelVeriTabani _yerelVeriTabani = YerelVeriTabani();
  List<Book> kitaplar = [];
  int secilenKategori =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitaplar Listesi'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Kategori:'),
              DropdownButton<int>(
                value: secilenKategori,
                items: Sabitler.kategoriler.keys.map((int key) {
                  return DropdownMenuItem<int>(
                    value: key,
                    child: Text(Sabitler.kategoriler[key]!),
                  );
                }).toList(),
                onChanged: (int? yeniDeger) {
                  setState(() {
                    secilenKategori = yeniDeger!;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(future: _kitaplariGetir(), builder: (context,asyncSnapshot){
              return ListView.builder(itemCount:kitaplar.length,itemBuilder: (context,index){
                return ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi(book: kitaplar[index],)));
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon:Icon(Icons.edit),onPressed: ()async{
                List<dynamic>? sonuc=await _showMyDialog();
                String? yeniKitapAdi = sonuc?[0];
                int? kategori =sonuc?[1];
                if(yeniKitapAdi!=null && kategori != null){
                  kitaplar[index].name=yeniKitapAdi;
                await _yerelVeriTabani.updateBook(kitaplar[index]);
                setState(() {

                });

                };



                }),
                      IconButton(onPressed: ()async{
                        await _yerelVeriTabani.deleteBook(kitaplar[index]);
                        setState(() {

                        });
                      }, icon: Icon(Icons.delete))
                    ],
                  ),
                  leading: CircleAvatar(child: Text(kitaplar[index].id.toString()),),
                  title: Text(kitaplar[index].name),
                  subtitle: Text(Sabitler.kategoriler[kitaplar[index].kategori]?? ''),
                );
              });
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        List<dynamic> ? sonuc =await _showMyDialog();
        String? kitapAdi = sonuc?[0];
        int? kategori = sonuc?[1];
        if(kitapAdi != null && kategori != null){
          Book newBook = Book(name: kitapAdi, createdAt: DateTime.now(),kategori: kategori);
          await _yerelVeriTabani.createBook(newBook);
          setState(() {

          });
        }
      },child: Icon(Icons.add),),
    );
  }
  Future<void> _kitaplariGetir() async{
    kitaplar = await _yerelVeriTabani.readBook(secilenKategori);
  }
  Future<List<dynamic>?> _showMyDialog() async {
    String? sonuc;
    int kategori =0;
    return showDialog<List<dynamic>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Yeni Kitap Ekle'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
            StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (yeniDeger) {
                  sonuc = yeniDeger;
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kategori:'),
                  DropdownButton<int>(
                    value: kategori,
                    items: Sabitler.kategoriler.keys.map((int key) {
                      return DropdownMenuItem<int>(
                        value: key,
                        child: Text(Sabitler.kategoriler[key]!),
                      );
                    }).toList(),
                    onChanged: (int? yeniDeger) {
                      setState(() {
                        kategori = yeniDeger!;
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        },
        )


              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(onPressed: (){
              Navigator.pop(context,[sonuc,kategori]);
            }, child: Text('Ekle'))
          ],
        );
      },
    );
  }
}
