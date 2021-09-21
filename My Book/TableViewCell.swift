//
//  TableViewCell.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/30/1400 AP.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleDataLabel: UILabel!
    @IBOutlet weak var PageCountDataLabel: UILabel!
    @IBOutlet weak var ratingCountDataLabel: UILabel!
    @IBOutlet weak var avarageRatingDataLabel: UILabel!
    
    @IBOutlet weak var pageCountStackView: UIStackView!
    @IBOutlet weak var ratingCountStackView: UIStackView!
    @IBOutlet weak var avarageRatingStackView: UIStackView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookImage.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
