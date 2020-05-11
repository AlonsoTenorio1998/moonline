// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ComprobanteModel comprobanteModelFromJson(String str) => ComprobanteModel.fromJson(json.decode(str));

String comprobanteModelToJson(ComprobanteModel data) => json.encode(data.toJson());

class ComprobanteModel {

    String id;
    String numcompra;
    int    numcliente;
    String fotoUrl;

    ComprobanteModel({
        this.id,
        this.numcompra = '',
        this.numcliente  = 1,
        this.fotoUrl,
    });

    factory ComprobanteModel.fromJson(Map<String, dynamic> json) => new ComprobanteModel(
        id         : json["id"],
        numcompra  : json["numcompra"],
        numcliente : json["numcliente"],
        fotoUrl    : json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        //"id"         : id,
        "numcompra"  : numcompra,
        "numcliente" : numcliente,
        "fotoUrl"    : fotoUrl,
    };
}