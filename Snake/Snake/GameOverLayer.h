//
//  GameOverLayer.h
//  Snake
//
//  Created by ddling on 13-3-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer<UITextFieldDelegate>{
    UITextField *textField;
}

@property (nonatomic) NSInteger currentHighScore_;

+ (CCScene *)scene;
- (id)initWithScore: (NSInteger)score;

@end
