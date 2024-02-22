//
//  MoreToolsViewController.swift
//  projectOneAlt
//
//  Created by Xotech on 17/01/2024.
//

import UIKit

class MoreToolsViewController: UIViewController {

    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var addMusicButton: UIButton!
    @IBOutlet weak var extractButton: UIButton!
    @IBOutlet weak var voiceOverButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var topBar: UIView!
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.layer.cornerRadius = 2
        eightButton.isEnabled = false
        
        monitorShadow()
    }
    
    
    func monitorShadow() {
        shadowMonitor(liveButton)
        shadowMonitor(faceButton)
        shadowMonitor(videoButton)
        shadowMonitor(addMusicButton)
        shadowMonitor(extractButton)
        shadowMonitor(voiceOverButton)
        shadowMonitor(sevenButton)
        shadowMonitor(eightButton)
    
    }
    
    func shadowMonitor(_ myButton : UIButton! ) {
        myButton.frame = CGRect(x: 0, y: 0, width: 118, height: 104)
        myButton.layer.shadowColor = UIColor.lightGray.cgColor
        myButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        myButton.layer.shadowRadius = 5.0
        myButton.layer.shadowOpacity = 0.25
        myButton.layer.masksToBounds = false
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
    
    
    

}
