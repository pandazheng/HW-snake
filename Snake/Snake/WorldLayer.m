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
        gameAreaRect_ = CGRectMake(29, 38, 422, 242);
        
        // return to the menu layer
        CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"] selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"] target:self selector:@selector(menuBtnClicked)];
        [menuBtn setPosition:CGPointMake(winSize.width * 0.43, winSize.height * 0.4)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuBtn, nil];
        [self addChild:menu];
    }
    
    return self;
}

- (void)menuBtnClicked
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

- (void)draw
{
//    glLineWidth(1.0f);
//    glColorMask(0, 0, 0, 255);
//    ccDrawFilledCGRect(gameAreaRect_);
}

@end
