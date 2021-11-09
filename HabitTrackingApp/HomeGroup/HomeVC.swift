//
//  HomeVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 01/11/2021.
//

import UIKit
import Alamofire
class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.getPlans,method: .post,parameters: ["id":"\(golbalUser.id ?? 0)"]) { (result:Result<PlanModel>) in
            DispatchQueue.main.async {
                [weak self] in
                ActivityController.init().dismissIndicator()
                guard let _ = self else {return}
                switch result{
                case .success(let user):
                    guard let plan = user.result?.first else{
                        return
                    }
                    currentPlan = plan
                case .failure(let er):
                    print(er)
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Home"
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.getPlans,method: .post,parameters: ["id":"\(golbalUser.id ?? 0)"]) { (result:Result<PlanModel>) in
            DispatchQueue.main.async {
                [weak self] in
                ActivityController.init().dismissIndicator()
                guard let _ = self else {return}
                switch result{
                case .success(let user):
                    guard let plan = user.result?.first else{
                        return
                    }
                    currentPlan = plan
                case .failure(let er):
                    print(er)
                }
            }
        }
    }
    
    
    @IBAction private func gotToTutorial(){
        
    }
    @IBAction private func gotToSetPlans(){
        let vc = SetPlansAndGoalsFirstVC(nibName: "SetPlansAndGoalsFirstVC", bundle: nil)
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func gotToTrack(){
        let vc = TrackVC(nibName: "TrackVC", bundle: nil)  //TrackCollectionVC()
        
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func gotToHabitLog(){
        let vc = HabitLogVC(nibName: "HabitLogVC", bundle:nil)
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
