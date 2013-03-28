//
//  WorldLayer.h
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Snake.h"
#import "Food.h"

typedef enum {
    RIGHT,
    DOWN,
    LEFT,
    UP
} Direction;

typedef enum {
    GameStateRunning,
    GameStateGameOver
} GameState;

typedef enum {
    EASY,
    MEDIUM,
    HARD
} Degree;

@interface WorldLayer : CCLayer {
    
    CGSize winSize_;
    CGRect gameAreaRect_;
    
    CCLabelTTF *scoreLabel_;
    NSInteger score_;
    
    // Food Sprite
    CCSprite *foodSprite_;
    NSInteger remainingFoodPieces_;
    
    // Snake Sprite
    Snake *snake1;
    NSMutableArray *snakeSprites_;
    NSMutableArray *snakePieces_;
    NSInteger snakeCount_;
    
    Snake *snake2;
    NSMutableArray *snakeSpritesRobot_;
    NSMutableArray *snakePiecesRobot_;
    
    // game info
    NSArray *info_;
    
    // snake direction
    Direction direction_;
    Direction nextDirection_;
    
    Direction directionRobot_;
    Direction nextDirectionRobot_;
    
    // speed
    NSInteger currentSpeed_;
    float accumulator;
    
    // game state
    GameState gameState_;
    
    // game degree
    Degree currentDegree;
}

+ (CCScene *)scene;

@property(nonatomic, assign) NSInteger score;
@property(nonatomic, assign) NSArray *info;

@end
