//
//  Constants.swift
//  Car Pool
//
//  Created by Muhammad Ali on 22/10/2021.
//

import UIKit

var golbalUser : User!
var currentPlan:Plan?
struct ApiEndPoints{
    private let baseURL = "http://codexit.xyz/api/" //"http://api.bilkoll.com/api/"
    static let signup = "\(ApiEndPoints().baseURL)signup"
    static let login = "\(ApiEndPoints().baseURL)login"
    static let habitLog = "\(ApiEndPoints().baseURL)habit_log"
    static let addLog = "\(ApiEndPoints().baseURL)addlog"
    static let addPlan = "\(ApiEndPoints().baseURL)addPlan"
    static let getPlans = "\(ApiEndPoints().baseURL)getPlans"
    static let getTracks = "\(ApiEndPoints().baseURL)getTracks"
    
    static let getCounter = "\(ApiEndPoints().baseURL)getcounter"
    static let updateTrack = "\(ApiEndPoints().baseURL)updateTrack"
    
    static let addTrack = "\(ApiEndPoints().baseURL)addTrack"
    static let planstatus = "\(ApiEndPoints().baseURL)planstatus"
    static let fetchCarUsedByUser = "\(ApiEndPoints().baseURL)get_my_plan_Tracks"
    static let leaveCarUsedByUser = "\(ApiEndPoints().baseURL)updateTrack"
}

extension UIColor{
    static let bgColor = UIColor(named: "BG")
    static let labelColor = UIColor(named: "LabelColor")
    static let s2 = UIColor(named: "S2")
    static let s3 = UIColor(named: "S3")
    static let s4 = UIColor(named: "S4")
}

extension String{
    func formatIntoDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self){
            let secondFormatter = DateFormatter()
            secondFormatter.dateStyle = .medium
            return secondFormatter.string(from: date)
        }else{
            return ""
        }
    }
}

extension Notification.Name{
    static let update = Notification.Name(rawValue: "update")
}
@IBDesignable
class DesignableTextField: UITextField {

//    //Delegate when image/icon is tapped.
//    private var myDelegate: DesignableTextFieldDelegate? {
//        get { return delegate as? DesignableTextFieldDelegate }
//    }

//    @objc func buttonClicked(btn: UIButton){
//        self.myDelegate?.textFieldIconClicked(btn: btn)
//    }

    //Padding images on left
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += padding
        return textRect
    }

    //Padding images on Right
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= padding
        return textRect
    }

    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var leadingImage: UIImage? { didSet { updateView() }}
    @IBInspectable var color: UIColor = UIColor.lightGray { didSet { updateView() }}
    @IBInspectable var imageColor: UIColor = UIColor.systemBlue { didSet { updateView() }}
    @IBInspectable var rtl: Bool = false { didSet { updateView() }}

    func updateView() {
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        leftViewMode = UITextField.ViewMode.never
        leftView = nil

        if let image = leadingImage {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
            button.tintColor = imageColor

            button.setTitleColor(UIColor.clear, for: .normal)
//            button.addTarget(self, action: #selector(buttonClicked(btn:)), for: UIControlEvents.touchDown)
//            button.isUserInteractionEnabled = true

            if rtl {
                rightViewMode = UITextField.ViewMode.always
                rightView = button
            } else {
                leftViewMode = UITextField.ViewMode.always
                leftView = button
            }
        }

        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
