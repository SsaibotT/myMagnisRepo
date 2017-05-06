//
//  TableViewCell.swift
//  Magnis
//
//  Created by Serhii on 06.05.17.
//  Copyright © 2017 Serhii. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var OpenLabel: UILabel!
    @IBOutlet weak var HighLabel: UILabel!
    @IBOutlet weak var LowLabel: UILabel!
    @IBOutlet weak var CloseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
