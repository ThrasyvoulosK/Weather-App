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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// keep favourites in a list
var favourites = [];

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  String selectedItem = '';

  void clearText() {
    fieldText.clear();
  }

  void _clearSearchField() {
    setState(() {
      selectedItem = ''; // Clear the search field
    });
  }

  //add a new favourite city
  void _addToFavourites() {
    //get city
    var newFavourite = cityNow;
    //print(newFavourite.city);

    for (var v in favourites) {
      if (v == newFavourite) {
        return;
      }
      //print(v.city);
    }

    setState(() {
      favourites.add(newFavourite);
      //print(favourites);
    });
  }

  //keep data from JSON file stored locally into a list of classes
  List<cities> _cityList = [];

  //import data from JSON and map it to the list
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
    var currentIcon = Icons.sunny;
    var currentCondition = "Sunny";

    //initialise default city with values
    var chosenCity = cities(
        city: currentCity,
        condition: currentCondition,
        icon: "white-balance-sunny",
        temperature: currentTemperature);

    if (cityNow != null) {
      chosenCity = cityNow;
    }

    currentCity = chosenCity.city!;

    currentTemperature = chosenCity.temperature!;
    var currentCelsiusTemperature = currentTemperature.toString() + " °C";
    var ic = MdiIcons.fromString(chosenCity.icon!);
    currentIcon = ic!;
    currentCondition = chosenCity.condition!;

    /*for (var data in _cityList) {
      print(
          "CityName: ${data.city}, Condition: ${data.condition}, Icon: ${data.icon}, Temperature ${data.temperature}");
    }*/
    //print(_cityList[0].city);

    void updateAllItems(cities city, IconData ic) {
      setState(() {
        currentCity = city.city!;
        currentCondition = city.condition!;
        currentCelsiusTemperature = currentTemperature.toString() + " °C";
        ic = MdiIcons.fromString(city.icon!)!;
        currentIcon = ic!;

        cityNow = city;
        //print(currentCity + currentCondition);
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //alignment: Alignment.topCenter,

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
                      //print('User clicked on: $suggestion');

                      // update screen with choice and close search bar
                      if (suggestion != errorString) {
                        for (var city in _cityList) {
                          if (suggestion == city.city) {
                            updateAllItems(city, ic);

                            filteredStrings.clear();

                            _clearSearchField();
                            clearText();

                            FocusScope.of(context).unfocus();

                            break;
                          }
                        }
                      }
                    },
                    child: ListTile(
                      title: Text(suggestion),
                    ),
                  );
                },
              ),
              Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentCity,
                        style: TextStyle(fontSize: 48),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            currentIcon,
                            size: 48,
                          ),
                          Flexible(
                              child: Text(currentCondition,
                                  style: TextStyle(fontSize: 36))),
                        ],
                      ),
                      //SizedBox(height: 5),
                      Text(currentCelsiusTemperature,
                          style: TextStyle(
                              fontSize: 64, fontWeight: FontWeight.w500))
                    ],
                  )),
              SizedBox(height: 0),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            //view Favourites Button
            Positioned(
              bottom: 68.0,
              right: 4.0,
              child: FloatingActionButton(
                heroTag: 'favView',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavouritesPage(
                              updateSelectedItem: updateAllItems)));
                },
                tooltip: 'View Favourites',
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
            //add to Favourites Button
            Positioned(
              bottom: 4.0,
              right: 4.0,
              child: FloatingActionButton(
                heroTag: 'favAdd',
                onPressed: _addToFavourites,
                tooltip: 'Add To Favourites',
                child: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ));
  }
}

class FavouritesPage extends StatelessWidget {
  final void Function(cities, IconData) updateSelectedItem;

  const FavouritesPage({Key? key, required this.updateSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('❤️ Favourites'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: ListView.builder(
        itemCount: favourites.length, // Replace with your actual item count
        itemBuilder: (context, index) {
          final item = favourites[index].city;
          return ListTile(
            title: Text(item),
            // Customize your list item here
            onTap: () {
              //print(item);
              var ic = MdiIcons.fromString(favourites[index].icon!)!;
              updateSelectedItem(favourites[index], ic);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
