//
//  ChangeViewController.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit
import CoreData

class ChangeViewController: UIViewController {
    weak var coordinator: ChangeCoordinator?
    var changeView = ChangeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
    }
    
    @objc func doneTapped(){
        coordinator?.change(id: changeView.index, newName: changeView.textField1.text!, place: changeView.textField2.text!)
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        [changeView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        changeView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.leading.equalTo(view)
        }
        
    }

}
