//
//  HighScoreLayer.m
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "HighScoreLayer.h"
#import "GameConfig.h"
#import "MenuLayer.h"


@implementation HighScoreLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    HighScoreLayer *layer = [HighScoreLayer node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    if (self = [super init]) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor *background = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:background];
        
        // return to the menu layer
        CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"]
                                                                    target:self
                                                                  selector:@selector(menuBtnClicked)];
        [menuBtn setPosition:CGPointMake(winSize.width * 0.43, winSize.height * 0.4)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuBtn, nil];
        [self addChild:menu];
        
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"High Score" fontName:@"Marker Felt" fontSize:25];
        [titleLabel setPosition:CGPointMake(winSize.width / 2, winSize.height / 1.25)];
        [titleLabel setColor:ccRED];
        [self addChild:titleLabel];
    }
    
    return self;
}

- (void)menuBtnClicked
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

@end
