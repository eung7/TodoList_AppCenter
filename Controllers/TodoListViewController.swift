//
//  TodoListViewController.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/07.
//

import UIKit
import SnapKit

class TodoListViewController: UIViewController {
    
    let viewModel = TodoListViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TodayTableHeaderView.self, forHeaderFooterViewReuseIdentifier: TodayTableHeaderView.identifier)
        tableView.register(UpcomingTableHeaderView.self, forHeaderFooterViewReuseIdentifier: UpcomingTableHeaderView.identifier)
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.identifier)
        tableView.sectionHeaderHeight = 35
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = "I want to..."
        textField.setPadding(left: 8, right: 8)
        textField.textColor = UIColor.systemGray3
        textField.font = .systemFont(ofSize: 14)
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var todayButton: UIButton = {
        let button = UIButton()
        button.setTitle("today", for: .normal)
        button.setTitleColor(UIColor.systemGray2, for: .normal)
        button.setTitleColor(UIColor.label, for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addTarget(self, action: #selector(didTapTodayButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemIndigo
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        return view
    }()
    
    private lazy var tapBackGround: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackGround))
        
        return gestureRecognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodoManager.shared.loadTodo()
        addKeyboardNotificationCenter()
        setupViews()
    }
    
    private func addKeyboardNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(willChangeKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willChangeKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setupViews() {
        view.addGestureRecognizer(tapBackGround)
        
        [ textField, addButton, todayButton ]
            .forEach { backgroundView.addSubview($0) }
        
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(30)
            $0.width.equalTo(260)
            $0.centerY.equalToSuperview()
        }
        
        todayButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(textField.snp.trailing).offset(10)
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        [ tableView, backgroundView ]
            .forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(backgroundView.snp.top)
        }
        
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
}

extension TodoListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.textColor == .systemGray3 else { return }
        textField.textColor = .label
        textField.text = ""
    }
}

extension TodoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return TodoManager.shared.todayTodos.count
        case 1:
            return TodoManager.shared.upcomingTodos.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.identifier, for: indexPath) as? TodoListCell else { return UITableViewCell() }
        cell.delegate = self
        switch indexPath.section {
        case 0:
            cell.setupData(TodoManager.shared.todayTodos[indexPath.row])
            cell.todo = TodoManager.shared.todayTodos[indexPath.row]
            return cell
        case 1:
            cell.setupData(TodoManager.shared.upcomingTodos[indexPath.row])
            cell.todo = TodoManager.shared.upcomingTodos[indexPath.row]
            return cell
        default:
            return cell
        }
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let todayHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodayTableHeaderView.identifier)
        let upcomingHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: UpcomingTableHeaderView.identifier)
        let headers = [ todayHeader, upcomingHeader ]
        
        return headers[section]
    }
}

extension TodoListViewController: TodoListDelegate {
    func didTapDeleteButton(todo: Todo) {
        TodoManager.shared.deleteTodo(todo)
        tableView.reloadData()
    }
    
    func didTapDoneButton(todo: Todo) {
        TodoManager.shared.updateTodo(todo)
        tableView.reloadData()
    }
}

private extension TodoListViewController {
    @objc func didTapTodayButton() {
        if todayButton.isSelected == false {
            todayButton.isSelected = true
            todayButton.layer.backgroundColor = UIColor.systemBackground.cgColor
        } else {
            todayButton.isSelected = false
            todayButton.backgroundColor = nil
        }
    }
    
    @objc func didTapAddButton() {
        guard textField.text != "",
              textField.textColor != UIColor.systemGray3,
              let contents = textField.text else { return }
        let todo = TodoManager.shared.createTodo(contents: contents, isToday: todayButton.isSelected)
        TodoManager.shared.addTodo(todo)
        
        textField.text = ""
        todayButton.isSelected = false
        todayButton.backgroundColor = .systemGray6
        todayButton.tintColor = .systemGray2
        tableView.reloadData()
    }
    
    @objc func didTapBackGround() {
        view.endEditing(true)
    }
    
    @objc func willChangeKeyboard(_ notification: Notification) {
        guard let userinfo = notification.userInfo else { return }
        guard let keyboardFrame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            backgroundView.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight + tabBarHeight)
                $0.height.equalTo(50)
            }
        } else {
            backgroundView.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
                $0.height.equalTo(50)
            }
        }
    }
}
