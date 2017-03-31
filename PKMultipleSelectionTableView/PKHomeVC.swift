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
        
        if let returnValue = UserDefaults.standard.object(forKey: "data") as? String {
            self.btnClickMe.setTitle("\(returnValue)", for: UIControlState.normal)
            
        }
    }

    //MARK:- Button Action
    @IBAction func btnClickMeOpen(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objMultipleSelectionVC:PKMultipleSelectionVC = storyboard.instantiateViewController(withIdentifier: "PKMultipleSelectionVC") as! PKMultipleSelectionVC
        
//        objMultipleSelectionVC.arrContent = [1,2,3,4,5,6,7,8,9]  // Pass Array Data
        objMultipleSelectionVC.arrContent = ["IPhone","IMac","IPad","MacBook","IPod","MacMini","Apple TV"]  // Pass Array Data
        objMultipleSelectionVC.backgroundColorDoneButton = UIColor.green
        objMultipleSelectionVC.backgroundColorHeaderView = UIColor.purple
        objMultipleSelectionVC.backgroundColorTableView = UIColor.darkGray
        objMultipleSelectionVC.backgroundColorCellTitle = UIColor.yellow
        objMultipleSelectionVC.backgroundColorDoneTitle = UIColor.brown
        objMultipleSelectionVC.backgroundColorSelectALlTitle = UIColor.magenta

        
        // Get Selected Index from PKMultipleSelectionVC
        if let returnIndex = UserDefaults.standard.object(forKey: "indexPath") as? [Int] {
            objMultipleSelectionVC.objGetSelectedIndex = returnIndex
        }

        
        // Data Passing Usning Block
        objMultipleSelectionVC.passDataWithIndex = { arrayData, selectedIndex in
            self.btnClickMe.setTitle("\(arrayData)", for: UIControlState.normal)
            UserDefaults.standard.set(arrayData, forKey: "data")
            UserDefaults.standard.synchronize()
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
