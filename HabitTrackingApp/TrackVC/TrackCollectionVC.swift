//
//  TrackCollectionVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 03/11/2021.
//

import UIKit

private let reuseIdentifier = "TrackCell"

class TrackCollectionVC: UICollectionViewController {

    private var colorsArr = [UIColor.labelColor,UIColor.s2,UIColor.s3,UIColor.s3,UIColor.s3]
    init() {
        super.init(collectionViewLayout: TrackCollectionVC.createCompositionalLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5)))
            item.contentInsets.trailing = 16
            item.contentInsets.bottom = 16
//                item.contentInsets.bottom = 16
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400)), subitems: [item])
            //group.interItemSpacing = .fixed(15)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.top = 16
            section.contentInsets.leading = 16
            //section.interGroupSpacing = 15
            //section.orthogonalScrollingBehavior = .paging
            
            return section
        }
      
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tap and Track"
        self.collectionView.backgroundColor = UIColor(named: "BG")
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.layer.cornerRadius = 10
        cell.backgroundColor = colorsArr[indexPath.item]
    
        return cell
    }
}
