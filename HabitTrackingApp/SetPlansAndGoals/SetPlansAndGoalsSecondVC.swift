//
//  SetPlansAndGoalsSecondVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 31/10/2021.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialChips
class SetPlansAndGoalsSecondVC: UIViewController {
    private var ques3Arr = ["Bulid Awareness","Make it harder","Keeps hands busy"]
    private var eventLap = ["Morning","Afternoon","Evening","Night"]
    private var times = ["1","2","3","4","5"]
    var pro : [String] = [String]()
    private var focusOnthisweek : String = "" {
        didSet{
            dropDow3.text = focusOnthisweek
        }
    }
    var parameters : [String:Any]?
    @IBOutlet weak private var ques3View:UICollectionView!{
        didSet{
            
            ques3View.tag = 3
            ques3View.dataSource = self
            ques3View.delegate = self
        }
    }
    
    @IBOutlet weak private var dropDow1:UITextField!{
        didSet{
            let picker = UIPickerView()
            picker.tag = 1
            picker.delegate = self
            picker.dataSource = self
            dropDow1.inputView = picker
        }
    }
    @IBOutlet weak private var dropDow2:UITextField!{
        didSet{
            let picker = UIPickerView()
            picker.tag = 2
            picker.delegate = self
            picker.dataSource = self
            dropDow2.inputView = picker
        }
    }
    @IBOutlet weak private var dropDow3:UITextField!
//    {
////        didSet{
////            let picker = UIPickerView()
////            picker.tag = 3
////            picker.delegate = self
////            picker.dataSource = self
////            dropDow1.inputView = picker
////        }
//    }
    @IBOutlet weak private var dropDow4:UITextField!{
        didSet{
            let picker = UIPickerView()
            picker.tag = 4
            picker.delegate = self
            picker.dataSource = self
            dropDow4.inputView = picker
        }
    }
    
    @IBOutlet weak private var submitBtn:UIButton!{
        didSet{
            submitBtn.layer.cornerRadius = submitBtn.frame.height/2
        }
    }
    
//    @IBOutlet weak private var ques2View:TagListView!{
//        didSet{
//            ques2View.cornerRadius = 18
//            ques2View.tagBackgroundColor = .systemOrange
//            ques2View.addTags(["P_Ring","S_Ring","Oil","File","Sleeve"])
//            
//            ques2View.textFont = UIFont.systemFont(ofSize: 18)
//            ques2View.alignment = .center // possible values are [.leading, .trailing, .left, .center, .right]
//            ques2View.delegate = self
//        }
//    }
//    
//    @IBOutlet weak private var ques3View:TagListView!{
//        didSet{
//            ques3View.cornerRadius = 18
//            ques3View.tagBackgroundColor = .systemOrange
//            ques3View.addTags(["Bulid Awareness","Make it harder","Keeps hands busy"])
//            
//            ques3View.textFont = UIFont.systemFont(ofSize: 18)
//            ques3View.alignment = .center // possible values are [.leading, .trailing, .left, .center, .right]
//            ques3View.delegate = self
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ques3View.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
    }
    
    @IBAction private func submitBtn(_ sender:UIButton)
    {
        guard focusOnthisweek != "", dropDow1.text != "",
              dropDow2.text != "",dropDow3.text != "",
              dropDow4.text != ""
        else {return}
        
        parameters?.updateValue(dropDow1.text ?? "" , forKey:"try_product")
        parameters?.updateValue(dropDow2.text ?? "", forKey: "p_total_times")
        parameters?.updateValue(dropDow3.text ?? "", forKey: "p_location")
        parameters?.updateValue(dropDow4.text ?? "", forKey:  "event_time")
        parameters?.updateValue("", forKey:"reminder_time")
        parameters?.updateValue("", forKey:"reminder_detail")
        
        guard let para = parameters else {
            return
        }
        
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.addPlan, method: .post, parameters: para) { (result:Result<SuccessModel>) in
            DispatchQueue.main.async {
                [weak self] in
                switch result{
                case .success(let user):
                    print("Successlffff",user)
                case .failure(let er):
                    print(er)
                }
            }
        }
    }

}


extension SetPlansAndGoalsSecondVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return pro.count
        case 2:
            return times.count
        case 4:
            return eventLap.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return pro[row]
        case 2:
            return times[row]
        case 4:
            return eventLap[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            dropDow1.text =  pro[row]
            pickerView.resignFirstResponder()
        case 2:
            dropDow2.text = times[row]
            pickerView.resignFirstResponder()
        case 4:
            dropDow4.text = eventLap[row]
            pickerView.resignFirstResponder()
        default:
            break
        }
    }
    
    
}


extension SetPlansAndGoalsSecondVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ques3Arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! MDCChipCollectionViewCell
          //cell.backgroundColor = UIColor.labelColor
          let chipView = cell.chipView
          // configure the chipView to be a choice chip
        chipView.setBackgroundColor(UIColor.labelColor, for: .normal)
        
        //chipView.backgroundColor = UIColor.labelColor
        chipView.titleFont = UIFont.systemFont(ofSize: 15)
        chipView.titleLabel.numberOfLines = 1
        chipView.titleLabel.minimumScaleFactor = 0.6
        chipView.titleLabel.text = ques3Arr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 3:
            focusOnthisweek = ques3Arr[indexPath.item]
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 36)
    }
}
