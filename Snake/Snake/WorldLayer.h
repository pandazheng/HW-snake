//
//  WorldLayer.h
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WorldLayer : CCLayer {
    
    CGSize winSize_;
    CGRect gameAreaRect_;
    
    CCLabelTTF *scoreLabel_;
    NSInteger score_;
    
    // game info
    NSArray *info_;
}

+ (CCScene *)scene;

@property(nonatomic, assign) NSInteger score;
@property(nonatomic, assign) NSArray *info;

@end
