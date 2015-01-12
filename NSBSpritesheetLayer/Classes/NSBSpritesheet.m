//
//  NSBSpritesheet.m
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/11/13.
//  Copyright (c) 2012. All rights reserved.
//

#import "NSBSpritesheet.h"

@interface NSBSpritesheet ()
{
    NSBSpritesheetFrameSetType _frames;
    NSBSpritesheetFrameSetType _sourceSizes;
    
    NSUInteger _frameCount;
}

@property (nonatomic, retain, readwrite) UIImage *image;

@end

@implementation NSBSpritesheet

- (instancetype)initWithFrames:(const NSBSpritesheetFrameSetType)frames sourceSizes:(const NSBSpritesheetFrameSetType)sourceSizes frameCount:(const NSUInteger)frameCount spritesheetImage:(UIImage *)image
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
}

#pragma mark -

- (NSBSpritesheetFrameSetType)frames
{
    return _frames;
}

- (NSBSpritesheetFrameSetType)sourceSizes
{
    return _sourceSizes;
}

- (NSUInteger)frameCount
{
    return _frameCount;
}

@end
