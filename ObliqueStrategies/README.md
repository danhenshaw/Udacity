# Oblique Strategies


Oblique Strategies (the App) is an app designed as part of the Udacity iOS Developer Nanodegree as the Final Project: You Decide.

The app requirements were to demonstrate solid proficiency in persisting state on the device and downloading data from network resources.

Oblique Strategies are a set of cards created by Brian Eno and Peter Schmidt and first published in 1975. Each card contain phrases which are used to break deadlocks in creative situations.

From the introduction to the 2001 edition:

    "These cards evolved from separate observations of the principles underlying what we were doing. Sometimes they were recognised in retrospect (intellect catching up with intuition), sometimes they were identified as they were happening, sometimes they were formulated.

    They can be used as a pack, or by drawing a single card from the shuffled pack when a dilemma occurs in a working situation. In this case the card is trusted even if its appropriateness is quite unclear..."


## Features

The app loads to a plain black screen asking users to "tap [the] screen for an Oblique Strategy". At this initial stage, users have three options available:
    (1) click on the screen to load an Oblique Strategy,
    (2) view all oblique strategies, or
    (3) view their favoruite Oblique Strategies.

If the user selects option one and taps the screen to load an Oblique Strategy, the app will download a single Oblique Strategy at random from the provided web API. Once the Oblique Strategy has been downloaded, the share button will be enabled along with either the 'add' item or the 'trash' item based on whether the Oblique Strategy has already been favourited. At all times, either both the 'add' and 'trash' item will be disabled (if no Oblique Strategy has been selected) or only one of the options will be enabled.

If a user decides to view all the Oblique Strategies by navigation to the 'View All' table view, the app will download all of the Oblique Strategies which are taken from the web API in JSON format. A user can select any cell upon which they will be redirected to the initial screen with the selected Oblique Strategy loaded. At this stage, the 'add' and 'trash' icons will be updated pending on the outcome of the searchFavourites() function which takes in the label text as a search parameter to search the core data and determine if the current Oblique Strategy being displayed in the label text has already been favourited.

The 'View Favoruites' table view works in much the same fashion as the 'View All' table view with the only difference being that the table is loaded with Oblique Strategies which have been saved to core data and therefore does not need to download any data from any API.

Each Oblique Strategy is downloaded from the web API in the following format:

{"id":(Int),"edition":(Int),"cardnumber":(Int),"strategy":(String)}

Once the Oblique Strategy has been downloaded, it is stored in one of three methods depending on the function used and the useage within the app. When the 'View All' table view is loaded, it downloads multiple Oblique Strategies in the form of a JSON file and saves each entry to a dictionary. At times, the home screen or initial view will download either a random Oblique Strategy or a specific Oblique Strategy. The downloaded JSON from the API is then either saved to the singleDictionary which is found in the Constants file under JSONResponseKeys. The saved information is then called in the Initial View Controller by either using singleObliqueStrategy.... or specificObliqueStrategy.


## Resources

http://brianeno.needsyourhelp.org/info
Oblique Strategies by Brian Eno and Peter Schmidt
Data from The Oblique Strategies Website (http://www.rtqe.net/ObliqueStrategies/)
API made with Sinatra by Andrew Monks
Hosted with Heroku


## Future Improvements

- Make further improvements to backend code
- Improve the UI/UX experience
- Create your own 'Oblique Strategies'
- Create a network of users with data on the most favourited 'Oblique Strategies'


## Author

Daniel Henshaw, danieljhenshaw@gmail.com


## License

WeatherApp is available under the [MIT license](https://opensource.org/licenses/MIT)
