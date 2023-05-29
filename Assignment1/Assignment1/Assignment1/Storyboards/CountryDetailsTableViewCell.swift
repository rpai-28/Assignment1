//
//  CountryDetailsTableViewCell.swift
//  Assignment1
//
//  Created by Reshma Pai on 28/05/23.
//

import UIKit
import RxSwift
import RxCocoa

class CountryDetailsTableViewCell: UITableViewCell {
    
    var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Constants.one
        stackView.alignment = .leading
        return stackView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailImageView.image = nil
    }
    
    func setupCellUI() {
        
        contentView.addSubview(cellStackView)
        contentView.addSubview(detailImageView)
        addCellStackViewConstraint()
        addImageViewConstraint()
        addTitleLabelConstraints()
        
        setNeedsLayout()
    }
    
    func addCellStackViewConstraint() {
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: detailImageView.trailingAnchor, constant: Constants.eight),
            cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.sixteen),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Constants.eight))
        ])
    }
    
    func addTitleLabelConstraints() {
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(descriptionLabel)
    }
    
    func addImageViewConstraint() {
        NSLayoutConstraint.activate([
            detailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.sixteen),
            detailImageView.widthAnchor.constraint(equalToConstant: Constants.hundred),
            detailImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.sixteen),
            detailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.eight)
        ])
    }
    
    func setupTitle(text: String?) {
        titleLabel.text = text
    }
    
    func setupDescription(text: String?) {
        descriptionLabel.text = text
    }
    
    func setImageView(data: Data?) {
        if let data = data {
            detailImageView.image = UIImage(data: data)
        }
    }
}
