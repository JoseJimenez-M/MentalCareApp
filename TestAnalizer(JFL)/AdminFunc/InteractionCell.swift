//
//  InteractionCell.swift
//  TestAnalizer(JFL)
//
//  Created by Marlot Leonardo Hernandez Felix on 06/04/25.
//

import UIKit

class InteractionCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
      @IBOutlet weak var sentimentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
