//
//  ViewController2.swift
//  DATN_PHUC4
//  Created by Tran Anh Quang on 12/23/18.
//  Copyright © 2018 Tran Anh Quang. All rights reserved.
//

import UIKit
import Toast_Swift
import Foundation
import CocoaMQTT
import Charts

class ViewController2: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CocoaMQTTDelegate {
    
    var device_add_para : [String : String] = [:]

    var mqttClient: CocoaMQTT!

    let matopic = "demo"
    let Matopic = "demo2"
    var sltb = 9
    let batden = "BUTTON_ON.png"
    let tatden = "BUTTON_OFF.png"
    var hienthi = [String]()
    var dieukhientb = [String]()
    var battb : [String] = ["1on", "2on", "3on", "4on"]
    var tattb : [String] = ["1off", "2off", "3off", "4off"]
    var control_txt = ""
    var thongso = [String]()
    var connected = false
    var manual = false
    var line = false
    
    
    @IBOutlet weak var dot_status: UIImageView!
    
    @IBOutlet weak var bnt_image1: UIButton!
    
    @IBOutlet weak var bnt_image2: UIButton!
    
    @IBOutlet weak var bnt_image3: UIButton!
    
    @IBOutlet weak var bnt_image4: UIButton!
    
    @IBOutlet weak var control_status: UIButton!
    
    @IBOutlet weak var nhietdo: UILabel!
    
    @IBOutlet weak var doamkk: UILabel!
    
    @IBOutlet weak var doamdat: UILabel!
    
    @IBOutlet weak var anhsang: UILabel!
    
    @IBOutlet weak var modetxt: UILabel!
    
    struct dataload : Decodable{

        let message : String
        let data : [Data]
        let result : Bool

    }

    struct Data : Decodable{

        let receive_at : String
//        let value : Int
        let value : Float


    }

    
    @IBAction func Switch_state(_ sender: Any) {
        
        if(manual){
         PUBLISH(mqttclient: mqttClient, topic: Matopic, state: "autoAPP")

        }
        else{
            
        PUBLISH(mqttclient: mqttClient, topic: Matopic, state: "manualAPP")
            
        }

    }
    
    

