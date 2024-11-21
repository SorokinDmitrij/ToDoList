//
//  TaskCell.swift
//  ToDoListTest
//
//  Created by mac on 16.11.2024.
//
import UIKit

class TaskCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkbox: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        return button
    }()
    
    var onCheckboxToggle: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = .black
        contentView.addSubview(checkbox)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    @objc private func toggleCheckbox() {
        checkbox.isSelected.toggle()

        if checkbox.isSelected {
            if let text = titleLabel.text {
                titleLabel.attributedText = text.strikethrough(color: .gray)
            }
            titleLabel.textColor = .gray
        } else {
            if let attributedText = titleLabel.attributedText?.string {
                titleLabel.attributedText = nil
                titleLabel.text = attributedText
            }
            titleLabel.textColor = .white
        }
        
        // Уведомляем контроллер о смене состояния
        onCheckboxToggle?()
    }
    
    func configure(with task: Task) {
        if task.completed {
            titleLabel.attributedText = task.title.strikethrough(color: .gray)
            titleLabel.textColor = .gray
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = task.title
            titleLabel.textColor = .white
        }
        descriptionLabel.text = task.todo
        dateLabel.text = task.date.description
        checkbox.isSelected = task.completed
    }
}
extension String {
    func strikethrough(color: UIColor = .gray) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes([
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: color
        ], range: NSMakeRange(0, self.count))
        return attributedString
    }
}
