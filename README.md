#  BikePoint

## Min spec

* XCode 15.0 beta (I used latest MapKit with SwiftUI, published on WWDC'23, so beta is required)
* iOS 17 beta or simulator 
* Mac OS Ventura 13.4 or MacOS Sonoma 14 beta

## How to use app

Although application can run without user position, it's advised to allow location tracking.
If you are running app on simulator it's advised to switch simulator location to London.
App shows list of available TFL Santander Bikes docking stations on the map and on horizontal scrolling list, ranged by distance to current location.
You can select marker on the map or cell in the list to focus on particular spot. If you tap on selected item again app will show you detailed information including precise post address and StreetView a.k.a. MapKit LookAround.      

## Developer notes and considerations 

This is TechTask for LLoyd Banking Group. 

The task was to implement simple but scalable and modern app using any of the public APIs.

Because it's open task I decided to use some modern api published by WWDC'23 that i didn't use before to learn something new along the way. I decided to go with MapKit for SwiftUI. As API i choose TFL shared bike scheme api because I'm using it time to time, and find TFL app lacking some features.

I choose MVP architecture with thin transparent ViewState layer used to communicate UI changes from Presenter to View. ViewStates utilise Combine publishers, so View can establish bindings and respond to any changes on fly. This approach grants me decouple UI and Presentation layers greatly, so i can easily switch to UIKit Views andViewControllers any moment if i need to without changing Presentation layer at all and retaining all functionality. It allows to segregate Model, DataFetching, Presentation and UI layers, isolate each individual components, test it, mock it, and replace it without damaging others. I don't see it fit at this scale but application designed in that way can be easily broken down on separate modules and frameworks that can speed up development processes for big companies.     

Application developed using SwiftUI, however I find Navigation in SwiftUI lacking flexibility and scalability, so I used technic i used before on some of my products to create a SwiftUI wrapper around Navigation Controller, so I can use this wrapper and integrate it into SwiftUI, but retain flexibility to navigate to any new screens i want from Navigators decoupling navigation from particular screen details.
                
I implemented several tests to demonstrate how this application can be tested to achieve near 100% code coverage. I used CallStack technic that records all calls and allow  determine responses from tests for Mocking dependencies. All "uncovered" components can be easily tested using same technics. I didn't want to spend too much time on testing.

It's appeared that no api keys required to run BikePoint requests with TFL API, so although Networking infrastructure was originaly prepared to inject app keys into header, it wasn't necessary and wasn't used.       

Please don't hesitate to contact me if you have any questions.      
