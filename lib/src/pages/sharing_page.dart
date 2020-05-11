import 'package:flutter/material.dart';
import 'package:moonline/src/pages/home_page.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:moonline/src/utils/util.dart' as utils;
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

class ReceiveSharingPage extends StatefulWidget {
  @override
  _ReceiveSharingPageState createState() => _ReceiveSharingPageState();
}

class _ReceiveSharingPageState extends State<ReceiveSharingPage> {

  StreamSubscription _intentDataStreamSubscription;

  List<SharedMediaFile> _sharedFiles;
  
  String _picturePath = '';
  File pictureFile;

  
  @override
  void initState(){
    super.initState();  
  //Para compartir imágenes que provienen de fuera de la aplicación mientras la aplicación está en la memoria
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
        _sharedFiles = value;
        _picturePath = _sharedFiles[0].path;
        pictureFile = new File(_picturePath);
        print(pictureFile.existsSync());
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    //Para compartir imágenes que provienen de fuera de la aplicación mientras la aplicación está cerrada
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        _picturePath = _sharedFiles[0].path;
        pictureFile = new File(_picturePath);
        print(pictureFile.existsSync());
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Comprobante', style: TextStyle( color: Colors.black87),),
        actions: <Widget>[
         IconButton(
          icon: Icon(Icons.clear), 
          onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()),
          ),
         )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: <Widget>[
           Text('Referencia'),
           _buscarId(),
           // _crearNombre(),
           _crearBoton(),
    
          pictureFile != null && pictureFile.existsSync()
            ? Image.memory(
             Uint8List.fromList(pictureFile.readAsBytesSync()),
             alignment: Alignment.center,
             height: 250,
             width: 250,
             fit: BoxFit.contain,
            )
              : Container(),       
          ],
        ), 
      ), 
    );
  }

  Widget _buscarId() {
      return TextFormField(
     // initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Ingresa No. de pedido'
      ),
      //onSaved: (value)=> producto.valor = double.parse(value) ,
      validator: (value){

        if( utils.isNumeric(value) ){
          return null;

        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearNombre() {
    return TextFormField(
     // initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      //onSaved: (value)=> producto.titulo = value,
      validator: (value) {
        if (value.length <3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
     // shape: RoundedRectangleBorder(
      //  borderRadius: BorderRadius.circular(20.0)
     // ),
      color: Colors.blue,
      textColor: Colors.white,
      label: Text('Buscar'),
      icon: Icon(Icons.search),
      onPressed: (){

      },
    );
  }
}