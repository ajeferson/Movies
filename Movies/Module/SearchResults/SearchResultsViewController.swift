//
//  ResultsViewController.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultsViewController: UIViewController, Identifiable, View, UISearchResultsUpdating {
    
    static var identifier: String = "SearchResultsViewController"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var emptyLabel: UILabel!
    
    let searchDebounceInterval = 0.3
    let searchMinCharacters = 3
    let bottomOffset = 5
    
    var viewModel: SearchResultsViewModel!
    
    let disposeBag = DisposeBag()
    
    var subscribedToSearchBar = false
    
    
    weak var delegate: SearchResultsDelegate?
    
    //MARK:- Static
    
    static func newInstance(viewModel: SearchResultsViewModel, delegate: SearchResultsDelegate) -> SearchResultsViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: SearchResultsViewController.identifier) as! SearchResultsViewController
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        return viewController
    }
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView() {
        tableView.delegate = self
        addEmptyResultsLabel()
        tableView.tableFooterView = UIView()
        activityIndicator.startAnimating()
    }
    
    func initViewModel() {
        subscribeToIsLoading()
        bindToEmptyResults()
        bindToTableView()
    }
    
    private func addEmptyResultsLabel() {
        
        emptyLabel = UILabel(frame: CGRect.zero)
        emptyLabel.text = "Nenhum resultado"
        emptyLabel.sizeToFit()
        emptyLabel.font = UIFont.appFont(withStyle: .medium)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(emptyLabel)
        
        emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 40).isActive = true
        
    }
    
    
    //MARK:- SearchController
    
    func updateSearchResults(for searchController: UISearchController) {
        // Subscribes only once
        guard !subscribedToSearchBar else { return }
        subscribedToSearchBar = true
        subscribeEventsOf(searchBar: searchController.searchBar)
    }
    
}


//MARK:- ViewModel Subscriptions
extension SearchResultsViewController {
    
    private func subscribeToIsLoading() {
        viewModel
            .isLoading
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                self?.activityIndicator.isVisible = isLoading ?? false
                self?.tableView.isHidden = isLoading ?? true
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
    
    private func bindToEmptyResults() {
        viewModel
            .emptyResults
            .asObservable()
            .map { !$0 }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindToTableView() {
        
        viewModel
            .viewModelCells
            .asObservable()
            .bind(to: tableView
                .rx
                .items(cellIdentifier: SearchResultsTableViewCell.identifier,
                       cellType: SearchResultsTableViewCell.self)) {
                        row, cellViewModel, cell in
                        cell.viewModel = cellViewModel
            }
            .disposed(by: disposeBag)
        
    }
    
    private func subscribeEventsOf(searchBar: UISearchBar) {
        
        let searchBarText = searchBar
            .rx
            .text
            .orEmpty
        
        searchBarText
            .filter { [mc = searchMinCharacters] in $0.count >= mc }
            .debounce(searchDebounceInterval, scheduler: Schedulers.main as! SchedulerType)
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.search(query: query, fromFirstPage: true)
            })
            .disposed(by: disposeBag)
        
        searchBarText
            .filter { $0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.clearSearch()
            })
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.clearSearch()
            })
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.clearSearch()
            })
            .disposed(by: disposeBag)
        
    }
    
}


//MARK:- TableView
extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.movie(at: indexPath.row)
        delegate?.showDetailsOf(movie: movie)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.resultsCount - bottomOffset && !viewModel.isSearching  && !viewModel.isDone {
            viewModel.search(fromFirstPage: false)
        }
    }
    
}
