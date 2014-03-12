//
//  MyScene.m
//  EmptyScene
//
//  Created by Sergio on 09/03/14.
//  Copyright (c) 2014 Sergio. All rights reserved.
//

#import "SceneIntro.h"
#import "SceneGamePlay.h"
#import "ViewController.h"

@implementation SceneIntro
@synthesize sonicSpriteSheet, coordenadas, sonic, enter, animacionMueve, fondo;

int contador;
bool rodando = false;
SKTransition *transicion;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        transicion = [SKTransition doorwayWithDuration:3];
        
        fondo = [[SKSpriteNode alloc] initWithImageNamed:@"fondo_intro.jpg"];
        fondo.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
        fondo.anchorPoint = CGPointMake(0,1);
        fondo.xScale = 0.35;
        fondo.yScale = 0.35;
        
        [self addChild:fondo];
        
        self.backgroundColor = [SKColor blueColor];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        
        myLabel.text = @"Start";
        myLabel.name = @"start";
        myLabel.fontSize = 15;
        myLabel.color = [UIColor lightGrayColor];
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)-100);
        
        sonicSpriteSheet = [SKTexture textureWithImageNamed:@"SuperSonic2.gif"];
        contador = 0;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *plistName = @"Lista_Sprites.plist";
        NSString *finalPath = [path stringByAppendingPathComponent:plistName];
        coordenadas = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray *transSonic = [SceneIntro loadFramesFromSpriteSheet:sonicSpriteSheet
                                             WithBaseFileName:@"sonic_trans"
                                           WithNumberOfFrames:16
                                              WithCoordenadas:coordenadas];
        
        NSArray *downSonic = [SceneIntro loadFramesFromSpriteSheet:sonicSpriteSheet
                                            WithBaseFileName:@"sonic_down"
                                          WithNumberOfFrames:5 WithCoordenadas:coordenadas];
        sonic = [SKSpriteNode spriteNodeWithTexture:downSonic[1]];
        sonic.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        SKAction *entrada =[SKAction sequence:
                            @[
                              [SKAction animateWithTextures:transSonic timePerFrame:0.1 resize:true restore:true],
                              [SKAction repeatActionForever:[SKAction animateWithTextures:downSonic timePerFrame:0.1]]
                              ]
                            ];
        [sonic runAction:entrada];
        [self addChild:sonic];
        
        
        [self addChild:myLabel];
        
        NSArray *cargaSonic=[SceneIntro loadFramesFromSpriteSheet:sonicSpriteSheet
                                                 WithBaseFileName:@"sonic_charge" WithNumberOfFrames:5 WithCoordenadas:coordenadas];
        

        
        enter = [SKAction group:@[[SKAction animateWithTextures:cargaSonic
                                                   timePerFrame:0.1],
                                  [SKAction playSoundFileNamed:@"dash.mp3"
                                             waitForCompletion:NO]]];
        NSArray *ruedaSonic=[SceneIntro
                             loadFramesFromSpriteSheet:sonicSpriteSheet WithBaseFileName:@"sonic_wheel"
                             WithNumberOfFrames:5 WithCoordenadas:coordenadas];
        
        
        animacionMueve = [SKAction group:@[[SKAction animateWithTextures:ruedaSonic
                                                                      timePerFrame:0.1],[SKAction
                                                                                         sequence:@[[SKAction moveByX:60 y:20 duration:0.15-
                                                                                                     contador*0.01],[SKAction moveByX:20 y:60 duration:0.15-
                                                                                                                     contador*0.01],[SKAction moveByX:-20 y:60 duration:0.15-
                                                                                                                                     contador*0.01],[SKAction moveByX:-60 y:20 duration:0.15-
                                                                                                                                                     contador*0.01],[SKAction moveByX:-60 y:-20 duration:0.15-
                                                                                                                                                                     contador*0.01],[SKAction moveByX:-20 y:-60 duration:0.15-
                                                                                                                                                                                     contador*0.01],[SKAction moveByX:20 y:-60 duration:0.15-
                                                                                                                                                                                                     contador*0.01],[SKAction moveByX:60 y:-20 duration:0.15-
                                                                                                                                                                                                                     contador*0.01],[SKAction
                                                                                                                                                                                                                                     moveTo:CGPointMake(CGRectGetMaxX(self.frame)+40, CGRectGetMidY(self.frame))
                                                                                                                                                                                                                                     duration:0.5-contador*0.05]]]]];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        SKNode * node = [self nodeAtPoint:[touch locationInNode:self]];
        if([node.name isEqualToString:@"start"]){
            if(!rodando){
                [sonic removeAllActions];
                [sonic runAction:enter completion:
                 ^{
                     [sonic removeAllActions];
                      rodando = true;
                     [sonic runAction:animacionMueve completion:^{
                         transicion.pausesOutgoingScene = NO;
                         SceneGamePlay *newScene = [[SceneGamePlay alloc]
                                                    initWithSize:self.size];
                         [self.view presentScene: newScene transition: transicion ];
                     } ];
                     SKAction *grande = [SKAction scaleBy:4 duration:2];
                     SKAction *mueve = [SKAction moveByX:-200 y:-200 duration:2];
                     [fondo runAction:[SKAction group:@[grande,mueve]]];
                     
                 }];
                if(contador < 8)contador++;
            }
            
        }
            
            
            
    }
}


+(NSArray *)loadFramesFromSpriteSheet:(SKTexture *)textureSpriteSheet
                     WithBaseFileName: (NSString *)baseFileName WithNumberOfFrames: (int)
numberOfFrames WithCoordenadas: (NSDictionary *)coordenadasSpriteSheet
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
