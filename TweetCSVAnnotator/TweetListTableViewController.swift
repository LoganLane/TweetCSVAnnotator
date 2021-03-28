//
//  TweetListTableViewController.swift
//  TweetCSVAnnotator
//
//  Created by Logan Lane on 3/1/21.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices


let queue = DispatchQueue.global()
let timingSemaphore = DispatchSemaphore(value: 0)
var userFile : URL?
var CSVData : Data?
var path : String?
var decode2: String?
var TweetList = [Tweet]()
class TweetListTableViewController: UITableViewController, UIDocumentPickerDelegate{
    func selectCSV() {
        queue.sync {
            let type = UTType.types(tag: "csv", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
            let documentSelector = UIDocumentPickerViewController(forOpeningContentTypes: type, asCopy: true)
            documentSelector.delegate = self
            self.present(documentSelector, animated: true, completion: nil)
            
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        queue.sync {
            let userSelectedCSV = urls[0]
            userFile = userSelectedCSV
            path = userFile?.path
            CSVData = try? Data(contentsOf: userFile!)
            decode2 = String(decoding: CSVData!, as: UTF8.self)
            print("This is decode2", decode2)
            timingSemaphore.signal()
        }
    }
    
    @objc func refresh(){
        TweetTable.reloadData()
    }
    
    
    
    @IBOutlet var TweetTable: UITableView!
    
    @IBAction func FileImportButton(_ sender: Any) {
        selectCSV()
        parseCSV()
        TweetTable.reloadData()
        DispatchQueue.main.async {
            NotificationCenter
                .default
                .addObserver(self, selector: #selector(self.refresh), name: .init("dataParsed"), object: nil)
        }
        
    }
    
    @IBAction func FileExportButton(_ sender: Any) {
        exportCSV()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToTweetDetailed", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //parseCSV()
        //print("This is csvtestfile", csvtestfile)
        //self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TweetTable.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberRows = TweetList.count
        return numberRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetcell", for: indexPath)
        let row = indexPath.row
        cell.textLabel!.text = TweetList[row].tweet
        
        
        if(TweetList[row].Type == true){
            cell.contentView.backgroundColor = UIColor.red
            cell.textLabel!.textColor = UIColor.black
        }
        else{
            cell.contentView.backgroundColor = UIColor.systemBackground
            cell.textLabel!.textColor = UIColor.label
        }
        return cell
    }
    

    // MARK: - Segue Data Transfer

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            if let indexPath = tableView.indexPathForSelectedRow{
                guard let destinationVC = segue.destination as? TweetDetailedViewController else{return}
                let selectedRow = indexPath.row
                destinationVC.TweetSegueContent = TweetList[selectedRow].tweet
                destinationVC.TweetSegueType = TweetList[selectedRow].Type
                destinationVC.arraynum = selectedRow
                //TweetDetailedViewController
            }
    }
}
