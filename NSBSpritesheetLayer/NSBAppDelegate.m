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

        [view.layer addSublayer:layer];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((double)arc4random() / ARC4RANDOM_MAX * 2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            [self animateLayer:layer];
        });
        
        view;
    })];
}
     
- (void)animateLayer:(NSBSpritesheetLayer *)layer
{
    [layer animateWithCompletionBlock:^(BOOL finished)
    {
        [self animateLayer:layer];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
