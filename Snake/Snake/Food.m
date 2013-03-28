//
//  Food.m
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Food.h"
#import "GameConfig.h"


@implementation Food

- (id)init
{
    if (self = [super init]) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"];
        NSDictionary *infos = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

        infoDef_ = [infos objectForKey:@"level"];
//        CCLOG(@"%@", infoDef_);
        
        remainingFoodPieces_ = [[infoDef_ objectForKey:@"foodPieces"] intValue];
        CCLOG(@"remain Food piece: %d", remainingFoodPieces_);
    }
    
    return self;
}

- (CCSprite *)getFoodSprite
{
    NSArray *foodTypes = [NSArray arrayWithObjects:@"snail.png",@"worm.png", nil];
    CCSprite *foodSprite_ = [CCSprite spriteWithSpriteFrameName:[foodTypes objectAtIndex:rand()%[foodTypes count]]];
    return foodSprite_;
}

- (NSInteger)getRemainingFoodPieceNumber
{
    return remainingFoodPieces_;
}

@end
