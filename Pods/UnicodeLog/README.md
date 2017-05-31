# UnicodeLog

###NSArray NSDictionary 及其子类输出中文 description

[![Version](https://img.shields.io/cocoapods/v/UnicodeLog.svg?style=flat)](http://cocoapods.org/pods/UnicodeLog)
[![License](https://img.shields.io/cocoapods/l/UnicodeLog.svg?style=flat)](http://cocoapods.org/pods/UnicodeLog)
[![Platform](https://img.shields.io/cocoapods/p/UnicodeLog.svg?style=flat)](http://cocoapods.org/pods/UnicodeLog)


---
## Usage

**无需配置和注意**  
**只在Debug模式时生效**

	NSArray *array=@[@"呦西",@"粑粑",@"hehe"];
	NSLog(@"%@",array);

	NSMutableArray *mutableArray=[NSMutableArray arrayWithArray:array];
	NSLog(@"%@",mutableArray);

	NSDictionary *dict=@{@"呦西":@"呵呵",@"555":@"hehe"};
	NSLog(@"%@",dict);

## Installation

直接把 NSObject+Unicode.h .m 拖进工程即可

或者通过CocoaPods

UnicodeLog is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UnicodeLog"
```

## Author

BigPi wangdapishuai@163.com

## Thanks To
[0x5e](https://github.com/0x5e)

## License

UnicodeLog is available under the MIT license. See the LICENSE file for more info.
