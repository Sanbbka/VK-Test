//
//  VKPostStateViewCell.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 15.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

class VKPostStateViewCell: BaseCell {

    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
