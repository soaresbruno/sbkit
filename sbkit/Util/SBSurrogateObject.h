//
//  SBSurrogateObject.h
//  sbkit
//
//  Created by Bruno Soares on 11/20/12.
//  Copyright (c) 2012 Bruno Soares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBSurrogateObject : NSObject {
    
    NSMutableDictionary *_interceptors;
    
}

@property (nonatomic, strong) id object;

- (id)initWithObject:(id)object;
- (void)interceptSelector:(SEL)aSelector withBlock:(void (^)(NSInvocation *invocation))block;
- (void)cancelInterceptSelector:(SEL)aSelector;

@end
