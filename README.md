KSLayout
======
KSLayout is a tiny library that helps to automatically layout subviews in a container view by creating the necessary constraints.

## Installation
Use CocoaPods to add KSLayout to your project. Just add the following line to your Podfile.
```
pod 'KSLayout', '~> 1.0.0'
```
## Example
```objective-c
[self.container setSubviewsStacked:@[view1, view2, view3, view4, view5] layoutDirection:KSLayoutDirectionVertical settings:^(KSLayoutSettings *settings) {
	settings.subviewSpacing = 10;
	settings.subviewSize = 45;
	settings.containerPadding = UIEdgeInsetsMake(10, 10, 10, 10);
}];
```
