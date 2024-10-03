# TIE API Client

> [!IMPORTANT]
> This project has been retired and archived  
> If there is a need of continued use / development of this project for your own needs please feel free to fork the project - which will remain here in archived form.

This library provides a way of communicating with a Teneo Engine server instance

## Requirements

- iOS 12.0+
- Xcode 11.0+
- Swift 5.0+

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

> CocoaPods 1.5+ is required to build TieApiClient 1.0.0+.

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
