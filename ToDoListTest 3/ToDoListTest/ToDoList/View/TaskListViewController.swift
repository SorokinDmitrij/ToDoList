//
//  ViewController.swift
//  ToDoListTest
//
//  Created by mac on 15.11.2024.
//

import UIKit

protocol TasksViewProtocol: AnyObject {
    func reloadTableView()
}

class TasksViewController: UIViewController {

    var presenter: TaskListPresenterProtocol!

    private var blurView: UIVisualEffectView?
    private var detailView: UIView?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = .default
        searchBar.searchTextField.textColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var countLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        return lbl
    }()
    private lazy var newTaskButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let menu = CustomMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tasksTableView)
        view.addSubview(bottomView)
        bottomView.addSubview(countLabel)
        bottomView.addSubview(newTaskButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tasksTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 80),
            
            countLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 25),
            
            newTaskButton.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            newTaskButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            newTaskButton.heightAnchor.constraint(equalToConstant: 25),
            newTaskButton.widthAnchor.constraint(equalToConstant: 55),
        ])
    }
  
    private func showTaskDetailWithMenu(task: Task) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        self.blurView = blurView
        view.addSubview(blurView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTaskDetailAndMenu))
        blurView.addGestureRecognizer(tapGesture)
        
        let detailView = UIView()
        detailView.backgroundColor = .darkGray
        detailView.layer.cornerRadius = 12
        detailView.translatesAutoresizingMaskIntoConstraints = false
        self.detailView = detailView
        view.addSubview(detailView)
        
        let titleLabel = UILabel()
        titleLabel.text = task.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = task.todo
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.text = task.date.description
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .lightGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailView.addSubview(titleLabel)
        detailView.addSubview(descriptionLabel)
        detailView.addSubview(dateLabel)
       
        menu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menu)
        
        NSLayoutConstraint.activate([
            detailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            detailView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            detailView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: detailView.bottomAnchor, constant: -16),
            
            menu.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 16),
            menu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menu.widthAnchor.constraint(equalToConstant: 200),
            menu.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            blurView.alpha = 1
            self?.menu.alpha = 1
        }
    }

    @objc private func hideTaskDetailAndMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView?.alpha = 0
            self.detailView?.alpha = 0
            self.menu.alpha = 0
        }) { [weak self] _ in
            guard let self else { return }
            menu.removeFromSuperview()
            blurView?.removeFromSuperview()
            detailView?.removeFromSuperview()
            blurView = nil
            detailView = nil
        }
    }
    
    func showMenu(below view: UIView) {
        let menu = CustomMenu()
        self.view.addSubview(menu)
        
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            menu.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            menu.widthAnchor.constraint(equalToConstant: 200),
            menu.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    private func updateTaskCount() {
        countLabel.text = " \(presenter.task.count) Задач"
    }
    
   
    @objc func newTaskButtonTapped() {
        tasksTableView.reloadData()
        updateTaskCount()
    }
}
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.task.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = presenter.task[indexPath.row]
        showTaskDetailWithMenu(task: selectedTask)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = presenter.task[indexPath.row]
        cell.configure(with: task)
        cell.onCheckboxToggle = { [weak self] in
            guard let self = self else { return }
            self.presenter.task[indexPath.row].completed.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
}

extension TasksViewController: TasksViewProtocol {
    func reloadTableView() {
        tasksTableView.reloadData()
    }
}
