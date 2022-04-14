//
//  SplashViewController.swift
//  inwiOCR
//
//  Created by taha_jadid on 11/4/2022.
//

import Foundation
import UIKit
import Lottie

class SplashViewController : UIViewController {
    
    @IBOutlet weak var animatedView: UIView!
    private var myAnimationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        myAnimationView = .init(name: "inwi_Animation")
        myAnimationView!.frame = animatedView.bounds
        myAnimationView!.contentMode = .scaleAspectFill
        myAnimationView!.loopMode = .repeat(1.0)
        animatedView.addSubview(myAnimationView!)
        myAnimationView!.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            // your code here
            self.performSegue(withIdentifier: "splashToScan", sender: self)

        }

    }
    
    
}
