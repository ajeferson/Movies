//
//  SearchResultsTableViewCell.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var labelTitle: UILabel!
    
    static var identifier: String = "SearchResultsTableViewCell"
    
    var viewModel: SearchResultsCellViewModel? { didSet { updateView() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func updateView() {
        labelTitle.text = viewModel?.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
