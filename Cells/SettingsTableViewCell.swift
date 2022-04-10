//
//  SettingsTableViewCell.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/07.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
    
    static let indentifier = "SettingsTableViewCell"
    
    let titleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}

