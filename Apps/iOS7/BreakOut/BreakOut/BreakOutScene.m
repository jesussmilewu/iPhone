//
//  BreakOutMyScene.m
//  BreakOut
//
//  Created by Clemens Wagner on 11.01.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "BreakOutScene.h"

const NSUInteger kRows = 4;
const NSUInteger kBricksPerRow = 8;

const uint32_t kWallMask = 1 << 0;
const uint32_t kBallMask = 1 << 1;
const uint32_t kBrickMask = 1 << 2;
const uint32_t kRacketMask = 1 << 3;

static NSString * const kGameOverLabel = @"Game Over";

@interface BreakOutScene ()<SKPhysicsContactDelegate>

@property (nonatomic) CGFloat velocity;
@property (nonatomic, strong) SKNode *ball;
@property (nonatomic, strong) SKNode *racket;

@end

@implementation BreakOutScene

- (id)initWithSize:(CGSize)inSize {
    CGSize theCellSize = CGSizeMake(inSize.width / kBricksPerRow,
                                    inSize.width / (3 * kBricksPerRow));
    CGSize theRacketSize = CGSizeMake(theCellSize.width, theCellSize.height / 2.0);
    CGFloat theMinimalY = 0.0;
    
    self = [super initWithSize:inSize];
    if(self) {
        CGRect theFrame = self.frame;
        SKPhysicsBody *theBody;
        
        theFrame.origin.y = -2.0 * theCellSize.height;
        theFrame.size.height += 2.0 * theCellSize.height;
        theBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:theFrame];
        self.backgroundColor = [SKColor blueColor];
        self.velocity = inSize.height / 2.0;
        for(NSUInteger i = 0; i < kRows; ++i) {
            CGPoint thePoint = CGPointMake(theCellSize.width / 2.0,
                                           inSize.height - (i + 0.5) * theCellSize.height);
            
            theMinimalY = thePoint.y;
            for(NSUInteger j = 0; j < kBricksPerRow; ++j) {
                SKColor *theColor = [SKColor redColor];
                
                [self addChild:[self brickWithColor:theColor size:theCellSize position:thePoint]];
                thePoint.x += theCellSize.width;
            }
        }
        self.racket = [self racketWithSize:theRacketSize
                                  position:CGPointMake(inSize.width / 2.0, theCellSize.height)];
        [self addChild:self.racket];
        theBody.density = 0.0;
        theBody.friction = 0.0;
        theBody.linearDamping = 0.0;
        theBody.angularDamping = 0.0;
        theBody.categoryBitMask = kWallMask;
        theBody.collisionBitMask = kBallMask;
        self.physicsBody = theBody;
        self.physicsWorld.contactDelegate = self;
        [self start];
    }
    return self;
}

- (CGFloat)speed {
    SKPhysicsBody *theBody = self.ball.physicsBody;
    CGVector theVelocity = theBody.velocity;
    
    return sqrtf(theVelocity.dx * theVelocity.dx + theVelocity.dy * theVelocity.dy);
}

- (CGFloat)direction {
    SKPhysicsBody *theBody = self.ball.physicsBody;
    CGVector theVelocity = theBody.velocity;

    return atan2f(theVelocity.dy, theVelocity.dx);
}

- (CGFloat)gravity {
    CGVector theGravity = self.physicsWorld.gravity;
    
    return sqrtf(theGravity.dx * theGravity.dx + theGravity.dy * theGravity.dy);
}

- (void)addImpulseWithFactor:(CGFloat)inFactor {
    SKPhysicsBody *theBody = self.ball.physicsBody;
    CGFloat theAngle = self.direction;
    CGFloat theImpulse = theBody.mass * self.gravity * inFactor;
    CGVector theImpulseVector = CGVectorMake(theImpulse * cosf(theAngle), theImpulse * sinf(theAngle));
    
    [theBody applyImpulse:theImpulseVector];
}

