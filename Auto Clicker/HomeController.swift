//
//  ViewController.swift
//  Auto Clicker
//
//  Created by Tej on 21/12/20.
//

import Cocoa
class HomeController: NSViewController {
    @IBOutlet weak var txtProcess: NSTextField!
    @IBOutlet weak var btnListen: NSButton!
    @IBOutlet weak var txtDelay: NSTextField!
    @IBOutlet weak var txtX: NSTextField!
    @IBOutlet weak var txtY: NSTextField!
    @IBOutlet weak var txtRepeat: NSTextField!
    @IBOutlet weak var comboAction: NSComboBox!
    @IBOutlet weak var dataTableView: NSTableView!
    @IBOutlet weak var txtComment: NSTextField!
    var actionIndex : Int!
    var arrTasks = [Task]()
    var eventMonitor : Any?
    let arrCombo = ["Left Click","Right Click","Delay","Paste","Random"]
    lazy var window: NSWindow = self.view.window!
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    let toPaste = ["#music #motivation #trip #training #friends #weekend #insta #TBT #instamood #follow4follow #swag #model #summer #live #holiday #portrait #followforfollow #instalike #likeforlike #Travelgram #happy #architecture #fun #f4f #like #instagood #like4like #followme #gym #nofilter \nFollow Me For More Posts","Toronto, Ontario"]
    var arrRandom = [(165,690),(165,545),(165,415),(165,285),(165,145),(303,690),(303,545),(303,415),(303,285),(303,145),(440,690),(440,545),(440,415),(440,285),(440,145)]
    func setupUI(){
        // 15 diffrent clicks and select one randomly
        /*
         mouse cliced: 167.4, 690.3
         mouse cliced: 303.5, 688.2
         mouse cliced: 439.2, 689.8
         mouse cliced: 163.7, 148.9
         mouse cliced: 303.4, 148.3
         mouse cliced: 430.7, 145.7
         xcol1 = 165
         ycol1 = 691 ==== -145
         */
        
    }
    
