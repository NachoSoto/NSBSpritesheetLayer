//
//  NSBAppDelegate.m
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSBAppDelegate.h"

#import "NSBSpritesheet.h"
#import "NSBSpritesheetLayer.h"

#import "NSBTexturePackerSpritesheetFactory.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation NSBAppDelegate

- (void)dealloc
{
    [_window release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"spritesheet.png"];
    
    NSData *JSONdata = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"spritesheet" ofType:@"json"]];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:JSONdata options:0 error:nil];
    
    NSBSpritesheet *spritesheet = [[NSBTexturePackerSpritesheetFactory factory] spritesheetsWithAnimationsData:data image:image][@"Frame"];
    
    const NSUInteger rows = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 20 : 7;
    
    for (NSUInteger i = 0; i < rows; ++i)
    {
        const CGFloat y = i * 60;
        [self addAnimationAtPoint:CGPointMake(0, y) withSpritesheet:spritesheet];
        [self addAnimationAtPoint:CGPointMake(self.window.frame.size.width / 2, y) withSpritesheet:spritesheet];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)addAnimationAtPoint:(CGPoint)point withSpritesheet:(NSBSpritesheet *)spritesheet
{
    NSBSpritesheetLayer *layer = [[[NSBSpritesheetLayer alloc] initWithSpritesheet:spritesheet framesPerSecond:15] autorelease];
    
    [self.window addSubview:({
        UIView *view = [[[UIView alloc] initWithFrame:(CGRect){
            .origin = point,
            .size = CGSizeZero
        }] autorelease];

        layer.autoreverses = YES;
        layer.repetitions = HUGE_VAL;
        
        [view.layer addSublayer:layer];
        
        [layer animate];

        view;
    })];
}

@end
