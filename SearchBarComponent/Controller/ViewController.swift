//
//  ViewController.swift
//  SearchBarComponent
//
//  Created by Alexandr on 06.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Private Properties
    private let tableViewIdentifier = "cell"
    private var headerSearchView: HeaderSearchView!
    private var tableView: UITableView!
    private var tableViewLastContentOffsetY: CGFloat = 0
    
    lazy private var apiProvider: APIProvider = AlamofireAPIProvider()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHeaderSearchView()
        setUpTableView()
    }
    
}

//MARK: - Initializers
extension ViewController {
    
    fileprivate func setUpTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerSearchView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        tableView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    fileprivate func setUpHeaderSearchView() {
        headerSearchView = HeaderSearchView()
        headerSearchView.delegate = self
        headerSearchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerSearchView)
        
        headerSearchView.backgroundColor = .lightGray
        headerSearchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        headerSearchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        headerSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerSearchView.heightAnchor.constraint(equalToConstant: 82).isActive = true
    }
    
}

//MARK: - Alert
extension ViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDataSource
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier, for: indexPath)
        cell.textLabel?.text = "Item #\(indexPath.row)"
        return cell
    }
    
}

extension ViewController : HeaderSearchViewDelegate {
    
    func searchButtonWasTappedWith(query: String) {
        apiProvider.searchGoods(query: query) { [weak self] (results, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self?.showAlert(title: "Ошибка", message: (error as NSError?)?.userInfo["description"] as? String ?? "")
                    return
                }
                guard let results = results else {
                    self?.showAlert(title: "Ошибка", message: (error as NSError?)?.userInfo["description"] as? String ?? "")
                    return
                }
                
                self?.showAlert(title: "Ответ с сервера", message: "Количество возвращенных товаров: \(results.count)")                
            }
        }
    }
    
}

//MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableViewLastContentOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset <= 0 {
            headerSearchView.collapse()
            return
        }
        
        if offset > tableViewLastContentOffsetY {
            headerSearchView.expand()
        } else if offset < tableViewLastContentOffsetY {
            headerSearchView.collapse()
        }
    }
    
}

