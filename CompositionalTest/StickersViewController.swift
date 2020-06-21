//
//  StickersViewController.swift
//  MyAppName MessagesExtension
//
//  Created by Алексей Пархоменко on 20.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import Messages

class StickersViewController: UIViewController {

    var stickers = [StickerModel]()
    
    var count: Int = 3
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, StickerModel>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, StickerModel>! = nil
    
    enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        loadStickerData()
        setupNavigationBar()
        setupCollectionView()
        setupDataSource()
        reloadData()
    }
    
    func loadStickerData() {
        if let path = Bundle.main.path(forResource: "StickerData", ofType: ".plist") {
            print("path: \(path)")
            if let data = NSArray(contentsOfFile: path) as? [Dictionary<String, Any>]{
                data.forEach { (item) in
                    let id = item["id"] as! Int
                    let name = item["name"] as! String
                    let isFree = item["isFree"] as! Bool
 
                    let stickerObject = StickerModel(id: id, name: name, isFree: isFree)
                    if stickerObject.sticker != nil {
                        stickers.append(stickerObject)
                    }
                }
            }
        }
    }
    
    func setupNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    
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
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(SectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooter.reuseId)
        
        collectionView.register(MyStickerCell.self, forCellWithReuseIdentifier: MyStickerCell.reuseId)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    // MARK: - Layout
    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            let float = CGFloat(1 / Double(self.count))
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(float),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(float))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])
            

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: -8, leading: 8, bottom: 8, trailing: 8)
            
            let sectionFooterrSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(530))
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionFooterrSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            section.boundarySupplementaryItems = [sectionFooter]
            
            return section
        }
        return layout
    }
    
    // MARK: - Data Source
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, StickerModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, sticker) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyStickerCell.reuseId, for: indexPath) as! MyStickerCell
            
            cell.configure(self.stickers[indexPath.row])
            return cell
            
        })
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            if let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooter.reuseId, for: indexPath) as? SectionFooter {
                
                return sectionFooter
            } else {
                fatalError("Cannot create new supplementary")
            }
            
            
        }
    }
}



// MARK: - Actions

extension StickersViewController {
    
    @objc func сubesButtonTapped() {
        
    }
    
    @objc func loopButtonTapped() {
        count += 1
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}
