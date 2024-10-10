import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:knob_widget/knob_widget.dart';
import 'dart:io';
import 'package:ctelnet/ctelnet.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 

{
  const MyApp({super.key});


Future<void> connect(String host, int port) async
 {
  if (kDebugMode) {
    print('Connecting to $host:$port');
  }

  final client = CTelnetClient(
    host: host,
    port: port,
    timeout: const Duration(seconds: 30),
    onConnect: () 
    {     
      if (kDebugMode) 
      {
      print('Connecting to $host:$port');
      }
    },
    
    onDisconnect: () 
    {     
      if (kDebugMode) 
      {
      print('Desconectado!');
      }
    },    
    
    onError: (error) 
    {     
      if (kDebugMode) 
      {
      print('Erro $error');
      }
    },
    
  );

  final stream = await client.connect();
  final subscription = stream?.listen((data) => print('Data received: ${data.text}'));
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Knob Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'ARM NR005'),
    );
  }
}

class MyHomePage extends StatefulWidget 
{
  const MyHomePage
  (
    
    {
     super.key,
     required this.title,
    }
  );

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
  final double _minimum = 0;
  final double _maximum = 360;

  late KnobController _controller;
  late double _knobValue;

  void valueChangedListener(double value) 
  
  {
    if (mounted) 
    {
      setState(() 
      {
        _knobValue = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _knobValue = _minimum;
    _controller = KnobController(
      initial: _knobValue,
      minimum: _minimum,
      maximum: _maximum,
      startAngle: 0,
      endAngle: 360,
      precision: 1,
    );
    _controller.addOnValueChangedListener(valueChangedListener);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: 
          [


             Padding
                (
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                
                 child: Center
                 (  
                child: Image.asset('assets/images/arm.png'),  
                 ),   
                ),           
            
            Text(_knobValue.toString()),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                var value =
                    Random().nextDouble() * (_maximum - _minimum) + _minimum;
                _controller.setCurrentValue(value);
              },
              child: const Text('Update Knob Value'),
            ),
            const SizedBox(height: 75),
            Container(
              child: Knob(
                controller: _controller,
                width: 150,
                height: 150,
                style: KnobStyle(
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  tickOffset: 5,
                  labelOffset: 10,
                  minorTicksPerInterval: 10,
                  showMinorTickLabels: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeOnValueChangedListener(valueChangedListener);
    super.dispose();
  }
}
