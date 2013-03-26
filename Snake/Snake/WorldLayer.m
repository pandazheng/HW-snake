//
//  WorldLayer.m
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WorldLayer.h"
#import "GameConfig.h"
#import "MenuLayer.h"
#import "CCDrawingPrimitives.h"
#import <OpenGLES/ES1/gl.h>


void ccDrawFilledCGRect( CGRect rect )
{
    CGPoint poli[]=
    {rect.origin,
        CGPointMake(rect.origin.x,rect.origin.y + rect.size.height),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height),
        CGPointMake(rect.origin.x + rect.size.width,rect.origin.y)};
    
	ccDrawLine(poli[0], poli[1]);
	ccDrawLine(poli[1], poli[2]);
	ccDrawLine(poli[2], poli[3]);
	ccDrawLine(poli[3], poli[0]);
}

@implementation WorldLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    WorldLayer *layer = [WorldLayer node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    if (self = [super init]) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor *background = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:background z:-1];
        
        // set the layer can catch touch event
        self.isTouchEnabled = YES;
        
        // initialize a rectangle, which the snake can move
        gameAreaRect_ = CGRectMake(29, 22, 422, 242);               // 39
        
        // return to the menu layer
        CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"]
                                                            selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"]
                                                                    target:self
                                                                  selector:@selector(menuBtnClicked)];
        [menuBtn setPosition:CGPointMake(winSize.width * 0.40, winSize.height * 0.415)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuBtn, nil];
        [self addChild:menu z:-1];
        
        // initialize the pause button
        CCMenuItemSprite *pauseBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-off.png"]
                                                             selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-on.png"]
                                                                     target:self
                                                                   selector:@selector(pauseTheGame:)];
        CCMenu *menuPause = [CCMenu menuWithItems:pauseBtn, nil];
        [menuPause setPosition:CGPointMake(winSize.width * 0.17, winSize.height * 0.90)];
        [self addChild:menuPause z:-1];
    }
    
    return self;
}

- (void)menuBtnClicked
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

// if the game is paused, resume the game or the game is running, pause the game
- (void)pauseTheGame: (id)sender
{
    CCDirector *director = [CCDirector sharedDirector];
    if (![director isPaused]) {
        
        [director pause];
    } else {
        
        [director resume];
    }
}

- (void)draw
{
    glDisable(GL_LINE_SMOOTH);
    glLineWidth(1.0f);
    glColor4ub(0, 0, 0, 255);
    ccDrawFilledCGRect(gameAreaRect_);
}

@end
