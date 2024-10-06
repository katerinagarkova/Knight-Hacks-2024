import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

void main() {
  runApp(
    const MaterialApp(
      home: StartPage(),
    ),
  );
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
 /* UsbPort? _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;

  TextEditingController _textController = TextEditingController();

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port!.close();
      _port = null;
    }

    if (device == null) {
      _device = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }
    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(_port!.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction!.stream.listen((String line) {
      setState(() {
        _serialData.add(Text(line));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (!devices.contains(_device)) {
      _connectTo(null);
    }
    print(devices);

    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName!),
          subtitle: Text(device.manufacturerName!),
          trailing: ElevatedButton(
            child: Text(_device == device ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(_device == device ? null : device).then((res) {
                _getPorts();
              });
            },
          )));
    });

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(34, 34, 39, 1.0), Color.fromRGBO(93, 122, 173, 1.0)],
            // stops: [0.4, 0.6],
            begin:Alignment.topCenter,
            end: Alignment.bottomCenter, 
            ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bloom Buddy',
                  style: TextStyle(
                  color: Color.fromRGBO(75, 95, 121, 1.0),
                    fontWeight: FontWeight.w100,
                    fontSize: 55,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Image.asset(
                  'imgs/bloombuddylogotrans.png',
                  width: 300,
                  height: 400,
                ),
              ElevatedButton(
          onPressed: () {
            // Navigate to the main page when button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
          child: Text('Continue'),
        ),
                  ],
                ),
                
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloom Buddy'),
        backgroundColor: Color.fromRGBO(75, 95, 121, 1.0), 
      ),
      body: Container(
        // Set the gradient background using BoxDecoration
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(34, 34, 39, 1.0), Color.fromRGBO(93, 122, 173, 1.0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
          // Add a centered image
          child: Center(
            child: Image.network(
            'imgs/bloombuddyplanttrans.png', // Example image URL
            width: 500,
            height: 500,
          ),
        ),
      ),
      // Text above the icons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Plant Stats:',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Temperature
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Temperature',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.thermostat,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      '50 degrees',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                // Brightness
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Brightness',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.sunny,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      '30%',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                // Moisture Level
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Moisture Level',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.water_drop,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      '30%',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}