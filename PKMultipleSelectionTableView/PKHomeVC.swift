//
//  PKHomeVC.swift
//  PKMultipleSelectionTableView
//
//  Created by indianic on 29/03/17.
//  Copyright © 2017 pratik. All rights reserved.
//

import UIKit

class PKHomeVC: UIViewController {
    
    
    public var inedexPass = [Int]()
    public var arrContentData = [String]()
    
    @IBOutlet weak var btnClickMe: UIButton!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getIndexWithValue), name: NSNotification.Name("notify"), object: nil)
        
    }
 
    //MARK:- Get Notification Selected Indexes
    func getIndexWithValue(notification : NSNotification)
    {
        let UserData = notification.object as! NSDictionary
        
        arrContentData  = (UserData["Data"])! as! [String]
        inedexPass  = (UserData["indexPath"])! as! [Int]
        
        let string = arrContentData.joined(separator: ",")                  // Seperate String From Array
        btnClickMe.setTitle(string, for: UIControlState.normal)             // Set Title
        
        
    }
    
    
    //MARK:- Button Action
    @IBAction func btnClickMeOpen(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objMultipleSelectionVC:PKMultipleSelectionVC = storyboard.instantiateViewController(withIdentifier: "PKMultipleSelectionVC") as! PKMultipleSelectionVC
        
        objMultipleSelectionVC.objGetHomeVCData = inedexPass // If you want to pass value
        objMultipleSelectionVC.objGetHomeVCIndexes = arrContentData // If you want to pass value
        
        
        if let returnValue = UserDefaults.standard.object(forKey: "indexPath") as? Int {
            objMultipleSelectionVC.objGetHomeVCData = [returnValue]
            objMultipleSelectionVC.objGetHomeVCIndexes = arrContentData
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        objMultipleSelectionVC.view.frame = CGRect(x: screenSize.origin.x, y: screenSize.origin.y, width: screenSize.width * 1, height: screenSize.height * 1)
        
        
        let transition = CATransition()
        transition.duration = 0.1
        //        transition.type = kCAAnimationPaced
        //        transition.subtype = kCATransitionFade
        
        self.view!.layer.add(transition, forKey: kCATransition)
        
        objMultipleSelectionVC.willMove(toParentViewController: self)
        self.view.addSubview(objMultipleSelectionVC.view)
        self.addChildViewController(objMultipleSelectionVC)
        objMultipleSelectionVC.didMove(toParentViewController: self)
    }

}
