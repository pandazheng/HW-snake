//
//  Snake.h
//  Snake
//
//  Created by ddling on 13-3-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Snake : CCLayer {
    
    NSDictionary *snakeInfo_;
    
    NSMutableArray *snake_;
    NSMutableArray *snakeSprites_;
    NSInteger snakePieces_;
    
    CGPoint snakePiece;
    
    NSInteger direction_;
}

@end
