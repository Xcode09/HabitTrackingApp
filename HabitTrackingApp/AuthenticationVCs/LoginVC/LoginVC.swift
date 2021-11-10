//
//  LoginVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 30/10/2021.
//

import UIKit
import FacebookLogin
import Alamofire
class LoginVC: BaseController {
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
    @IBOutlet weak private var fbBtn:UIButton!
    @IBOutlet weak private var signUpbtn:UILabel!{
        didSet{
            signUpbtn.isUserInteractionEnabled = true
            signUpbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoSignUp)))
        }
    }
    //@IBOutlet weak private var emailField:UITextField!
    private var manager : LoginManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = LoginManager()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    @objc private func gotoSignUp(){
        let vc = SignUpVC(nibName: "SignUpVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func fbLogin(){
        manager.logIn(permissions: ["public_profile", "email"], from: self) { (login, error) in
            if error != nil{
                
            }else{
                self.fetchUserProfile(token: login?.authenticationToken?.tokenString ?? "")
            }
        }
    }
    
    @IBAction private func loginTapped(_ sender:UIButton){
        guard let text = emailField.text,
              text != "",
              let pass = passField.text,
              pass != ""
        else{
            self.showAlert(title: "Error", message: "Kindly fill all fields", action: nil)
            return
            
        }
        ActivityController.init().showIndicator()
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.login,method: .post,parameters: ["email":text,"password":pass]) { (result:Result<UserModel>) in
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else {return}
                ActivityController.init().dismissIndicator()
                switch result{
                case .success(let user):
                    guard let use = user.result?.first else {return}
                    UserState.saveUserLogin(user:use)
                    NotificationCenter.default.post(name: .update, object: self)
                case .failure(let er):
                    self.showAlert(title: "Error", message: er.localizedDescription, action: nil)
                }
            }
        }
    }
    
    func fetchUserProfile(token:String)
    {
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        
        graphRequest.start { (connection, result, error) in
            
            if ((error) != nil)
            {
                print("Error took place: \(error)")
            }
            else
            {
                print("Print entire fetched result: \(result)")
                if let dic = result as? [String:Any]{
                    let login = ["email":dic["email"] as! String,"password":dic["id"] as! String]
                    let signup = ["name":dic["name"] as! String,"email":dic["email"] as! String,"password":dic["id"] as! String]
                    self.authenticationWithFb(logindic: login, signInDic: signup)
                }
                
            }
        }
    }
    
    private func authenticationWithFb(logindic:[String:Any],signInDic:[String:Any]){
        ActivityController.init().showIndicator()
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.login,method: .post,parameters:logindic) { (result:Result<UserModel>) in
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else {return}
                ActivityController.init().dismissIndicator()
                switch result{
                case .success(let user):
                    guard let use = user.result?.first else {return}
                    UserState.saveUserLogin(user:use)
                    NotificationCenter.default.post(name: .update, object: self)
                case .failure(let er):
                    self.signUpCall(loginindic: logindic, dic: signInDic)
                }
            }
        }
    }
    private func signUpCall(loginindic:[String:Any],dic:[String:Any]){
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.signup, method: .post, parameters: dic) { (result:Result<SuccessModel>) in
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else {return}
                ActivityController.init().dismissIndicator()
                switch result{
                case .success:
                    Networking.shareInstance.callNetwork(uri: ApiEndPoints.login,method: .post,parameters:loginindic) { (result:Result<UserModel>) in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let self = self else {return}
                            switch result{
                            case .success(let user):
                                guard let use = user.result?.first else {return}
                                UserState.saveUserLogin(user:use)
                                NotificationCenter.default.post(name: .update, object: self)
                            case .failure(let er):
                                self.showAlert(title: "Error", message: er.localizedDescription, action: nil)
                            }
                        }
                    }
                case .failure(let er):
                    self.showAlert(title: "Error", message: er.localizedDescription, action: nil)
                }
            }
        }
    }
    
}
@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