    override func viewDidLoad() {
        setupUI()
        updateData(with: Task())
        setupAndHandleShortkey()
        
        
        //        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
        //            print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
        //            print("windowLocation:", String(format: "%.1f, %.1f", self.location.x, self.location.y))
        //            return $0
        //        }
        
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        window.acceptsMouseMovedEvents = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveFile(notification:)), name: Helper.saveFileNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpenFile(notification:)), name: Helper.openFileNotification, object: nil)
    }
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(Helper.saveFileNotification)
        NotificationCenter.default.removeObserver(Helper.openFileNotification)
    }
    @objc func handleSaveFile(notification : Notification){
        let url = (notification.object as! URL)
        Helper.saveTasks(for: arrTasks, at: url)
    }
    @objc func handleOpenFile(notification : Notification){
        let url = notification.object as! URL
        if let tasks = Helper.loadTask(at: url){
            arrTasks = tasks
            dataTableView.reloadData()
        }
    }
    @IBAction func handleListen(_ sender: Any) {
        self.view.window?.miniaturize(self)
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown]) { _ in
            self.txtX.doubleValue = Double(self.mouseLocation.x)
            self.txtY.doubleValue = Double(self.mouseLocation.y)
            print("mouse cliced:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
            self.removeListener()
        }
    }
    func removeListener(){
        self.window.deminiaturize(self)
        if let event = eventMonitor{
            NSEvent.removeMonitor(event)
        }
    }
    @IBAction func handleAdd(_ sender: Any) {
        var newData : Task!
        switch comboAction.indexOfSelectedItem {
        case 2:
            //delay
            newData = Task(numRepeat: txtRepeat.intValue, actionIndex: comboAction.indexOfSelectedItem, delay: txtDelay.intValue, comment: txtComment.stringValue)
        case 3:
            //paste
            newData = Task(actionIndex: comboAction.indexOfSelectedItem, delay: txtDelay.intValue, comment: txtComment.stringValue)
        case 4:
            //random
            newData = Task(numRepeat: txtRepeat.intValue, actionIndex: comboAction.indexOfSelectedItem, delay: txtDelay.intValue, comment: txtComment.stringValue)
        default:
            // left and right
            newData = Task(xAxis: txtX.doubleValue, yAxis: txtY.doubleValue, numRepeat: txtRepeat.intValue, actionIndex: comboAction.indexOfSelectedItem, delay: txtDelay.intValue, comment: txtComment.stringValue)
        }
        if newData.numRepeat == 0{
            newData.numRepeat = 1
        }
        arrTasks.append(newData)
        dataTableView.reloadData()
        clearTxtFields()
    }
    @IBAction func handleDelete(_ sender: Any) {
        arrTasks.remove(at: dataTableView.selectedRow)
        dataTableView.reloadData()
    }
    @IBAction func handleDeleteAll(_ sender: Any) {
        arrTasks.removeAll()
        dataTableView.reloadData()
    }
    @IBAction func handleMoveUp(_ sender: Any) {
        if dataTableView.selectedRow != 0{
            let newIndex = dataTableView.selectedRow - 1
            arrTasks.swapAt(newIndex, dataTableView.selectedRow)
            dataTableView.reloadData()
            let indexSet = IndexSet(integer: newIndex)
            dataTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    @IBAction func handleMoveDown(_ sender: Any) {
        if dataTableView.selectedRow != arrTasks.count{
            let newIndex = dataTableView.selectedRow + 1
            arrTasks.swapAt(newIndex, dataTableView.selectedRow)
            dataTableView.reloadData()
            let indexSet = IndexSet(integer: newIndex)
            dataTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    @IBAction func handleStart(_ sender: Any) {
        self.view.window?.miniaturize(self)
        // Main Process Loop
        for _ in 1...txtProcess.intValue{
            // Tasks Loop
            var arrPaste = toPaste
            for task in arrTasks{
                // Task Repeat Loop
                let random = Int.random(in: 0..<arrRandom.count)
                for _ in 1...task.numRepeat{
                    sleep(UInt32(task.delay))
                    switch task.actionIndex {
                    case 0:
                        Helper.leftClick(with: task)
                    case 1:
                        Helper.rightClick(with: task)
                    case 3:
                        let pasteBoard = NSPasteboard.general
                        pasteBoard.clearContents()
                        pasteBoard.writeObjects([arrPaste.first! as NSString])
                        arrPaste.removeFirst()
                        Helper.pressKeyComboWithCMD(with: Keycode.v)
                    case 4:
                        var newTask = task
                        arrRandom.shuffle()
                        newTask.xAxis = Double(arrRandom[random].0)
                        newTask.yAxis = Double(arrRandom[random].1)
                        Helper.leftClick(with: newTask)
                    default:
                        //Delay
                    print("delay")
                    }
                }
            }
        }
    }
    func updateData(with taskData: Task){
        comboAction.selectItem(at: taskData.actionIndex)
        txtDelay.intValue = taskData.delay
        txtRepeat.intValue = taskData.numRepeat
        txtX.doubleValue = taskData.xAxis
        txtY.doubleValue = taskData.yAxis
    }
    func clearTxtFields(){
        self.txtX.intValue = 0
        self.txtY.intValue = 0
        self.txtComment.stringValue = ""
        self.txtRepeat.intValue = 1
        self.txtDelay.intValue = 0
    }
    // MARK: Shortkeys
    func setupAndHandleShortkey(){
//        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
//        let accessEnabled = AXIsProcessTrustedWithOptions(options)
//        if !accessEnabled {
//            print("Access Not Enabled")
//        }
//        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { (event) in
//            if event.keyCode == 0{
//                self.txtX.doubleValue = Double(self.mouseLocation.x)
//                self.txtY.doubleValue = Double(self.mouseLocation.y)
//                self.handleAdd(self)
//            }
//        }
    }
}
extension HomeController : NSComboBoxDelegate,NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return arrCombo.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return arrCombo[index]
    }
    func comboBoxSelectionDidChange(_ notification: Notification) {
        switch comboAction.indexOfSelectedItem {
        case 0,1:
            txtY.isEnabled = true
            txtX.isEnabled = true
            btnListen.isEnabled = true
            txtRepeat.isEnabled = true
        case 2,4:
            txtY.isEnabled = false
            txtX.isEnabled = false
            btnListen.isEnabled = false
            txtRepeat.isEnabled = true
        case 3:
            txtY.isEnabled = false
            txtX.isEnabled = false
            btnListen.isEnabled = false
            txtRepeat.isEnabled = false
        default:
            print("FOo")
        }
        self.clearTxtFields()
    }
    
}

extension HomeController : NSTableViewDelegate,NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return arrTasks.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let data = arrTasks[row]
        let isNotDelay = data.actionIndex != 2
        switch tableColumn?.identifier.rawValue{
        case "0" : return row + 1
        case "1" : return arrCombo[data.actionIndex]
        case "2" : return isNotDelay ? data.xAxis : ""
        case "3" : return isNotDelay ? data.yAxis : ""
        case "4" : return data.comment
        case "5" : return data.delay
        case "6" : return data.numRepeat
        default:
            print("damn")
            return nil
        }
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        let table = notification.object as! NSTableView
        if table.selectedRow < arrTasks.count && table.selectedRow != -1{
            updateData(with: arrTasks[table.selectedRow])
        }
    } 
}

