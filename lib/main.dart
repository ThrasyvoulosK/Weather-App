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

  String selectedItem = '';

  void clearText() {
    fieldText.clear();
  }

  void _clearSearchField() {
    setState(() {
      selectedItem = ''; // Clear the search field
    });
  }

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
    final String response =
        await rootBundle.loadString('data/MockWeatherJSON.json');
    final data = await json.decode(response);

    final List<cities> dataList = (data["cities"] as List)
        .map((item) => cities(
            city: item["city"],
            condition: item["condition"],
            temperature: item["temperature"],
            icon: item["icon"]))
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

  final List<String> _results = [];

  void _handleSearch(String input) {
    _results.clear(); // Clear previous results
    for (var item in _cityList) {
      var cityString = item.city;
      if (cityString!.contains(input)) {
        _results.add(cityString);
      }
    }
    // Optionally limit the results to a specific number (e.g., 5)
    if (_results.length > 5) {
      _results.removeRange(5, _results.length);
    }
    // Update the UI to reflect the filtered results
    setState(() {});
  }

  final List<String> allStrings = [];

  List<String> filteredStrings = [];

  var errorString = "No Results";

  void _updateSuggestions(String query) {
    if (_cityList.length > allStrings.length) {
      for (var city in _cityList) {
        allStrings.add(city.city!);
      }
    }
    selectedItem = selectedItem + query;
    //limit suggestions to a small number
    var limit = 5;

    setState(() {
      filteredStrings = allStrings
          .where((string) => string.toLowerCase().contains(query.toLowerCase()))
          .take(limit) // Limit suggestions
          .toList();

      //display error if search yields no results
      if (filteredStrings.isEmpty) filteredStrings.add(errorString);
    });
  }

  var cityNow;

  final fieldText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var currentCity = "Athens";
    var currentTemperature = 36;
    //var currentCelsiusTemperature=currentTemperature.toString()+" C";
    var currentIcon = Icons.sunny;
    var currentCondition = "Sunny";

    /*for (var data in _cityList) {
      print(
          "CityName: ${data.city}, Condition: ${data.condition}, Icon: ${data.icon}, Temperature ${data.temperature}");
    }*/
    //print(_cityList[0].city);

    var chosenCity = _cityList[0];

    if (cityNow != null) chosenCity = cityNow;

    currentCity = chosenCity.city!;

    currentTemperature = chosenCity.temperature!;
    var currentCelsiusTemperature = currentTemperature.toString() + " °C";
    var ic = MdiIcons.fromString(chosenCity.icon!);
    currentIcon = ic!;
    currentCondition = chosenCity.condition!;

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

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[
              TextField(
                onChanged: _updateSuggestions,
                //controller: TextEditingController(text: selectedItem),
                controller: fieldText,
                //onTapOutside: ,
                decoration: const InputDecoration(
                  hintText: '🔍 Search City...',
                  border: OutlineInputBorder(),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredStrings.length,
                itemBuilder: (context, index) {
                  final suggestion = filteredStrings[index];

                  return GestureDetector(
                    onTap: () {
                      // Handle the suggestion item click here
                      print('User clicked on: $suggestion');
                      // Add your custom logic (e.g., navigation, state update, etc.)
                      if (suggestion != errorString) {
                        for (var city in _cityList) {
                          if (suggestion == city.city) {
                            setState(() {
                              currentCity = city.city!;
                              currentCondition = city.condition!;
                              currentCelsiusTemperature =
                                  currentTemperature.toString() + " °C";
                              ic = MdiIcons.fromString(city.icon!);
                              currentIcon = ic!;

                              cityNow = city;
                              print(currentCity + currentCondition);
                            });

                            filteredStrings.clear();

                            _clearSearchField();
                            clearText();

                            FocusScope.of(context).unfocus();

                            break;
                          }
                        }
                      }
                      //Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(suggestion),
                    ),
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.all(100.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: 
                Column(children: [
                  Text(currentCity, style: TextStyle(fontSize: 48)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    currentIcon,
                    size: 48,
                  ),
                  Text(currentCondition, style: TextStyle(fontSize: 48)),
                ],
              ),
              SizedBox(height: 10),
              Text(currentCelsiusTemperature, style: TextStyle(fontSize: 48))

                ],)
              
              )
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              child: FloatingActionButton(
                onPressed: null,
                tooltip: 'View Favourites',
                child: Icon(Icons.favorite),
              ),
              bottom: 80.0,
              right: 8.0,
            ),
            Positioned(
              child: FloatingActionButton(
                onPressed: _addToFavourites,
                tooltip: 'Add To Favourites',
                child: const Icon(Icons.add),
              ),
              bottom: 16.0,
              right: 8.0,
            ),
          ],
        ));
  }
}

  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}*/
