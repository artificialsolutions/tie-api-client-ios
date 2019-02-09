# TIE API Client

This library provides a way of communicating with a Teneo Engine server instance

## Requirements

- iOS 9.0+
- Xcode 10.0+
- Swift 4.2+

## Basic Use

### Setup
**Must be called before calling sendInput or closeSession**


```swift
do {
	try TieApiService.sharedInstance.setup("BASE_URL", endpoint: "ENDPOINT")
} catch {
	// Handle errors here
}
```

### Send Input
```swift
TieApiService.sharedInstance.sendInput({MESSAGE},
                                       parameters: {PARAMETERS},
                                       success: { response in
	// Handle response. Remember to dispatch to main thread if updating UI
}, failure: { error in
	// Handle error
})
```

### Close Session
```swift
TieApiService.sharedInstance.closeSession({ response in
	// Handle response. Remember to dispatch to main thread if updating UI
}, failure: { error in
	// Handle error
})
```


## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.5+ is required to build TieApiClient 0.0.1+.

To integrate TieApiClient into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod "TieApiClient"
```

Then, run the following command:

```bash
$ pod install
```

## License

TieApiClient is released under the Apache License, Version 2.0. [See LICENSE](https://github.com/artificialsolutions/tie-api-client-ios/blob/master/LICENSE) for details.
