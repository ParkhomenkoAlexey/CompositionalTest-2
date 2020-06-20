//
//  ViewController.swift
//  CompositionalTest
//
//  Created by Алексей Пархоменко on 20.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

struct StickerModel: Hashable {
    var name: String
    var imageName: String
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ViewController: UIViewController {
    
    let stickers = [
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf"),
        StickerModel(name: "Alexey", imageName: "deferf")
    ]
    
    var count: Int = 3
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, StickerModel>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, StickerModel>! = nil
    
    enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupCollectionView()
        setupDataSource()
        reloadData()
    }
    
    func setupNavigationBar() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "App Features Light Mode Icon"), style: .plain, target: self, action: #selector(сubesButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Sticker Size Changer Light Mode Icon"), style: .plain, target: self, action: #selector(loopButtonTapped))
    }
    
    func reloadData() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, StickerModel>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(stickers, toSection: .main)
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
        
    }
    
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCompositionalLayout())
        collectionView.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.0 / CGFloat(self.count)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: self.count)
            
            let spacing = CGFloat(16)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            return section
        }
        return layout
    }
    
    // MARK: - Data Source
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, StickerModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, sticker) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .red
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
            
        })
    }
}



// MARK: - Actions

extension ViewController {
    
    @objc func сubesButtonTapped() {
        
    }
    
    @objc func loopButtonTapped() {
        
        count += 1
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

