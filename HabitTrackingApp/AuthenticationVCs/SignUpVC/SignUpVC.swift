//
//  SignUpVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 01/11/2021.
//

import UIKit
import Alamofire
class SignUpVC: BaseController {
    @IBOutlet weak private var nameField:UITextField!{
        didSet{
            nameField.layer.borderWidth = 0.5
            nameField.layer.borderColor = UIColor.lightGray.cgColor
            nameField.layer.cornerRadius = emailField.frame.height/2
        }
    }
    @IBOutlet weak private var emailField:UITextField!{
        didSet{
            emailField.layer.borderWidth = 0.5
            emailField.layer.borderColor = UIColor.lightGray.cgColor
            emailField.layer.cornerRadius = emailField.frame.height/2
        }
    }
    @IBOutlet weak private var passField:UITextField!{
        didSet{
            passField.layer.borderWidth = 0.5
            passField.layer.borderColor = UIColor.lightGray.cgColor
            passField.layer.cornerRadius = passField.frame.height/2
        }
    }
    @IBOutlet weak private var signInBtn:UIButton!{
        didSet{
            signInBtn.layer.cornerRadius = signInBtn.frame.height/2
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func signTapped(_ sender:UIButton)
    {
        guard let text = emailField.text,
              text != "",
              let name = nameField.text,
              name != "",
              let pass = passField.text,
              pass != ""
        else{ return }
        ActivityController.init().showIndicator()
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.signup, method: .post, parameters: ["name":name,"email":text,"password":pass]) { (result:Result<SuccessModel>) in
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else {return}
                ActivityController.init().dismissIndicator()
                switch result{
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .failure(let er):
                    self.showAlert(title: "Error", message: er.localizedDescription, action: nil)
                }
            }
        }
    }

}
