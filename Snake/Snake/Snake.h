//
//  Snake.h
//  Snake
//
//  Created by ddling on 13-3-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    SnakeTypeMe,
    SnakeTyepRobot
} SnakeType;

@interface Snake : CCLayer {
}

@property (nonatomic, retain) NSDictionary *snakeInfo_;
@property (nonatomic, retain) NSMutableArray *snakePoints_;
@property (nonatomic, retain) NSMutableArray *snakeSprites_;
@property (nonatomic) NSInteger snakePiecesCount_;
@property (nonatomic) CGPoint snakePoint_;
@property (nonatomic) NSInteger direction_;
@property (nonatomic) NSInteger directionRobot_;
@property (nonatomic) NSInteger currentSpeed_;

- (NSMutableArray *)getSnakeSprites;
- (CCSprite *)snakeSpriteAtIndex:(NSInteger)index;
- (id)initASnakeWithType: (SnakeType)type;

@end
