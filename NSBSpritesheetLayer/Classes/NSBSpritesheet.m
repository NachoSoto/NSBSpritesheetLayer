//
//  NSBSpritesheet.m
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSBSpritesheet.h"

@interface NSBSpritesheet ()
{
    const CGRect *_frames;
    const CGRect *_sourceSizes;
    
    NSUInteger _frameCount;
}

@property (nonatomic, retain, readwrite) UIImage *image;

@end

@implementation NSBSpritesheet

- (id)initWithFrames:(const CGRect *const)frames sourceSizes:(const CGRect *const)sourceSizes frameCount:(const NSUInteger)frameCount spritesheetImage:(UIImage *)image
{
    NSParameterAssert(frames);
    NSParameterAssert(sourceSizes);
    NSAssert(frameCount > 0, @"There should be at least 1 frame");
    NSParameterAssert(image);
    
    if ((self = [super init]))
    {
        _frames = frames;
        _sourceSizes = sourceSizes;
        _frameCount = frameCount;
        
        self.image = image;
    }
    
    return self;
}

- (void)dealloc
{
    free((void *)_frames);
    free((void *)_sourceSizes);
    
    [_image release];
    
    [super dealloc];
}

#pragma mark -

- (const CGRect *const)frames
{
    return _frames;
}

- (const CGRect *const)sourceSizes
{
    return _sourceSizes;
}

- (NSUInteger)frameCount
{
    return _frameCount;
}

@end
