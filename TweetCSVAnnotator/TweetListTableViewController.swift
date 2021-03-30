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
    //A semaphore needed to be used here because UI changes cannot be relegated to another thread and the timing was off without it. (The parsing function fired off before the selected file was passed causing a crash. The semaphore solved this.)
    
    //This function brings up the document selector and allows the user to select a CSV file to be parsed
    func selectCSV() {
        queue.sync {
            let type = UTType.types(tag: "csv", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
            let documentSelector = UIDocumentPickerViewController(forOpeningContentTypes: type, asCopy: true)
            documentSelector.delegate = self
            self.present(documentSelector, animated: true, completion: nil)
            
        }
    }
    //Passes the selected file's URL
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        queue.sync {
            let userSelectedCSV = urls[0]
            userFile = userSelectedCSV
            path = userFile?.path
            CSVData = try? Data(contentsOf: userFile!)
            decode2 = String(decoding: CSVData!, as: UTF8.self)
            timingSemaphore.signal()
        }
    }
    
    //This is an Objective C function that is used in combination with the notification center call to update the table from another class separate from the view controller itself
    @objc func refresh(){
        TweetTable.reloadData()
    }
    
    @IBOutlet var TweetTable: UITableView!
    
    
    @IBAction func FileImportButton(_ sender: Any) {
        selectCSV()
        parseCSV()
        TweetTable.reloadData()
        //observes a call from the CSVParser.swift file and refreshes the TweetTable TableUIView when it recieves the signal from that file
        DispatchQueue.main.async {
            NotificationCenter
                .default
                .addObserver(self, selector: #selector(self.refresh), name: .init("dataParsed"), object: nil)
        }
        
    }
    
    //exports the updated CSV file into the documents folder on the user's iPad.
    @IBAction func FileExportButton(_ sender: Any) {
        exportCSV()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToTweetDetailed", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Deinitializes the observer above
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
        
        //Logic for highlighting Tweet cells deemed hate speech in red
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
            // Passses the data for each individual Tweet to the TweetDetailedViewController
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
