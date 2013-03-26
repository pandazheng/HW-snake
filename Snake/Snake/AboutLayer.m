//
//  AboutLayer.m
//  Snake
//
//  Created by ddling on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "AboutLayer.h"
#import "GameConfig.h"
#import "MenuLayer.h"


@implementation AboutLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    AboutLayer *layer = [AboutLayer node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    if (self = [super init]) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor *background = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:background];
        
        NSString *str = [NSString stringWithFormat:@"This is game is based on the project, clawoo/Snake, which is on the github: https://github.com/clawoo/Snake. I simple add some new features and delete what I does not ues"];
        CCLabelTTF *label = [CCLabelTTF labelWithString:str dimensions:CGSizeMake(350, 250) hAlignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:25];
        [label setPosition:CGPointMake(winSize.width / 2, winSize.height / 2.4)];
        [label setColor:ccBLACK];
        [self addChild:label];
        
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

@end
