//
//  GameScene.swift
//  ShootIt
//
//  Created by etudiant on 08/04/2019.
//  Copyright © 2019 etudiant. All rights reserved.
//

import SpriteKit
import Foundation

struct resultats {
    static var scoreFinal:Int = 0
}

//Les instructions ci-dessous sont nécessaires au bon fonctionnement de l'utilisation de Random
//On peut maintenant générer des valeurs de type Double de façon aléatoires
//Sans ses instructions on obtient des erreurs

extension Range where Bound == Int {
    var random: Int {
        return lowerBound + numericCast(arc4random_uniform(numericCast(count)))
    }
    func random(_ n: Int) -> [Int] {
        return (0..<n).map { _ in random }
    }
}
extension ClosedRange where Bound == Int {
    var random: Int {
        return lowerBound + numericCast(arc4random_uniform(numericCast(count)))
    }
    func random(_ n: Int) -> [Int] {
        return (0..<n).map { _ in random }
    }
}

extension Double {
    var absoluteValue: Double {
        if self > 0.0 {
            return self
        }
        else {
            return -1 * self
        }
    }
}

//Les instructions ci-dessous permet de "shuffle" un array
//Shuffle est une méthode permettant de réorganiser les éléments d'un array

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}




class GameScene: SKScene {
    var slots = [WhackSlot]()       //Un array nous permettant de stocker toutes nos fenêtres
    var gameScore: SKLabelNode!     //Label du score
    var gameTimer: SKLabelNode!     //Label du timer
    var popupTime = 2.35            //Temps d'affichage des objets
    
    var score = 0 {                 //Variable qui contiendra le score
        didSet {
            gameScore.text = "\(score)"
        }
    }
    
    
    var temps = 0 {                 //Variable qui contiendra le temps
        didSet {
            gameTimer.text = "\(temps)"
        }
    }
    
    var chrono = Timer()            //On déclare une variable chrono qui est un Timer, cela nous permettra de gérer plusieurs paramètres plus bas comme le nombre de secondes entre les déclenchements du timer



    override func didMove(to view: SKView) {
        
        //On place ici l'arrière plan de notre jeu
        let background = SKSpriteNode(imageNamed: "FINAL_Building_NoWindowsV2")   //SKSpriteNote est un élément graphique qui peut être initialisé à partir d'une image ou d'une couleur unie. imageNamed initialise une image-objet texturée à l'aide d'un fichier image
        background.position = CGPoint(x: 0, y: 0)   //On définie les coordonnées de l'arrière plan
        background.blendMode = .replace             //blendeMode est une propriété qui décrit comment tous les "SpriteKit nodes" doivent être dessinés à l'écran. La valeur par défaut est ".alpha" qui signifie que l'image doit être dessiné pour que la transparence alpha soit respectée, on utilise ".replace" pour ignorer l'alpha dans la texture. Plus d'infos : https://www.hackingwithswift.com/example-code/games/how-to-made-an-skspritenode-render-faster-using-blendmode
        background.zPosition = -1
        addChild(background)                                //On ajoute l'arrière plan à notre ViewController, ici GameViewController
        
        gameScore = SKLabelNode(fontNamed:"Chalkduster")    //On définit une police pour le texte
        gameScore.text = "0"                                //On définit notre texte
        gameScore.position = CGPoint(x: -320, y: 580)       //On positionne le texte
        gameScore.horizontalAlignmentMode = .left           //On définit l'alignement horizontale
        gameScore.fontSize = 48                             //On définit la taille du texte
        addChild(gameScore)
        
        //Même chose pour le temps
        gameTimer = SKLabelNode(fontNamed:"Chalkduster")
        gameTimer.text = "0"
        gameTimer.position = CGPoint(x: -100, y: 580)
        gameTimer.horizontalAlignmentMode = .center
        gameTimer.fontSize = 48
        addChild(gameTimer)
        if(difficulty.easy == true){
            temps = 60
        } else if(difficulty.medium == true || difficulty.hard == true) {
            temps = 30
        }
        
        
        //Les boucles ici correspondent à la création et à l'emplacement des fenêtres
        //On aura ici 5 lignes et 4 colonnes de fenêtres
        //L'appel de la fonction createSlot permet de créer les fenêtres
        //CGPoint est une structure qui contient un point dans un système de coordonnées à deux dimensions 
        for i in 0..<4 { createSlot(at: CGPoint(x: -225 + (i * 150), y: 400))}
        for i in 0..<4 { createSlot(at: CGPoint(x: -225 + (i * 150), y: 250))}
        for i in 0..<4 { createSlot(at: CGPoint(x: -225 + (i * 150), y: 100))}
        for i in 0..<4 { createSlot(at: CGPoint(x: -225 + (i * 150), y: -120))}
        for i in 0..<4 { createSlot(at: CGPoint(x: -225 + (i * 150), y: -300))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self]
            in self?.createEnemy()
        }
        