    func connectToWebAPI_loaddata(){
        let TOKEN = "13236c1a626f66a9bad58f160b4ed2146b19610a"
//        let parameters = ["serial": "dv1112"]

        guard let url = URL(string: "https://phucproject.pythonanywhere.com/api/device/measure/data/") else { return }
        var request = URLRequest(url: url)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: device_add_para, options: []) else { return }
//                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Token \(Token)", forHTTPHeaderField: "Authorization")
        request.setValue("Token \(TOKEN)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in

            if let data = data {
                do {
                    //            let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                                        print(json)
                    let Json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    let json = try JSONDecoder().decode(dataload.self, from: data)
                    
                    if((Json!["result"] as! Bool) && (json.data.count != 0)){

                        self.line = true

//                        print(self.Fromdatepicker)
                        for i in 0 ..< json.data.count{
//                            print(String(i))

                            let date = json.data[i].receive_at.replacingOccurrences(of: ":", with: ".")
                            
                            var datearr : [String] = date.components(separatedBy: " ")
//
//                            print("self.Fromdatepicker : \(self.Fromdatepicker)")
//                            print("datearr[0] : \(datearr[0])")
                            
                            if(self.Fromdatepicker == datearr[0]){

                                self.indexes.append(Double(datearr[1])!)

                                self.numbers.append(Double(json.data[i].value))
//                                print(String(i))
//                                print(datearr[1])
//
//                                print(json.data[i].value)
                            }
                            
                        }

                    }

                }  catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func connectToWebAPI_loaddata_temp(){
        
        let TOKEN = "13236c1a626f66a9bad58f160b4ed2146b19610a"
                let parameters = ["serial": "temp001"]
        
        guard let url = URL(string: "https://phucproject.pythonanywhere.com/api/device/measure/data/") else { return }
        var request = URLRequest(url: url)
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: device_add_para, options: []) else { return }
//                guard let httpBody = try? JSONSerialization.data(withJSONObject: Device_add_para, options: []) else { return }
                        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.setValue("Token \(Token)", forHTTPHeaderField: "Authorization")
        request.setValue("Token \(TOKEN)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    //            let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                                        print(json)
                    let Json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    let json = try JSONDecoder().decode(dataload.self, from: data)
                    
                    if((Json!["result"] as! Bool) && (json.data.count != 0)){
                        
                        self.line = true
                        
//                        print(String(json.data.count))
//                        print(self.Fromdatepicker)
                        for i in 0 ..< json.data.count{
                            //                            print(String(i))
                            
                            let date = json.data[i].receive_at.replacingOccurrences(of: ":", with: ".")
                            
                            var datearr : [String] = date.components(separatedBy: " ")
                            
//                            print("self.Fromdatepicker : \(self.Fromdatepicker)")
//                            print("datearr[0] : \(datearr[0])")
//
                            if(self.Fromdatepicker == datearr[0]){
                                
                                self.indexes_temp.append(Double(datearr[1])!)
                                self.numbers_temp.append(Double(json.data[i].value))
//                                print(String(i))
//                                print(datearr[1])
//
//                                print(json.data[i].value)
                            }
                            
                        }
                        
                    }
                    
                }  catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func connectToWebAPI_loaddata_hum(){
        
        let TOKEN = "13236c1a626f66a9bad58f160b4ed2146b19610a"
        let parameters = ["serial": "hum001"]
        
        guard let url = URL(string: "https://phucproject.pythonanywhere.com/api/device/measure/data/") else { return }
        var request = URLRequest(url: url)
        //        guard let httpBody = try? JSONSerialization.data(withJSONObject: device_add_para, options: []) else { return }
        //                guard let httpBody = try? JSONSerialization.data(withJSONObject: Device_add_para, options: []) else { return }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.setValue("Token \(Token)", forHTTPHeaderField: "Authorization")
        request.setValue("Token \(TOKEN)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    //            let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                                        print(json)
                    let Json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    let json = try JSONDecoder().decode(dataload.self, from: data)
                    
                    if((Json!["result"] as! Bool) && (json.data.count != 0)){
                        
                        self.line = true
                        
//                        print(String(json.data.count))
//                        print(self.Fromdatepicker)
                        for i in 0 ..< json.data.count{
                            //                            print(String(i))
                            
                            let date = json.data[i].receive_at.replacingOccurrences(of: ":", with: ".")
                            
                            var datearr : [String] = date.components(separatedBy: " ")
                            
//                            print("self.Fromdatepicker : \(self.Fromdatepicker)")
//                            print("datearr[0] : \(datearr[0])")
//
                            if(self.Fromdatepicker == datearr[0]){
                                
                                self.indexes_hum.append(Double(datearr[1])!)
                                self.numbers_hum.append(Double(json.data[i].value))
//                                print(String(i))
//                                print(datearr[1])
//
//                                print(json.data[i].value)
                            }
                            
                        }
                        
                    }
                    
                }  catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func connectToWebAPI_loaddata_light(){
        
        let TOKEN = "13236c1a626f66a9bad58f160b4ed2146b19610a"
        let parameters = ["serial": "light001"]
        
        guard let url = URL(string: "https://phucproject.pythonanywhere.com/api/device/measure/data/") else { return }
        var request = URLRequest(url: url)
        //        guard let httpBody = try? JSONSerialization.data(withJSONObject: device_add_para, options: []) else { return }
        //                guard let httpBody = try? JSONSerialization.data(withJSONObject: Device_add_para, options: []) else { return }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.setValue("Token \(Token)", forHTTPHeaderField: "Authorization")
        request.setValue("Token \(TOKEN)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    //            let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                                        print(json)
                    let Json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    let json = try JSONDecoder().decode(dataload.self, from: data)
                    
                    if((Json!["result"] as! Bool) && (json.data.count != 0)){
                        
                        self.line = true
                        
//                        print(String(json.data.count))
//                        print(self.Fromdatepicker)
                        for i in 0 ..< json.data.count{
                            //                            print(String(i))
                            
                            let date = json.data[i].receive_at.replacingOccurrences(of: ":", with: ".")
                            
                            var datearr : [String] = date.components(separatedBy: " ")
                            
//                            print("self.Fromdatepicker : \(self.Fromdatepicker)")
//                            print("datearr[0] : \(datearr[0])")
                            
                            if(self.Fromdatepicker == datearr[0]){
                                
                                self.indexes_light.append(Double(datearr[1])!)
                                self.numbers_light.append(Double(json.data[i].value))
//                                print(String(i))
//                                print(datearr[1])
                                
//                                print(json.data[i].value)
                            }
                            
                        }
                        
                    }
                    
                }  catch {
                    print(error)
                }
            }
            }.resume()
    }
    // MQTT
    @IBAction func bnt1(_ sender: Any) {

        if(connected && manual){

            PUBLISH(mqttclient: mqttClient, topic: Matopic, state: dieukhientb[0])

        }
        else{
            
        }
    }
    
    @IBAction func bnt2(_ sender: Any) {

        if(connected && manual){
//            mqttClient.publish(Matopic, withString: dieukhientb[1], qos: .qos0, retained: false, dup: false)
            PUBLISH(mqttclient: mqttClient, topic: Matopic, state: dieukhientb[1])

            
        }
        else{
            
        }
    }
    
    @IBAction func bnt3(_ sender: Any) {
        
        if(connected && manual){
//            mqttClient.publish(Matopic, withString: dieukhientb[2], qos: .qos0, retained: false, dup: false)
            PUBLISH(mqttclient: mqttClient, topic: Matopic, state: dieukhientb[2])

        }
        else{
            
        }
        
    }
    
    @IBAction func bnt4(_ sender: Any) {

        if(connected && manual){
//            mqttClient.publish(Matopic, withString: dieukhientb[3], qos: .qos0, retained: false, dup: false)
            PUBLISH(mqttclient: mqttClient, topic: Matopic, state: dieukhientb[3])

        }
        else{
            
        }
    }
    
    func configureMQTTAndConnect() {
        print("mqtt_phuc")
        let clientID = "iOSMotorControl-111" + String(ProcessInfo().processIdentifier)
        // Replace with the host name for the MQTT Server
         let host = "m12.cloudmqtt.com"
//        let host = "iot.eclipse.org"
        //        let host = "iot.eclipse.org"
        
        // Replace with the port number for MQTT over TCP (without TLS)
//        let port = UInt16(1883)
        let port = UInt16(13974)

        mqttClient = CocoaMQTT(clientID: clientID, host: host, port: port)
        mqttClient.username = "esp8266"
        mqttClient.password = "123456"
        mqttClient.keepAlive = 60
        mqttClient.delegate = self
        mqttClient.connect()
    }
    
    func PUBLISH(mqttclient : CocoaMQTT, topic : String, state : String){
        
        mqttclient.publish(topic, withString: state, qos: .qos1, retained: false, dup: false)
    
    }
    func hienthiden(){
        
        bnt_image1.setImage(UIImage(named: hienthi[0]), for: .normal)
        bnt_image2.setImage(UIImage(named: hienthi[1]), for: .normal)
        bnt_image3.setImage(UIImage(named: hienthi[2]), for: .normal)
        bnt_image4.setImage(UIImage(named: hienthi[3]), for: .normal)
//        control_status.titleLabel?.text = control_txt
        nhietdo.text = thongso[0] + "°C"
        doamkk.text = thongso[1] + "%"
        anhsang.text = thongso[2] + " lux"
        doamdat.text = thongso[3] + "%"
        modetxt.text = control_txt

    }
    
    // MQTT start
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("connected")
        mqttClient.subscribe(matopic, qos: .qos0)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
        print("didPublishMessage : \(message.string!)")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        
        print("message is \(message.string!)")
        print("id is \(id)")
        let state = message.string
        var statearr = state?.components(separatedBy: ";")
        
//        if ((statearr?.count)! >= sltb){
//            connected = true
//            manual = true
//            dot_status.image = UIImage(named: "DOT_CONNECTED.png")
//
//            for i in 0 ..< sltb{
//
//                if statearr?[i] == String(i + 1) + "a"{
//
//                    hienthi[i] = batden
//                    dieukhientb[i] = tattb[i]
//                }
//
//                if statearr?[i] == String(i + 1) + "b"{
//
//                    hienthi[i] = tatden
//                    dieukhientb[i] = battb[i]
//
//                }
//            }
//
//            hienthiden()
//
//
//        }
        // Cong them cac thong so nhiet do, do am, ... anh sang
        if ((statearr?.count)! >= sltb){
            connected = true
            dot_status.image = UIImage(named: "DOT_CONNECTED.png")
            
//            sltb += 4
            for i in 0 ..< sltb{
                
                if(i < (sltb - 5)){
                    if statearr?[i] == String(i + 1) + "a"{
                        
                        hienthi[i] = batden
                        dieukhientb[i] = tattb[i]
                    }
                    
                    if statearr?[i] == String(i + 1) + "b"{
                        
                        hienthi[i] = tatden
                        dieukhientb[i] = battb[i]
                        
                    }
                }
                else{
                    if(i != (sltb-1)){
//                        print(statearr?[i])
                        thongso[i-4] = (statearr?[i])!

                    }
                    else{
                        print(statearr?[i] as Any)
                        if((statearr?[i])! == "m"){
                            print("0")
                            manual = true
                            control_txt = "M"

                        }
                        else if((statearr?[i])! == "a")
                        {
                            print("1")

                            manual = false
                            control_txt = "A"

                        }
                        else
                        {
                            
                        }

                    }
                    
                }

            }

        }
        else{
//
//            if(state == "manual"){
//
//                manual = true
//                control_txt = "MANUAL"
//            }
//            else if(state == "auto"){
//
//                manual = false
//                control_txt = "AUTO"
//
//            }
//            else{
//
//
//            }
            
        }
        hienthiden()


    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        
        print("topic is \(topic)")
        
    }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
        print("topic is \(topic)")
        
    }
    
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        dot_status.image = UIImage(named: "DOT_DISCONNECTED.png")
        connected = false
        print("disconnected")
        
        configureMQTTAndConnect()
    }
    
    // MQTT end

    var Name : [String] = []
    var dem = 0
    var sttpicker = 0
    
    @IBOutlet weak var devicenbr: UILabel!
    
    
    @IBOutlet weak var namepicker: UIPickerView!
    
    
    @IBOutlet weak var fromdatepicker: UITextField!
    var Fromdatepicker = ""
    

    
    let datePicker1 = UIDatePicker()
