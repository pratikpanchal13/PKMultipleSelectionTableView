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
    
    public var backgroundColorHeaderView: UIColor       = UIColor.init(colorLiteralRed: 76.0/255.0, green: 82.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    public var backgroundColorDoneButton: UIColor       = UIColor.init(colorLiteralRed: 87.0/255.0, green: 188.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    public var backgroundColorTableView: UIColor        = UIColor.init(colorLiteralRed: 59.0/255.0, green: 65.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    public var backgroundColorSelectALlTitle: UIColor   = UIColor.white
    public var backgroundColorCellTitle: UIColor        = UIColor.init(colorLiteralRed: 87.0/255.0, green: 188.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    public var backgroundColorDoneTitle: UIColor        = UIColor.white



    

    
    
    public var passingDataToHomeVC: NSMutableArray = []     //PKMultipleSelectionVC
    
    var isSelectAll : Bool = false

    public var invitedUsers:( _ data : String, _ index:NSMutableArray)->() = {_ in}


    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnDone: UIButton!
    
    //Public Local Variable Declaration
    
    public var arrContent: NSMutableArray = []
    public var selectedData: NSMutableArray = []
    
    
    //MARK:- View Life Cycle
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        arrContent = ["Mac","Iphone","IWatch","IPad","IPod","IMac"]
//        arrContent = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        
        self.config()
        tblView.allowsMultipleSelection = true
        tblView.tableFooterView = UIView(frame: .zero)
    }
    
    
    func config()
    {
        self.tblView.backgroundColor = backgroundColorTableView
        self.btnSelectAll.setTitleColor(backgroundColorSelectALlTitle, for: UIControlState.normal)
        self.viewHeader.backgroundColor = backgroundColorHeaderView
        self.btnDone.backgroundColor = backgroundColorDoneButton
        self.btnDone.setTitleColor(backgroundColorDoneTitle, for: UIControlState.normal)
        
    }
    
   public func setDataForMultipleSelection(data : [Any]){
        
        arrContent.addObjects(from: data)

        print("arrContent is \(arrContent)")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        selectedData.addObjects(from: objGetHomeVCData)
        
        for i in objGetHomeVCData {
            let indexPath = IndexPath(row: i, section: 0)
            tblView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
        
        if(selectedData.count == arrContent.count){
            btnSelectAll.setImage(UIImage(named: "Check"), for: UIControlState.normal)
            isSelectAll = !isSelectAll;
        }
        
        
        self.tblView.reloadData()
    }

    
    //MARK: - Button Action
    @IBAction func btnBackClicked(_ sender: Any) {
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func btnSelectALL(_ sender: Any) {

        selectedData.removeAllObjects()
        
        if(!isSelectAll)
        {
            for i in arrContent {
                
                selectedData.add(arrContent.index(of: i))
            }
        }
        
        print("Selected Data \(selectedData)")
        
        let aStrImg:String = !isSelectAll ? "Check": "unCheck"
        btnSelectAll.setImage(UIImage(named:aStrImg), for: UIControlState.normal)
        isSelectAll = !isSelectAll
        tblView.reloadData()
        
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
        
        let strData = passingDataToHomeVC.componentsJoined(by: ",")
        self.invitedUsers(strData, selectedData)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrContent.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell
        cell?.lblName.text = arrContent[indexPath.row] as? String
        let aStrImg:String = selectedData.contains((indexPath.row)) ? "Check": "unCheck"
        let image: UIImage =  UIImage(named: aStrImg)!;
        cell?.imgVewCheckUnckeck.image = image;
        cell?.contentView.backgroundColor = backgroundColorTableView
        cell?.lblName.textColor = backgroundColorCellTitle
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
        
        if(isSelectAll && selectedData.count != arrContent.count){
            btnSelectAll.setImage(UIImage(named: "unCheck"), for: UIControlState.normal)
            isSelectAll = !isSelectAll;
        }else if(selectedData.count == arrContent.count){
            btnSelectAll.setImage(UIImage(named: "Check"), for: UIControlState.normal)
            isSelectAll = !isSelectAll;
        }
        
        

        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
}
