//
//  CityTableViewCell.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.isOpaque = false
        self.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        [titleLabel, placeLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).inset(5)
            make.left.equalTo(self).offset(30)
            make.height.equalTo(30)
        }
        
        placeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).inset(5)
            make.left.equalTo(self).offset(30)
            make.height.equalTo(30)
        }
        
    }
    
}


