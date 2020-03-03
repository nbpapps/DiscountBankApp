//
//  IntradayViewController.swift
//  DiscontBankApp
//
//  Created by niv ben-porath on 27/01/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import UIKit

final class IntradayViewController: UIViewController {
    
    let bankViewModel : BankViewModel
    
    let timeSeriesDataSource = TimeSeriesDataSource()
    
    private lazy var timeSeriesTableView  = makeTimeSeriesTableView()
    private lazy var timeIntervalSelectionSegmentControl = makeSegmentControl()
    
    let loadingViewController = LoadingViewController()
    let timeIntervals : TimeIntervals
    
    //MARK: - life cycle
    
    init(bankViewModel : BankViewModel,timeIntervals : TimeIntervals) {
        self.bankViewModel = bankViewModel
        self.timeIntervals = timeIntervals
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Strings.noStoryboardImplementation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        configureTimeIntervalSegments()
        layoutView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getIntradayData(for: bankViewModel.bankStk, and: timeIntervals.getDefualtInterval())
    }
    
    //MARK: - factory
    private func makeTimeSeriesTableView() -> UITableView {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        return tableView
    }
    
    private func makeSegmentControl() -> UISegmentedControl {
        let allTimeIntevals = timeIntervals.getAllIntervalOptions()
        let segCont = DBASegmentControl(items: allTimeIntevals)
        return segCont
    }
    
    //MARK: - layout
    
    func layoutView() {
        NSLayoutConstraint.activate([
            
            timeIntervalSelectionSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UISegmentedControl.padding),
            timeIntervalSelectionSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UISegmentedControl.padding),
            timeIntervalSelectionSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UISegmentedControl.padding),
            timeIntervalSelectionSegmentControl.heightAnchor.constraint(equalToConstant: 44.0),
            
            timeSeriesTableView.topAnchor.constraint(equalTo: timeIntervalSelectionSegmentControl.bottomAnchor, constant: UITableView.tableViewPadding),
            timeSeriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UITableView.tableViewPadding),
            timeSeriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UITableView.tableViewPadding),
            timeSeriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UITableView.tableViewPadding)
            
        ])
    }
    
    //MARK:- configure
    func configureView() {
        title = bankViewModel.bankName
        view.backgroundColor = .systemBackground
    }
    
    func configureTableView() {
        timeSeriesTableView.backgroundColor = .systemBackground
        timeSeriesTableView.register(IntradayTableViewCell.self, forCellReuseIdentifier: IntradayTableViewCell.reuseId)
        timeSeriesTableView.dataSource = timeSeriesDataSource
        
        timeSeriesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeSeriesTableView)
    }
    
    
    func configureTimeIntervalSegments() {
        let allTimeIntevals = timeIntervals.getAllIntervalOptions()
        timeIntervalSelectionSegmentControl = DBASegmentControl(items: allTimeIntevals)
        timeIntervalSelectionSegmentControl.addTarget(self, action: #selector(userSelectedTimeInterval(sender:)), for: .valueChanged)
        view.addSubview(timeIntervalSelectionSegmentControl)
    }
    
    //MARK:- get Intraday data
    func getIntradayData(for symbol : String, and timeInterval : String) {
        showLoading()
        timeSeriesDataSource.fetchIntradayData(for: symbol, and: timeInterval) { [weak self] (error,success) in
            DispatchQueue.main.async {
                self?.timeSeriesTableView.reloadData()
                self?.removeLoading()
            }
        }
    }
    
    //MARK:- time intervall segment control
    @objc func userSelectedTimeInterval(sender : DBASegmentControl) {
        let timeInterval = timeIntervals.getInterval(at: sender.selectedSegmentIndex)
        getIntradayData(for: bankViewModel.bankStk, and: timeInterval)
    }
    
    //MARK:- loading
    func showLoading() {
        view.alpha = 0.7
        add(loadingViewController)
    }
    
    func removeLoading() {
        view.alpha = 1.0
        self.loadingViewController.remove()
    }
}

