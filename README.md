
# Movie Time - Powered by TMDb Framework
**TMDb-Framework** is a custom Swift Framework built to support **discovering movies** / **searching for movies** by a keyword. Uses **singleton, callback closures and delegation design patterns**, it is a simple piece of code you can refer to learn getting started with building iOS Frameworks.
![MovieDB iOS 13+ mobile application](https://raw.githubusercontent.com/iAkashlal/movieDB/master/TMDb-Client/Screenshots/2.png)
**Movie Time** is a iPhone client Application which consumes TMDb framework to query and get movie details straight from TMDb. Built with Swift.

# Requirements

 - MacOS 10.15+ Catalina
 - XCode 11+
 - iOS 13+
# Get Started

 - Clone the repository
 - Get TMDb API Key from [https://developers.themoviedb.org/3/](https://developers.themoviedb.org/3/)
 - Input the API key in apiKey constant under 

> TMDb-Framework/TMDb-Framework/TMDbManager.swift

Then,
```
open TMDb-Client.xcworkspace
```
Best viewed on XCode 11 (dark mode compatibility) or later. 
Select mcLogin target, under Signing & Capabilities, choose your organization team, enable automatic signing and build for your device.

# Application Screenshots

 - Launcher
 ![Launcher Screen to open TMDb based Movie Time](https://raw.githubusercontent.com/iAkashlal/movieDB/master/TMDb-Client/Screenshots/1.png)
 - First Screen
 ![Using the Discover TMDb API](https://raw.githubusercontent.com/iAkashlal/movieDB/master/TMDb-Client/Screenshots/2.png)
 - Details when a movie is selected
 ![Movie details screen with data fetched from the movie database](https://raw.githubusercontent.com/iAkashlal/movieDB/master/TMDb-Client/Screenshots/3.png)
 - Search Interface
 ![Search Screen](https://raw.githubusercontent.com/iAkashlal/movieDB/master/TMDb-Client/Screenshots/4.png)
 - Search Results
 ![Movies resulting as a keyword search for TMDb API in iOS Framework](https://raw.githubusercontent.com/iAkashlal/movieDB/master/TMDb-Client/Screenshots/5.png)
 - No results found
 ![When The Movie Database can't find any movies for your search input](https://raw.githubusercontent.com/iAkashlal/movieDB/master/TMDb-Client/Screenshots/6.png)
