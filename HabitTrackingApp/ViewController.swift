//
//  ViewController.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 30/10/2021.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showAlert(title:String="",message:String="",action: ((Bool)->Void)?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

}

