//
//  SearchResultsTableViewCell.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell, Identifiable, View {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    
    static var identifier: String = "SearchResultsTableViewCell"
    
    var viewModel: SearchResultsCellViewModel? { didSet { updateView() } }
    
    private func updateView() {
        labelTitle.text = viewModel?.title
        labelReleaseDate.text = viewModel?.releaseDateStr
        labelReleaseDate.superview?.isVisible = viewModel?.releaseDateStr != nil
    }

}
