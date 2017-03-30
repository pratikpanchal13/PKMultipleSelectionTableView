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
    
    var obj = PKMultipleSelectionVC()
    
    @IBOutlet weak var btnClickMe: UIButton!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getIndexWithData), name: NSNotification.Name("notify"), object: nil)
        
    }
 
    //MARK:- Get Notification Selected Indexes
    func getIndexWithData(notification : NSNotification)
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
        objMultipleSelectionVC.arrContent = ["1","2","3","4","5","6","7"]  // Pass Array Data
        
        objMultipleSelectionVC.backgroundColorDoneButton = UIColor.green
        objMultipleSelectionVC.backgroundColorHeaderView = UIColor.purple
        objMultipleSelectionVC.backgroundColorTableView = UIColor.darkGray
        objMultipleSelectionVC.backgroundColorCellTitle = UIColor.yellow
        objMultipleSelectionVC.backgroundColorDoneTitle = UIColor.brown
        objMultipleSelectionVC.backgroundColorSelectALlTitle = UIColor.magenta




        
        
        if let returnValue = UserDefaults.standard.object(forKey: "indexPath") as? Int {
            objMultipleSelectionVC.objGetHomeVCData = [returnValue]
            objMultipleSelectionVC.objGetHomeVCIndexes = arrContentData
        }
        
        
        // Data Passing Usning Block
        objMultipleSelectionVC.invitedUsers = { selectedUsers, index in
            print("data is \(selectedUsers)",index)
            self.btnClickMe.setTitle("\(selectedUsers)", for: UIControlState.normal)
        }
        
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
