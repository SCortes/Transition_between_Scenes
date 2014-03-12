//
//  MyScene.m
//  MoveSonicOverTheScreen
//
//  Created by Sergio on 09/03/14.
//  Copyright (c) 2014 Sergio. All rights reserved.
//

#import "SceneGamePlay.h"

@implementation SceneGamePlay
@synthesize sonic, sonicSheet, coordenadas;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        sonicSheet = [SKTexture textureWithImageNamed:@"SuperSonic2.gif"];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *plistName = @"Lista_Sprites.plist";
        NSString *finalPath = [path stringByAppendingPathComponent:plistName];
        coordenadas = [NSDictionary dictionaryWithContentsOfFile:finalPath];


        NSArray * animacionSonic = [[NSArray alloc] initWithArray:[SceneGamePlay loadFramesFromSpriteSheet:sonicSheet WithBaseFileName:@"sonic_fly" WithNumberOfFrames:4 WithCoordenadas:coordenadas]];
        sonic = [SKSpriteNode spriteNodeWithTexture:animacionSonic[1]];
        sonic.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        
        SKAction *volar =[SKAction repeatActionForever:[SKAction
                                                        animateWithTextures:animacionSonic timePerFrame:0.1]];
        SKAction *aparece = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame),
                                                         CGRectGetMidY(self.frame)) duration:2];
        [sonic runAction:[SKAction group:@[aparece,volar]]];
        [self addChild:sonic];
        
        
    
    }
    return self;
}

+(NSArray *)loadFramesFromSpriteSheet:(SKTexture *)textureSpriteSheet WithBaseFileName: (NSString *)baseFileName WithNumberOfFrames: (int)numberOfFrames WithCoordenadas:(NSDictionary *)coordenadasSpriteSheet
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numberOfFrames
                              +1];
    for(int i = 1; i<=numberOfFrames;i++)
    {
        NSDictionary *coordenadasSprite = [coordenadasSpriteSheet objectForKey:
                                           [NSString stringWithFormat:@"%@%d", baseFileName, i]];
        NSString *x = [coordenadasSprite objectForKey:@"x"];
        NSString *y = [coordenadasSprite objectForKey:@"y"];
        NSString *width = [coordenadasSprite objectForKey:@"width"];
        NSString *height = [coordenadasSprite objectForKey:@"height"];
        SKTexture *texture = [SKTexture textureWithRect:
                              CGRectMake((CGFloat)[x floatValue]/
                                         textureSpriteSheet.size.width,
                                         (textureSpriteSheet.size.height-(CGFloat)[y floatValue]-((CGFloat)[height floatValue]))/textureSpriteSheet.size.height,(CGFloat)[width floatValue]/textureSpriteSheet.size.width,(CGFloat)[height floatValue]/
                                         textureSpriteSheet.size.height)
                                              inTexture:textureSpriteSheet];
        [frames addObject:texture];
    }
    return frames;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        for (UITouch *touch in touches) {
            if(sonic != (SKSpriteNode *)[self nodeAtPoint:[touch
                                                           locationInNode:self]])
                [self moveSonicTo:[touch locationInNode:self]];
        }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if(![sonic actionForKey:@"mover"]){
            if(sonic == (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]])
            {
                sonic.position = [touch locationInNode:self];
            }
        }
    }
}


-(void)moveSonicTo:(CGPoint)location
{
    [sonic removeActionForKey:@"mover"];
    float base=0;
    CGFloat distancia = sqrtf((location.x-sonic.position.x)*(location.x-
                                                             sonic.position.x)+(location.y-sonic.position.y)*(location.y-sonic.position.y));
    if (sonic.position.x > location.x && sonic.position.y <= location.y) {
        base = M_PI; }
    else if (sonic.position.x > location.x && sonic.position.y > location.y)
    {
        base = 3*M_PI/2;
    }
    else if (sonic.position.x <= location.x && sonic.position.y > location.y)
    {
        base = 2*M_PI;
    }
    float angulo = asinf( fabsf(location.y-sonic.position.y)/distancia);
    if(base !=0){
        angulo = base - angulo;
    }
    SKAction *giroInicio = [SKAction rotateToAngle:angulo
                                          duration:angulo/20
                                   shortestUnitArc:YES];
    
    SKAction *mover = [SKAction moveTo:location
                              duration:distancia/200];
    
    SKAction *giroFin = [SKAction rotateToAngle:0
                                       duration:angulo/20
                                shortestUnitArc:YES];
    
    [sonic runAction:[SKAction sequence:@[[SKAction
                                           group:@[giroInicio,mover]],giroFin]] withKey:@"mover"];
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
