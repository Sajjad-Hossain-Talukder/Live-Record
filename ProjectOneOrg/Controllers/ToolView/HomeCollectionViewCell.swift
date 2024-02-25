//
//  HomeCollectionViewCell.swift
//  ProjectOneOrg
//
//  Created by Xotech on 21/01/2024.
//

import UIKit
import StoreKit


class HomeCollectionViewCell: UICollectionViewCell, SKStoreProductViewControllerDelegate{
    
    @IBOutlet weak var buttonOne : UIButton!
    @IBOutlet weak var buttonTwo : UIButton!
    @IBOutlet weak var buttonThree : UIButton!
    @IBOutlet weak var buttonFour : UIButton!
    @IBOutlet weak var buttonFive : UIButton!
    @IBOutlet weak var buttonSix : UIButton!
    
    @IBOutlet weak var pro : UIButton!
    @IBOutlet weak var set : UIButton!
    @IBOutlet weak var mid : UIButton!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var screenRecord: UILabel!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionFlow: UICollectionViewFlowLayout!
    
    var startDis : CGFloat = 0.0
    var endDis : CGFloat = 0.0
    var preDis : CGFloat = 0.0
    var curElement : Int = 1
    var fetchElement : Int = 0
    var totalElement : Int?
    var bannerUIImage =  [UIImage]()
    var bannerLink = [String?]()
    var isAutoScrollingEnabled : Bool = true
    var autoscrollTimer: Timer?
    let urlString = "https://app.kinggamesstudio.net/api/admin/cross-promotions/1"
    var delegate : DeleteProtocol?
    var bannerCount = 100
    var firstTerm : CGFloat = 0.0
    var eachTerm : CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        performRequest()
        screenRecordText()
        addShadowToButton()
        bannerCollectionManager()
        bannerCollectionView.isScrollEnabled = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        bannerView.addGestureRecognizer(panGesture)
        
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
       
        let velocity = gestureRecognizer.velocity(in: bannerView)
                
        if gestureRecognizer.state == .began {
            print(" Paan Started ")
            preDis = 0.0
            isAutoScrollingEnabled = false
            stopAutoscrolling()
            startDis = bannerCollectionView.contentOffset.x
            
            print(firstTerm,eachTerm)
            
            if Int(startDis-357)%376 != 0 {
                print(" Yahooo return ing from Tap - ", startDis )
                return
            }
            
            
            
        }
        
