//
//  NoteTableViewCell.swift
//  NoteApp
//
//  Created by Balsa Komnenovic on 13.3.23..
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    static let identifier = "NoteTableViewCell"
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    //MARK: - Private
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    //MARK: - Public
    public func configure(with viewModel: NoteTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
    }
}
