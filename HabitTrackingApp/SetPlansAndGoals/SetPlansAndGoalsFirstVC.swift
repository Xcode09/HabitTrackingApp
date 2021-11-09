//
//  SetPlansAndGoalsFirstVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 31/10/2021.
//

import UIKit
import TagListView
import MaterialComponents.MaterialChips
class SetPlansAndGoalsFirstVC: UIViewController {
    private var ques1Arr = ["Awareness","Substituting","Evaluating"]
    private var ques2Arr = ["P_Ring","S_Ring","Oil","File","Sleeve"]
    private var ques3Arr = ["Bulid Awareness","Make it harder","Keeps hands busy"]
    private var ques1Ans = [String]()
    private var ques2Ans = [String]()
    private var ques3Ans = [String]()
    
    
    @IBOutlet weak private var chipCV1:UICollectionView!
    
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
    
    @IBOutlet weak private var nextBtn:UIButton!{
        didSet{
            nextBtn.layer.cornerRadius = nextBtn.frame.height/2
        }
    }
    var titele = ""
    
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7)))
            item.contentInsets.trailing = 16
            item.contentInsets.bottom = 16
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            //section.contentInsets.leading = 16
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
      
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Bulid your weekly plan"
        // Do any additional setup after loading the view.
//        for i in 0..<ques1Arr.count{
//            ques1View.tagViews[i].tag = i
//        }
        
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
        ques2View.allowsMultipleSelection = true
        ques3View.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        
    }
    @IBAction private func gotoNextVC(){
        let vc = SetPlansAndGoalsSecondVC(nibName: "SetPlansAndGoalsSecondVC", bundle: nil)
        
        guard !ques1Ans.isEmpty,!ques3Ans.isEmpty,!ques2Ans.isEmpty else {return}
        vc.pro = ques2Ans
        if ques2Ans.count == 2{
            vc.parameters = ["id":"\(golbalUser.id ?? 0)","focus":ques1Ans[0],"product_1":ques2Ans[0],"product_2":ques2Ans[1],"help_me":ques3Ans[0]]
        }else{
            let sr = ques2Ans.joined()
            vc.parameters = ["id":"\(golbalUser.id ?? 0)","focus":ques1Ans[0],"product_1":sr,"help_me":ques3Ans[0]]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SetPlansAndGoalsFirstVC:TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
//        switch sender.tag {
//        case 1:
//            // break
//          
//        
//        default:
//            break
//        }
       
        print(tagView.tag)
        tagView.highlightedBackgroundColor = .red
        
//        switch sender.tag {
//        case 1:
//
//
//
//        default:
//            break
//        }
        
    }
}

extension SetPlansAndGoalsFirstVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            if ques1Ans.contains(ques1Arr[indexPath.item]){
                _ = ques1Ans.popLast()
            }
        case 2:
            guard !ques2Ans.isEmpty else {return}
            if ques2Ans.contains(ques2Arr[indexPath.item]) && ques2Ans.count == 1 {
                ques2Ans.removeAll()
            }else{
                ques2Ans.remove(at: indexPath.item)
            }
        case 3:
            if ques3Ans.contains(ques3Arr[indexPath.item]){
                _ = ques3Ans.popLast()
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            if ques1Ans.count <= 1{
                ques1Ans.append(ques1Arr[indexPath.item])
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        case 2:
            if ques2Ans.count < 2{
                ques2Ans.append(ques2Arr[indexPath.item])
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                
            }
            break
        case 3:
            if ques3Ans.count <= 1{
                ques3Ans.append(ques3Arr[indexPath.item])
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 36)
    }
    
}