        if gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: bannerView.superview)
            var crossedDis = abs(translation.x-preDis)
            let pos =  bannerCollectionView.contentOffset.x
            
            if preDis < translation.x {
                crossedDis *= (-1)
            }
            bannerCollectionView.contentOffset = CGPoint(x: pos+crossedDis, y: 0)
            
            preDis = translation.x
        }
        
        if gestureRecognizer.state == .ended {
            
            var w : CGFloat = 0
            let contentWidth = bannerCollectionView.frame.size.width
            endDis = bannerCollectionView.contentOffset.x
            
            for indexPath in bannerCollectionView.indexPathsForVisibleItems {
                if let cell = bannerCollectionView.cellForItem(at: indexPath) {
                    w = cell.frame.width
                    break
                }
            }
            
            print(" Gesture ended ")
            print(startDis, endDis)
            
           
            let speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
            print("Speed: \(speed) points per second")
            
            if speed > 100 {
                if startDis < endDis {
                    nextBanner()
                } else {
                    previousBanner()
                }
            } else {
            
                let crossed = abs(endDis-startDis)
                let vis = (contentWidth-w)/2 - 8
                let temp = w/2
                
                
                if startDis < endDis  && (vis+crossed) >= temp  {
                    nextBanner()
                } else if startDis > endDis && (vis+crossed) >= temp {
                    previousBanner()
                } else {
                    locateBanner()
                }
            
            }
            
            
            isAutoScrollingEnabled = true
            startAutoscrolling()
            
        }
    }
    
    func nextBanner(){
        bannerCount += 1
        locateBanner()
    }
    
    func previousBanner(){
        bannerCount -= 1
        locateBanner()
    }
    
    func locateBanner(){
        bannerCollectionView.setContentOffset(CGPoint(x:   firstTerm+CGFloat(bannerCount)*eachTerm, y: 0), animated: true )
    }
    
    //MARK: - Auto Scroll
    
    func startAutoscrolling() {
        autoscrollTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoscrolling), userInfo: nil, repeats: true)
    }
    
    func stopAutoscrolling() {
        autoscrollTimer?.invalidate()
        autoscrollTimer = nil
    }
    
    
    
    @objc func autoscrolling() {
        
        guard isAutoScrollingEnabled else {
            return
        }
        nextBanner()
    }
    
    
    //MARK: - API Fetch Banner Image
    
    func performRequest(){
        let url = URL(string: urlString)
        
        if let safeURL = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeURL) { data, response, error in
                if error != nil {
                    //print(error)
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        self.parseJSONData(safeData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONData(_ safeData : Data ){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BannerDecoder.self, from: safeData)
            
            DispatchQueue.main.async {
                self.totalElement = decodedData.CrossPromotions.count
                for item in decodedData.CrossPromotions{
                    self.getImage(item.image_url)
                
                    if let safeURL = item.promotional_url {
                        self.bannerLink.append(safeURL)
                    } else {
                        self.bannerLink.append(nil)
                    }
                }
            }
            
           // print(bannerUIImage.count," - okay ")
         
            
        } catch {
            print(error)
        }
    }
    
    func getImage(_ urlString : String){
        let url = URL(string: urlString)
        if let safeURL = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeURL) { data, response, error in
                if error != nil {
                    print(error)
                }
                if let safeData = data {
                    let img = UIImage(data: safeData)
                    if let image = img {
                        DispatchQueue.main.async{
                            self.bannerUIImage.append(image)
                            self.fetchElement += 1
                            self.bannerCollectionView.reloadData()
                            self.bannerLocating()
                               
            
                            if self.fetchElement == self.totalElement {
                                self.startAutoscrolling()
                            }
                        
                        }
                    }
                }
            }
            task.resume()
        }
       // print(urlString , bannerUIImage.count)
    }
    
    
    //MARK: - Banner Manager


    func bannerLocating(){
        if bannerUIImage.count >= 2 {
            bannerCollectionView.scrollToItem(at: IndexPath(item: 100 , section: 0), at: .centeredHorizontally , animated: false )
            DispatchQueue.main.async {
                var w : CGFloat = 0
                for indexPath in self.bannerCollectionView.indexPathsForVisibleItems {
                    if let cell = self.bannerCollectionView.cellForItem(at: indexPath) {
                        w = cell.frame.width
                        break
                    }
                }
                self.firstTerm = self.bannerCollectionView.contentOffset.x - w*CGFloat(self.bannerCount)
                self.eachTerm = w
            }
        }
    }
    
    func bannerCollectionManager(){
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.collectionViewLayout = bannerCollectionFlow
    
        bannerCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        
        bannerCollectionFlow.scrollDirection = .horizontal
        bannerCollectionFlow.collectionView?.showsVerticalScrollIndicator = false
        bannerCollectionFlow.collectionView?.showsHorizontalScrollIndicator = false
        bannerCollectionFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bannerCollectionFlow.minimumLineSpacing = 0
        bannerCollectionFlow.minimumInteritemSpacing = 0
       
    }
    
    func screenRecordText () {
        screenRecord.textColor = UIColor(named: "fontColorDark")
        screenRecord.font = UIFont(name: "Poppins-Regular", size: 24)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.94
    
        screenRecord.attributedText = NSMutableAttributedString(string: "SCREEN RECORDING", attributes: [NSAttributedString.Key.kern: 0.48, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        screenRecord.font = UIFont(name: "Poppins-Regular", size: 24 )
        screenRecord.textAlignment = .center
    }
    

    //MARK: - SHADOW MONITOR

    func addShadowToButton(){
        shadowMonitor(buttonOne)
        shadowMonitor(buttonTwo)
        shadowMonitor(buttonThree)
        shadowMonitor(buttonFour)
        shadowMonitor(buttonFive)
        shadowMonitor(buttonSix)
    }
    
    func shadowMonitor(_ myButton : UIButton! ) {
        myButton.layer.shadowColor = UIColor.lightGray.cgColor
        myButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        myButton.layer.shadowRadius = 5.0
        myButton.layer.shadowOpacity = 0.25
        myButton.layer.masksToBounds = false
    }
    
    
    //MARK: - Haptic FeedBack
    
    func addHaptic(){
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
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
    
    
    //MARK: - Show App Details
    
}

//MARK: - Banner DataSource

extension HomeCollectionViewCell : UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCollectionViewCell
        var index = indexPath.row
        if fetchElement > 0  {
            index = index % fetchElement
        } else {
            return cell
        }
    
        cell.bannerView.image = bannerUIImage[index]

        return cell
    }
    
    
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        var index = indexPath.row
        
        if fetchElement > 0  {
            index = index % fetchElement
        }
        
        
        if var safeURLString = bannerLink[index] {
            print(safeURLString, index )
            
            let parts = safeURLString.components(separatedBy: "id")
            if let partAfterID = parts.last {
                print(partAfterID)
                delegate?.showAppDetails(appId: partAfterID)
            }
            
//            let url = URL(string: safeURLString)
//            if let safeURL = url {
//                UIApplication.shared.open(safeURL)
//            }
        }
        
    }
    

    
}

extension HomeCollectionViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = homeView.frame.size.height
        let w = homeView.frame.size.width
        
        //print(h,w , " Banner ")
        return CGSize(width: w*376/414, height: h*104/759)

    }
}
