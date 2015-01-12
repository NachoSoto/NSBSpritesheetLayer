//
//  NSBSpritesheet.h
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/11/13.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef const CGRect *NSBSpritesheetFrameSetType;

@interface NSBSpritesheet : NSObject

/**
 * @param frames: array of CGRects that represent the portion of the `image` for each frame.
 * @param sourceSizes: array of CGRects that represent how each frame will actually be displayed. The size is tipically the same as that in `frames` and the origin can be offset if the frame has removed white spaces.
 * @note `frames` and `sourceSizes` need to be heap allocated arrays that this class will own upon calling this method.
 */
- (instancetype)initWithFrames:(const NSBSpritesheetFrameSetType)frames sourceSizes:(const NSBSpritesheetFrameSetType)sourceSizes frameCount:(const NSUInteger)frameCount spritesheetImage:(UIImage *)image;

- (NSUInteger)frameCount;
- (NSBSpritesheetFrameSetType)frames;
- (NSBSpritesheetFrameSetType)sourceSizes;

- (UIImage *)image;

@end
