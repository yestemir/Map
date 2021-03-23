//
//  ChangeView.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit
import CoreData

class ChangeView: UIView {
    
    var index: Int!
    
    lazy var textField1: UITextField  = {
        let textField = UITextField()
        textField.placeholder = "Change..."
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
        return textField
    }()
    
    lazy var textField2: UITextField  = {
        let textField = UITextField()
        textField.placeholder = "Change..."
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        [textField1, textField2].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        textField1.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(350)
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
        
        textField2.snp.makeConstraints { (make) in
            make.top.equalTo(textField1.snp.bottom).offset(40)
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
    }
    
}
