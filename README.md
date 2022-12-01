# ZooApp

> zoo | zuː |
> noun
>
> an establishment which maintains a collection of wild animals, typically in a park or gardens, for study, conservation, or display to the public.
>
> • a situation characterized by confusion and disorder: it's a zoo in the lobby.

## Abstract

The app tries to implement a navigation concept in SwiftUI for iOS16 and later versions. 

## Requirements

### No external dependencies

Navigation is a crucial part of any app and should be under control of the engineering team of the app. There are great open-source-projects out there that help with the complexity of navigating in SwiftUI, but they also add their bias and their own complexity.

### Be additive

Simple things should stay simple. If you want to use a `NavigationLink` inside a `NavigationStack` the concept has to allow that and stay out of the way.

### Assume multiple actions per user interaction / event

The standard navigation in SwiftUI with `NavigationLink` and `NavigationStack` assumes exaclty one action, namely **navigating**; taking the user from one point to another. In `XING.app` we usually want at least two actions, navigating and **tracking**.

In the Armstrong era we iterated on using publishers for user interactions and other events. Usually a view model defines which events are available and subscribers will take care of navigation and tracking.

### Make it work in SwiftUI previews
