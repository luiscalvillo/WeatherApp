//
//  SettingsCell.swift
//  WeatherApp
//
//  Created by Luis Calvillo on 6/6/17.
//  Copyright © 2017 Luis Calvillo. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.currentLocationSwitch.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func currentLocationSwitchPressed(_ sender: Any) {
      
        if currentLocationSwitch.isOn == true {
            print("button is now on")
            
            
        } else {
            print("button is now off")
        }
    }
    
    

}























