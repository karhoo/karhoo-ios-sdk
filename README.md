# Karhoo-iOS-SDK

![](https://github.com/karhoo/Karhoo-iOS-SDK/workflows/CI-Development/badge.svg)

KarhooSDK is a framework for integrating with the KarhooAPI: https://developer.karhoo.com

To setup the project, simply clone, pod install and run the unit tests to verify everything works.

# SDK Architecture overview:

The SDK is split into Services. Services such as Trip, DriverTracking, Availability, User, Payments etc. These services in turn depend on Interactors, these Interactors depend on a request. Simply calling a function in a service will trigger the interactor to call the request. The request uses our HttpClient to make the network call. 

Call and PollCall objects are returned from the KarhooSDK. PollCalls return observables which can be used to poll the endpoint, and Calls have an execute function which fires the request. 

Models are encoded/decoded using Decodable structs. These are located in Api/DataObjects/Request /Response groups. 

There is a unit test target that tests individual classes work as expected, and there is an integration test target that uses OHHTPStubs to test the sdk works as expected end to end. (from the network layer to a service)

![](docs/assets/network_sdk.png)

