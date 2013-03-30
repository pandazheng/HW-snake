//
//  GameOverLayer.m
//  Snake
//
//  Created by ddling on 13-3-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameConfig.h"
#import "MenuLayer.h"
#import "WorldLayer.h"

@implementation GameOverLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [GameOverLayer node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    if (self = [super init]) {
        
        CCLayerColor *background = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:background];
        
        // return to the menu layer
        CCMenuItemSprite *refreshBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"refres-off.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"refresh-on.png"]
                                                                    target:self
                                                                     selector:@selector(refreshBtnClicked:)];
        
        CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"]
                                                                    target:self
                                                                  selector:@selector(menuBtnClicked:)];
        
        CCMenu *menu = [CCMenu menuWithItems:refreshBtn, menuBtn, nil];
        [menu alignItemsHorizontallyWithPadding:80.0];
        [self addChild:menu];
    }
    
    return self;
}

- (id)initWithScore: (NSInteger)score
{
    if (self = [super init]) {

        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        score_ = score;
        
        CCLayerColor *background = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:background];
        
        // when the game is over
        [self setupScore];
        
        // return to the menu layer
        CCMenuItemSprite *refreshBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"refres-off.png"]
                                                               selectedSprite:[CCSprite spriteWithFile:@"refresh-on.png"]
                                                                       target:self
                                                                     selector:@selector(refreshBtnClicked:)];
        
        CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"]
                                                                    target:self
                                                                  selector:@selector(menuBtnClicked:)];
        
        CCMenu *menu = [CCMenu menuWithItems:refreshBtn, menuBtn, nil];
        [menu alignItemsHorizontallyWithPadding:80.0];
        [self addChild:menu];
    }
    
    return self;
}

- (void)setupScore
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Zapfino" fontSize:24];
    [gameOverLabel setColor:ccc3(255, 0, 255)];
    [gameOverLabel setPosition:ccp(winSize.width / 2, winSize.height * 0.8)];
    [self addChild:gameOverLabel];
    
    CCLabelTTF *scoreLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", score_]  fontName:@"Marker Felt" fontSize:20];
    [scoreLabel_ setColor:ccc3(100, 155, 255)];
    [scoreLabel_ setPosition:ccp(winSize.width / 2, winSize.height / 1.5)];
    [self addChild:scoreLabel_];
}

- (void)menuBtnClicked: (id)sender
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

- (void)refreshBtnClicked: (id)sender
{
    [[CCDirector sharedDirector] replaceScene:[WorldLayer scene]];
}

@end
