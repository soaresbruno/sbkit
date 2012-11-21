//
//  SBSurrogateObject.m
//  sbkit
//
//  Created by Bruno Soares on 11/20/12.
//  Copyright (c) 2012 Bruno Soares. All rights reserved.
//

#import "SBSurrogateObject.h"

@implementation SBSurrogateObject

- (id)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        self.object = object;
        _interceptors = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)interceptSelector:(SEL)aSelector withBlock:(void (^)(NSInvocation *invocation))block
{
    _interceptors[NSStringFromSelector(aSelector)] = block;
}

- (void)cancelInterceptSelector:(SEL)aSelector
{
    [_interceptors removeObjectForKey:NSStringFromSelector(aSelector)];
}

- (void (^)(NSInvocation *))interceptBlockForSelector:(SEL)aSelector
{
    return _interceptors[NSStringFromSelector(aSelector)];
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [super isKindOfClass:aClass] || [self.object isKindOfClass:aClass];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.object respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return [super conformsToProtocol:aProtocol] || [self.object conformsToProtocol:aProtocol];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (signature == nil) {
        signature = [self.object methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    void (^block)(NSInvocation *) = [self interceptBlockForSelector:anInvocation.selector];
    if (block != nil) {
        block(anInvocation);
    }
    else if ([self.object respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.object];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end
