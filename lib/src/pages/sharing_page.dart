import 'package:flutter/material.dart';
import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:moonline/src/utils/util.dart' as utils;

class ReceiveSharingPage extends StatefulWidget {
  @override
  _ReceiveSharingPageState createState() => _ReceiveSharingPageState();
}

class _ReceiveSharingPageState extends State<ReceiveSharingPage> {

  final formKey = GlobalKey<FormState>();

  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  String _sharedText;
  String _picturePath ="";
  @override
  void initState(){
    super.initState();

        // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        _picturePath = _sharedFiles[0].path;
        print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        _picturePath = _sharedFiles[0].path;
        print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
      });
    });
  }


  Widget build(BuildContext context) {
    const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: Text('MoonLine'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
               // _mostrarFoto(),
                //SizedBox(height: 30.0),
              //Text("Shared files:", style: textStyleBold),
              //Text(_sharedFiles?.map((f) => f.path)?.join(",") ?? ""),
              
              Text('Text:$_sharedText'),
              //_picturePath.length == 0 ? Container() : Text('Picture Path:$_picturePath'),
              _picturePath.length == 0 ? Container() : Image.asset(_picturePath),
               // _buscarId(),
               // _crearNombre(),
               // _crearBoton(),
              ],

            ),
          ),
        ),
      ),
      
    );
  }

  Widget _mostrarFoto() {
    return Image(

          image: AssetImage('assets/original.png'),
          height: 200.0,
          fit: BoxFit.cover,
        );
  }

  Widget _buscarId() {
      return TextFormField(
     // initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'ID'
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
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (){

      },
    );

  }
}