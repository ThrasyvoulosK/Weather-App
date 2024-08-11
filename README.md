# Weather App
 A simple weather application made in Flutter, built primarily for Android.  
<img src="https://github.com/ThrasyvoulosK/Weather-App/blob/main/images/mainScreen.png" width=270 height=480>
## Installation
To try out this project, grab the files from this GitHub repository and place them in your computer. This is a Visual Studio Code project, so make sure you have everything needed to run code for Flutter.
## Functionality
### What Does It Do?
It's a small app displaying weather information for a number of cities. Such information includes: 
1. The name of the city,
2. Its weather condition description,
3. An accompanying icon for it, as well as
4. The city's temperature (*in Celsius*).
### SearchBar
The user is allowed to search for a particular city. Clicking on it will update the main screen with values corresponding to it. Searching for an invalid city will display an error message...  
<img src="https://github.com/ThrasyvoulosK/Weather-App/blob/main/images/searchBar.png" width=270 height=480>
### Favourites
The user can keep a number of cities as 'Favourites' and can revisit them later on. To do so, one may click on the 'Plus' icon button in order to add the current city to Favourites. To view them all together as a list they may click on the 'Heart' icon button. Navigation to the Main Screen is done by the 'Back' Button.  
<img src="https://github.com/ThrasyvoulosK/Weather-App/blob/main/images/favourites.png" width=270 height=480>
## Automated Testing
As a bonus, this application runs a number of Unit Tests, designed to ensure much of the app's proper functionality, including tests on the 'Search Bar', the 'Favourites' page, and the buttons on the first screen.  They're located in the 'test' folder.
