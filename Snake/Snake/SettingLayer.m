//
//  SettingLayer.m
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SettingLayer.h"
#import "MenuLayer.h"
#import "CCRadioMenu.h"
#import "GameConfig.h"


@implementation SettingLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    SettingLayer *layer = [SettingLayer node];
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
        CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"] selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"] target:self selector:@selector(menuBtnClicked)];
        [menuBtn setPosition:CGPointMake(winSize.width * 0.43, winSize.height * 0.4)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuBtn, nil];
        [self addChild:menu];
        
        // music setting
        
        CCLabelTTF *musicLabel = [CCLabelTTF labelWithString:@"音乐: " fontName:@"Marker Felt" fontSize:25];
        [musicLabel setPosition:CGPointMake(winSize.width * 0.3, winSize.height * 0.7)];
        [musicLabel setColor:ccBLACK];
        [self addChild:musicLabel];
        
        CCSprite *pauseBtn = [CCSprite spriteWithFile:@"off.png"];
        CCSprite *pauseBtn1 = [CCSprite spriteWithFile:@"off.png"];
        CCMenuItemSprite *pause = [CCMenuItemSprite itemWithNormalSprite:pauseBtn selectedSprite:pauseBtn1 target:self selector:nil];
        
        CCSprite *playBtn = [CCSprite spriteWithFile:@"on.png"];
        CCSprite *playBtn1 = [CCSprite spriteWithFile:@"on.png"];
        CCMenuItemSprite *play = [CCMenuItemSprite itemWithNormalSprite:playBtn selectedSprite:playBtn1 target:self selector:nil];
        
        musicBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicSetting) items:play, pause, nil];
        [musicBtn setPosition:CGPointMake(winSize.width * 0.1, winSize.height * 0.2)];
        
        CCMenu *menu1 = [CCMenu menuWithItems:musicBtn, nil];
        [self addChild:menu1];
        
        // easy or difficult
        
        CCLabelTTF *easyLabel = [CCLabelTTF labelWithString:@"简单: " fontName:@"Marker Felt" fontSize:25];
        [easyLabel setPosition:CGPointMake(winSize.width * 0.3, winSize.height * 0.52)];
        [easyLabel setColor:ccBLACK];
        [self addChild:easyLabel];
        
        CCLabelTTF *mediumLabel = [CCLabelTTF labelWithString:@"中等: " fontName:@"Marker Felt" fontSize:25];
        [mediumLabel setPosition:CGPointMake(winSize.width * 0.3, winSize.height * 0.40)];
        [mediumLabel setColor:ccBLACK];
        [self addChild:mediumLabel];

        CCLabelTTF *diffLabel = [CCLabelTTF labelWithString:@"困难: " fontName:@"Marker Felt" fontSize:25];
        [diffLabel setPosition:CGPointMake(winSize.width * 0.3, winSize.height * 0.28)];
        [diffLabel setColor:ccBLACK];
        [self addChild:diffLabel];
        
        CCMenuItem *easyItem = [CCMenuItemImage itemWithNormalImage:@"off.png" selectedImage:@"on.png" disabledImage:@"off.png" target:self selector:@selector(easyBtnTapped:)];
        CCMenuItem *mediumItem = [CCMenuItemImage itemWithNormalImage:@"off.png" selectedImage:@"on.png" disabledImage:@"off.png" target:self selector:@selector(mediumBtnTapped:)];
        CCMenuItem *difficultItem = [CCMenuItemImage itemWithNormalImage:@"off.png" selectedImage:@"on.png" disabledImage:@"off.png" target:self selector:@selector(diffBtnTapped:)];
        
        CCRadioMenu *radioMenu = [CCRadioMenu menuWithItems:easyItem, mediumItem, difficultItem, nil];
        [radioMenu setPosition:CGPointMake(winSize.width * 0.6, winSize.height * 0.4)];
        [radioMenu alignItemsVertically];
        [radioMenu setSelectedItem_:easyItem];
        [easyItem selected];
        [self addChild:radioMenu];
    }
    
    return self;
}

- (void)menuBtnClicked
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

- (void)musicSetting
{
    if ([musicBtn selectedIndex] == 0) {
        
        // play music
        CCLOG(@"music play");
    } else if ([musicBtn selectedIndex] == 1) {
        
        // stop music
        CCLOG(@"music stop");
    }
}

- (void)easyBtnTapped: (id)sender
{
    CCLOG(@"easy");
}

- (void)mediumBtnTapped: (id)sender
{
    CCLOG(@"medium");
}

- (void)diffBtnTapped: (id)sender
{
    CCLOG(@"difficult");
}

@end
