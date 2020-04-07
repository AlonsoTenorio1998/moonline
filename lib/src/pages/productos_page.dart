import 'package:flutter/material.dart';
import 'package:moonline/src/models/producto_model.dart';
import 'package:moonline/src/providers/productos_provider.dart';

class ProductoPage extends StatelessWidget {

  final productoProvider = new ProductoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context) ,
    );
  }
   Widget _crearListado() {
     return FutureBuilder(
       future: productoProvider.cargarProductos(),
       builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
         if (snapshot.hasData){

          final productos = snapshot.data;
           return ListView.builder(
             itemCount: productos.length,
             itemBuilder: (context, i)=> _crearItem(context, productos[i]),
             );

         } else {

           return Center(
            child: CircularProgressIndicator(),
           );
         }
       }
      );
    }
    Widget _crearItem(BuildContext context, ProductoModel producto){
      return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion){
          productoProvider.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[

              ( producto.fotoUrl == null )
                ? Image(image: AssetImage('assets/original.png'))
                : FadeInImage(
                  image: NetworkImage( producto.fotoUrl),
                  placeholder: AssetImage('assets/original.gif'),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover, 
                  ),

                ListTile(
                  title: Text('${ producto.titulo} - ${producto.valor}'),
                  subtitle: Text(producto.id),
                  onTap: ()=> Navigator.pushNamed(context, 'CompartirPage', arguments: producto),
                ),

            ],
          ),
        )
      );

     
    }
  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=> Navigator.pushNamed(context, 'CompartirPage'),
      );
  }


}