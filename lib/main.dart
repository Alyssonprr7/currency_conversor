import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // converter para Json 

const request = 'https://api.hgbrasil.com/finance?format=json-cors&key=2b592fb7';

void main() async {
  await getData(); //Chama a função do futuro 
 

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
      ),
      hintColor: Colors.amber,
      primaryColor: Colors.white //Cor da borda no Onfocus
    ),
  ));
}

Future<Map> getData() async { // Mapear uma função futura 
  http.Response response = await http.get(request);
   return json.decode(response.body); //estou entrando nos parametros do Json
}




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void clearAll ( ) { 
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }


  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged (String text){ 
    if(text.isEmpty) {
      clearAll();
      return ; 
    }

    double real = double.parse(text); //Transforma a string 'text' em um double de nome real
    dolarController.text = (real/dolar).toStringAsFixed(2); // COnverte para String em apens dois digitos de casa decimal
    euroController.text = (real/euro).toStringAsFixed(2); // COnverte para String em apens dois digitos de casa decimal
  }

  void _dolarChanged (String text){ 
    if(text.isEmpty) {
      clearAll();
      return ; 
    }
    double dolar = double.parse(text); //Transforma a string 'text' em um double de nome real
    realController.text = (dolar * this.dolar).toStringAsFixed(2); // COnverte para String em apens dois digitos de casa decimal
    euroController.text = ((dolar*this.dolar)/euro).toStringAsFixed(2); // COnverte para String em apens dois digitos de casa decimal
  }

  void _euroChanged (String text){ 
    if(text.isEmpty) {
      clearAll();
      return ; 
    }
    double euro = double.parse(text); //Transforma a string 'text' em um double de nome real
    realController.text = (euro * this.euro).toStringAsFixed(2); // COnverte para String em apens dois digitos de casa decimal
    dolarController.text = ((euro*this.euro)/dolar).toStringAsFixed(2);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center (
                child: Text("Carregando Dados", 
                style: TextStyle (
                  color: Colors.amber,
                  fontSize: 25.0),
                textAlign: TextAlign.center,)
                ,);
            default:
              if (snapshot.hasError) {
                return Center (
                child: Text("Erro ao Carregar Dados", 
                style: TextStyle (
                  color: Colors.amber,
                  fontSize: 25.0),
                textAlign: TextAlign.center,)
                ,);
              }else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber,),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField('Dólares', "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euros","€", euroController, _euroChanged)                
                    ],
                  ),
                );
              }
          }
        }
      ),
      
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controlador, Function changedInput) {
  return TextField (
          controller: controlador,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.amber),
            border: OutlineInputBorder(),
            prefixText: prefix
          ),
          style: TextStyle(
            color: Colors.amber, fontSize: 25.0),
          onChanged: changedInput,
          keyboardType: TextInputType.number, //Colocar apenas numeros 
        );

}