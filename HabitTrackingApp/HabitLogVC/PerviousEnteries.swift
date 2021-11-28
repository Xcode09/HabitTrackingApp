//
//  PerviousEnteries.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 07/11/2021.
//

import UIKit
import Alamofire

struct model{
    let date:String
    let logs:[HabitLog]
    var isExpand:Bool
}
class PerviousEnteries: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    private var tableView:UITableView={
        let view = UITableView()
        view.backgroundColor = UIColor.bgColor
        view.register(UINib(nibName: "LogCell", bundle: nil), forCellReuseIdentifier: "LogCell")
        view.tableFooterView = UIView()
        return view
    }()
    private lazy var enteries = [model]()
    private var isOpened = false
    private var selectedSection = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 1
        self.navigationItem.title = "Previous Enteries"
        
        
        
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.habitLog,method: .post,parameters: ["id":"\(golbalUser.id ?? 0)"]){ (result:Result<HabitLogModel>) in
            DispatchQueue.main.async {
                [weak self] in
                
                switch result{
                case .success(let user):
                    guard let data = user.result else {return}
                     
                    
                    let r =  Dictionary.init(grouping: data) { (Habi) -> String in
                        return (Habi.created_at ?? "")
                    }
                    var enteris = [model]()
                    for (_ , index) in r.enumerated(){
                        let gg = model(date: index.key, logs: index.value, isExpand: false)
                        enteris.append(gg)
                    }
                    self?.enteries = enteris
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let er):
                    print(er)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return enteries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = enteries[section]
        if sec.isExpand{
            return sec.logs.count
        }else{
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        cell.activityL.text = enteries[indexPath.section].logs[indexPath.row].activity ?? ""
        cell.feelingsL.text = enteries[indexPath.section].logs[indexPath.row].feeling ?? ""
        cell.biteOrPickL.text = enteries[indexPath.section].logs[indexPath.row].bite ?? ""
        cell.urgusizeL.text = enteries[indexPath.section].logs[indexPath.row].urge ?? ""
        cell.usedToolsL.text = enteries[indexPath.section].logs[indexPath.row].tool_used ?? ""
        cell.otherThingsL.text = enteries[indexPath.section].logs[indexPath.row].other_things ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Date:\(enteries[section].date.formatIntoDate())\nTime:\(enteries[section].date.formatIntoTime())"
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.tag = section
        button.addTarget(self, action: #selector(expandCells), for: .touchUpInside)
        let stack = UIStackView(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: 80))
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        //stack.frame = view.bounds
        view.addSubview(stack)
        
        return view
    }
    
    
    @objc private func expandCells(button:UIButton){
        print("expanding cells")
        print(button.tag)
        enteries[button.tag].isExpand = !enteries[button.tag].isExpand
        tableView.reloadSections([button.tag], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }


}
