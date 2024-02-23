//
//  ViewController.swift
//  ProjectOneOrg
//
//  Created by Xotech on 21/01/2024.
//

import UIKit
import StoreKit

class ViewController: UIViewController , DeleteProtocol{


 
    @IBOutlet weak var homeCollection: UICollectionView!
    @IBOutlet weak var navCollection: UICollectionView!
    @IBOutlet weak var homeFlow: UICollectionViewFlowLayout!
    
    @IBOutlet weak var navFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var toolButton: UIButton!
    
    @IBOutlet weak var projectButton: UIButton!
    
    var deleteButtonActivated : Bool = true
    var deleteButtonShow : Bool = false
    var deleteIndexList = [Int]()

    
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var detailedDeleteButton: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var bottomNavigationView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    var pageNavigation = 0
    var deletePressed : Bool = false
    var deleteOpen : Bool = false
    var deleteMode : Bool = true

    
    let navColor : [String] = ["buttonBackGround", "NavBarColorActive","buttonBackGround"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetting()
        navButtonManager(true)
        homeCollectionManager()
        navTopManager()
        pageMovement(contentRow: 0, navRow: 1)
        controlNavogationView()
        
    }
    
    func initSetting(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDelete(_:)))
        detailedDeleteButton.addGestureRecognizer(tapGesture)
        navigationView.isHidden = false
        deleteView.isHidden = true
        detailView.isHidden = true
    }
    
    @objc func handleDelete(_ sender: UITapGestureRecognizer) {
        addHaptic()
        deleteMode = true
        deleteOperation()
        print("View tapped")
    }
    
    func pageMovement( contentRow content : Int ,navRow navBar : Int) {
        homeCollection.reloadData()
        homeCollection.scrollToItem(at: IndexPath(item: content, section: 0), at: .centeredHorizontally , animated: true)
        
        navCollection.reloadData()
        navCollection.scrollToItem(at: IndexPath(item: navBar , section: 0), at: .left, animated: true)
    }
    
    func homeCollectionManager(){
        
        homeCollection.dataSource = self
        homeCollection.delegate = self
        homeCollection.collectionViewLayout = homeFlow
        
        
        homeCollection.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCell")
        homeCollection.register(UINib(nibName: "ProjectCollectionViewCell", bundle: nil ), forCellWithReuseIdentifier: "projectCell")
        
        
        homeFlow.scrollDirection = .horizontal
        homeFlow.collectionView?.showsVerticalScrollIndicator = false
        homeFlow.collectionView?.showsHorizontalScrollIndicator = false
        homeFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        homeFlow.minimumLineSpacing = 0
        homeFlow.minimumInteritemSpacing = 0
        
    }
    
    func navTopManager(){
        
        navCollection.dataSource = self
        navCollection.delegate = self
        navCollection.collectionViewLayout = navFlow
        
        
        navCollection.register(UINib(nibName: "NavTopCollectionViewCell", bundle: nil ), forCellWithReuseIdentifier: "navCell")
        
        navFlow.scrollDirection = .horizontal
        navFlow.collectionView?.showsVerticalScrollIndicator = false
        navFlow.collectionView?.showsHorizontalScrollIndicator = false
        
        navFlow.minimumLineSpacing = 0
        navFlow.minimumInteritemSpacing = 0
        
    }
    
    func navButtonManager (_ fg : Bool ) {
        let lf = fg ? "NavBarColorActive" : "NavBarColorInActive" ;
        let rt = fg ? "NavBarColorInActive" : "NavBarColorActive" ;
        constructButton(toolButton, "Tools", UIColor(named: lf) )
        constructButton(projectButton, "Projects", UIColor(named: rt)  )
    }
    
    func constructButton(_ btn : UIButton , _ t : String ,_ clr : UIColor! ) {
        let attributedText = NSMutableAttributedString(string: t )
        let customFont = UIFont(name: "Poppins-SemiBold", size: 10.0)
        attributedText.addAttribute(NSAttributedString.Key.font, value: customFont ?? UIFont(name: "Poppins-SemiBold", size: 10.0), range: NSRange(location: 0, length: attributedText.length))
        let customColor = clr!
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: customColor, range: NSRange(location: 0, length: attributedText.length))
        btn.setAttributedTitle(attributedText,for: .normal)
    }
    
    @IBAction func buttonPressedTools(_ sender: UIButton){
        navButtonManager(true)
        setNavButtonImage(imageTools: "toolColorLogo", imageProjects: "projects")
        pageMovement(contentRow: 0, navRow: 1)
    }
    
    @IBAction func buttonPressedProjects(_ sender: UIButton){
        navButtonManager(false)
        setNavButtonImage(imageTools: "tools", imageProjects: "projectColorLogo")
        pageMovement(contentRow: 1, navRow: 0)
        
    }
    
    func setNavButtonImage(imageTools imO : String , imageProjects imT : String ){
        toolButton.setImage(UIImage(named: imO), for: .normal)
        projectButton.setImage(UIImage(named: imT), for: .normal)
    }
    

    
    func showAppDetails(appId: String) {
        
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier: appId]
        storeViewController.loadProduct(withParameters: parameters) { success, error in
            if success {
                self.present(storeViewController, animated: true,completion: nil)
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    

    func deleteit(_ deleteIndex: [Int] ,_ remaining : Int  ) {
        //print(deleteIndex, " Delete Them ")
    
        if deleteIndex.count > 0 {
            deleteOpen = true
            deleteButton.setImage(UIImage(named: "deleteRed"), for: .normal)
            constructDeleteButton(deleteButton,clr: "redOne")
        } else {
            deletePressed = false 
            deleteOpen = false
            deleteButton.setImage(UIImage(named: "deleteGray"), for: .normal)
            constructDeleteButton(deleteButton,clr: "buttonGray")
        }
        
        if remaining == 0 {
            deleteButtonShow = false
            controlNavogationView()
        }
        
    }
    
    
    func showDetailedNavigation() {
        navigationView.isHidden = true
        deleteView.isHidden = true
        detailView.isHidden = false
       
     
        bottomViewHeight.constant = 0
        //contentViewHeight.constant += (93/896 * self.wholeView.frame.height)
        
       //print(contentViewHeight.constant ,bottomViewHeight.constant , " content Height ")
        
        self.wholeView.layoutIfNeeded()

        UIView.animate(withDuration: 0.3 , animations: {
            self.bottomViewHeight.constant =  93/896 * self.wholeView.frame.height
            //self.bottomViewHeight.constant = 759/896 * self.wholeView.frame.height
            self.wholeView.layoutIfNeeded()
            
        })
        
        //constructDeleteButton(detailedDeleteButton,clr: "redOne")
    }
    
    func backToProjectFromDetails(){
        navigationView.isHidden = false
        deleteView.isHidden = true
        detailView.isHidden = true
    }
    
    
    
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if deleteOpen {
            deleteMode = false
            deleteOperation()
        }
    }
    
    func addHaptic(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func deleteOperation(){
        let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deletePressed = true
            
            self.homeCollection.reloadData()
            if self.deleteMode {
                self.navigationView.isHidden = false
                self.deleteView.isHidden = true
                self.detailView.isHidden = true
            } else {
                self.navigationView.isHidden = true
                self.deleteView.isHidden = false
                self.detailView.isHidden = true 
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.deletePressed = false
            print("Stoooooooop ")
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}



extension ViewController : UICollectionViewDataSource , UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.homeCollection {
            return 2
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.homeCollection {
            if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCollectionViewCell
                cell.selectButton.addTarget(self, action: #selector(addDeleteButton), for: .touchUpInside)
                cell.cancelButton.addTarget(self, action: #selector(addDeleteButton), for: .touchUpInside)
                cell.deleteTriggered(deletePressed,deleteMode)
            
                
                cell.delegate = self
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
                cell.buttonSix.addTarget(self, action: #selector(buttonTappedInCollectionViewCell), for: .touchUpInside)
                cell.delegate = self
                //print(indexPath.row , "HomeCollection View Cell")
                
                return cell
            }
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "navCell", for: indexPath) as! NavTopCollectionViewCell
            print(indexPath.row)
            cell.navView.backgroundColor = UIColor(named: navColor[indexPath.row])
            return cell
        }
        
    }
    
  
    @objc func addDeleteButton(){
        deleteButtonShow.toggle()
        controlNavogationView()
    }
    
    func controlNavogationView(){
        if deleteButtonShow {
            navigationView.isHidden = true
            deleteView.isHidden = false
            constructDeleteButton(deleteButton,clr: "buttonGray")
        } else {
            navigationView.isHidden = false
            deleteView.isHidden = true
        }
    }
    
    
    func constructDeleteButton(_ btn : UIButton , clr : String ) {
        let attributedText = NSMutableAttributedString(string: "Delete" )
        let customFont = UIFont(name: "Poppins-SemiBold", size: 10.0)
        attributedText.addAttribute(NSAttributedString.Key.font, value: customFont ?? UIFont(name: "Poppins-SemiBold", size: 10.0), range: NSRange(location: 0, length: attributedText.length))
        let customColor = UIColor(named: clr)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: customColor, range: NSRange(location: 0, length: attributedText.length))
        btn.setAttributedTitle(attributedText,for: .normal)
    }
    
    @objc func buttonTappedInCollectionViewCell(sender: UIButton) {
        self.performSegue(withIdentifier: "goToTools", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTools" {
            var destinationVC = segue.destination as! MoreToolsViewController
            
            if #available(iOS 15.0, *) {
                if let sheet = destinationVC.sheetPresentationController {
                    print("sheet Got ")
                    if #available(iOS 16.0, *) {
                        sheet.detents = [ UISheetPresentationController.Detent.custom { context in
                            self.view.layer.frame.height *
                            0.47
                            //0.503348 // 0.509029 // 0.503348 //\4
                        }]
                    }
                }
            }
        }
    }
    
    
    
    
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == homeCollection {
        
            let w = view.frame.size.width
            let h = view.frame.size.height
            
            print(w,h, " Whole Item Test ")
            
            return CGSize(width: w, height: h*0.847098)
            
        } else {
            let w = wholeView.frame.width/2
            let h = wholeView.frame.height*2/896
            
            print(w,h, " Whole Item Navigation Test ")
            
            
            return CGSize(width: w, height: h)
            
        }
        
    }
}




extension ViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true)
    }
}
