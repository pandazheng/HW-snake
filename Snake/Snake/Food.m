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
@synthesize remainingFoodPiecesCount_;
@synthesize foodSprite_;

- (id)init
{
    if (self = [super init]) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"];
        NSDictionary *infos = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

        NSDictionary *infoDef_ = [infos objectForKey:@"level"];
        
        remainingFoodPieces_ = [[infoDef_ objectForKey:@"foodPieces"] intValue];
        
        NSArray *foodTypes = [NSArray arrayWithObjects:@"snail.png",@"worm.png", nil];
        foodSprite_ = [CCSprite spriteWithSpriteFrameName:[foodTypes objectAtIndex:rand()%[foodTypes count]]];
    }
    
    return self;
}

@end
