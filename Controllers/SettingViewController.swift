//
//  SettingViewController.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/07.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    let settings: [String] = [
        "Support",
        "About",
        "Version"
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.indentifier)
        tableView.rowHeight = 50
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemGray6
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.indentifier, for: indexPath) as! SettingsTableViewCell
        cell.layer.cornerRadius = 20
        cell.titleLabel.text = settings[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "EungCheol_TodoList"
    }
}

extension SettingViewController: UITableViewDelegate {
    
}
