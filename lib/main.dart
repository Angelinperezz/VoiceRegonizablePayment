import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'Functions/Funciones.dart' as Clases;
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

const List<String> account = <String>['Cuenta Corriente ****0356'];

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
  final _amount = TextEditingController();

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

  final SpeechToText _speech = SpeechToText();
  SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _text = '';
  String _lastWords = '';
  String nuevoTexto = '';
  String finalTexto = '';
  int numeroMagico = 0;
  bool registrado = true;

  void _initSpeech() async {
    _isListening = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    setState(() {
      _text = '';
    });
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech status: $status');
          if (status == 'notListening') {
            _stopListening();
            hablar();
          }
        },
        onError: (error) {
          print('Error: $error');
        },
      );

      if (available) {
        var locales = await _speech.locales();
        print(locales.length);

        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            // Handle recognized speech result here
            _text = result.recognizedWords;
          },
          listenFor: Duration(seconds: 5),
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  String concatResult() {
    finalTexto = "$nuevoTexto $_lastWords";
    return "$nuevoTexto $_lastWords";
  }

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

  FlutterTts flutterTts = FlutterTts();

  Future textToSpeech(String text) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("es-VE");
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setPitch(0);
    await flutterTts.speak(text);
  }

  void hablar() async {
    switch (numeroMagico) {
      case 0:
        await textToSpeech(
            "Bienvenido al asistente de pagos de Banesco. Desea realizar un pago a un contacto ¿frecuente? ");
        numeroMagico++;
        break;
      case 1:
        if (_text.isEmpty) break;
        if (_text.toLowerCase().contains("si") ||
            _text.toLowerCase().contains("see")) {
          await textToSpeech("Diga el nombre de su contacto");
          registrado = true;
          numeroMagico++;
        } else if (_text.toLowerCase().contains("no")) {
          await textToSpeech(
              "Para realizar el pago se necesitan los datos del destinatario. Por favor diga el número de teléfono");
          numeroMagico = 5;
        } else {
          await textToSpeech("No entendí, podría repetir?");
        }
        break;
      case 2:
        if (_text.isEmpty) break;
        var lista = Clases.SearchDestinatario().filtro(_text);
        if (lista.isEmpty) {
          await textToSpeech("No se encontraron coincidencias para" + _text);
        } else if (lista.length == 1) {
          await textToSpeech("Desea pagarle a " + lista[0].alias + "?");
          numeroMagico++;
        } else {
          await textToSpeech("Se encontraron " +
              lista.length.toString() +
              " coincidencias para " +
              _text);
        }
        break;
      case 3:
        if (_text.isEmpty) break;
        if (_text.toLowerCase().contains("si") ||
            _text.toLowerCase().contains("see")) {
          await textToSpeech("Indique el monto a pagar");
          numeroMagico++;
        } else if (_text.toLowerCase().contains("no")) {
          await textToSpeech(
              "Gracias por utilizar el servicio de pago movil de Banesco");
          numeroMagico = 1000;
        } else {
          await textToSpeech("No entendí, podría repetir?");
        }
        break;
      case 4:
        if (_text.isEmpty) break;
        if (int.tryParse(_text) == null) {
          print(_text);
          await textToSpeech("Porfavor indique solo números");
        } else {
          await textToSpeech("El monto a pagar es " + _text + "?");
          numeroMagico=20;
        }
        break;

      case 5:
        if (_text.isEmpty) break;

        await textToSpeech(
            "El numero de telefono indicado es " + _text + "¿correcto?");
        numeroMagico++;
        break;

      case 6:
        if (_text.toLowerCase().contains("si") ||
            _text.toLowerCase().contains("see")) {
          numeroMagico++;
        } else {
          await textToSpeech("No entendí, podría repetir?");
        }

      case 7:
        await textToSpeech("Indique el banco del destinatario");
        numeroMagico++;

        break;
      case 8:
        if (_text.isEmpty) break;
        await textToSpeech(
            "El banco del destinatario es " + _text + "¿correcto?");
        numeroMagico++;
        break;

      case 9:
        if (_text.toLowerCase().contains("si") ||
            _text.toLowerCase().contains("see")) {
          numeroMagico++;
        } else {
          await textToSpeech("No entendí, podría repetir?");
        }
        break;
      case 10:
        await textToSpeech("Indique la cedula del destinatario");
        numeroMagico++;
        break;

      case 11:
        await textToSpeech(
            "El numero de cedula indicado es " + _text + "¿correcto?");
        numeroMagico++;
        break;
      case 12:
        if (_text.toLowerCase().contains("si") ||
            _text.toLowerCase().contains("see")) {
          numeroMagico = 3;
        } else {
          await textToSpeech("No entendí, podría repetir?");
        }
        break;

      case 20:
        await textToSpeech("Pago registrado exitosamente");

        break;
    }

    _startListening();
  }

  void _showPaymentProcessing(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop();
          // Aquí puedes continuar con la operación después del intervalo de 20 segundos
        });
        return Container(
          height: 300,
          color: Color(0xFF007A51),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Procesando su pago",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentSuccess(BuildContext context) {
    String referencia = "002983982"; // Número de referencia ficticio
    String fecha = "27/08/2023";
    String cuenta = "****0356"; // Número de cuenta ficticio
    String telefono = _phoneCtrl.text; // Número de teléfono ficticio
    String monto = _amount.text;
    String concepto = "Pago de servicio"; // Concepto

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Color(0xFF007A51),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Operación exitosa",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Desde mi cuenta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "$cuenta - $telefono",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Monto: \$$monto",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Concepto: $concepto",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Número de referencia: $referencia",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Fecha: $fecha",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
    _bankCtrl.clear();
    _cedCtrl.clear();
    _phoneCtrl.clear();
    _amount.clear();
  }

  //textToSpeech('texto');
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
