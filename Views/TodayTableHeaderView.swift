//
//  TodayTableHeaderView.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/07.
//

import UIKit
import SnapKit

class TodayTableHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "TodayTableHeaderView"
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "Today 🚀"
        label.font = .systemFont(ofSize: 24.0, weight: .heavy)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.trailing.equalToSuperview()
        }
    }
}
