//
//  LocationInfoTableViewCell.swift
//  WhereAmI
//
//  Created by Sandeep Palepu on 12/2/15.
//  Copyright © 2015 Sandeep Palepu. All rights reserved.
//

import UIKit

class LocationInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
