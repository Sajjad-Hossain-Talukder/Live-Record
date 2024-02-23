//
//  ProjectCollectionViewCell.swift
//  ProjectOneOrg
//
//  Created by Xotech on 21/01/2024.
//

import UIKit

class ProjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var projectItemCollection: UICollectionView!
    
    @IBOutlet weak var projectItemCollectionFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var projectMenuCollectionFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var projectMenuCollection: UICollectionView!
    @IBOutlet weak var createProjectButton: UIButton!
    @IBOutlet weak var createProjectView: UIView!
    @IBOutlet weak var createProjectContainer: UIView!
    @IBOutlet weak var secButton: UIButton!
    @IBOutlet weak var tirButton: UIButton!
    @IBOutlet weak var firButton: UIButton!
    
    @IBOutlet weak var ProjectOption: UIView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var detailedContentView: UIView!
    @IBOutlet weak var detailedImageView: UIImageView!
    
    @IBOutlet weak var detailedImageContainer: UIView!
    @IBOutlet weak var ProjectView: UIView!
    @IBOutlet weak var DetailedView: UIView!
    
    @IBOutlet weak var quickActionButton: UILabel!
    @IBOutlet weak var selectDeselectButton: UIButton!
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    let menuList : [String] = ["Marge", "Split" , "Trim" , "Crop" , "GIF" , "Volume"]
    
    var projectItem = ProjectModel()
    var mainView = ViewController()
    
    var recordingIndex = [Int]()
    var videoProjectIndex = [Int]()
    var viewListGrid : Bool = true
    var menuViewTag = 0
    var isEditingEnabled : Bool = false
    var selectOn : Bool = true
    var allSelectedState : [Bool] = [false , false , false]
    var deleteIndex = [Int]()
    
    
    var initialContentOffset: CGFloat = 0.0
    var initConstant : CGFloat = 0.0
    var alreadyScrolled : CGFloat = 0.0
    var scrolledDistance : CGFloat = 0.0
    var accumulatedScrollOffset: CGFloat = 0.0
    var initialPanPoint: CGPoint?
    var lastPanLocation: CGPoint?
    var lastPanTime: Date?
    var collapsedMaxHeight : CGFloat = 0.0
    var lastSelectedIndex : Int!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var initialView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var detailedTitle: UILabel!
    @IBOutlet weak var detailedSize: UILabel!
    @IBOutlet weak var detailedDate: UILabel!
    @IBOutlet weak var detailedDescriptionView: UIView!
    @IBOutlet weak var collapsedView: UIView!
    @IBOutlet weak var collapsedHeight: NSLayoutConstraint!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var allProjectView: UIView!
    @IBOutlet weak var insideContent: UIView!
    
    var delegate : DeleteProtocol?
    var preDis : CGFloat = 0.0
    var upDirection : Int = -1
    var mxHeight : CGFloat = 0.0
    var reachedBottom = false
    var reachedTop = false
    var alreadyDealed = false
    var projectViewHeight : CGFloat = 0.0
    var projectViewWidth : CGFloat = 0.0
    
    var cellHeight : CGFloat = 0.0
    var cellWidth : CGFloat = 0.0
    var contWidth : CGFloat = 0.0
    var contheight : CGFloat = 0.0
    var xPosition : CGFloat = 0.0
    var yPosition : CGFloat = 0.0
    var upHeight : CGFloat = 0.0
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        initSetting()
        projectMenuCollectionManager()
        projectItemCollectionManager()
        projectMenuLocating()
        resetFilterButton()
        constructButton(firButton, "All", "NavBarColorActive", "Poppins-Medium", "NavBarColorActive" )
        
        filterVideos()
        
    
    }
    
    
    //MARK: - INIT CONFIG
    func initSetting(){
        
        
//        projectItemCollection.isScrollEnabled = false
//        
//        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        allProjectView.addGestureRecognizer(panGesture)
        collapsedMaxHeight = collapsedView.frame.size.height
    
        setGradientFill(applyView: createProjectButton, cornerRadius: 13, colors: [UIColor(named: "grad1")?.cgColor,UIColor(named: "grad2")?.cgColor])
       
        firButton.tag = 0
        secButton.tag = 1
        tirButton.tag = 2
        selectedView.isHidden = true
        DetailedView.isHidden = true
        detailedImageView.layer.cornerRadius = 16
        detailedImageContainer.layer.cornerRadius = 16
        
        detailedImageContainer.layer.shadowColor = UIColor.black.cgColor
        detailedImageContainer.layer.shadowOpacity = 0.5
        detailedImageContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        detailedImageContainer.layer.shadowRadius = 4
        
        
        upperView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOne)))
        lowerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapTwo)))
        
    }
    
    
    
    //MARK: - Scrolling Handle
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let velocity = gestureRecognizer.velocity(in: allProjectView)
        
        if gestureRecognizer.state == .began {
           //print(" Began ")
            preDis = 0.0
            mxHeight = projectItemCollection.contentSize.height
        }
        
        if gestureRecognizer.state == .changed {
            //print(" Changed ")

            let position = gestureRecognizer.translation(in: allProjectView)
            let crossedDistance = abs(position.y - preDis)
            
            
           // print(preDis , position.y )
            
            if preDis > position.y {
               //print(" Up ")
                upDirection = 1
                
                if collapsedHeight.constant-crossedDistance > 0 {
                    
                    //print(" Not Collapsed yet  " , crossedDistance)
                    collapsedHeight.constant -= crossedDistance
                    quickActionButton.alpha =  collapsedHeight.constant / collapsedMaxHeight
 
                    
                } else {
                    
                   // print(" Collapsed ALREADY  ")
                    
                    collapsedHeight.constant = 0.0
                    quickActionButton.alpha = 0.0
                    
                    //print(projectItemCollection.contentOffset.y)
                    projectItemCollection.contentOffset = CGPoint(x: 0, y: projectItemCollection.contentOffset.y + crossedDistance )
                    
                    let bottomEdge = projectItemCollection.contentOffset.y + projectItemCollection.frame.size.height
                    reachedBottom = ( bottomEdge >= projectItemCollection.contentSize.height) ?  true : false
                        
                    
                }
                
                
                
                
            } else {
                //print(" Down ")
                upDirection = 2
                
                reachedTop = projectItemCollection.contentOffset.y  > 0.0 ? false : true
                
            
                
               // print( projectItemCollection.contentOffset.y , crossedDistance )
                
                if  !reachedTop {
                   // print( " I am scrolling View ")
                    projectItemCollection.contentOffset = CGPoint(x: 0, y: projectItemCollection.contentOffset.y - crossedDistance )
                } else {
                   // print(" Already Top Visible ... Open Collapse " ,  projectItemCollection.contentOffset.y , collapsedHeight.constant , crossedDistance )
                    projectItemCollection.contentOffset = CGPoint(x: 0, y: projectItemCollection.contentOffset.y )
                    if collapsedHeight.constant+crossedDistance < collapsedMaxHeight {
                        collapsedHeight.constant+=crossedDistance
                        quickActionButton.alpha = collapsedHeight.constant/collapsedMaxHeight
                    } else {
                        collapsedHeight.constant = collapsedMaxHeight
                        quickActionButton.alpha = 1.0
                    }
                    
                }
                
               // print(projectItemCollection.contentOffset.y , " inside Down " )
                
                
            }

            preDis = position.y
        }
        
        
        if gestureRecognizer.state == .ended {
            print(" Ended ")
            
            let speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
            print("Speed: \(speed) points per second")
            
            
            DispatchQueue.main.async {
            
               // self.projectItemCollection.isScrollEnabled = true
            }
//
//            if speed > 0 {
//                var distance = speed*0.3
//                if upDirection == 2 {
//                    distance *= (-1)
//                } else  if upDirection == 1 {
//                    
//                    
//    
//                projectItemCollection.setContentOffset(CGPoint(x: 0, y: projectItemCollection.contentOffset.x+distance), animated: true )
//                        
//                    
//                    
//                }
//                
//            }
            
            
            if reachedBottom {
                let bottomOffset = CGPoint(x: 0, y: max( projectItemCollection.contentSize.height - projectItemCollection.bounds.size.height, 0))
                projectItemCollection.setContentOffset(bottomOffset, animated: true )
                reachedBottom = false
            }
            
            if upDirection == 1 && collapsedHeight.constant > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.collapsedHeight.constant = 0.0
                    self.ProjectView.layoutIfNeeded()
                    self.quickActionButton.alpha = 0.0
                })
            }
            
            if reachedTop == false {
                projectItemCollection.reloadData()
            }
            
           // print( upDirection , collapsedHeight.constant , reachedTop , " Ended Detailes ")
            
            if upDirection == 2 && collapsedHeight.constant < collapsedMaxHeight && reachedTop {
                
                self.projectMenuCollection.reloadData()
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.collapsedHeight.constant = self.collapsedMaxHeight
                    self.ProjectView.layoutIfNeeded()
                    self.quickActionButton.alpha = 1.0
                })
                
                reachedTop = false
                
            }
           
        }
        
    }
    
   


    
    //MARK: - Detailed View
    @objc func handleTapOne(){
        actionToBack()
    }
    @objc func handleTapTwo(){
        actionToBack()
    }
    func actionToBack(){
            UIView.animate(withDuration: 0.3, animations: {
                self.detailedContentView.transform = CGAffineTransform(scaleX: self.cellWidth/self.contWidth, y: self.cellHeight/self.contheight).concatenating(CGAffineTransform(translationX: self.xPosition-(self.contWidth/2)+(self.cellWidth/2), y: self.yPosition-self.upHeight-(self.contheight/2)+(self.cellHeight/2)))
            }, completion: { [self]_ in
                delegate?.backToProjectFromDetails()
                DetailedView.isHidden = true
                ProjectView.isHidden = false
                detailedContentView.transform = .identity
        })
    }
    
    
    
    
    //MARK: - Editing Menu
    
    @IBAction func itemFilter(_ sender: UIButton) {
        menuViewTag =  sender.tag
        selectDeselectCustomize(allSelectedState[sender.tag])
        projectItemCollection.reloadData()
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if projectItem.projectItemImage.count > 0 {
            
            initialView.isHidden = true
            selectedView.isHidden = false
            
            selectButtonCustomize()
            
            allSelectedState = [false , false , false]
            
            isEditingEnabled = true
            
            projectItemCollection.reloadData()
            
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        initialView.isHidden = false
        selectedView.isHidden = true
        
        isEditingEnabled = false
        selectOn = true
        
        deleteIndex.removeAll()
        delegate?.deleteit(deleteIndex,projectItem.projectItemImage.count)
        projectItemCollection.reloadData()
    }
    @IBAction func selectDeselectButtonPressed(_ sender: UIButton) {
        
        //        print(menuViewTag , " selection , menu ")
        if menuViewTag == 0 {
            if allSelectedState[0] {
                allSelectedState = [false , false , false ]
            } else {
                allSelectedState = [true, true ,true ]
            }
        } else {
            allSelectedState[menuViewTag].toggle()
            if allSelectedState[1] == true && allSelectedState[2] == true {
                allSelectedState[0] = true
            } else if allSelectedState[1] == false || allSelectedState[2] == false {
                allSelectedState[0] = false
            }
        }
        //        print(allSelectedState)
        
        if allSelectedState[menuViewTag] {
            populateDeleteArray()
            deSelectButtonCustomize()
            
        } else {
            if menuViewTag == 1 {
                removeFromDeleteArray(recordingIndex)
            } else if menuViewTag == 2 {
                removeFromDeleteArray(videoProjectIndex)
            } else {
                deleteIndex.removeAll()
            }
            selectButtonCustomize()
        }
        
        delegate?.deleteit(deleteIndex,projectItem.projectItemImage.count)
        projectItemCollection.reloadData()
    }
    
    func deleteTriggered(_ trig : Bool , _ detailed : Bool ){
        
        //        print(deleteIndex, " Finally Deleted ")
        
        if let selected = lastSelectedIndex , detailed {
            deleteIndex.append(selected)
           // print(deleteIndex)
        } else {
           // print("Project")
        }
        
//        if detailed {
//           // print("Found True ")
//        }
        
        deleteIndex.sort()
        deleteIndex.reverse()
        
        //print(deleteIndex, " Sorted Finally Deleted ")
        
        
        for index in deleteIndex {
            projectItem.projectItemImage.remove(at: index)
            projectItem.projectItemTitle.remove(at: index)
            projectItem.projectItemSize.remove(at: index)
            projectItem.flag.remove(at: index)
        }
        
        if detailed {
            ProjectView.isHidden = false
            DetailedView.isHidden = true 
            lastSelectedIndex = nil
        }
        
        
        
        if projectItem.projectItemImage.count == 0 {
            initialView.isHidden = false
            selectedView.isHidden = true
            selectButton.isEnabled = false
        }
        
        deleteIndex.removeAll()
        recordingIndex.removeAll()
        videoProjectIndex.removeAll()
        delegate?.deleteit(deleteIndex,projectItem.projectItemImage.count)
        filterVideos()
        
        
        allSelectedState = [false,false,false]
        selectDeselectCustomize(allSelectedState[menuViewTag])

        projectItemCollection.reloadData()
        
    }
    func filterVideos() {
        var k = 0
        for item in projectItem.flag {
            item ? recordingIndex.append(k) : videoProjectIndex.append(k);
            k += 1
        }
    }
    func removeFromDeleteArray(_ arr : [Int]){
        for item in arr {
            if deleteIndex.contains(item) {
                deleteIndex.removeAll{$0 == item }
            }
        }
    }
    func insertIntoDeleteArray (_ arr : [Int] ){
        for index in arr {
            if deleteIndex.contains(index) == false {
                deleteIndex.append(index)
            }
        }
    }
    func populateDeleteArray(){
        if menuViewTag == 0 {
            var index = 0
            for _ in projectItem.projectItemImage {
                if deleteIndex.contains(index) == false {
                    deleteIndex.append(index)
                }
                index+=1
            }
        } else if menuViewTag == 1 {
            insertIntoDeleteArray(recordingIndex)
        } else {
            insertIntoDeleteArray(videoProjectIndex)
        }
    }
    func selectDeselectCustomize ( _ state : Bool ){
        if state {
            deSelectButtonCustomize()
        } else {
            selectButtonCustomize()
        }
    }
    func selectButtonCustomize() {
        selectDeselectButton.setTitle("Select all", for: .normal)
        selectDeselectButton.setImage(UIImage(named: "checkmarkColorBlank"), for: .normal)
    }
    func deSelectButtonCustomize() {
        selectDeselectButton.setTitle("Deselect all", for: .normal)
        selectDeselectButton.setImage(UIImage(named: "checkmarkColorFillBlank"), for: .normal)
    }
    
    
    @IBAction func filterTouchDown(_ sender: UIButton){
        addHaptic()
    }
    @IBAction func filterTouchUp(_ sender: UIButton) {
        resetFilterButton()
        var buttonTitle = "All"
        if sender.tag == 1 {
            buttonTitle =  "Screen Recording"
        } else if sender.tag == 2 {
            buttonTitle = "Video Projects"
        }
        constructButton(sender, buttonTitle , "NavBarColorActive", "Poppins-Medium", "NavBarColorActive" )
    }
    
    func constructButton(_ btn : UIButton , _ t : String ,_ fontColor : String ,_ fontName : String ,_ buttonBorderColor : String ) {
        let attributedText = NSMutableAttributedString(string: t )
        let customFont = UIFont(name: fontName , size: 12.0)
        attributedText.addAttribute(NSAttributedString.Key.font, value: customFont ?? UIFont(name: fontName, size: 12.0), range: NSRange(location: 0, length: attributedText.length))
        let customColor = UIColor(named: fontColor )
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: customColor, range: NSRange(location: 0, length: attributedText.length))
        btn.setAttributedTitle(attributedText,for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 1.5
        btn.layer.cornerRadius = 16
        btn.layer.borderColor = UIColor(named:  buttonBorderColor )?.cgColor
    }
    

    func resetFilterButton() {
        let buttonList : [UIButton] = [firButton,secButton,tirButton]
        let buttonTitle : [String] = ["All", "Screen Recording", "Video Projects"]
        var i : Int = 0
        for btn in buttonList {
            constructButton(btn, buttonTitle[i], "fontColorDark", "Poppins-Regular", "borderFilter" )
            i+=1
        }
    }
    
    //MARK: - Collection View Part
    func projectMenuLocating() {
        projectMenuCollection.reloadData()
        projectMenuCollection.scrollToItem(at: IndexPath(item: 0 , section: 0), at: .centeredHorizontally , animated: true)
    }
    func projectItemCollectionManager() {
        projectItemCollection.dataSource = self
        projectItemCollection.delegate = self
        projectItemCollection.collectionViewLayout = projectItemCollectionFlow
        
        projectItemCollection.register(UINib(nibName: "ProjectGridItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "projectGridItemCell")
        
        projectItemCollection.register(UINib(nibName: "ProjectListItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "projectListItemCell")
        
        
        
        projectItemCollectionFlow.scrollDirection = .vertical
        projectItemCollectionFlow.collectionView?.showsVerticalScrollIndicator = false
        projectItemCollectionFlow.collectionView?.showsHorizontalScrollIndicator = false
        projectItemCollectionFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        projectItemCollectionFlow.minimumLineSpacing = 16
        projectItemCollectionFlow.minimumInteritemSpacing = 0
    }
    func projectMenuCollectionManager(){
        projectMenuCollection.dataSource = self
        projectMenuCollection.delegate = self
        projectMenuCollection.collectionViewLayout = projectMenuCollectionFlow
        
        
        projectMenuCollection.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "projectMenuCell")
        
        
        
        projectMenuCollectionFlow.scrollDirection = .horizontal
        projectMenuCollectionFlow.collectionView?.showsVerticalScrollIndicator = false
        projectMenuCollectionFlow.collectionView?.showsHorizontalScrollIndicator = false
        projectMenuCollectionFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        projectMenuCollectionFlow.minimumLineSpacing = 0
        projectMenuCollectionFlow.minimumInteritemSpacing = 0
        
    }
    func setGradientFill(applyView: UIButton , cornerRadius : Int , colors : [CGColor?]){
        
        DispatchQueue.main.async {
            applyView.setImage(UIImage(named: "add"), for: .normal)
            
            applyView.layer.cornerRadius = CGFloat(cornerRadius)
            let gradient = CAGradientLayer()
            
            gradient.frame = applyView.bounds
            
            
            gradient.cornerRadius = CGFloat(cornerRadius)
            gradient.colors = colors as [Any]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            applyView.layer.insertSublayer(gradient, at: 0)
            
            
        }
        
    }
    
    //MARK: - Haptic FeedBack
    
    func addHaptic(){
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
    
    //MARK: - TEST PHASE
    @IBAction func touchDown(_ sender: UIButton) {
        addHaptic()
        sender.adjustsImageWhenHighlighted = false
        UIView.animate(withDuration: 0.2 , animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    @IBAction func touchUP(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2 , animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    @IBAction func viewButtonTouchUp(_ sender: UIButton) {
        viewListGrid.toggle()
        
        projectItemCollection.reloadData()
    
      
        if viewListGrid {
            sender.setImage(UIImage(named: "grid"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "menu"), for: .normal)
        }
    }
    
}

//MARK: -  Collection View Delegate DataSource

extension ProjectCollectionViewCell : UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func editCellList(_ cell : ProjectListItemCollectionViewCell ,_ image : UIImage , _ titleText : String , _ sizeText : String , _ index : Int ) {
        
        cell.imageView.image = image
        cell.itemTitle.text = titleText
        cell.itemSize.text = sizeText
        
        if isEditingEnabled {
            if deleteIndex.contains(index) {
                cell.editButton.image = UIImage(named: "checkmarkColorFill")
               
            } else {
                cell.editButton.image = UIImage(named: "circleGray")
            }
        } else {
             cell.editButton.image = UIImage(named: "edit")
        }
    }
    func editCellGrid(_ cell : ProjectGridItemCollectionViewCell ,_ image : UIImage , _ titleText : String , _ sizeText : String , _ index : Int ) {
        
        cell.imageView.image = image
        cell.itemTitle.text = titleText
        cell.itemSize.text = sizeText
        
        if isEditingEnabled {
            if deleteIndex.contains(index) {
                cell.editButton.image = UIImage(named: "checkmarkColorFill")
            } else {
                cell.editButton.image = UIImage(named: "circle")
               
            }
        } else {
            cell.editButton.image = UIImage(named: "edit-round")
        }
    }
    func getIndex(_ index : Int )->Int{
        if menuViewTag == 0 {
            return   index
        } else if menuViewTag == 1 {
            return   recordingIndex[index]
        }
        return  videoProjectIndex[index]
    }
    func checkElementsForDelete(_ listOfElement : [Int] , _ tag : Int ){
        //print("inside : check ")
        //print(listOfElement, tag)
        for index in listOfElement {
            if deleteIndex.contains(index) == false {
                allSelectedState[tag] =  false
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == projectItemCollection {
            
            if menuViewTag == 0 {
                return projectItem.projectItemTitle.count
            } else if menuViewTag == 1 {
                return recordingIndex.count
            } else {
                return videoProjectIndex.count
            }
        } else {
            return menuList.count
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        if collectionView == projectItemCollection {
            
            
//            let frame = projectItemCollection.layoutAttributesForItem(at: indexPath)?.frame
//            let cellPosition = projectItemCollection.convert(frame?.origin ?? .zero, to: projectItemCollection.superview)
//            
//            print(cellPosition , " YoCell ")
            
            
            let index  = getIndex(indexPath.row)
            if viewListGrid {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectListItemCell", for: indexPath) as! ProjectListItemCollectionViewCell
                
                
                
                editCellList(cell,
                             UIImage(named: projectItem.projectItemImage[index])! ,
                             projectItem.projectItemTitle[index] ,
                             projectItem.projectItemSize[index] ,
                             index
                )
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectGridItemCell", for: indexPath) as! ProjectGridItemCollectionViewCell
                
                
                editCellGrid(cell,
                             UIImage(named: projectItem.projectItemImage[index])! ,
                             projectItem.projectItemTitle[index] ,
                             projectItem.projectItemSize[index] ,
                             index
                )
                return cell
                
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectMenuCell", for: indexPath) as! MenuCollectionViewCell
            cell.menuImage.image = UIImage(named: menuList[indexPath.row])
            cell.buttonLabel.text = menuList[indexPath.row]
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastSelectedIndex = getIndex(indexPath.row)
        if isEditingEnabled {
            let index = getIndex(indexPath.row)
            
            if deleteIndex.contains(index){
                deleteIndex.removeAll { $0 == index }
            } else {
                deleteIndex.append(index)
            }
            
            //            print(" deleteList : " , deleteIndex )
            if deleteIndex.count == projectItem.projectItemImage.count {
                allSelectedState = [true,true,true]
            } else {
                allSelectedState = [false,true,true]
                checkElementsForDelete(recordingIndex, 1)
                checkElementsForDelete(videoProjectIndex, 2)
            }
            selectDeselectCustomize(allSelectedState[menuViewTag])
            
            delegate?.deleteit(deleteIndex,projectItem.projectItemImage.count)
            projectItemCollection.reloadData()
            
        } else {
            
            if collectionView == projectItemCollection{
                
                delegate?.showDetailedNavigation()
                
                let index = getIndex(indexPath.row)

                
                if let cell = collectionView.cellForItem(at: indexPath) as? ProjectListItemCollectionViewCell {
                    if let imageView = cell.imageView{
                        cellWidth = imageView.frame.width
                        cellHeight = imageView.frame.height
                    }
                }
                

                
                detailedImageView.image = UIImage(named: projectItem.projectItemImage[index])
                detailedTitle.text = projectItem.projectItemTitle[index]
                detailedSize.text = projectItem.projectItemSize[index]
                detailedDate.text = "01/01/2024 - 1:05"
                DetailedView.isHidden = false
                ProjectView.isHidden = true
                
                
                xPosition =  allProjectView.frame.origin.x
                yPosition =   allProjectView.frame.origin.y
                
                let frame = projectItemCollection.layoutAttributesForItem(at: indexPath)?.frame
                let cellPosition = projectItemCollection.convert(frame?.origin ?? .zero, to: projectItemCollection.superview)
                
                upHeight = upperView.frame.height
                contheight = detailedContentView.frame.height
                contWidth =  detailedContentView.frame.width
                
                xPosition += cellPosition.x
                yPosition += cellPosition.y
            
                
                
                detailedContentView.transform = CGAffineTransform(scaleX: cellWidth/contWidth, y: cellHeight/contheight).concatenating(CGAffineTransform(translationX: xPosition-(contWidth/2)+(cellWidth/2), y: yPosition-upHeight-(contheight/2)+(cellHeight/2)))
                
                UIView.animate(withDuration: 0.2 ) {
                    self.detailedContentView.transform = .identity
                }
            }
            
        }
        
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
    
    
}


//MARK: - Flow Delegate

extension ProjectCollectionViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == projectItemCollection {
            let w = ProjectView.layer.frame.width
            let h = ProjectView.layer.frame.height
            
            //print(" Flow  Delegate Info ")
            //   print(w,h)
            
            if viewListGrid {
                return CGSize(width: w-32, height: h*88/759)
            }
            
            return CGSize(width: w*183/w, height: h*212/759)
            
        } else if collectionView == projectMenuCollection {
         
            let w = ProjectView.layer.frame.width
       
            //print(w*76/(w-4),h , " Debug with Menu ")
            return CGSize(width: w*76/(w-4), height: collectionView.layer.frame.height)
            
        }
        
        return CGSize(width: 0, height: 0)
    }
}

extension ProjectCollectionViewCell : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == projectItemCollection {
            print("Scrolling started!")
            preDis = 0.0
            reachedBottom == false
            alreadyDealed = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == projectItemCollection {
            
            print(scrollView.contentOffset.y)
            
            if( scrollView.contentOffset.y  <= 0.0 && collapsedHeight.constant >=  162 ) {
                upDirection = -1
            } else {
                
                if collapsedHeight.constant >=  0 &&  scrollView.contentOffset.y > 0.0  {
                    collapsedHeight.constant -= scrollView.contentOffset.y
                    self.quickActionButton.alpha = collapsedHeight.constant / 162
                    upDirection =  1
                    scrollView.contentOffset = CGPoint(x: 0, y: 0)
                } else if collapsedHeight.constant < 162 && scrollView.contentOffset.y < 0.0  {
                    collapsedHeight.constant += (scrollView.contentOffset.y*(-1))
                    self.quickActionButton.alpha = collapsedHeight.constant / 162
                    upDirection =  2
                    scrollView.contentOffset = CGPoint(x: 0, y: 0)
                } else {
                    if scrollView.contentOffset.y > preDis {
                        upDirection =  1
                    } else if scrollView.contentOffset.y < preDis  {
                        upDirection =  2
                    }
                }
                
                preDis = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height
                let yOffset = scrollView.contentOffset.y
                let scrollViewHeight = scrollView.frame.size.height
                if yOffset + scrollViewHeight >= contentHeight {
                    reachedBottom = true
                }
            }
            
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(" Stopped Hereeeeeeee ")
        alreadyDealed = true
        print(upDirection, collapsedHeight.constant , reachedBottom , projectItemCollection.contentOffset.y, " Final details DEAC  ")
        levelCollapsedView()
        reachedBottom = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if alreadyDealed == false {
            print("Ended Dragging ")
            print(upDirection, collapsedHeight.constant , reachedBottom , projectItemCollection.contentOffset.y , " Final details END DRAG ")
            levelCollapsedView()
            
            reachedBottom = false
        }
        
    }
    
    
    func levelCollapsedView(){
        if upDirection == 1 && collapsedHeight.constant > 0 && reachedBottom == false{
            print(" Up Move ")
            UIView.animate(withDuration: 0.2 , animations: {
                self.collapsedHeight.constant = 0
                self.ProjectView.layoutIfNeeded()
                self.quickActionButton.alpha = 0.0
            })
        } else if upDirection == 2  && collapsedHeight.constant < 162 && reachedBottom == false && projectItemCollection.contentOffset.y <= 0{
            print("Down Move ")
            UIView.animate(withDuration: 0.2 , animations: {
                self.collapsedHeight.constant = 162
                self.ProjectView.layoutIfNeeded()
                self.quickActionButton.alpha = 1.0
            })
            projectMenuCollection.reloadData()
        }
    }
    
    
    
}