- (void)updateRacketWithTouches:(NSSet *)inTouches {
    SKNode *theRacket = self.racket;
    
    if(![theRacket hasActions]) {
        UITouch *theTouch = [inTouches anyObject];
        CGPoint thePoint = [theTouch locationInNode:self];
        /*NSTimeInterval theTime = 0.5 * fabs(thePoint.x - theRacket.position.x) / self.size.width;
        
        [theRacket runAction:[SKAction moveToX:thePoint.x duration:theTime]];*/
        thePoint.y = theRacket.position.y;
        theRacket.position = thePoint;
    }
}

- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent {
    if([self isRunning]) {
        [self updateRacketWithTouches:inTouches];
    }
    else {
        [self start];
    }
}

- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent {
    [self updateRacketWithTouches:inTouches];
}

- (BOOL)isRunning {
    return self.ball != nil;
}

- (void)start {
    if(self.ball == nil) {
        CGRect theFrame = self.frame;
        CGFloat theRadius = CGRectGetWidth(theFrame) / (6 * kBricksPerRow);
        CGPoint thePosition = CGPointMake(CGRectGetMidX(theFrame), CGRectGetMidY(theFrame));
        SKNode *theLabel = [self childNodeWithName:kGameOverLabel];
        
        self.ball = [self ballWithRadius:theRadius position:thePosition];
        [self addChild:self.ball];
        [theLabel removeFromParent];
    }
}

- (void)stop {
    SKNode *theBall = self.ball;

    self.ball = nil;
    if(theBall != nil) {
        SKLabelNode *theNode = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold "];
        CGRect theFrame = self.frame;
        
        [theBall runAction:[SKAction removeFromParent]];
        theNode.name = kGameOverLabel;
        theNode.text = NSLocalizedString(@"Game Over", @"Game Over");
        theNode.position = CGPointMake(CGRectGetMidX(theFrame), CGRectGetMidY(theFrame));
        theNode.alpha = 0.0;
        [self addChild:theNode];
        [theNode runAction:[SKAction fadeInWithDuration:0.25]];
    }
}

- (CGVector)velocityWithDirection:(CGVector)inDirection {
    CGFloat theAbsoluteVelocity = sqrtf(inDirection.dx * inDirection.dx + inDirection.dy * inDirection.dy);
    
    if(theAbsoluteVelocity == 0) {
        CGFloat theAngle = 2 * M_PI * drand48();
        
        return CGVectorMake(self.velocity * sinf(theAngle), self.velocity * cosf(theAngle));
    }
    else {
        CGFloat theScale = self.velocity / theAbsoluteVelocity;

        return CGVectorMake(inDirection.dx * theScale, inDirection.dy * theScale);
    }
}

- (SKNode *)brickWithColor:(SKColor *)inColor size:(CGSize)inSize position:(CGPoint)inCenter {
    SKShapeNode *theBrick = [SKShapeNode new];
    CGRect theBounds = CGRectMake(-inSize.width / 2.0, -inSize.height / 2.0, inSize.width, inSize.height);
    CGPathRef thePath = CGPathCreateWithRect(theBounds, NULL);
    SKPhysicsBody *theBody = [SKPhysicsBody bodyWithRectangleOfSize:inSize];
    
    theBrick.path = thePath;
    theBrick.fillColor = inColor;
    theBrick.strokeColor = [SKColor whiteColor];
    theBrick.glowWidth = 1.0;
    theBrick.position = inCenter;
    theBody.dynamic = NO;
    theBody.categoryBitMask = kBrickMask;
    theBody.collisionBitMask = kBallMask;
    theBody.mass = inSize.width * inSize.height;
    theBrick.physicsBody = theBody;
    CGPathRelease(thePath);
    return theBrick;
}

