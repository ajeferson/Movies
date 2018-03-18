# Movies
This is an iOS app whose main purpose is to show the upcoming movies from The Movie Database (TMDb). Besides showing the list of upcoming movies, it is also possible to search movies and checkout out the details of a movie. This project uses MVVM as its main architectural pattern along with RxSwift/RxCocoa for Reactive Programming and bindings.

# Third-party libraries
The project has `Cocoapods` as its dependency manager, but it it not necessary to run `pod install`, as the `Pods` directory is already included. Below follow a list of the used libraries:

* [Alamofire](https://github.com/Alamofire/Alamofire) - An HTTP networking library.
* [RxSwift/RxCocoa](https://github.com/ReactiveX/RxSwift) - Rx version of Swift, for Reactive Programming. It also provides Reactive extensions for `UIView` subclasses.
* [Quick](https://github.com/Quick/Quick) - Behavior-driven testing framework, for writing more expressive tests.
* [Nimble](https://github.com/Quick/Nimble) - A matcher framework for expressing expected outcomes of tests.

