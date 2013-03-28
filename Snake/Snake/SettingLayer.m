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
#import "SimpleAudioEngine.h"
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
        CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"]
                                                                    target:self
                                                                  selector:@selector(menuBtnClicked)];
        [menuBtn setPosition:CGPointMake(winSize.width * 0.43, winSize.height * 0.4)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuBtn, nil];
        [self addChild:menu];
        
        // music setting
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *isMusicOn = [defaults objectForKey:@"isMusicOn"];
        
        CCLabelTTF *musicLabel = [CCLabelTTF labelWithString:@"音乐: " fontName:@"Marker Felt" fontSize:25];
        [musicLabel setPosition:CGPointMake(winSize.width * 0.3, winSize.height * 0.7)];
        [musicLabel setColor:ccBLACK];
        [self addChild:musicLabel];
        
        CCSprite *pauseBtn = [CCSprite spriteWithFile:@"off.png"];
        CCSprite *pauseBtn1 = [CCSprite spriteWithFile:@"off.png"];
        CCMenuItemSprite *pause = [CCMenuItemSprite itemWithNormalSprite:pauseBtn
                                                          selectedSprite:pauseBtn1
                                                                  target:self
                                                                selector:nil];
        
        CCSprite *playBtn = [CCSprite spriteWithFile:@"on.png"];
        CCSprite *playBtn1 = [CCSprite spriteWithFile:@"on.png"];
        CCMenuItemSprite *play = [CCMenuItemSprite itemWithNormalSprite:playBtn
                                                         selectedSprite:playBtn1
                                                                 target:self
                                                               selector:nil];
        
        if ([isMusicOn isEqualToString:@"on"]) {
            
            musicBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicSetting) items:play, pause, nil];
        } else {
            
            musicBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicSetting) items:pause, play, nil];
        }
        
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
        
        CCMenuItem *easyItem = [CCMenuItemImage itemWithNormalImage:@"off.png"
                                                      selectedImage:@"on.png"
                                                      disabledImage:@"off.png"
                                                             target:self
                                                           selector:@selector(easyBtnTapped:)];
        CCMenuItem *mediumItem = [CCMenuItemImage itemWithNormalImage:@"off.png"
                                                        selectedImage:@"on.png"
                                                        disabledImage:@"off.png"
                                                               target:self
                                                             selector:@selector(mediumBtnTapped:)];
        CCMenuItem *difficultItem = [CCMenuItemImage itemWithNormalImage:@"off.png"
                                                           selectedImage:@"on.png"
                                                           disabledImage:@"off.png"
                                                                  target:self
                                                                selector:@selector(hardBtnTapped:)];
        
        CCRadioMenu *radioMenu = [CCRadioMenu menuWithItems:easyItem, mediumItem, difficultItem, nil];
        [radioMenu setPosition:CGPointMake(winSize.width * 0.6, winSize.height * 0.4)];
        [radioMenu alignItemsVertically];
        
        NSString *degree = [defaults objectForKey:@"degree"];
        if ([degree isEqualToString:@"medium"]) {
            
            [radioMenu setSelectedItem_:mediumItem];
            [mediumItem selected];
        } else if ([degree isEqualToString:@"hard"]) {
            
            [radioMenu setSelectedItem_:difficultItem];
            [difficultItem selected];
        } else {
            
            [radioMenu setSelectedItem_:easyItem];
            [easyItem selected];
        }
        
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isMusicOn = [defaults objectForKey:@"isMusicOn"];
    CCLOG(@"%@", [defaults objectForKey:@"isMusicOn"]);
    
    if ([isMusicOn isEqualToString:@"off"]) {
        
        // play music
        CCLOG(@"music play");
        [defaults setObject:@"on" forKey:@"isMusicOn"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf" loop:YES];
    } else if ([isMusicOn isEqualToString:@"on"]) {
        
        // stop music
        CCLOG(@"music stop");
        [defaults setObject:@"off" forKey:@"isMusicOn"];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
}

// easy degree for new user
- (void)easyBtnTapped: (id)sender
{
    CCLOG(@"easy");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"easy" forKey:@"degree"];
}

- (void)mediumBtnTapped: (id)sender
{
    CCLOG(@"medium");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"medium" forKey:@"degree"];
}

- (void)hardBtnTapped: (id)sender
{
    CCLOG(@"hard");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"hard" forKey:@"degree"];
}

@end
