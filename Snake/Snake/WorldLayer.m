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
@synthesize score = score_;
@synthesize info = info_;

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
        
        winSize_ = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor *background = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:background z:-1];
        
        // set the layer can catch touch event
        self.isTouchEnabled = YES;
        
        // initialize a rectangle, which the snake can move
        gameAreaRect_ = CGRectMake(29, 22, 422, 242);               // 39
        
        // set up the game information
        info_ = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"]] retain];
        
        snakeSprites_ = [[NSMutableArray alloc] init];
        snakePieces_ = [[NSMutableArray alloc] init];
        
        snake1 = [[Snake alloc] init];
        snakeSprites_ = [snake1 getSnakeSprites];
        snakePieces_ = [snake1 getSnakePieces];
        direction_ = [snake1 getDirection];
        currentSpeed_ = 1;
        
//        Food *food = [[Food alloc] init];
//        NSInteger remain = [food getRemainingFoodPieceNumber];
//        CCLOG(@"%d", remain);
//        
//        [self putFood:foodSprite_];
        
        [self setMenuButtonAndPauseButton];
        
        [self setScore:0];
        
        srand(time(NULL));
        [self scheduleUpdate];
        
        gameState_ = GameStateRunning;
    }
    
    return self;
}

// set menu button and pause button
- (void)setMenuButtonAndPauseButton
{
    // return to the menu layer
    CCMenuItemSprite *menuBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menu.png"]
                                                        selectedSprite:[CCSprite spriteWithFile:@"menu-on.png"]
                                                                target:self
                                                              selector:@selector(menuBtnClicked)];
    [menuBtn setPosition:CGPointMake(winSize_.width * 0.40, winSize_.height * 0.415)];
    
    CCMenu *menu = [CCMenu menuWithItems:menuBtn, nil];
    [self addChild:menu z:-1];
    
    // initialize the pause button
    CCMenuItemSprite *pauseBtn = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-off.png"]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-on.png"]
                                                                 target:self
                                                               selector:@selector(pauseTheGame:)];
    CCMenu *menuPause = [CCMenu menuWithItems:pauseBtn, nil];
    [menuPause setPosition:CGPointMake(winSize_.width * 0.17, winSize_.height * 0.90)];
    [self addChild:menuPause z:-1];
}

// set the score with score
- (void)setScore:(NSInteger)score
{
    if (!scoreLabel_) {
        
        scoreLabel_ = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:25];
        [scoreLabel_ setPosition:ccp(winSize_.width / 2, winSize_.height * 0.90)];
        [self addChild:scoreLabel_];
    }
    
    [scoreLabel_ setString:[NSString stringWithFormat:@"Score: %d", score_]];
}

- (void)putFood: (CCSprite *)foodSprite
{
    NSInteger col =  0;
    NSInteger row = 0;
    
    while (true) {
        
        col = rand() % MAX_COLS;
        row = rand() % MAX_ROWS;
        
        BOOL isColliding = NO;
        
        if (!isColliding) {
            
            foodSprite.tag = col * 100 + row;
            break;
        }
    }
    [self addChild:foodSprite];
    foodSprite.position = CGPointMake(44 + col * 20, 38 + row * 20);
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
    
    // snake 1
    int i = 0;
    for (NSValue *value in snakePieces_) {
        
        CCSprite *sprite = [snake1 snakeSpriteAtIndex: i++];
        CGPoint point = [value CGPointValue];

        sprite.position = CGPointMake(40 + point.x * 20, 34 + point.y * 20);
        
        if (![sprite parent]) {
            [self addChild:sprite];
        }
    }
}

- (void)step {
    direction_ = nextDirection_;
    
    CGPoint tmp = [[snakePieces_ objectAtIndex:0] CGPointValue];
    
    switch (direction_) {
        case UP:
            tmp.y++;
            break;
        case RIGHT:
            tmp.x++;
            break;
        case DOWN:
            tmp.y--;
            break;
        case LEFT:
            tmp.x--;
            break;
        default:
            break;
    }
    if (tmp.x < 0
        || tmp.x > MAX_COLS
        || tmp.y < 0
        || tmp.y > MAX_ROWS) {
        NSLog(@"GAME OVER");
        gameState_ = GameStateGameOver;
    }
    else {
        
        NSInteger snakeCount = [snakePieces_ count];
        
        CGPoint lastPiece = [[snakePieces_ objectAtIndex:snakeCount - 1] CGPointValue];

        for (int i = snakeCount - 1; i > 0; i--) {
            snakePieces_[i] = snakePieces_[i - 1];
        }
        
        NSValue *value = [NSValue valueWithCGPoint:tmp];
        snakePieces_[0] = value;
//        if (foodSprite_.tag / 100 == snake_[0].x
//            && foodSprite_.tag % 100 == snake_[0].y) {
//            snake_[snakePieces_] = lastPiece;
//            snakePieces_++;
//            remainingFoodPieces_--;
//            [foodSprite_ removeFromParentAndCleanup:YES];
//            if (remainingFoodPieces_) {
//                [self setUpFoodPiece];
//            }
//            else {
//                gameState_ = GameStateLevelOver;
//                [self displayEndOfLevelAnimation];
//            }
//        }
    }
}

- (void)update:(ccTime)time
{
    if (gameState_ == GameStateRunning){
        accumulator += time;
        float speedStep = BASE_SPEED - BASE_SPEED / MAX_SPEED * currentSpeed_;
        while (accumulator >= speedStep) {
            [self step];
            accumulator -= speedStep;
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(gameAreaRect_, p)) {
        
        if (direction_ == UP || direction_ == DOWN) {
            if (p.x - 29 > gameAreaRect_.size.width / 2) {
                nextDirection_ = RIGHT;
                CCLOG(@"RIGHT");
            } else {
                nextDirection_ = LEFT;
                CCLOG(@"LEFT");
            }
        } else {
            if (p.y - 38 > gameAreaRect_.size.height / 2) {
                nextDirection_ = UP;
                CCLOG(@"UP");
            } else {
                nextDirection_ = DOWN;
                CCLOG(@"DOWN");
            }
        }
    }
}

@end
