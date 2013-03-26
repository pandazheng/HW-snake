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
        
        infos_ = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"]] retain];
        CCLOG(@"%@", infos_);
        NSDictionary *infosDef = [infos_ objectAtIndex:0];
        remainingFoodPieces_ = [[infosDef valueForKey:@"foodPieces"] intValue];
        CCLOG(@"nimdiddiid");
    }
    
    return self;
}

- (CCSprite *)getFoodSprite
{
    NSArray *foodTypes = [NSArray arrayWithObjects:@"snail.png",@"worm.png", nil];
    foodSprite_ = [CCSprite spriteWithSpriteFrameName:[foodTypes objectAtIndex:rand()%[foodTypes count]]];
    return foodSprite_;
}

- (NSInteger)getRemainingFoodPieceNumber
{
    return remainingFoodPieces_;
}

@end
