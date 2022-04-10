//
//  TodoListCell.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/08.
//

import UIKit
import SnapKit

protocol TodoListDelegate {
    func didTapDeleteButton(todo: Todo)
    func didTapDoneButton(todo: Todo)
}

class TodoListCell: UITableViewCell {
    static let identifier = "TodoListCell"
    
    var todo: Todo?
    
    var delegate: TodoListDelegate?
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold), forImageIn: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold), forImageIn: .selected)
        button.tintColor = .systemIndigo
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24), forImageIn: .normal)
        button.isHidden = true
        button.tintColor = .systemGray3
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    lazy var completedLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.isHidden = true
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
    }
    
    func updateUI(_ isHidden: Bool) {
        completedLine.isHidden = !isHidden
        deleteButton.isHidden = !isHidden
        
        if isHidden {
            contentsLabel.textColor = .systemGray3
        } else {
            contentsLabel.textColor = .label
        }
    }
    
    func setupData(_ todo: Todo) {
        contentsLabel.text = todo.contents
        contentsLabel.textColor = todo.isDone ? .systemGray3 : .label
        doneButton.isSelected = todo.isDone
        completedLine.isHidden = !todo.isDone
        deleteButton.isHidden = !todo.isDone
    }
    
    func setupViews() {
        [
            doneButton,
            contentsLabel,
            deleteButton,
            completedLine
        ]
            .forEach { addSubview($0) }
        
        doneButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(30)
            $0.centerY.equalTo(contentsLabel.snp.centerY)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(30)
            $0.centerY.equalTo(contentsLabel.snp.centerY)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.leading.equalTo(doneButton.snp.trailing).offset(24)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        completedLine.snp.makeConstraints {
            $0.leading.equalTo(doneButton.snp.trailing).offset(26)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

private extension TodoListCell {
    @objc func didTapDeleteButton() {
        guard let todo = todo else { return }
        delegate?.didTapDeleteButton(todo: todo)
    }
    
    @objc func didTapDoneButton() {
        guard var todo = todo else { return }
        
        doneButton.isSelected = !doneButton.isSelected
        todo.isDone = doneButton.isSelected
        updateUI(todo.isDone)
        delegate?.didTapDoneButton(todo: todo)
    }
}

