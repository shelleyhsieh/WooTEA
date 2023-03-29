//
//  MenuViewController.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import UIKit

class MenuViewController: UIViewController {
    
    var drinks = [Record]()
    var displayCellModel = [Record]()
    
    var menuDatas = [Record]()
    let urlStr = "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Menu?sort[][field]=category"
    
    var currentBtnIndex: Int = 0
    var categoriesBtn = [String]()

    var dic: [String: [Record]] = [:]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuController.shared.fetchData(urlStr: urlStr) { (result) in
            switch result {
            case.success(menudata: let menuDatas):
                self.updateUI(with: menuDatas)
                self.displayCellModel = menuDatas
                print("✅ 成功抓取檔案")
            case .failure(error: let error):
                self.displayError(error, title: "❌檔案抓取失敗")
            }
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        configureCellSize()
    }
    
    //MARK: - get menu from airtable
    func updateUI(with menuDatas: [Record]) {
        
        self.menuDatas = menuDatas
        self.categoriesBtn = Record.categories(menuDatas)
        self.dic = self.getDrinkBook(models: menuDatas)
        print("😲每杯茶飲的分類\(self.categoriesBtn)")
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // 檔案抓取失敗時出示警告視窗
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

//    MARK: - category button
    @IBAction func changeDrink(_ sender: UIButton) {
        
        let category = sender.titleLabel!.text!
        currentBtnIndex = sender.tag
        getDrinks(category: category)
        print(category)

    }
//    建立參數名稱，往後若有修改只需要改參數名稱
    func getDrinkBook(models: [Record]) -> [String: [Record]] {
        var dic: [String: [Record]] = [:]
        
        for drink in models {
            if dic[drink.fields.category] != nil {
                dic[drink.fields.category]?.append(drink)
            } else {
                dic[drink.fields.category] = [drink]
            }
        }
        return dic
    }
    // 分類後的飲料序列
    func getDrinks(category: String) {
        
        if let drinks = self.dic[category] {
            displayCellModel = drinks
        }

//        drinks = []
//        for drink in menuDatas {
//            if drink.fields.category == category {
//                drinks = [drink] + drinks
//            }
//        }
//        displayCellModel = drinks
        
        print("🥺\(displayCellModel)")
        collectionView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let selectedItem = collectionView.indexPath(for: cell)?.row,
           let controller = segue.destination as? OrderTableViewController {
            
            let menuData = displayCellModel[selectedItem]
            controller.menuDatas = menuData
        }
    }
        
}
//MARK: - Collection View
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 只有一個section時可省略不寫
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return displayCellModel.count //分類後的數量
//        return menuDatas.count  //全部數量
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuCollectionViewCell.self)", for: indexPath) as! MenuCollectionViewCell
        
        let menuData = displayCellModel[indexPath.row]
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
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 210)  // 設定Section Header高度
        flowLayout.sectionHeadersPinToVisibleBounds = true   // 滑動時讓SectionHeader浮在最上方
        
    }
    
    // DataSourse protocol中的viewForSupplementaryElementOfKind()來顯示header或footer，此function提供了"kind"這個參數來辨別header或是footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(MenuCollectionReusableHeaderView.self)", for: indexPath) as? MenuCollectionReusableHeaderView else { return UICollectionReusableView()}
        
        return header
    }
}
