//
//  DifficultyViewController.swift
//  ShootIt
//
//  Created by etudiant on 15/05/2019.
//  Copyright © 2019 etudiant. All rights reserved.
//

import UIKit

struct difficulty {
    static var easy:Bool = false
    static var medium:Bool = false
    static var hard:Bool = false
}

class DifficultyViewController: UIViewController {
    
    @IBAction func easyBtn(_ sender: UIButton) {
        difficulty.easy = true
    }
    
    @IBAction func mediumBtn(_ sender: UIButton) {
        difficulty.medium = true
    }
    
    @IBAction func hardBtn(_ sender: UIButton) {
        difficulty.hard = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(difficulty.easy == true){
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
