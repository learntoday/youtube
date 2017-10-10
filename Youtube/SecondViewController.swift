//
//  SecondViewController.swift
//  Youtube
//
//  Created by Gasser on 10/9/17.
//  Copyright © 2017 Gasser. All rights reserved.
//

import UIKit
import YouTubePlayer
import Alamofire

class SecondViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate{

    
    @IBOutlet var tableView: UITableView!
    
    // API key for Youtube Service
    let apiKey = "AIzaSyCw4JSetTAPCuq0XdCsS5UUnfBCJQjS4Z8"
    
    // Array to append video code in it
    var arrayOfVideoCode = [String]()
    @IBOutlet var searchBar: UISearchBar!

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
       
    }

    // MARK: - SearchBar Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // the following code to avoid url not safe characters
        var originalString = searchBar.text!
        var escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
       
        // clear the array to append the new search results
        self.arrayOfVideoCode = [String]()
       
        self.view.endEditing(true)

        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(escapedString!)&type=video&key=\(apiKey)&maxResults=25"
        
        let url = URL(string: urlString)
        
        let httpRequest = URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
        
        if error != nil {
            
            print(error!)
            
        } else {
            
            if let urlContent = data {
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options:
                        JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                    
                     let items: Array<Dictionary<String, Any>> = jsonResult["items"] as! Array<Dictionary<String, Any>>
                    print(items) //this part works fine
                    
                    
                    for item in items{
                    
                    
                        var itemId = item["id"] as! Dictionary<String, Any>
                        print(itemId["videoId"]!)
                        
                        self.arrayOfVideoCode.append(itemId["videoId"]! as! String)
                    
                    }
                    
                    // get the main UI thread to enable updating in UI
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                         self.tableView.setContentOffset(CGPoint.zero, animated:true)
                    }
                   
                    
                } catch {
                    
                    print("JSON Processing Failed")
                }
            }
        }

        
        
        }
        httpRequest.resume()
      
        // Clear the Text after search
         searchBar.text = ""
       
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    


    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfVideoCode.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Videos"
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
     
     // Configure the cell...
        
        let videoPlayer: YouTubePlayerView = cell.viewWithTag(1) as! YouTubePlayerView
        
        videoPlayer.loadVideoID(arrayOfVideoCode[indexPath.row])
     
     return cell
     }
    
    

}
