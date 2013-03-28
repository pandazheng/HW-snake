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

- (id)init
{
    if (self = [super init]) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"];
        NSDictionary *infos = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        snakeInfo_ = [[infos objectForKey:@"level"] objectForKey:@"snake"];
        
        direction_ = [[[infos objectForKey:@"level"] objectForKey:@"direction"] intValue];
        
        CCLOG(@"%@", snakeInfo_);
        snakeSprites_ = [[NSMutableArray alloc] init];
        snake_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSMutableArray *)getSnakeSprites
{
    for (int i = 0; i < [snakeInfo_ count]; i++) {
        NSDictionary *piece = [snakeInfo_ objectAtIndex:i];
        
        CGPoint snakePiece = MakeSnakePiece([[piece valueForKey:@"x"] intValue], [[piece valueForKey:@"y"] intValue]);
        
        NSValue *snakePieceValue = [NSValue valueWithCGPoint:snakePiece];
        [snake_ addObject:snakePieceValue];
        
        [self snakeSpriteAtIndex:i].scale = 1;
    }
    snakePieces_ = [snakeInfo_ count];
    return snakeSprites_;
}

- (CCSprite *)snakeSpriteAtIndex:(NSInteger)index {
    NSAssert(index <= [snakeSprites_ count], @"Oopsiee");
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

- (NSInteger)getSnakePiecesCount
{
    return snakePieces_;
}

- (NSInteger)getDirection
{
    return direction_;
}

- (NSMutableArray *)getSnakePieces
{
    return snake_;
}

@end
