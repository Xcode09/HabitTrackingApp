//
//  HabitLogVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 01/11/2021.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialChips
class HabitLogVC: BaseController {
    private var ques1Arr = ["Anxious","Stressed","Bored"]
    private var ques2Arr = ["Yes","No"]
    private var ques3Arr = ["Yes","No"]
    private var urgeValues : Float = 0.0
    private var activity = "UnKnown"
    private var feeling = "UnKnown"
    private var biteOr = "UnKnown"
    private var usedTool = "UnKnown"
    @IBOutlet weak private var otherThingsView:UITextField!
    
    @IBOutlet weak private var activityField:UITextField!
    @IBOutlet weak private var chipCV1:UICollectionView!
    @IBOutlet weak private var urge:UISlider!
    @IBOutlet weak private var ques2View:UICollectionView!{
        didSet{
            
            ques2View.tag = 2
            ques2View.dataSource = self
            ques2View.delegate = self
        }
    }
    
    @IBOutlet weak private var ques3View:UICollectionView!{
        didSet{
            
            ques3View.tag = 3
            ques3View.dataSource = self
            ques3View.delegate = self
        }
    }
    
    @IBOutlet weak private var submitBtn:UIButton!{
        didSet{
            submitBtn.layer.cornerRadius = submitBtn.frame.height/2
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.bgColor
        let layout = MDCChipCollectionViewFlowLayout()
        
        chipCV1.collectionViewLayout = layout
        
        chipCV1.delegate = self
        chipCV1.dataSource = self
        chipCV1.tag = 1
        chipCV1.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        
        ques2View.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        //ques2View.allowsMultipleSelection = true
        ques3View.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setTitle("P", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(goToPervious), for: .touchUpInside)
        button.backgroundColor = UIColor.labelColor
        button.layer.cornerRadius = button.frame.width/2
        
        let perVi = UIBarButtonItem(title: "Pervious", style: .plain, target: self, action: #selector(goToPervious))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Habit Log"
    }
    @objc private func goToPervious(){
        let vc = PerviousEnteries()
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func urgeValue(_ sender:UISlider)
    {
        urgeValues = sender.value
    }
    @IBAction private func submitBtn(_ sender:UIButton)
    {
        guard activityField.text != "",
              feeling != "",
              biteOr != "",
              urgeValues != 0.0
        else{
            self.showAlert(title: "Error", message: "Kindly select all fields", action: nil)
            return
        }
              
        
        let para : [String:Any] = ["id":"\(golbalUser.id ?? 0)",
        "tool_used":usedTool,
        "other_things":otherThingsView.hasText == true ? otherThingsView.text ?? "" : "",
        "urge":urgeSize(value: urge.value),
        "bite":biteOr,
        "feeling":feeling,
        "activity":activityField.text ?? ""
        ]
        
        ActivityController.init().showIndicator()
        
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.addLog, method: .post, parameters: para) { (result:Result<SuccessModel>) in
            DispatchQueue.main.async {
                [weak self] in
                ActivityController.init().dismissIndicator()
                switch result{
                case .success:
                    self?.showAlert(title: "Success", message: "Successfully Added", action: nil)
                    break
                case .failure(let er):
                    self?.showAlert(title: "Error", message: er.localizedDescription, action: nil)
                }
            }
        }
        
    }
    
    private func urgeSize(value:Float)->String{
        switch value {
        case 1.0..<4.9:
            return "Small"
        case 4.9..<5.9:
            return "Medium"
        default:
            return "Large"
        }
    }
}

extension HabitLogVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return ques1Arr.count
        }else  if collectionView.tag == 2 {
            return ques2Arr.count
        }else{
            return ques3Arr.count
        }
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
        if collectionView.tag == 1{
            chipView.titleLabel.text = ques1Arr[indexPath.item]
        }else if collectionView.tag == 2
        {
            chipView.titleLabel.text = ques2Arr[indexPath.item]
        }else{
            chipView.titleLabel.text = ques3Arr[indexPath.item]
        }
         
         chipView.invalidateIntrinsicContentSize()
          return cell

    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        switch collectionView.tag {
//        case 1:
//            if ques1Ans.contains(ques1Arr[indexPath.item]){
//                _ = ques1Ans.popLast()
//            }
//        case 2:
//            guard !ques2Ans.isEmpty else {return}
//            if ques2Ans.contains(ques2Arr[indexPath.item]) && ques2Ans.count == 1 {
//                ques2Ans.removeAll()
//            }else{
//                ques2Ans.remove(at: indexPath.item)
//            }
//        case 3:
//            if ques3Ans.contains(ques3Arr[indexPath.item]){
//                _ = ques3Ans.popLast()
//            }
//        default:
//            break
//        }
//    }
//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            feeling = ques1Arr[indexPath.item]
        case 2:
            biteOr = ques2Arr[indexPath.item]
            break
        case 3:
            usedTool = ques3Arr[indexPath.item]
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 36)
    }
    
}

