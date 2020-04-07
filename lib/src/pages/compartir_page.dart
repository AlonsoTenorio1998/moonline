import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:moonline/src/models/producto_model.dart';
import 'package:moonline/src/providers/productos_provider.dart';
import 'package:moonline/src/utils/util.dart' as utils;

class CompartirPage extends StatefulWidget {

  @override
  _CompartirPageState createState() => _CompartirPageState();
}

class _CompartirPageState extends State<CompartirPage> {

  
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductoProvider();
  File foto;

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if( prodData != null){
      producto = prodData;
    }



    return Scaffold(
      key: scaffoldKey,
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
                _crearDisponible(),
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


    Widget _mostrarFofo(){

      if ( producto.fotoUrl !=null) {
        

        return FadeInImage(
          image: NetworkImage(producto.fotoUrl),
          placeholder: AssetImage('assets/original.gif'),
          height: 300.0,
          fit: BoxFit.contain, 
          );
      } else {

        return Image(

          image: AssetImage( foto?.path ?? 'assets/original.png'),
          height: 300.0,
          fit: BoxFit.cover,
        );
      }
    }

   _seleccionarFoto() async {
     
     _procesarImagen(ImageSource.gallery);
      
  }

  _tomarFoto() async {
   
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen( ImageSource origen ) async{
     foto = await ImagePicker.pickImage(
        source: origen
      );

      if ( foto !=null ) {
        //Limpieza 
        producto.fotoUrl = null;
      }

      setState(() {
        
      });
  }

  _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible, 
      title: Text('Disponible'),
      onChanged: (value)=> setState((){
        producto.disponible = value;
      }),
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
      onPressed:(_guardando) ? null: _submit,
    );
  }

  void _submit() async {

    if ( !formKey.currentState.validate() ) return;

    formKey.currentState.save();

    setState(() {_guardando = true; });

    if ( foto != null){
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    }




    if ( producto.id == null){
    productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    //setState(() {_guardando = false; }); 
    mostarSnackbar('Registro Guardado');

    Navigator.pop(context);

    /*if ( formKey.currentState.validate() ){

    }*/

  }

    void mostarSnackbar(String mensaje){

      final snackbar = SnackBar(
        content: Text(mensaje),
        duration: Duration(milliseconds: 1500),
        );

        scaffoldKey.currentState.showSnackBar(snackbar);
    }


    

}