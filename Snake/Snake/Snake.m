//
//  Snake.m
//  Snake
//
//  Created by ddling on 13-3-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Snake.h"

CGPoint MakeSnakePiece(NSInteger x, NSInteger y)
{
    CGPoint piece;
    piece.x = x;
    piece.y = y;
    return piece;
}

@implementation Snake
@synthesize snakeInfo_;
@synthesize snakePoints_;
@synthesize snakeSprites_;
@synthesize snakePiecesCount_;
@synthesize snakePoint_;
@synthesize direction_;
@synthesize directionRobot_;
@synthesize currentSpeed_;

- (id)init
{
    if (self = [super init]) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"];
        NSDictionary *infos = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        snakePoints_ = [[NSMutableArray alloc] init];
        snakeSprites_ = [[NSMutableArray alloc] init];
        
        snakeInfo_ = [[infos objectForKey:@"level"] objectForKey:@"snake"];
        
        direction_ = [[[infos objectForKey:@"level"] objectForKey:@"direction"] intValue];
        currentSpeed_ = [[[infos objectForKey:@"level"] objectForKey:@"speed"] intValue];
        
        snakePiecesCount_ = [snakeInfo_ count];
    }
    
    return self;
}

- (id)initASnakeWithType: (SnakeType)type
{
    if(self = [super init]){
        
        NSString *snakeTypeStr = [[NSString alloc] init];
        switch (type) {
            case SnakeTypeMe:
                snakeTypeStr = @"snake";
                break;
            case SnakeTyepRobot:
                snakeTypeStr = @"snakeTypeRobot";
            default:
                break;
        }
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"];
        NSDictionary *infos = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        snakePoints_ = [[NSMutableArray alloc] init];
        snakeSprites_ = [[NSMutableArray alloc] init];
        
        snakeInfo_ = [[infos objectForKey:@"level"] objectForKey:snakeTypeStr];
        directionRobot_ = [[[infos objectForKey:@"level"] objectForKey:@"directionRobot"] intValue];
        CCLOG(@"%d", directionRobot_);
        currentSpeed_ = [[[infos objectForKey:@"level"] objectForKey:@"speed"] intValue];
        
        snakePiecesCount_ = [snakeInfo_ count];
    }
    
    return self;
}

- (NSMutableArray *)getSnakeSprites
{
    for (int i = 0; i < snakePiecesCount_; i++) {
        NSMutableArray *piece = [snakeInfo_ objectAtIndex:i];
        
        CGPoint snakePiece = MakeSnakePiece([[piece valueForKey:@"x"] intValue], [[piece valueForKey:@"y"] intValue]);
        
        NSValue *snakePieceValue = [NSValue valueWithCGPoint:snakePiece];
        [snakePoints_ addObject:snakePieceValue];
        
        [self snakeSpriteAtIndex:i].scale = 1;
    }
    return snakePoints_;
}

- (CCSprite *)snakeSpriteAtIndex:(NSInteger)index {
    if ([snakeSprites_ count] == index) {
        CCSprite *sprite = nil;
        if (index == 0) {
            sprite = [CCSprite spriteWithSpriteFrameName:@"snake-head.png"];
        }
        else {
            sprite = [CCSprite spriteWithSpriteFrameName:@"snake-body.png"];
        }
        [snakeSprites_ addObject:sprite];
    }
    return [snakeSprites_ objectAtIndex:index];
}

@end
