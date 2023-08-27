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

  final bottomBar = BottomNavigationBar(
    backgroundColor: Color(0xFF3B4455),
    selectedItemColor: Colors.white,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.phone_android_rounded),
        label: 'PAGO MÓVIL',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.paid, color: Colors.grey),
        label: 'TRANSFERIR',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.lightbulb,
          color: Colors.grey,
        ),
        label: 'SERVICIOS',
      ),
    ],
  );

  String dropdownValue = account.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        backgroundColor: Color(0xFF1F222B),
        bottomNavigationBar: bottomBar,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      value: dropdownValue,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: account.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.black)),
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
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 300,
                                        color: Color(0xFF007A51),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Color(0xFF1F222B),
                                              child: TextFormField(),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Número de teléfono',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCod,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCod = value!;
                                        });
                                      },
                                      items: _codigos
                                          .map<DropdownMenuItem<String>>((cod) {
                                        return DropdownMenuItem<String>(
                                          value: cod,
                                          child: Text(cod),
                                        );
                                      }).toList(),
                                    ),
                                  ))),
                          SizedBox(width: 8),
                          Expanded(
                              flex: 3,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Número de teléfono',
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                controller: _phoneCtrl,
                              ))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
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
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCed,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCed = value!;
                                        });
                                      },
                                      items: _tiposCed
                                          .map<DropdownMenuItem<String>>(
                                              (tipo) {
                                        return DropdownMenuItem<String>(
                                          value: tipo,
                                          child: Text(tipo),
                                        );
                                      }).toList(),
                                    ),
                                  ))),
                          SizedBox(width: 8),
                          Expanded(
                              flex: 3,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Cedula de identidad',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                controller: _cedCtrl,
                              )),
                          SizedBox(width: 16),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Banco',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
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
                        'Monto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Concepto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Concepto',
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
        ));
  }
}
