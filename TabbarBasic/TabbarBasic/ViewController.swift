//
//  ViewController.swift
//  TabbarBasic
//
//  Created by swuad_39 on 04/07/2019.
//  Copyright © 2019 Digital Media Dept. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func moveToTabbar(_ sender: Any) {
    
        let tabbarViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
        self.present(tabbarViewController!, animated: false)
    }
    
    
    @IBAction func moveToSearch(_ sender: Any) {
        let tabbarViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController
        tabbarViewController?.selectedIndex = 2
        
        self.present(tabbarViewController!, animated: false)
        
    }
    
}

