//
//  IntradayItemInfoView.swift
//  DiscontBankApp
//
//  Created by niv ben-porath on 27/02/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import UIKit

class IntradayItemInfoView: UIView {
    
    let itemTitleLabel = DBALabel(textAlignment: .natural, fontSize: UILabel.timeSeriesLabelFontSize, weight: .regular, color: .systemBlue)
    let itemValueLabel = DBALabel(textAlignment: .natural, fontSize: UILabel.timeSeriesLabelFontSize, weight: .regular,color: .systemBlue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError(Strings.noStoryboardImplementation)
    }
    
    func update(title : String, value: String,textColor : UIColor) {
        itemTitleLabel.text = title
        itemValueLabel.text = value
        
        itemTitleLabel.textColor = textColor
        itemValueLabel.textColor = textColor
    }
    
    private func config() {
        
        let stackView = UIStackView(arrangedSubviews: [itemTitleLabel,itemValueLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
        
    }
    
}
