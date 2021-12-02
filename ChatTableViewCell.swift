//
//  ChatTableViewCell.swift
//  Instant
//
//  Created by Suflea Marius.
//  Copyright © 2021 Marius Suflea. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellImageViewView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellLastMessageLbl: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
