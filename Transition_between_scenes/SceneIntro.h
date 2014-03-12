//
//  MyScene.h
//  EmptyScene
//

//  Copyright (c) 2014 Sergio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SceneIntro : SKScene

@property(strong, nonatomic) NSDictionary *coordenadas;
@property(strong, nonatomic) SKTexture *sonicSpriteSheet;
@property(strong, nonatomic) SKSpriteNode *sonic;
@property(strong,nonatomic) SKAction *enter;
@property(strong, nonatomic) SKAction *animacionMueve;
@property(strong, nonatomic) SKSpriteNode *fondo;

@end
