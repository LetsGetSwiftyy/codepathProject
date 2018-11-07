//
//  SongCell.swift
//  ♥Beats
//
//  Created by Marilyn Florek on 11/7/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
