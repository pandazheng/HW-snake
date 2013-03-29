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
@synthesize currentHighScore_;

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
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(165, 50, 160, 40)];
        textField.placeholder = @"input your name";
        textField.textColor = [UIColor redColor];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        
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
        
        if (score > [self getCurrentHighScore]) {
            [self showTextField];
        }
    }
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [textField removeFromSuperview];
    return YES;
}

- (void)showTextField
{
    [[[CCDirector sharedDirector] openGLView] addSubview:textField];
}
- (NSInteger)getCurrentHighScore
{
    return 100;
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
