//
//  NSBTexturePackerSpritesheetFactory.h
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/10/13.
//
//

#import <Foundation/Foundation.h>

@class NSBSpritesheet;

@interface NSBTexturePackerSpritesheetFactory : NSObject

+ (instancetype)factory;

/**
 * @return dictionary where keys are the frame names and the values are instances of `NSBSpritesheet`.
 */
- (NSDictionary *)spritesheetsWithAnimationsData:(NSDictionary *)animationsData
                                           image:(UIImage *)image;

@end
