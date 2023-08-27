import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const List<String> account = <String>['Cuenta Corriente ****0412'];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      home: PagoMovil(),
    );
  }
}

class PagoMovil extends StatefulWidget {
  @override
  _PagoMovilState createState() => _PagoMovilState();
}

class _PagoMovilState extends State<PagoMovil> {
  String _selectedCod = '0414';
  String _selectedCed = 'V-';
  String _selectedBank = '';
  final _phoneCtrl = TextEditingController();
  final _cedCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();

  final List<String> _codigos = ['0412', '0414', '0416', '0424', '0426'];
  final List<String> _tiposCed = ['V-', 'E-', 'J-', 'P-', 'G-'];
  final List<String> _bancos = [
    'Banco Banesco',
    'Banco BBVA',
    'Banco de Venezuela',
    'Bancaribe',
    'Banco Fondo Común'
    // Agrega aquí más opciones de banco si lo necesitas
  ];

  final appBar = AppBar(
    leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () => ()),
    title: const Text('Enviar Pago'),
    backgroundColor: Color(0xFF1F8C6D),
    centerTitle: false,
    actions: <Widget>[
      IconButton(
          onPressed: () => (),
          icon: Icon(
            Icons.logout,
            color: Colors.white,
            size: 24,
          ))
    ],
  );

  String dropdownValue = account.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Color(0xFF1F222B),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFF3B4455),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: dropdownValue,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: account.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  iconSize: 30,
                )),
              ),
              SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: const Text(
                      'Ingrese los datos del beneficiario o seleccione un Pago Frecuente',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFF007A51),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.people_outline),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ),
                      const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFF007A51),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.qr_code_scanner),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFF007A51),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Ingrese el número de teléfono',
                  labelText: 'Número de teléfono',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  prefixIcon: DropdownButton<String>(
                    value: _selectedCod,
                    onChanged: (value) {
                      setState(() {
                        _selectedCod = value!;
                      });
                    },
                    items: _codigos.map<DropdownMenuItem<String>>((cod) {
                      return DropdownMenuItem<String>(
                        value: cod,
                        child: Text(cod),
                      );
                    }).toList(),
                  ),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                controller: _phoneCtrl,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cedula de identidad',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedCed,
                        onChanged: (value) {
                          setState(() {
                            _selectedCed = value!;
                          });
                        },
                        items: _tiposCed.map<DropdownMenuItem<String>>((tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Introduzca el número de cédula',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 7, // Solo admite 7 dígitos
                      controller: _cedCtrl,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seleccione el banco',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Banco',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: _bankCtrl,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Introduzca el monto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Monto',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    () {}, // Aquí debes agregar el código para aceptar el pago

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF007A51),
                  minimumSize: const Size.fromHeight(40),
                ),
                child: Text(
                  'ACEPTAR',
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
