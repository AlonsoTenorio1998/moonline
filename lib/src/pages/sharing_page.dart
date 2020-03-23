import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:moonline/src/utils/util.dart' as utils;

class ReceiveSharingPage extends StatefulWidget {
  @override
  _ReceiveSharingPageState createState() => _ReceiveSharingPageState();
}

class _ReceiveSharingPageState extends State<ReceiveSharingPage> {

  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  String _sharedText = '';
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

    //Para compartir o abrir URL / mensajes de texto que provienen de fuera de la aplicación mientras la aplicación está en la memoria
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    //Para compartir o abrir URL / mensajes de texto que provienen de fuera de la aplicación mientras la aplicación está cerrada
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _sharedText = value != null ? value : '';
      });
    });
  }


  Widget build(BuildContext context) {
    //const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: Text('MoonLine'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text('Referencia'),
                _buscarId(),
              // _crearNombre(),
               _crearBoton(),
                //SizedBox(height: 30.0),
                 //Text('Text:$_sharedText'), _picturePath.length == 0 ? Container() :
                // Text('Picture Path:$_picturePath'),
            // _picturePath.length == 0 ? Container() : Image.asset(_picturePath)
            pictureFile != null && pictureFile.existsSync()
                ? Image.memory(
                    Uint8List.fromList(pictureFile.readAsBytesSync()),
                    alignment: Alignment.center,
                    height: 300,
                    width: 300,
                    fit: BoxFit.contain,
                  )
                : Container(),
               
              //Para compartir la url de la imagen
              //Text("Shared files:", style: textStyleBold),
              //Text(_sharedFiles?.map((f) => f.path)?.join(",") ?? ""),
              
              ],
            ), 
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.blue,
      textColor: Colors.white,
      label: Text('Buscar'),
      icon: Icon(Icons.search),
      onPressed: (){

      },
    );

  }
}