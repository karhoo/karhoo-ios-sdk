//
//  ViewController.swift
//  Client
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

class ViewController: UIViewController {
    
    var table: UITableView!
    let endpoints = [
        ["title": "Login", "type": "Token Exchange"],
        ["title": "Revoke", "type": "Token Exchange"],
        ["title": "Adyen", "type": "Token Exchange"]
    ]
    
    var data = [TableSection: [[String: String]]]()
    
    let SectionHeaderHeight: CGFloat = 25
    
    enum TableSection: Int {
        case tokenExchange = 0
        case adyen = 1
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        
        view.backgroundColor = .white
        title = "Endpoints"
    
        sortData()
        
        table = UITableView()
        table.accessibilityIdentifier = "tableView"
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        
        view.addSubview(table)
        _ = [table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].map { $0.isActive = true }
    }
    
    private func sortData() {
        data[.tokenExchange] = endpoints.filter({ $0["type"] == "Token Exchange"})
        data[.adyen] = endpoints.filter({ $0["type"] == "Adyen"})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        if let tableSection = TableSection(rawValue: indexPath.section), let endpoints = data[tableSection]?[indexPath.row] {
            cell.textLabel?.text = endpoints["title"]
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = .lightGray
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .tokenExchange:
                label.text = "Token Exchange"
            case .adyen: label.text = "Adyen"
            }
        }
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        let testViewController = AuthRequestsTesterViewController(requestType: AuthRequestType(rawValue: title)!)
        navigationController?.pushViewController(testViewController, animated: true)
    }
}
