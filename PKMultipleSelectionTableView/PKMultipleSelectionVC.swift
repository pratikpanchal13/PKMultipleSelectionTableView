//
//  PKMultipleSelectionVC.swift
//  PKMultipleSelectionTableView
//
//  Created by indianic on 29/03/17.
//  Copyright © 2017 pratik. All rights reserved.
//

import UIKit

class PKMultipleSelectionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Public Variable Declaration For Data Passing
    public var objGetHomeVCData: [Int] = []                       // HomeVC
    public var objGetHomeVCIndexes: [String] = []                     // HomeVC
    
    public var passingDataToHomeVC: NSMutableArray = []     //PKMultipleSelectionVC


    @IBOutlet weak var tblView: UITableView!
    
    //Public Local Variable Declaration
    
    public var arrContent: NSMutableArray = []
    public var selectedData: NSMutableArray = []
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        arrContent = ["Mac","Iphone","IWatch","IPad","IPod","IMac"]
        tblView.allowsMultipleSelection = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        selectedData.addObjects(from: objGetHomeVCData)
        
        for i in objGetHomeVCData {
            let indexPath = IndexPath(row: i, section: 0)
            tblView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
        self.tblView.reloadData()
    }

    
    //MARK: - Button Action
    @IBAction func btnBackClicked(_ sender: Any) {
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
    
        UserDefaults.standard.set(selectedData, forKey: "indexPath")
        UserDefaults.standard.synchronize()
        print("Data is \(selectedData)")
        
        for i  in selectedData {
            
            passingDataToHomeVC.add(arrContent[i as! Int])
        }
        
        print("passingData \(passingDataToHomeVC)")
        
        let myDict = [ "Data": passingDataToHomeVC, "indexPath":selectedData] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notify"), object: myDict)
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    //MARK: - View Touch Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

}

// TableView Cell
class Cell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVewCheckUnckeck: UIImageView!
    
}


// Tableview Data Source & Delegate Method
extension PKMultipleSelectionVC{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrContent.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell
        cell?.lblName.text = arrContent[indexPath.row] as? String
        let aStrImg:String = selectedData.contains((indexPath.row)) ? "Check": "unCheck"
        let image: UIImage =  UIImage(named: aStrImg)!;
        cell?.imgVewCheckUnckeck.image = image;
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedData.contains(indexPath.row){
            let index  = indexPath.row
            selectedData.remove(index)
        }else{
            let index  = indexPath.row
            selectedData.add(index)
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
}
