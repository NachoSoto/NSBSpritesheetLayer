//
//  NSBSpritesheetLayer.m
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSBSpritesheetLayer.h"

#import "NSBSpritesheet.h"

@interface NSBSpritesheetLayer ()
{
    NSInteger _frameNumber;
    
    BOOL _goingBack;
    NSUInteger _fps;
    CGSize _imageSize;
}

@property (nonatomic, retain) NSBSpritesheet *spritesheet;

@property (nonatomic, assign) CADisplayLink *link;

@end

@implementation NSBSpritesheetLayer

- (id)initWithSpritesheet:(NSBSpritesheet *)spritesheet framesPerSecond:(NSUInteger)framesPerSecond
{
    NSParameterAssert(spritesheet);
    NSAssert(framesPerSecond > 0, @"Invalid frames per second");
    
    if ((self = [super init]))
    {
        self.spritesheet = spritesheet;
        
        CGImageRef image = spritesheet.image.CGImage;
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.contents = (id)image;
        
        self.autoreverses = NO;
        _goingBack = NO;
        _fps = framesPerSecond;
        _frameNumber = 0;
        _imageSize = CGSizeMake(CGImageGetWidth(image),
                                CGImageGetHeight(image));
        
        [self renderCurrentFrame];
    }
    
    return self;
}

- (void)dealloc
{
    [_link invalidate];
    
    [_spritesheet release];
    [_completionBlock release];
    
    [super dealloc];
}

#pragma mark -

- (void)update:(CADisplayLink *)link
{
    [self renderCurrentFrame];
    
    if (_goingBack)
        _frameNumber--;
    else
        _frameNumber++;
    
    if (_frameNumber >= (NSInteger)self.spritesheet.frameCount)
    {
        if (self.autoreverses)
        {
            _goingBack = YES;
            _frameNumber--;
        }
        else
        {
            [self handleCompletion];
        }
    }
    else if (_frameNumber < 0)
    {
        _goingBack = NO;
        
        [self handleCompletion];
    }
}

- (void)renderCurrentFrame
{
    self.contentsRect = [self contentsRectForFrameIndex:_frameNumber];
    self.frame = [self frameForFrameIndex:_frameNumber];
}

#pragma mark - public methods

- (BOOL)animate
{
    return [self animateWithCompletionBlock:NULL];
}

- (BOOL)animateWithCompletionBlock:(void (^)(BOOL))completionBlock
{
    if ([self isAnimating])
        return NO;
    
    NSAssert(self.spritesheet.frameCount > 1, @"This spritesheet is not an animation");
    
    self.completionBlock = completionBlock;
    
    // make sure we render the current frame before starting
    // this prevents the user from seeing the last frame right before the animation starts
    [self renderCurrentFrame];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    self.link.frameInterval = 60 / _fps;
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    return YES;
}

- (void)stop
{
    [self stopFinished:NO];
}

- (BOOL)isAnimating
{
    return (self.link != nil);
}

#pragma mark -

- (void)stopFinished:(BOOL)finished
{
    // make sure self doesn't get dealloc-ed after the link is invalidated
    [[self retain] autorelease];
    
    // set link to nil before invalidating to make sure we don't call that twice
    CADisplayLink *displayLink = self.link;
    self.link = nil;
    [displayLink invalidate];
    
    if (self.completionBlock != NULL)
    {
        void (^block)(BOOL completed) = [[self.completionBlock copy] autorelease];
        
        self.completionBlock = NULL;
        
        block(finished);
    }
}

- (void)handleCompletion
{
    _frameNumber = 0;
    
    [self stopFinished:YES];
}

#pragma mark -

-(id<CAAction>)actionForKey:(NSString *)event
{
    // disable implicit animations for all these keys
    if ([event isEqualToString:@"hidden"] ||
        [event isEqualToString:@"position"] ||
        [event isEqualToString:@"bounds"] ||
        [event isEqualToString:@"contentsRect"])
    {
        return nil;
    }
    else
    {
        return [super actionForKey:event];
    }
}

- (void)removeFromSuperlayer
{
    [self stop];
    
    [super removeFromSuperlayer];
}

#pragma mark - helpers

- (CGRect)frameForFrameIndex:(NSInteger)frameIndex
{
    const CGRect contentsRect = self.spritesheet.frames[frameIndex];
    const CGRect spriteSize = self.spritesheet.sourceSizes[frameIndex];
    
    return CGRectMake(spriteSize.origin.x / self.contentsScale,
                      spriteSize.origin.y / self.contentsScale,
                      contentsRect.size.width / self.contentsScale,
                      contentsRect.size.height / self.contentsScale);
}

- (CGRect)contentsRectForFrameIndex:(NSInteger)frameIndex
{
    const CGRect frame = self.spritesheet.frames[frameIndex];
    
    // contentsRect is relative to the image size
    return CGRectMake(frame.origin.x / _imageSize.width,
                      frame.origin.y / _imageSize.height,
                      frame.size.width / _imageSize.width,
                      frame.size.height / _imageSize.height);
}

@end