        //selector: permet d'envoyer un message à la méthode gameChrono, lorsque le timer se déclenche
        chrono = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameChrono), userInfo: nil, repeats: true)
        
        
    }
    
    //La méthode touhesBegan est une méthode généré lors de la création du projet
    //Cet méthode gère la détection d'appui sur l'écran
    //On testera également, en parcourant la liste de tous les "node", si l'utilisateur a touché une bonne ou une mauvaise cible.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend" || node.name == "charFriend2"{
                //Touche la mauvaise cible
                score -= 5
                run(SKAction.playSoundFileNamed("civil.mp3", waitForCompletion: false))
            } else if node.name == "charEnemy"{
                //Touche la bonne cible
                whackSlot.charNode.xScale = 0.85    //Lorsqu'on touche une bonne cible on change l'échelle juste pour montrer qu'on a touché la bonne cible
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("ouille.mp3", waitForCompletion: false))
            }
        }
    }
    
    //Méthode qui permet de générer les fenêtres
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()      //On appelle notre ficher WhackSlot.swift
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    //Méthode qui gère le timer
    @objc func gameChrono(){
        if(pause.pauseValue == false){
            temps -= 1
        }
        
        
        //On teste lorsque celui-ci atteint 0 on change de vue
        if temps == 0 {
            for slot in slots {
                slot.hide()
            }
            resultats.scoreFinal = score
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EndScene")   //On précise la vue qu'on veut atteindre, on attribue un ID à la vue dans le Main.storyboard
            vc.view.frame = (self.view?.frame)!
            vc.view.layoutIfNeeded()
            
            //On choisit le type de transition
            UIView.transition(with: self.view!, duration: 0.3,
                              options: .transitionFlipFromRight, animations:
                {
                    self.view?.window?.rootViewController = vc
            }, completion: { completed in
                
            })
            return      //Return est important, sans lui le jeu continue de tourner (les cibles vont continuer à apparaître
        }
    }
    
    
    
    
    //Méthode de la création des ennemis
    //Ici, le temps sera également
    @objc func createEnemy() {
        //popupTime *= 1.085
        if(difficulty.easy == true || difficulty.medium == true) {
            popupTime *= 1.085
        } else if (difficulty.hard == true) {
            popupTime *= 0.975
        }
        
        
        
        slots.shuffle()                     //Randomizes the order of an array’s elements.
        slots[0].show(hideTime: popupTime)  //On prend le premier élément de notre liste
        
        //On veut faire apparaître les cibles dans plusieurs fenêtre et pas seulement dans la première
        //On fait appelle à la méthode show()
        if (0...12).random > 4 {slots[1].show(hideTime: popupTime)}
        if (0...12).random > 8 {slots[2].show(hideTime: popupTime)}
        if (0...12).random > 10 {slots[3].show(hideTime: popupTime)}
        if (0...12).random > 11 {slots[4].show(hideTime: popupTime)}
 
        
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double(arc4random_uniform(UInt32(minDelay + maxDelay)))
        //let delay = Double(arc4random()) * (minDelay - maxDelay)
        
        
        //DispatchQueue manages the execution of work items. Each work item submitted to a queue is processed on a pool of threads managed by the system.
        //asyncAfter Submits a work item to a dispatch queue for asynchronous execution after a specified time.
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}

