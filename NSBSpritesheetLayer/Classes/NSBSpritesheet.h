//
//  NSBSpritesheet.h
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef const CGRect *NSBSpritesheetFrameSetType;

@interface NSBSpritesheet : NSObject

/**
 * @param frames and sourceSizes: heap allocated arrays that this class will own.
 */
- (id)initWithFrames:(const NSBSpritesheetFrameSetType)frames sourceSizes:(const NSBSpritesheetFrameSetType)sourceSizes frameCount:(const NSUInteger)frameCount spritesheetImage:(UIImage *)image;

- (NSUInteger)frameCount;
- (NSBSpritesheetFrameSetType)frames;
- (NSBSpritesheetFrameSetType)sourceSizes;

- (UIImage *)image;

@end
