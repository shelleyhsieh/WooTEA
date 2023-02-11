//
//  MenuViewController.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import UIKit

class MenuViewController: UIViewController {
    
//    var drinks:[DrinkMenu] = []
    var menuDatas = [Record]()
    let urlStr = "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Menu?sort[][field]=category"
    
    
//    var categoryArray: [DrinkCategory] = []
    var currentBtnIndex: Int = 0
    var totalNomberCups: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuController.shared.fetchData(urlStr: urlStr) { (result) in
            switch result {
            case.success(let menuDatas):
                self.updateUI(with: menuDatas)
                print("Fetch data success")
            case .failure(let error):
                self.displayError(error, title: "Failed to fetch the data")
            }
            
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        configureCellSize()
//        categorizeDrinks()
    }
    //MARK: - get menu from airtable
    func updateUI(with menuDatas: [Record]) {
        DispatchQueue.main.async {
            
            self.menuDatas = menuDatas
            self.collectionView.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeDrink(_ sender: UIButton) {
        let category = sender.titleLabel?.text!
//        getDrinks(category: category!)

        currentBtnIndex = sender.tag
    }
    
//    func getDrinks(category: String) {
//        drinks = []
//        for drink in allDrinks {
//            if drink.category == category {
//                drinks += [drink]
//            }
//        }
//        collectionView.reloadData()
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let selectedItem = collectionView.indexPath(for: cell)?.row,
           let controller = segue.destination as? OrderTableViewController {
            let menuData = menuDatas[selectedItem]
            controller.menuDatas = menuData
        }
    }
        
}
//MARK: - Collection View
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(menuDatas.count)
        
        return menuDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuCollectionViewCell.self)", for: indexPath) as! MenuCollectionViewCell
        let menuData = menuDatas[indexPath.row]
        cell.nameLable.text = menuData.fields.name
        
        let imageUrl = menuData.fields.image[0].url
        MenuController.shared.fetchImage(url: imageUrl) { (image) in
            guard let image = image else {return}
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    
    func configureCellSize(){
        
        let itemSpace: CGFloat = 0
        let columeCount: CGFloat = 2 //一排有兩個
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width - itemSpace * (columeCount-1)) / columeCount) //（螢幕寬-cell間距數量）/cell數量
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.estimatedItemSize = .zero                 //讓cell尺寸依據設定的itemSize顯示
        flowLayout.minimumInteritemSpacing = itemSpace       // 設定cell左右間距
        flowLayout.minimumLineSpacing = itemSpace            // 設定上下間距
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 180)  // 設定Section Header高度
        flowLayout.sectionHeadersPinToVisibleBounds = true   // 滑動時讓SectionHeader浮在最上方
//        collectionView.collectionViewLayout = flowLayout
        
    }
    
    // DataSourse protocol中的viewForSupplementaryElementOfKind()來顯示header或footer，此function提供了"kind"這個參數來辨別header或是footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(MenuCollectionReusableHeaderView.self)", for: indexPath) as? MenuCollectionReusableHeaderView else { return UICollectionReusableView()}
        
        return header
    }
}
