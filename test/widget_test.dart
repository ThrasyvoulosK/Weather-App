// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_thr/cities.dart';

import 'package:weather_app_thr/main.dart';

void main() {

  testWidgets('Find Default App', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyWeatherApp());

    //expect to find the title and placeholder city
    expect(find.text('My Weather App'), findsOneWidget);
    expect(find.text('Athens'), findsOneWidget);

  });

  testWidgets('Test City Constructor', (WidgetTester tester) async {
    var newCity=cities(city: "Patras",temperature: 39,condition: "Sunny",icon: "sun");

    expect(newCity.city,"Patras");
  });

  testWidgets('Heart Button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWeatherApp());

    //find heart button
    expect(find.byIcon(Icons.favorite),findsOne);

    //click and find 'Favourites' Page
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.text("❤️ Favourites"),findsOneWidget);

  });

  testWidgets('Plus Button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWeatherApp());

    expect(find.byIcon(Icons.add),findsOne);

    expect(find.text("🔍 Search City..."),findsOne);
    await tester.tap(find.text("🔍 Search City..."));
    await tester.enterText(find.byType(TextField), 'se');
    await tester.pumpAndSettle();
    await tester.tap(find.text("Seattle"));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    //we're in favourites, where there's no weather description
    expect(find.text("Seattle"), findsOne);
    expect(find.text("Cloudy"),findsNothing);
    
  });

  testWidgets('Search Bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWeatherApp());

    expect(find.text("🔍 Search City..."),findsOne);
    await tester.tap(find.text("🔍 Search City..."));
    await tester.enterText(find.byType(TextField), 'se');
    await tester.pumpAndSettle();
    //seattle should be on the list
    expect(find.text("Seattle"), findsOne);    
  });

}
