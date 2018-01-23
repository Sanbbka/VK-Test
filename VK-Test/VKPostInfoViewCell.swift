//
//  VKPostInfoViewCell.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 15.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

class VKPostInfoViewCell: BaseCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatar.roundCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
