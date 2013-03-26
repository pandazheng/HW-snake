//
//  MenuLayer.m
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "AboutLayer.h"
#import "SettingLayer.h"
#import "HighScoreLayer.h"
#import "WorldLayer.h"
#import "GameConfig.h"


@implementation MenuLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    MenuLayer *menuLayer = [MenuLayer node];
    [scene addChild:menuLayer];
    return scene;
}

// initialize the menu scene
- (id)init
{
    if (self = [super init]) {
        
        CCDirector *director = [CCDirector sharedDirector];
        CGSize winSize = [director winSize];
        
        CCLayerColor *backgroundColor = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:backgroundColor];
        
        // set the label for title 
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Snake World" fontName:@"Zapfino" fontSize:28];
        [label setPosition:CGPointMake(winSize.width / 2, winSize.height / 1.3)];
        [label setColor:ccRED];
        [self addChild:label];
        
        // set the main menu
        CCMenuItemSprite *playBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-play-off.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-play-on.png"]
                                                                    target:self
                                                                  selector:@selector(playBtnClicked)];
        
        CCMenuItemSprite *highScoreBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-highscores-off.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-highscores-on.png"]
                                                                    target:self
                                                                  selector:@selector(highScoreBtnClicked)];
        
        CCMenuItemSprite *aboutBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-about-off.png"]
                                                                 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-about-on.png"]
                                                                         target:self
                                                                       selector:@selector(aboutBtnClicked)];
        
        CCMenu *menu = [CCMenu menuWithItems:playBtn, highScoreBtn, aboutBtn, nil];
        [menu setPosition:CGPointMake(winSize.width / 2, winSize.height / 2.4)];
        [menu alignItemsVertically];
        
        // set the setting menu 
        CCMenuItemSprite *settingBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"setting.png"] selectedSprite:[CCSprite spriteWithFile:@"setting-on.png"] target:self selector:@selector(settingBtnClicked)];
        
        [settingBtn setPosition:CGPointMake(210, -130)];
        CCMenu *menu1 =[CCMenu menuWithItems:settingBtn, nil];
        
        [self addChild:menu];
        [self addChild:menu1];
    }
    
    return self;
}

// play game
- (void)playBtnClicked
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene:[WorldLayer scene]];
}

// high score layer
- (void)highScoreBtnClicked
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene:[HighScoreLayer scene]];
}

// about layer
- (void)aboutBtnClicked
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene:[AboutLayer scene]];
}

// set the game setting
- (void)settingBtnClicked
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene:[SettingLayer scene]];
}

@end