- (SKNode *)ballWithRadius:(CGFloat)inRadius position:(CGPoint)inCenter {
    SKShapeNode *theBall = [SKShapeNode new];
    CGRect theBounds = CGRectMake(-inRadius, -inRadius, 2 * inRadius, 2 * inRadius);
    CGPathRef thePath = CGPathCreateWithEllipseInRect(theBounds, NULL);
    SKPhysicsBody *theBody = [SKPhysicsBody bodyWithCircleOfRadius:inRadius];
    CGFloat theAngle = -M_PI / 4.0 + M_PI * drand48() / 2.0;
    
    theBall.name = @"ball";
    theBall.path = thePath;
    theBall.fillColor = [SKColor yellowColor];
    theBall.strokeColor = [SKColor clearColor];
    theBall.glowWidth = 1.0;
    theBall.position = inCenter;
    theBody.affectedByGravity = NO;
    theBody.categoryBitMask = kBallMask;
    theBody.collisionBitMask = kBrickMask | kRacketMask | kWallMask;
    theBody.contactTestBitMask = kBrickMask | kRacketMask | kWallMask;
    theBody.restitution = 0.0;
    theBody.mass = 10; // inRadius * inRadius * M_PI;
    theBody.velocity = CGVectorMake(self.velocity * sinf(theAngle), self.velocity * cosf(theAngle));
    theBody.friction = 0.0;
    theBody.linearDamping = 0.0;
    theBody.angularDamping = 0.0;
    theBall.physicsBody = theBody;
    CGPathRelease(thePath);
    return theBall;
}

- (SKNode *)racketWithSize:(CGSize)inSize position:(CGPoint)inCenter {
    SKShapeNode *theRacket = [SKShapeNode new];
    CGRect theBounds = CGRectMake(-inSize.width / 2.0, -inSize.height / 2.0, inSize.width, inSize.height);
    CGPathRef thePath = CGPathCreateWithRect(theBounds, NULL);
    SKPhysicsBody *theBody = [SKPhysicsBody bodyWithPolygonFromPath:thePath];

    theRacket.name = @"racket";
    theRacket.path = thePath;
    theRacket.fillColor = [SKColor whiteColor];
    theRacket.strokeColor = [SKColor clearColor];
    theRacket.glowWidth = 0.0;
    theRacket.position = inCenter;
    theBody.dynamic = NO;
    theBody.categoryBitMask = kRacketMask;
    theBody.collisionBitMask = kBallMask;
    theBody.contactTestBitMask = kBallMask;
    theBody.mass = inSize.width * inSize.height;
    theBody.allowsRotation = NO;
    theRacket.physicsBody = theBody;
    CGPathRelease(thePath);
    return theRacket;
}

- (SKNode *)emitterNodeNamed:(NSString *)inName {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:inName ofType:@"sks"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:thePath];
}

- (void)explosionAtPoint:(CGPoint)inPoint {
    SKNode *theNode = [self emitterNodeNamed:@"contact"];
    SKAction *theAction = [SKAction sequence:@[[SKAction waitForDuration:0.05],
                                               [SKAction removeFromParent]]];
    
    theNode.position = inPoint;
    [self addChild:theNode];
    [theNode runAction:theAction];
}

- (void)didBeginContact:(SKPhysicsContact *)inContact {
    SKPhysicsBody *theBody = inContact.bodyA;
    CGPoint thePoint = inContact.contactPoint;

    NSLog(@"contact: %u", theBody.categoryBitMask);
    if(theBody.categoryBitMask == kBrickMask) {
        SKNode *theBrick = theBody.node;
        SKAction *theAction = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],
                                                   [SKAction removeFromParent]
                                                   ]];
        
        [theBrick runAction:theAction];
        [self explosionAtPoint:thePoint];
    }
    else if (theBody.categoryBitMask == kWallMask && thePoint.y < 0.0) {
        [self stop];
    }
}

- (void)didEndContact:(SKPhysicsContact *)inContact {
    SKPhysicsBody *theBody = inContact.bodyA;

    if(theBody.categoryBitMask == kBrickMask) {
        [self addImpulseWithFactor:25.0];
    }
    else {
        [self addImpulseWithFactor:15.0];
    }
}

@end
