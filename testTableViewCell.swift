//
//  testTableViewCell.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit

class testTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
