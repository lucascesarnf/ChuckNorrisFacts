# ChuckNorrisFacts
[![Build Status](https://travis-ci.com/lucascesarnf/ChuckNorrisFacts.svg?branch=master)](https://travis-ci.com/lucascesarnf/ChuckNorrisFacts) [![codecov](https://codecov.io/gh/lucascesarnf/ChuckNorrisFacts/branch/master/graph/badge.svg)](https://codecov.io/gh/lucascesarnf/ChuckNorrisFacts)

 This project consumes the API [Chuck Norris Facts](https://api.chucknorris.io/) and was intended to study `SwiftUI` and the `Combine` framework.
 
 
### SwiftUI Considerations

It is clearly a very promising tool that is in an embryonic state, so much so that you will immediately come across the first problem, `the compiler`. The compiler gets lost in capturing lexical and syntactic errors and can't tell you which line the problem is in, making debugging code errors difficult. This may be because the `Combine` library changes the way the swift compiler parses the code and gets it lost at some point. However this is not a big problem as the code is very descriptive and error identification is easy :)

Everything goes very well when it comes to screen building, it is really beautiful to see all your changes being built realtime and it really helps in productivity, but still missing many components, in my case when I needed to make a `CollectionView` I understood that the tool is not ready to run in `Production`. I had to perform an arithmetic operation to transform a 1D vector into a matrix to make my `CollectionView`, it was nice to see how it works mathematically under the cloth but is something I would expect to use natively.

My second reality clash was when I had to build a navigation stream and found that there is no way to  "pop to root" in `SwiftUI`. Personally recommend using a `NavigationController` and take care of navigation via `UIKit`. Still on this subject, `SwiftUI` interoperates very well with UIKit and I can access components of both in both very simply and without compatibility issues.

Finally I would say that the tool is wonderful but it is nowhere near ready for the real world and that I am looking forward to it growing and maturing so we can have a "serious relationship" rs.

### Requirements

* Xcode 11.1
* Swift 5.1
* iOS 13.1
* SwiftLint

### Installing

Install [SwiftLint](https://github.com/realm/SwiftLint):
### Using [Homebrew](http://brew.sh/):

```
brew install swiftlint
```

Install the projetc:

```
git clone https://github.com/lucascesarnf/ChuckNorrisFacts.git
```

Open the `ChuckNorrisFacts.xcodeproj` and Run🏃

## Continuous Integration
Current linked with github project using [`TravisCI`](https://travis-ci.com/lucascesarnf/ChuckNorrisFacts) and [`Codecov`](https://codecov.io/gh/lucascesarnf/ChuckNorrisFacts)
To run just open a PR to `master` and watch the magic happen.

## Built With

* [RXSwift](https://github.com/ReactiveX/RxSwift) - Reactive Programming in Swift
* [RxSwiftExt](https://github.com/RxSwiftCommunity/RxSwiftExt) - A collection of Rx operators & tools not found in the core RxSwift distribution

