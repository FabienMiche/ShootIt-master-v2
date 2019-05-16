//
//  WhackSlot.swift
//  ShootIt
//
//  Created by etudiant on 08/04/2019.
//  Copyright © 2019 etudiant. All rights reserved.
//
import SpriteKit
import UIKit

//Le Slot correspond aux fenêtres

class WhackSlot: SKNode{
    var charNode: SKSpriteNode! //SKSpriteNode permet de dessiner des objets
    
    var isVisible = false       //Variable booléenne testant la visibilité des objets
    var isHit = false           //Variable booléenne testant si l'objet a été touché : ennemis ou alliés
    
    func configure(at position: CGPoint){
        self.position = position    //La position du "Node"
        
        let sprite = SKSpriteNode(imageNamed: "fenetre")        //On importe notre image de référence, ici la fenêtre
        addChild(sprite)
        
        let cropNode = SKCropNode()                             //SKCropNode va servir de masque pour cacher nos objets
        cropNode.position = CGPoint(x:0, y:-12)                 //On positionne notre masque
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "mask")    //On importe notre masque
        
        charNode = SKSpriteNode(imageNamed: "good")             //On importe notre objet
        charNode.position = CGPoint(x: 0 , y: -88)              //On positionne notre objet
        //charNode.name = "character"                           
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    //La fonction show qui va gérer le temps d'apparition des objets
    //On testera également si il s'agit d'une bonne ou une mauvaise cible
    func show(hideTime: Double){
        if isVisible {return}
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 88, duration: 0.05))      //SKAction.moveBy permet de bouger un élément, ici nos personnages, à certaines coordonnées et pendant une durée
        isVisible = true
        isHit = false
        
        if arc4random_uniform(3) == 0 {                                 //arc4randdom sert pour la génération aléatoire, l'intervalle maximum est précisé entre parenthèse, ici de 0 à 2, 3 exclus
            charNode.texture = SKTexture(imageNamed: "good")        //On change nos images
            charNode.name = "charFriend"
        } else if (arc4random_uniform(3) == 1){
            charNode.texture = SKTexture(imageNamed: "good_varient copie")
            charNode.name = "charFriend2"
        } else {
            charNode.texture = SKTexture(imageNamed: "bad")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 1.5)) { [weak self] in
            self?.hide()
        }
    }
    
    
    //La méthode hide() permet de cacher nos images après une certaine durée
    //On fait appel à .moveBy comme précédemment
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -88, duration: 0.05))
        isVisible = false
    }
    
    //Hit() va déplacer l'image touché vers des coordonnées données, ici l'image se déplacera vers le bas, lorsque l'utilisateur touche une cible
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -88, duration: 0.25)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false
        }
        charNode.run(SKAction.sequence([delay, hide, notVisible]) )
    }
}
