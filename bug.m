In Objective-C, a common yet subtle error involves the improper handling of `retain` and `release` calls, especially when dealing with memory management using reference counting.  Consider this example:

```objectivec
@interface MyClass : NSObject
@property (nonatomic, retain) NSString *myString;
@end

@implementation MyClass
- (void)dealloc {
    [myString release];
    [super dealloc];
}

- (void)setString:(NSString *)string {
    if (myString != string) {
        [myString release];
        myString = [string retain];
    }
}
@end
```

This code looks correct at first glance.  However, if `setString:` is called multiple times with the same string, the string will be retained multiple times, leading to a memory leak when the object eventually deallocates. The bug comes from not checking if `string` is `nil` before the `retain` call which can cause double release if the string is already `nil`.

Another potential issue arises if `myString` is deallocated externally. A `retain` is a potential solution. Without a strong reference, an external object could deallocate `myString` early, resulting in a dangling pointer and subsequent crashes.

This is easily mitigated by the usage of ARC in later versions of Objective-C but still is relevant in many legacy projects.