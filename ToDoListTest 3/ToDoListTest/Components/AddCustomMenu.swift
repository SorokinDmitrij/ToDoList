//
//  AddCustomMenu.swift
//  ToDoListTest
//
//  Created by mac on 19.11.2024.
//

import UIKit

class CustomMenu: UIView {
    private let menuItems: [(title: String, icon: UIImage?)] = [
        ("Редактировать", UIImage(systemName: "pencil")),
        ("Поделиться", UIImage(systemName: "square.and.arrow.up")),
        ("Удалить", UIImage(systemName: "trash"))
    ]
    init() {
        super.init(frame: .zero)
        setupMenu()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMenu()
    }
    private func setupMenu() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, item) in menuItems.enumerated() {
            let menuItemView = createMenuItem(title: item.title, icon: item.icon, tag: index)
            stackView.addArrangedSubview(menuItemView)
        }
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    private func createMenuItem(title: String, icon: UIImage?, tag: Int) -> UIView {
        let menuItemView = UIView()
        menuItemView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: icon)
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped(_:)))
        menuItemView.addGestureRecognizer(tapGesture)
        menuItemView.tag = tag
        
        menuItemView.addSubview(iconImageView)
        menuItemView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: menuItemView.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: menuItemView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: menuItemView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: menuItemView.centerYAnchor),
            
            menuItemView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return menuItemView
    }
    
    @objc private func menuItemTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        let selectedItem = menuItems[tag]
        print("Выбран пункт меню: \(selectedItem.title)")
        
        switch selectedItem.title {
        case "Редактировать":
            print("Редактировать задачу")
        case "Поделиться":
            print("Поделиться задачей")
        case "Удалить":
            print("Удалить задачу")
        default:
            break
        }
    }
}
