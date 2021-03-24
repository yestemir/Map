//
//  CityView.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit
import SnapKit
import CoreData

protocol CityViewDelegate {
    func goToCity(id: Int)
    func deleteCity(id: Int)
}

class CityView: UIView {
    
    var viewData: MainModel = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    var delegate: CityViewDelegate!
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var cities = [City]()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        [tableView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.leading.equalTo(self)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch viewData {
        case .initial:
            self.tableView.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        case .loading:
            self.tableView.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        case .success(let cities):
            self.tableView.isHidden = false
            self.cities = cities
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        case .failure:
            self.tableView.isHidden = true
            self.activityIndicator.stopAnimating()
        case .updateCity(let city, let id):
            cities[id] = city
        }
    }
    
}

//MARK: - UITableViewDelegate

extension CityView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CityTableViewCell
        cell.titleLabel.text = cities[indexPath.row].name
        cell.placeLabel.text = cities[indexPath.row].place
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.goToCity(id: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate.deleteCity(id: indexPath.row)
            cities.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}
