import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonline/src/models/producto_model.dart';
import 'package:moonline/src/utils/util.dart' as utils;

class CompartirPage extends StatefulWidget {

  @override
  _CompartirPageState createState() => _CompartirPageState();
}

class _CompartirPageState extends State<CompartirPage> {
  final formKey = GlobalKey<FormState>();
  File foto;

  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compartir'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
         ),
         IconButton(
           icon: Icon(Icons.camera_alt),
           onPressed: _tomarFoto,
         )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFofo(),
                _buscarId(),
                _crearNombre(),
                _crearBoton(),
              ],   
            ),
          ),
        ),
      ),
      
    );
  }

  Widget _buscarId() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'ID'
      ),
      onSaved: (value)=> producto.valor = double.parse(value) ,
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
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value)=> producto.titulo = value,
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
      onPressed: _submit,
    );
  }

  void _submit() {

    if ( !formKey.currentState.validate() ) return;

    formKey.currentState.save();

    print( producto.titulo);
    print( producto.valor);

    if ( formKey.currentState.validate() ){

    }

  }

    Widget _mostrarFofo(){

      if ( producto.fotoUrl !=null) {
        

        return Container();
      } else {

        return Image(

          image: AssetImage('assets/original.png'),
          height: 300.0,
          fit: BoxFit.cover,
        );
      }
    }

    _seleccionarFoto() async {

      foto = await ImagePicker.pickImage(
        source: ImageSource.gallery
      );

      if ( foto !=null ) {
        //Limpieza 
      }

      setState(() {
        
      });
  }

  _tomarFoto(){


  }
}