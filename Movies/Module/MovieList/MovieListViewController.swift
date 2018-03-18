//
//  MovieListViewController.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController, Identifiable, View {
    
    static var identifier: String = "MovieListViewController"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // How many cells from the bottom to fetch more
    let bottomOffset = 6
    
    let disposeBag = DisposeBag()
    var viewModel: MovieListViewModel!
    
    
    static func newInstance(viewModel: MovieListViewModel) -> MovieListViewController {
        let instance = storyboard.instantiateViewController(withIdentifier: MovieListViewController.identifier) as! MovieListViewController
        instance.viewModel = viewModel
        return instance
    }
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func initView() {
        
        collectionView.delegate = self
        activityIndicator.startAnimating()
        
        setupSearchController()
        
    }
    
    func initViewModel() {
        subscribeToIsLoading()
        subscribeToError()
        bindViewModelCellsToCollectionView()
        subscribeToCollectionViewWillEvents()
        viewModel.fetchMovies()
    }
    
    
    //MARK:- Rx hooks
    
    private func loadingStateChange(to isLoading: Bool) {
        activityIndicator.isVisible = isLoading
        collectionView.isHidden = isLoading
    }
    
    private func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == viewModel.moviesCount - bottomOffset && !viewModel.isFetchingMovies && !viewModel.isDone {
            viewModel.fetchMovies()
        }
    }
    
    private func present(detailsViewModel: MovieDetailViewModel) {
        let viewController = MovieDetailViewController.newInstance(viewModel: detailsViewModel) // View creates View
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupSearchController() {
        
        let searchResultsViewModel = viewModel.getSearchResultsViewModel()
        let searchResults = SearchResultsViewController.newInstance(viewModel: searchResultsViewModel, delegate: self)
        
        // Setup search controller
        let searchController = UISearchController(searchResultsController: searchResults)
        searchController.searchResultsUpdater = searchResults
        searchController.searchBar.barStyle = .black
        
        let button = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        button.tintColor = UIColor.white
        
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
}


//MARK:- CollectionView Layout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    var spacing: CGFloat { return 10 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 140
        let ratio: CGFloat = 1.7
        return CGSize(width: width, height: width * ratio) // Looks good in portrait and landscape
    }
    
}



//MARK:- ViewModel Subscriptions
extension MovieListViewController {
    
    private func subscribeToIsLoading() {
        viewModel
            .isLoading
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                self?.loadingStateChange(to: isLoading)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeToError() {
        viewModel
            .error
            .asObservable()
            .subscribe(onNext: { [weak self] error in
                guard let error = error else { return }
                self?.presentErrorAlert(withError: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelCellsToCollectionView() {
        viewModel
            .viewModelCells
            .asObservable()
            .bind(to: collectionView
                .rx
                .items(cellIdentifier: MovieListCollectionViewCell.identifier,
                       cellType: MovieListCollectionViewCell.self)) {
                        row, cellViewModel, cell in
                        cellViewModel.fetchImage()
                        cell.viewModel = cellViewModel
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeToCollectionViewWillEvents() {
        collectionView
            .rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] cellInfo in
                let (_, indexPath) = cellInfo
                self?.willDisplayCell(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
}


//MARK:- CollectionView Delegate
extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewModel = viewModel.getMovieDetailViewModel(at: indexPath.row)
        present(detailsViewModel: detailsViewModel)
    }
    
}


//MARK:- SearchResultsDelegate
extension MovieListViewController: SearchResultsDelegate {
    
    func showDetailsOf(movie: Movie) {
        let detailsViewModel = viewModel.getMoviewDetailViewModel(for: movie)
        present(detailsViewModel: detailsViewModel)
    }
    
}
