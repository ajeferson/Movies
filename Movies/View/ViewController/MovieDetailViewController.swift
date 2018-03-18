//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailViewController: UITableViewController, Identifiable {
    
    static var identifier: String = "MovieDetailViewController"
    
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    
    var viewModel: MovieDetailViewModel!
    
    let disposeBag = DisposeBag()
    
    // View creates View
    static func newInstance(viewModel: MovieDetailViewModel) -> MovieDetailViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateView()
        bindImages()
        viewModel.fetchImages()
    }
    
    private func bindImages() {
        
        viewModel
            .backdrop
            .asObservable()
            .bind(to: imageViewBackdrop.rx.image)
            .disposed(by: disposeBag)
        
        viewModel
            .poster
            .asObservable()
            .bind(to: imageViewPoster.rx.image)
            .disposed(by: disposeBag)
        
    }
    
    private func updateView() {
        labelTitle.text = viewModel.title
        labelReleaseDate.text = viewModel.releaseDateStr
        labelOverview.text = viewModel.overview
        labelGenres.text = viewModel.genresString
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            headerTopConstraint.constant = scrollView.contentOffset.y
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
