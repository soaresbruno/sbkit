//
//  SBSurrogateObjectTest.m
//  sbkit
//
//  Created by Bruno Soares on 11/20/12.
//  Copyright (c) 2012 Bruno Soares. All rights reserved.
//

#import "SBSurrogateObjectTest.h"
#import "SBSurrogateObject.h"

@implementation SBSurrogateObjectTest

- (void)testSurrogateObject
{
    id object = @"A string object!";
    id surrogate = [[SBSurrogateObject alloc] initWithObject:object];
    
    STAssertTrue([surrogate isKindOfClass:[object class]], @"surrogate should be the same kind of object as the original object");
    STAssertEquals([object length], [surrogate length], @"surrogate's number of characters should be the same as the original object's number of characters");
    
    [surrogate interceptSelector:@selector(length) withBlock:^(NSInvocation *invocation) {
        NSUInteger length = [[surrogate object] length];
        length *= 2;
        [invocation setReturnValue:&length];
    }];
    
    STAssertEquals([object length] * 2, [surrogate length], @"after intercepting, surrogate's number of characters should be twice the original object's number of characters");
}

@end
