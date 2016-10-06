# CAIVINScannerLite

## Release Notes

0.1.19 - Conditional check before starting scanner session and added logo image to scanner UI.</br>
2.3.0 - Updated project to support Swift 2.3 and xcode.</br>
3.0.0 - Swift 3.0 support added and code base updated. </br>

## Documentation

Documentation is generated with [Jazzy](https://github.com/realm/jazzy) and is located at the following path from the root directory:

'VinScanner/Swift/CAIVINScannerLite/CAIVINScannerLite/Docs'


## Requirements

ios 8 or higher

## Installation

CAIVINScannerLite is available from [here](https://ghe.coxautoinc.com/MPDG/pod_specs). To install
it, simply add the following line to your Podfile:

```ruby
pod "CAIVINScannerLite"
```

## Author

Pete Hornsby, peter.hornsby@coxautoinc.com

## License

Require Cox Automotive Inc License here!

## The Framework

The CAIVINScannerLite framework provides two solutions to a industry wide problem, data entry for VIN numbers. The framework extends vAuto's work in this area by providing a Swift wrapper for the VinScan library along with a re-implementation of the VIN keyboard in Swift using auto layout to support all iOS devices.

Because of this, the framework is broken down into two components: the VIN Scanner and the VIN Keyboard. They are independent of each other but both have a dependence on the VinScan library. We will review each component in terms, of it's functionality, usage, configuration, main classes and iOS device support.

The goal of this framework is to provide developers an easy to use encapsulated solution to VIN data entry that offers a high degree of flexibility through configuration.



## The Public Interface
The framework’s interface is contained in the file CAIVINScannerLite.swift and consists of four main sections, protocols for the scanner and keyboard, static properties for exposed user interface components, static methods for getting the scanner and keyboard objects and utility methods


Protocols
Both the scanner and keyboard make use of delegation, this is achieved through the use of protocols.  It is not required for the scanner but provides additional information. The keyboard requires the protocol to notify the end user that the keyboard has been dismiss, however in theory this information is available if the host class has implemented the UITextFieldDelegate methods.

####Vin Scanner Delegate
```swift
public protocol CAIVINScannerDelegate {
optional func scannerDidCompleteScan()
optional func scannerDidDecodeVIN(VIN: String)
func scannerDidRequestKeyboard()
func scannerDidRequestHelp()
}
```

####VIN Keyboard Delegate
```swift
public protocol CAIVINKeyboardDelegate {
func keyboardWillAddCharacter(string: String)
func keyboardDidChangeText(text: String)
func keyboardWillDismissKeyboard()
}
```


##Static UI Component Properties
Each component has certain UI components exposed for the developer to customize the look and feel. You should review the relevant section for a list of the UI components exposed for the scanner or keyboard. 

##Public Methods
There are just three public methods, one for the VIN Scanner and two for the VIN Keyboard.  It should be noted that the type creation methods return a plain UIKit object.


##VIN Scanner Method
```swift 
func scannerViewControllerWithStyle(style: ScannerStyle, delegate: AnyObject?, completion: ((success: Bool, VIN: String?, didCancel: Bool?) -> Void)?) -> UIViewController
```

`ScannerStyle`: Enumeration of possible VIN Scanner styles 
`delegate`: An optional  AnyObject? That must implement CAIVINScannerDelegate protocol, the delegate is left as nil if the object does not implement the protocol. 
`completion`: A closure to call upon completion of a scan, whether successful or not. 

##VIN Keyboard Method 
```swift
func VINKeyboardInputView(textField textField: UITextField, delegate: AnyObject?) -> UIView
```

`textField`: The `UITextField` object for the keyboard to provide input. 
`delegate`: An optional  AnyObject? That must implement`CAIVINKeyboardDelegate` protocol, the delegate is left as nil if the object does not implement the protocol. 


##The VIN Scanner
####Functionality
The VIN Scanner component has been designed with encapsulation and code reuse at the forefront. It supports scanning of CODE 39 (Code 3 of 9) and data matrix or 2D barcodes as the VinScan library does.  

Image acquisition has been refactored to support the implementation of different user interfaces or styles for the scanner. You can see this in the public ScannerStyle enumeration (see CAIVINScanner.swift). There are five possible styles, with the default style being based upon the Provision App interface. Currently all other values will return the default value. This has been done to help with future proofing the framework - ie we can introduce four more styles without effecting any instances of the framework that are already in production.

####Configuration
As well as being able to choose a style you can then further customize it by using the user interface properties that the framework exposes for the developer. The properties are listed  below. However we should note that the developer does not have to set a single property and the default values for the properties will be used.


1. Title Label</br>
titleText</br>
titleLabelFont</br>
titleTextColor</br>

2. Alignment Label
alignmentText</br>
alignmentLabelFont</br>
alignmentTextColor</br>

3. Alignment Target Indicators </br>
targetColor</br>

4. Alignment Guidelines</br>
guidelineColor</br>

5. Background </br>
backgroundFillColor </br>
backgroundBorderColor</br>

6. Help Button</br>
showHelpButton</br>
helpButtonNormalImage</br>
helpButtonHighlightImage</br>

7. Keyboard Button</br>
showKeyboardButton</br>
keyboardButtonNormalImage</br>
keyboardButtonHighlightImage</br>


8. Cancel Button</br>
cancelButtonNormalImage</br>
cancelButtonHighlightImage</br>

9. Flash button</br>
flashButtonNormalImage</br>
flashButtonHighlightImage</br>



##The VIN Keyboard

####Functionality
The VIN Keyboard goal is manual entry of a VIN.  The functionality is enhanced by the VinScan predictive VIN technology, which enables the keyboard to disable characters that are invalid for the current input string.

####Configuration
The layout of the keyboard is governed by it's function. Because of this there are limit options to configure the keyboard with all exposed components being directly related to appearance and color. 


