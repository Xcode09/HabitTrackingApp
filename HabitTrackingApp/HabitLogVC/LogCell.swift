//
//  LogCell.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 07/11/2021.
//

import UIKit

class LogCell: UITableViewCell {
    @IBOutlet weak var activityL:UILabel!
    @IBOutlet weak var feelingsL:UILabel!
    @IBOutlet weak var biteOrPickL:UILabel!
    @IBOutlet weak var urgusizeL:UILabel!
    @IBOutlet weak var usedToolsL:UILabel!
    @IBOutlet weak var otherThingsL:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
