//
//  SectionFooter.swift
//  CollectionTest
//
//  Created by Алексей Пархоменко on 15.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol HideButtonsDelegate: class {
    func unlockButtonPressed()
    func restoreButtonPressed()
}

class SectionFooter: UICollectionReusableView {
    
    static let reuseId = "SectionFooter"
    
    let unlockButton = UIButton(type: .system)
    let restoreButton = UIButton(type: .system)
    let checkLabel = UILabel()
    var buttonsStackView: UIStackView!
    
    var appsCollectionView: UICollectionView! = nil
    private let sectionInserts = UIEdgeInsets(top: 0, left: 16, bottom: 64, right: 16)
    
    weak var delegate: HideButtonsDelegate?
//    weak var messageDelegate: MessageExtensionDelegate?
//
//    var dataSource = MoreAppsDataManager.shared.dataSource
    
    var buttonsOnConstraint: NSLayoutConstraint!
    var buttonsOffConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
//        if UserData().productPurchased {
//            hideButtons()
//        }
    }
    
    // MARK: - Actions
    @objc func unlockButtonTapped() {
        delegate?.unlockButtonPressed()
    }
    
    @objc func restoreButtonTapped() {
        delegate?.restoreButtonPressed()
    }
    
    func hideButtons() {
        buttonsStackView.removeFromSuperview()
        buttonsOnConstraint.isActive = false
        buttonsOffConstraint.isActive = true
    }
    
    // MARK: - Setup View
    func setupElements() {
        unlockButton.setTitle("Unlock this Sticker Pack", for: .normal)
        restoreButton.setTitle("Restore Purchase", for: .normal)
        checkLabel.text = "Check out some more"
        
        unlockButton.titleLabel?.font = UIFont.sfProTextSemibold(ofSize: 17)
        restoreButton.titleLabel?.font = UIFont.sfProTextSemibold(ofSize: 17)
        checkLabel.font = UIFont.sfProDisplaySemibold(ofSize: 20)
        
        unlockButton.layer.cornerRadius = 8
        unlockButton.backgroundColor = .systemGreen
        unlockButton.setTitleColor(.white, for: .normal)
        
        restoreButton.layer.cornerRadius = 8
        restoreButton.backgroundColor = .systemBlue
        restoreButton.setTitleColor(.white, for: .normal)
        
        checkLabel.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        checkLabel.textColor = .white
        checkLabel.textAlignment = .center
        
        unlockButton.addTarget(self, action: #selector(unlockButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
        appsCollectionView = UICollectionView(frame: bounds, collectionViewLayout: UICollectionViewFlowLayout())
        appsCollectionView.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        appsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        
        appsCollectionView.register(AppCollectionCell.self, forCellWithReuseIdentifier: AppCollectionCell.reuseId)
        
        if let layout = appsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        appsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsStackView = UIStackView(arrangedSubviews: [unlockButton, restoreButton])
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 24
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonsStackView)
        addSubview(checkLabel)
        addSubview(appsCollectionView)
        
        unlockButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        restoreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
      if frame.width > 500 {
            NSLayoutConstraint.activate([
                buttonsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
                buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                buttonsStackView.widthAnchor.constraint(equalToConstant: 382)
            ])
        } else {
            NSLayoutConstraint.activate([
                buttonsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
                buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ])
        }
        
        buttonsOffConstraint = checkLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        buttonsOffConstraint.isActive = false
        
        buttonsOnConstraint = checkLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 36)
        buttonsOnConstraint.isActive = true
        NSLayoutConstraint.activate([
            checkLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            checkLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            checkLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        NSLayoutConstraint.activate([
            appsCollectionView.topAnchor.constraint(equalTo: checkLabel.bottomAnchor),
            appsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            appsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            appsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SectionFooter: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCollectionCell.reuseId, for: indexPath) as! AppCollectionCell
//        let itemToShow = dataSource[indexPath.row].values.first
//        cell.appImageView.image = itemToShow
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let appId = dataSource[indexPath.row].keys.first {
//            messageDelegate?.openStoreApp(id: appId)
//        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension SectionFooter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 87, height: 87)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}