//    let datePicker2 = UIDatePicker()
    let toolbar1 = UIToolbar()
//    let toolbar2 = UIToolbar()
    @IBAction func add_device(_ sender: Any) {
//       self.view.makeToast("This is a piece of toast")
//        self.view.makeToast("This is a piece of toast", duration: 2.0, position: .top)
        showInputDialog()

    }
    
    
    var SERIAL = [String]()
    
    var SERIAL_V2 = ["temp001", "hum001", "light001", "land001"]
    var NAME_V2 = ["ALL", "Nhiệt Độ", "Độ Ẩm KK", "Ánh Sáng", "Độ Ẩm Đất"]

    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter details?", message: "Enter your device information", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            let serial = alertController.textFields?[1].text
            let unit = alertController.textFields?[2].text
            
            self.device_add_para = ["serial" : serial] as! [String : String]
//            self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
            if((name == "")||(serial == "")||(unit == "")){
                
                self.view.makeToast("Wrong, pleae try again", duration: 3.0, position: .top)
                
            }
            else{
                self.dem += 1
                self.devicenbr.text = String(self.dem)
                self.Name.append(name!)
                self.SERIAL.append(serial!)
                self.namepicker.reloadAllComponents()
                self.view.makeToast("Successfull", duration: 3.0, position: .top)
            }
            
            let txt = "Name: " + name! + " Serial: " + serial! + " Unit: " + unit!
            print(txt)
        }
        
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Serial"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Unit"
        }
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 1111111
    func showDatePicker1(){
        //Formate Date
//        datePicker1.datePickerMode = .dateAndTime
        datePicker1.datePickerMode = .date

        //ToolBar
        //        let toolbar = UIToolbar()
        toolbar1.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1))
        
        toolbar1.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        fromdatepicker.inputAccessoryView = toolbar1
        fromdatepicker.inputView = datePicker1
    }
    
    @objc func donedatePicker1(){
        
        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd/MM/yyyy"
//        formatter.dateFormat = " dd/MM/yy, HH:mm a"

//        formatter.dateFormat = "yy-MM-dd HH:mm"
        formatter.dateFormat = "yyyy-MM-dd"

        fromdatepicker.text = formatter.string(from: datePicker1.date)
        Fromdatepicker = fromdatepicker.text!
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker1(){
        self.view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Name.append("All")
        self.devicenbr.text = "0"
        update_activity.isHidden = true
                for _ in 0 ..< sltb {
        
                    hienthi.append(tatden)
                    dieukhientb.append("")
                    thongso.append("")
                }
        
        
        showDatePicker1()
//        showDatePicker2()
        configureMQTTAndConnect()
        
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return Name.count
        return NAME_V2.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return Name[row]
        return NAME_V2[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sttpicker = row
//        if(row != 0){
//            device_add_para = ["serial" : SERIAL[row-1]]
//
//        }
        
        if(row != 0){
            device_add_para = ["serial" : SERIAL_V2[row-1]]
            
        }
//        print(Name[row])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBOutlet weak var chtChart: LineChartView!
    
    var numbers : [Double] = []
    var indexes : [Double] = []
    func updateGraph(){
        
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
//        var lineChartEntry2  = [ChartDataEntry]()
        
        //here is the for loop
        if(numbers.count != 0){
            for i in 0..<numbers.count {
                
                //            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
                let value = ChartDataEntry(x: indexes[i], y: numbers[i])
                
                lineChartEntry.append(value) // here we add it to the data set
                //            let value2 = ChartDataEntry(x: Double(i+1), y: numbers[i])
                //            lineChartEntry2.append(value2)
            }
        }

        
//        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
//        let line1 = LineChartDataSet(values: lineChartEntry, label: "2018-12-29")
//        let line1 = LineChartDataSet(values: lineChartEntry, label: Name[sttpicker])
        let line1 = LineChartDataSet(values: lineChartEntry, label: NAME_V2[sttpicker])
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
//        let line2 = LineChartDataSet(values: lineChartEntry2, label: "Nhiet do")
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
//        line2.colors = [NSUIColor.orange]
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
//        data.addDataSet(line2)
        
        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
//        chtChart.chartDescription?.text = "Temperature" // Here we set the description for the graph
        chtChart.chartDescription?.text = fromdatepicker.text!
    }
    
    // mutil line
    var numbers_temp : [Double] = []
    var indexes_temp : [Double] = []
    
    var numbers_hum : [Double] = []
    var indexes_hum : [Double] = []
    
    var numbers_light: [Double] = []
    var indexes_light : [Double] = []
    
    func updateGraph_multi(){
        
        var lineChartEntry_temp  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        var lineChartEntry_hum  = [ChartDataEntry]()
        var lineChartEntry_light  = [ChartDataEntry]()
        
        //        var lineChartEntry2  = [ChartDataEntry]()
        
        //here is the for loop
        // temp
        if(numbers_temp.count != 0){
            for i in 0..<numbers_temp.count {

                let value_temp = ChartDataEntry(x: indexes_temp[i], y: numbers_temp[i])
                
                lineChartEntry_temp.append(value_temp)

            }
        }
        //hum
        if(numbers_hum.count != 0){
            for i in 0..<numbers_hum.count {
                
                let value_hum = ChartDataEntry(x: indexes_hum[i], y: numbers_hum[i])
                
                lineChartEntry_hum.append(value_hum)
                
            }
        }
        //light
        if(numbers_light.count != 0){
            for i in 0..<numbers_light.count {
                
                let value_light = ChartDataEntry(x: indexes_light[i], y: numbers_light[i])
                
                lineChartEntry_light.append(value_light)
                
            }
        }
        
        
        
        let line_temp = LineChartDataSet(values: lineChartEntry_temp, label: NAME_V2[1])
        let line_hum = LineChartDataSet(values: lineChartEntry_hum, label: NAME_V2[2])
        let line_light = LineChartDataSet(values: lineChartEntry_light, label: NAME_V2[3])

        
        line_temp.drawCirclesEnabled = false
        line_hum.drawCirclesEnabled = false
        line_light.drawCirclesEnabled = false

        line_temp.drawValuesEnabled = false
        line_hum.drawValuesEnabled = false
        line_light.drawValuesEnabled = false

        
        line_temp.colors = [NSUIColor.blue] //Sets the colour to blue
        line_hum.colors = [NSUIColor.red] //Sets the colour to red
        line_light.colors = [NSUIColor.brown] //Sets the colour to yellow

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line_temp) //Adds the line to the dataSet
        data.addDataSet(line_hum) //Adds the line to the dataSet
        data.addDataSet(line_light) //Adds the line to the dataSet

        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = fromdatepicker.text!
    }
    

    var updatetimer : Timer!
    
    @IBOutlet weak var update_activity: UIActivityIndicatorView!
    //        @IBOutlet weak var activity: UIActivityIndicatorView!
//    activity.isHidden = false
//    activity.startAnimating()
//    activity.isHidden = true
//    activity.stopAnimating()
    @IBAction func showchart(_ sender: Any) {
        
        
        
//        indexes = [00.00, 01.00, 02.00, 03.00, 04.00, 05.00, 06.00, 07.00, 08.00, 09.00, 10.00, 11.00, 12.00, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23.59]
//        numbers = [30, 30.5, 31, 32, 29, 31, 33, 28, 27, 30, 31, 30, 31, 32, 31, 32, 31, 32, 31, 32, 32, 30, 31, 33, 30]
        //delete graph before drawing new
//        updateGraph()
        
        if(sttpicker != 0){
            chtChart.isHidden = true
            
            update_activity.isHidden = false
            update_activity.startAnimating()
            
            connectToWebAPI_loaddata()
            //
            //        if(line)
            //        {
            //
            //            updatetimer =  Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateline), userInfo: nil, repeats: true)
            //            line = false
            //        }
            updatetimer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateline), userInfo: nil, repeats: true)
            //        updateGraph()
            //
            //        indexes.removeAll()
            //        numbers.removeAll()

            
        }
        else{
            chtChart.isHidden = true
            
            update_activity.isHidden = false
            update_activity.startAnimating()
            
            connectToWebAPI_loaddata_temp()
            connectToWebAPI_loaddata_hum()
            connectToWebAPI_loaddata_light()

            updatetimer =  Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateline_multil), userInfo: nil, repeats: true)
            
            
        }
        

        
    }
    
    @objc func updateline(){
        
        chtChart.isHidden = false
        
        update_activity.isHidden = true
        update_activity.stopAnimating()
        
        updateGraph()
        
        indexes.removeAll()
        numbers.removeAll()
        
        updatetimer.invalidate()
        
    }
    
    @objc func updateline_multil(){
        
        chtChart.isHidden = false
        
        update_activity.isHidden = true
        update_activity.stopAnimating()
        
        updateGraph_multi()
        
        indexes_temp.removeAll()
        numbers_temp.removeAll()
        
        indexes_hum.removeAll()
        numbers_hum.removeAll()
        
        indexes_light.removeAll()
        numbers_light.removeAll()
        
        updatetimer.invalidate()
        
    }
    
    
    
    
    
    
    
    
    
}
