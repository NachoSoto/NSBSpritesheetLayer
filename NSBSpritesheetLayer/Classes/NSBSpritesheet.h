//
//  NSBSpritesheet.h
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBSpritesheet : NSObject

/**
 * @param frames and sourceSizes: heap allocated arrays that this class will own.
 */
- (id)initWithFrames:(const CGRect *const)frames sourceSizes:(const CGRect *const)sourceSizes frameCount:(const NSUInteger)frameCount spritesheetImage:(UIImage *)image;

- (NSUInteger)frameCount;
- (const CGRect *const)frames;
- (const CGRect *const)sourceSizes;

- (UIImage *)image;

@end
