import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'cities.dart';

void main() async {
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather App',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  void _addToFavourites() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  //keep data from JSON file stored locally into a list of classes
  List<cities> _cityList = [];

  Future<List<cities>> readJson() async {
    final String response = await rootBundle.loadString('data/MockWeatherJSON.json');
    final data = await json.decode(response);

    final List<cities> dataList = (data["cities"] as List)
      .map((item) => cities(
            city: item["city"],
            condition: item["condition"],
            temperature: item["temperature"],
            icon: item["icon"]
          ))
      .toList();

    return dataList;
  }

//initialise data when starting the program
  @override
void initState() {
  super.initState();
  _loadData();
}

//load the list of cities and update the app's data
Future<void> _loadData() async {
  final dataList = await readJson();
  setState(() {
    _cityList = dataList;
  });
}

  @override
  Widget build(BuildContext context) {

    var currentCity="Athens";
    var currentTemperature=36;
    //var currentCelsiusTemperature=currentTemperature.toString()+" C";
    var currentIcon=Icons.sunny;
    var currentCondition="Sunny";
    
    
    for (var data in _cityList) {
      print("CityName: ${data.city}, Condition: ${data.condition}, Icon: ${data.icon}, Temperature ${data.temperature}");
    }
    //print(_cityList[0].city);

    var chosenCity=_cityList[11];

    currentCity=chosenCity.city!;
    
    currentTemperature=chosenCity.temperature!;
    var currentCelsiusTemperature=currentTemperature.toString()+" °C";
    var ic=MdiIcons.fromString(chosenCity.icon!);
    currentIcon=ic!;
    currentCondition=chosenCity.condition!;

    

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.search,size:48),
                Text("Search"),
                Icon(Icons.favorite,size: 48,),
              ],
            ),
            Text(currentCity,style: TextStyle(fontSize: 48)),
            Text(currentCelsiusTemperature,style: TextStyle(fontSize: 64)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(currentIcon,size: 48,),
                Text(currentCondition,style: TextStyle(fontSize: 32)),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToFavourites,
        tooltip: 'Add To Favourites',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}*/
