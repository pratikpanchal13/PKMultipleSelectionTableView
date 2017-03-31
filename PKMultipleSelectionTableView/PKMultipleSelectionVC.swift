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
    public var objGetSelectedIndex: [Int] = []                       // HomeVC
    
    public var backgroundColorHeaderView: UIColor       = UIColor.init(colorLiteralRed: 76.0/255.0, green: 82.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    public var backgroundColorDoneButton: UIColor       = UIColor.init(colorLiteralRed: 87.0/255.0, green: 188.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    public var backgroundColorTableView: UIColor        = UIColor.init(colorLiteralRed: 59.0/255.0, green: 65.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    public var backgroundColorSelectALlTitle: UIColor   = UIColor.white
    public var backgroundColorCellTitle: UIColor        = UIColor.init(colorLiteralRed: 87.0/255.0, green: 188.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    public var backgroundColorDoneTitle: UIColor        = UIColor.white
    
    var isSelectAll : Bool = false
    public var passDataWithIndex:( _ arryData : Any, _ selectedIndex:NSMutableArray)->() = {_ in}

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnDone: UIButton!
    
    //Public Local Variable Declaration
    public var arrContent: NSMutableArray = []
    public var selectedIndex: NSMutableArray = []
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SetUpUI()   // Set UI
        
        tblView.allowsMultipleSelection = true
        tblView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedIndex.addObjects(from: objGetSelectedIndex)
        for i in objGetSelectedIndex {
            let indexPath = IndexPath(row: i, section: 0)
            tblView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
        if(selectedIndex.count == arrContent.count){
            btnSelectAll.setImage(UIImage(named: "Check"), for: UIControlState.normal)
            isSelectAll = !isSelectAll;
        }
        self.tblView.reloadData()
    }

    //MARK: - Set Up UI
    func SetUpUI()
    {
        self.tblView.backgroundColor = backgroundColorTableView
        self.btnSelectAll.setTitleColor(backgroundColorSelectALlTitle, for: UIControlState.normal)
        self.viewHeader.backgroundColor = backgroundColorHeaderView
        self.btnDone.backgroundColor = backgroundColorDoneButton
        self.btnDone.setTitleColor(backgroundColorDoneTitle, for: UIControlState.normal)
    }
    
    //MARK: - Button Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func btnSelectALL(_ sender: Any) {
        selectedIndex.removeAllObjects()
        if(!isSelectAll)
        {
            for i in arrContent {
                selectedIndex.add(arrContent.index(of: i))
            }
        }
        let aStrImg:String = !isSelectAll ? "Check": "unCheck"
        btnSelectAll.setImage(UIImage(named:aStrImg), for: UIControlState.normal)
        isSelectAll = !isSelectAll
        tblView.reloadData()
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        let passingDataToHomeVC: NSMutableArray = []
        for i  in selectedIndex {
            passingDataToHomeVC.add(arrContent[i as! Int])
        }
        
        let strData = passingDataToHomeVC.componentsJoined(by: ",")
        UserDefaults.standard.set(selectedIndex, forKey: "indexPath")
        UserDefaults.standard.synchronize()
    
        self.passDataWithIndex(strData, selectedIndex)  // Passing Data Using Blocks to Parent VC
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60.0;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContent.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell
        cell?.lblName.text = "\(arrContent[indexPath.row])"
        let aStrImg:String = selectedIndex.contains((indexPath.row)) ? "Check": "unCheck"
        let image: UIImage =  UIImage(named: aStrImg)!;
        cell?.imgVewCheckUnckeck.image = image;
        cell?.contentView.backgroundColor = backgroundColorTableView
        cell?.lblName.textColor = backgroundColorCellTitle
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex.contains(indexPath.row){
            let index  = indexPath.row
            selectedIndex.remove(index)
        }else{
            let index  = indexPath.row
            selectedIndex.add(index)
        }
        if(isSelectAll && selectedIndex.count != arrContent.count){
            btnSelectAll.setImage(UIImage(named: "unCheck"), for: UIControlState.normal)
            isSelectAll = !isSelectAll;
        }else if(selectedIndex.count == arrContent.count){
            btnSelectAll.setImage(UIImage(named: "Check"), for: UIControlState.normal)
            isSelectAll = !isSelectAll;
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
}
