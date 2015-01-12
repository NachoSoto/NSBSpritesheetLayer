//
//  NSBTexturePackerSpritesheetFactory.m
//  NSBSpritesheetLayer
//
//  Created by Nacho Soto on 8/10/13.
//
//

#import "NSBTexturePackerSpritesheetFactory.h"

#import <UIKit/UIKit.h>

#import "NSBSpritesheet.h"

static NSString * const kFrameKey = @"frame";
static NSString * const kSourceSizeKey = @"spriteSourceSize";

static inline CGRect rectFromDictionary(NSDictionary *dictionary)
{
    NSCAssert(dictionary, @"Dictionary is not valid");
    
    return  CGRectMake([dictionary[@"x"] intValue],
                       [dictionary[@"y"] intValue],
                       [dictionary[@"w"] intValue],
                       [dictionary[@"h"] intValue]);
}

@interface _NSBSpritesheetSequenceFrame : NSObject

+ (instancetype)sequenceFrameWithName:(NSString *)name number:(NSUInteger)number;

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) NSUInteger number;

@end

@interface NSBTexturePackerSpritesheetFactory ()

@property (nonatomic, retain, readwrite) NSRegularExpression *frameNameRegularExpression;

@end

@implementation NSBTexturePackerSpritesheetFactory

+ (instancetype)factory
{
	return [[self alloc] init];
}

- (id)init
{
    if ((self = [super init]))
    {
        NSError *error = nil;
        
        // matches a word followed by '_' and a set of numbers
        _frameNameRegularExpression = [NSRegularExpression
                                        regularExpressionWithPattern:@"([\\w|/]+)([_]{1})([0-9]+)$"
                                        options:NSRegularExpressionCaseInsensitive
                                        error:&error];
        
        NSAssert(_frameNameRegularExpression, @"Error creating regular expression: %@", error);
    }
    
    return self;
}

#pragma mark -

- (NSDictionary *)spritesheetsWithAnimationsData:(NSDictionary *)animationsData image:(UIImage *)image
{
	NSParameterAssert(animationsData);
	NSParameterAssert(image);

    NSDictionary *animations = [self animationsWithData:animationsData];
    NSDictionary *spritesheets = [self spritesheetsWithAnimations:animations image:image];

    return spritesheets;
}

- (NSDictionary *)animationsWithData:(NSDictionary *)data
{
    static NSString *const kSequenceIndexKey = @"index";
    
    NSMutableDictionary *animations = [NSMutableDictionary dictionary];
    
    [[data objectForKey:@"frames"] enumerateKeysAndObjectsUsingBlock:^(NSString *frameName, NSDictionary *frameData, __unused  BOOL *stop)
     {
         @autoreleasepool
         {
             _NSBSpritesheetSequenceFrame *sequenceFrame = [self sequenceFrameForName:[frameName stringByDeletingPathExtension]];
             
             const BOOL isSequence = (sequenceFrame != nil);
             if (isSequence)
             {
                 NSMutableArray *frames = animations[sequenceFrame.name];
                 
                 if (frames == nil)
                 {
                     frames = [NSMutableArray array];
                     animations[sequenceFrame.name] = frames;
                 }
                 
                 // append the index so that we can sort it after adding all the frames
                 [frames addObject:@{
                         kFrameKey: frameData[kFrameKey],
                    kSourceSizeKey: frameData[kSourceSizeKey],
                 kSequenceIndexKey: @(sequenceFrame.number)
                  }];
             }
             else
             {
                 animations[frameName] = @[frameData];
             }
         }
     }];
    
    // sort sequences
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kSequenceIndexKey ascending:YES];
    
    [animations enumerateKeysAndObjectsUsingBlock:^(NSString *frameName, NSMutableArray *frames, __unused BOOL *stop)
    {
        const BOOL isUnsorted = ([frames isKindOfClass:[NSMutableArray class]]);
        if (isUnsorted)
        {
            [frames sortUsingDescriptors:@[sortDescriptor]];
        }
    }];
    
    return animations;
}

- (_NSBSpritesheetSequenceFrame *)sequenceFrameForName:(NSString *)frameName
{
    _NSBSpritesheetSequenceFrame *result = nil;
    
    NSRegularExpression *sequenceRegex = [self frameNameRegularExpression];
    
    NSTextCheckingResult *match = [sequenceRegex firstMatchInString:frameName
                                                            options:0
                                                              range:NSMakeRange(0, frameName.length)];
    
    if (match != nil && match.numberOfRanges == 4)
    {
        NSString *name = [frameName substringWithRange:[match rangeAtIndex:1]];
        NSString *frameNumber = [frameName substringWithRange:[match rangeAtIndex:3]];
        
        const NSUInteger number = (NSUInteger)[frameNumber integerValue];
        result = [_NSBSpritesheetSequenceFrame sequenceFrameWithName:name
                                                            number:number];
    }
    
    return result;
}

- (NSDictionary *)spritesheetsWithAnimations:(NSDictionary *)animations image:(UIImage *)image
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:animations.count];
    
    [animations enumerateKeysAndObjectsUsingBlock:^(NSString *frameName, NSArray *frameArray, __unused BOOL *stop)
    {
        const NSUInteger frameCount = frameArray.count;
        
        CGRect *const frames = calloc(frameCount, sizeof(CGRect)),
               *const sourceSizes = calloc(frameCount, sizeof(CGRect));
        
        for (NSUInteger i = 0; i < frameCount; ++i)
        {
            NSDictionary *frameData = frameArray[i];
            
            frames[i] = rectFromDictionary(frameData[kFrameKey]);
            sourceSizes[i] = rectFromDictionary(frameData[kSourceSizeKey]);
        }

		result[frameName] = [[NSBSpritesheet alloc] initWithFrames:frames
													   sourceSizes:sourceSizes
														frameCount:frameCount
												  spritesheetImage:image];
	}];

	return result;
}

@end

@implementation _NSBSpritesheetSequenceFrame

- (instancetype)initWithName:(NSString *)name number:(NSUInteger)number
{
    if ((self = [super init]))
    {
        self.name = name;
        self.number = number;
    }
    
    return self;
}

+ (instancetype)sequenceFrameWithName:(NSString *)name number:(NSUInteger)number
{
    return [[self alloc] initWithName:name number:number];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, name: %@, number: %lu>", NSStringFromClass([self class]), self, self.name, (unsigned long)self.number];
}

@end