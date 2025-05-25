import 'package:author/model/bolum.dart';
import 'package:author/yerel_veri_tabani.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';

class BolumlerSayfasi extends StatefulWidget {
  Book book;
   BolumlerSayfasi({super.key,required this.book});

  @override
  State<BolumlerSayfasi> createState() => _BolumlerSayfasiState();
}

class _BolumlerSayfasiState extends State<BolumlerSayfasi> {
  YerelVeriTabani _yerelVeriTabani = YerelVeriTabani();
  List<Bolum> bolumler = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.name),
      ),
      body: FutureBuilder(future: _bolumleriGetir(widget.book.id!), builder: (context,asyncSnapshot){
        return ListView.builder(itemCount:bolumler.length,itemBuilder: (context,index){
          return ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon:Icon(Icons.edit),onPressed: ()async{
                  String? yeniBolumAdi=await _showMyDialog();
                  if(yeniBolumAdi!=null){
                    bolumler[index].title=yeniBolumAdi;
                    await _yerelVeriTabani.updateBolum(bolumler[index]);
                    setState(() {

                    });

                  };



                }),
                IconButton(onPressed: ()async{
                  await _yerelVeriTabani.deleteBolum(bolumler[index]);
                  setState(() {

                  });
                }, icon: Icon(Icons.delete))
              ],
            ),
            leading: CircleAvatar(child: Text(bolumler[index].id.toString()),),
            title: Text(bolumler[index].title),
          );
        });
      }),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        String? bolumAdi =await _showMyDialog();
        if(bolumAdi != null){
          Bolum newBolum = Bolum(title: bolumAdi, kitapId: widget.book.id!, icerik: '',);
          await _yerelVeriTabani.createBolum(newBolum);
          setState(() {

          });
        }
      },child: Icon(Icons.add),),
    );
  }
  Future<void> _bolumleriGetir(int kitapId) async{
    bolumler = await _yerelVeriTabani.readBolum(kitapId);
  }
  Future<String?> _showMyDialog() async {
    String? sonuc;
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Bölüm Ekle'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (yeniDeger){
                    sonuc=yeniDeger;
                  },
                ),
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
              Navigator.pop(context,sonuc);
            }, child: Text('Ekle'))
          ],
        );
      },
    );
  }
}
