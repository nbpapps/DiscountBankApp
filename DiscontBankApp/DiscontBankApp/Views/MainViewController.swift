//
//  MainViewController.swift
//  DiscontBankApp
//
//  Created by niv ben-porath on 26/01/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var bankListCollectionView : UICollectionView!
    let bankListCollectionViewDatasource = BankListDataSource()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        configureBankListDataSource()
    }
    
    //MARK:- config
    func configureView() {
        title = Strings.selectBankTitle
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        bankListCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout:UIConfig.createFlowLayout(in: view, numberOfColums: Values.numberOfCollectionViewColums))
        view.addSubview(bankListCollectionView)
        bankListCollectionView.backgroundColor = .systemBackground
        bankListCollectionView.register(BankCollectionViewCell.self, forCellWithReuseIdentifier: BankCollectionViewCell.reuseId)
        bankListCollectionView.delegate = self
        bankListCollectionView.dataSource = bankListCollectionViewDatasource
    }
    
    func configureBankListDataSource() {
        bankListCollectionViewDatasource.extractBankList(from: Bundle.main.data(from: Strings.banksJson)) {
            DispatchQueue.main.async {
                self.bankListCollectionView.reloadData()
            }
        }
    }
}

extension MainViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destViewController = IntradayViewController()
        if let bank = bankListCollectionViewDatasource.bank(at: indexPath.row) {
            destViewController.bank = bank
            navigationController?.pushViewController(destViewController, animated: true)
        }
    }
}


