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
#import "GameOverLayer.h"
#import "CCDrawingPrimitives.h"
#import "SimpleAudioEngine.h"
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
        
        // snake control by user
        snake1 = [[Snake alloc] init];
        snakeSprites_ = [snake1 getSnakeSprites];
        snakePieces_ = [snake1 snakePoints_];
        direction_ = [snake1 direction_];
        
        // snake control by computer
        snake2 = [[Snake alloc] initASnakeWithType:SnakeTyepRobot];
        snakeSpritesRobot_ = [snake2 getSnakeSprites];
        snakePiecesRobot_ = [snake2 snakePoints_];
        directionRobot_ = [snake2 directionRobot_];
        CCLOG(@"%d", directionRobot_);
        
        currentSpeed_ = [snake1 currentSpeed_];
        
        // put food
        Food *food = [[Food alloc] init];
        remainingFoodPieces_ = [food remainingFoodPiecesCount_];
        
        // set game degree
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *degree = [defaults objectForKey:@"degree"];
        if ([degree isEqualToString:@"medium"]) {
            currentDegree = MEDIUM;
        } else if ([degree isEqualToString:@"hard"]) {
            currentDegree = HARD;
        } else {
            currentDegree = EASY;
        }
        
        [self setMenuButtonAndPauseButton];
        
        [self setScore:0];
        
        srand(time(NULL));
        [self scheduleUpdate];
        [self putFood];
        
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

- (void)putFood
{
    Food *food = [[Food alloc] init];
    foodSprite_ = [food foodSprite_];
    
    NSInteger col =  0;
    NSInteger row = 0;
    
    while (true) {
        
        col = rand() % MAX_COLS;
        row = rand() % MAX_ROWS;
        
        BOOL isColliding = NO;
        
        for (int i = 0; i < [snakePieces_ count]; i++)
        {
            if ([[snakePieces_ objectAtIndex:i] CGPointValue].x == col ||
                 [[snakePieces_ objectAtIndex:i] CGPointValue].y == row)
            {
                isColliding = YES;
            }
        }
        
        for (int j = 0; j < [snakePiecesRobot_ count]; j++) {
            if ([[snakePiecesRobot_ objectAtIndex:j] CGPointValue].x == col ||
                [[snakePiecesRobot_ objectAtIndex:j] CGPointValue].y == row) {
                isColliding = YES;
            }
        }
                
        
        if (!isColliding) {
            
            foodSprite_.tag = col * 100 + row;
            break;
        }
    }
    [self addChild:foodSprite_];
    foodSprite_.position = CGPointMake(40 + col * 20, 34 + row * 20);
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
        
        if (i == 1) {
            sprite.rotation = direction_ * 90;
        }
        
        if (![sprite parent]) {
            [self addChild:sprite];
        }
    }
    
    // snakeRobot
    int j = 0;
    for (NSValue *value in snakePiecesRobot_) {
       
        CCSprite *sprite = [snake2 snakeSpriteAtIndex:j++];
        CGPoint point = [value CGPointValue];
        
        sprite.position = CGPointMake(40 + point.x * 20, 34 + point.y * 20);
        
        if (j == 1) {
            sprite.rotation = directionRobot_ * 90;
        }
        
        if (![sprite parent]) {
            [self addChild:sprite];
        }
    }
}

- (void)stepBySnakeSprite: (NSMutableArray *)snakeSprite withNextDirection: (Direction)nextDirection andSpriteType: (SnakeType)type
{
    Direction direction;
    switch (type) {
        case SnakeTypeMe:
            nextDirection_ = nextDirection;
            direction_ = nextDirection_;
            direction = direction_;
            break;
        case SnakeTyepRobot:
            nextDirectionRobot_ = nextDirection;
            directionRobot_ = nextDirectionRobot_;
            direction = directionRobot_;
            break;
        default:
            break;
    }
    
    CGPoint tmp = [[snakeSprite objectAtIndex:0] CGPointValue];
    
    switch (direction) {
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
        if (type == SnakeTypeMe) {
            gameState_ = GameStateGameOver;
        }
    }
    
    else {
        
        // initialize the snake length
        NSInteger snakeCount = [snakeSprite count];
        
        CGPoint lastPiece = [[snakeSprite objectAtIndex:snakeCount - 1] CGPointValue];
        
        for (int i = snakeCount - 1; i > 0; i--) {
            snakeSprite[i] = snakeSprite[i - 1];
        }
        
        NSValue *value = [NSValue valueWithCGPoint:tmp];
        snakeSprite[0] = value;
        
        CGPoint tmp0 = [[snakeSprite objectAtIndex:0] CGPointValue];
        if (foodSprite_.tag / 100 == tmp0.x && foodSprite_.tag % 100 == tmp0.y)
        {
            // score += 100
            score_ += 100;
            [self setScore:score_];
            [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
            NSValue *tmpValue = [NSValue valueWithCGPoint:lastPiece];
            snakeSprite[snakeCount] = tmpValue;
            remainingFoodPieces_--;
            [foodSprite_ removeFromParentAndCleanup:YES];
            if (remainingFoodPieces_) {
                [self putFood];
            }
            else {
                gameState_ = GameStateGameOver;
            }
        }
    }


}

- (void)snakeRobotStepEasy
{
    // easy degree
    nextDirectionRobot_ = arc4random() % 4;
    
    CGPoint tmp = [[snakePiecesRobot_ objectAtIndex:0] CGPointValue];
    
//    foodSprite_.tag
}

- (void)snakeRobotStepMedium
{
    // medium degree
}

- (void)snakeRobotStepHard
{
    // hard degree
}

- (void)snakeRobotStep
{
    switch (currentDegree) {
        case EASY:
            [self snakeRobotStepEasy];
            break;
        case MEDIUM:
            [self snakeRobotStepEasy];
            break;
        case HARD:
            [self snakeRobotStepEasy];
            break;
        default:
            [self snakeRobotStepEasy];
            break;
    }
    [self stepBySnakeSprite:snakePiecesRobot_ withNextDirection:nextDirectionRobot_ andSpriteType:SnakeTyepRobot];
}

- (void)update:(ccTime)time
{
    if (gameState_ == GameStateRunning){
        accumulator += time;
        float speedStep = BASE_SPEED - BASE_SPEED / MAX_SPEED * currentSpeed_;
        while (accumulator >= speedStep) {
            [self snakeRobotStep];
            [self stepBySnakeSprite:snakePieces_ withNextDirection:nextDirection_ andSpriteType:SnakeTypeMe];
            accumulator -= speedStep;
        }
    } else if (gameState_ == GameStateGameOver) {
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:1],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[[GameOverLayer alloc] initWithScore:score_]];
         }],
          nil]];
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
