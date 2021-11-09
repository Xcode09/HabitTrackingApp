//
//  TrackVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 01/11/2021.
//

import UIKit
import Alamofire
class TrackVC: UIViewController {
    
    @IBOutlet weak private var statsBtn:UIButton!{
        didSet{
            statsBtn.layer.cornerRadius = statsBtn.frame.height/2
        }
    }
    @IBOutlet weak private var logBtn:UIButton!{
        didSet{
            logBtn.layer.cornerRadius = logBtn.frame.height/2
        }
    }
    
    @IBOutlet weak private var trackNailBitingBtn:UIButton!
    @IBOutlet weak private var trackUsedToolsBtn:UIButton!
    private var tracks : TrackCounter?
    fileprivate func getTracks() {
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.getCounter,method: .post,parameters: ["id":"\(golbalUser.id ?? 0)","plan_id":currentPlan?.id ?? "0"]) { (result:Result<TrackCounter>) in
            DispatchQueue.main.async {
                [weak self] in
                ActivityController.init().dismissIndicator()
                switch result{
                case .success(let user):
                    self?.tracks = user
                    DispatchQueue.main.async {
                        self?.trackUsedToolsBtn.setTitle("\(user.tool_used_counter ?? 0)/\(user.pro_times ?? "0")", for: .normal)
                        self?.trackNailBitingBtn.setTitle("\(user.nail_bite_counter ?? 0)", for: .normal)
                    }
                case .failure(let er):
                    print(er)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard currentPlan != nil else {return}
        self.navigationItem.title = "Tap & Track"
        getTracks()
    }


    @IBAction private func gotStats(){
        let vc = StatsVC(nibName: "StatsVC", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func trackNailBitting(_ sender:UIButton){
        
        guard var counter = tracks?.nail_bite_counter, let r = tracks else {
            return
        }
        
        counter += 1
        
        self.trackNailBitingBtn.setTitle("\(counter)", for: .normal)
        
        let para : [String:Any] = ["id":golbalUser.id ?? 0,"plan_id":currentPlan?.id ?? "","nail_bite_counter":counter]
        
        //ActivityController.init().showIndicator()
        trackNailBitingBtn.isUserInteractionEnabled = false
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.updateTrack, method: .post, parameters: para) { (result:Result<SuccessModel>) in
            DispatchQueue.main.async {
                [weak self] in
                //ActivityController.init().dismissIndicator()
                switch result{
                case .success(let user):
                    self?.getTracks()
                    self?.trackNailBitingBtn.isUserInteractionEnabled = true
                case .failure(let er):
                    print(er)
                    self?.trackNailBitingBtn.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @IBAction private func trackUsedTools(_ sender:UIButton){
        guard var counter = tracks?.tool_used_counter, let r = tracks else {
            return
        }
        
        counter += 1
        
       
        self.trackUsedToolsBtn.setTitle("\(counter)/\(r.pro_times ?? "0")", for: .normal)
        let para : [String:Any] = ["id":golbalUser.id ?? 0,"plan_id":currentPlan?.id ?? "","tool_used_counter":counter]
        
        //ActivityController.init().showIndicator()
        trackUsedToolsBtn.isUserInteractionEnabled = false
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.updateTrack, method: .post, parameters: para) { (result:Result<SuccessModel>) in
            DispatchQueue.main.async {
                [weak self] in
                //ActivityController.init().dismissIndicator()
                switch result{
                case .success(let user):
                    self?.getTracks()
                    self?.trackUsedToolsBtn.isUserInteractionEnabled = true
                case .failure(let er):
                    print(er)
                    self?.trackUsedToolsBtn.isUserInteractionEnabled = true
                }
            }
        }
    }
    

}
