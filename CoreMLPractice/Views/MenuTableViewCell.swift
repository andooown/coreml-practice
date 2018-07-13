//
//  MenuTableViewCell.swift
//  CoreMLPractice
//
//  Created by Yoshikazu Ando on 2018/07/13.
//  Copyright © 2018年 Yoshikazu Ando. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setMenu(_ menu: MenuEntity) {
        self.label.text = menu.title
    }

}
