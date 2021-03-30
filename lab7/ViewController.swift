//
//  ViewController.swift
//  lab7
//
//  Created by Chase Brown on 3/29/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameDisplay: UILabel!
    @IBOutlet weak var cityLongitudeDisplay: UILabel!
    @IBOutlet weak var cityLatitudeDisplay: UILabel!
    
    @IBOutlet weak var earthquakesFoundDisplay: UILabel!
    @IBOutlet weak var currentIndexDisplay: UILabel!
    @IBOutlet weak var DateTimeDisplay: UILabel!
    @IBOutlet weak var magnitudeDisplay: UILabel!
    @IBOutlet weak var depthDisplay: UILabel!
    @IBOutlet weak var longitudeDisplay: UILabel!
    @IBOutlet weak var latitudeDisplay: UILabel!
    @IBOutlet weak var eqidDisplay: UILabel!
    @IBOutlet weak var srcDisplay: UILabel!
    
    @IBOutlet weak var systemMessage: UILabel!
    
    var cityName:String?
    var cityLongitude:Double?
    var cityLatitude:Double?
    
    var north:Double?
    var south:Double?
    var east:Double?
    var west:Double?
    
    var totalEarthquakes: Int = 0
    var index:Int = 0
    var date: String = ""
    var magnitude: Double = 0.0
    var depth: Double = 0.0
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var eqid: String = ""
    var src: String = ""
    
    var username: String = "chasebrownn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameDisplay.isHidden = true
        cityLongitudeDisplay.isHidden = true
        cityLatitudeDisplay.isHidden = true
        
        earthquakesFoundDisplay.isHidden = true
        currentIndexDisplay.isHidden = true
        DateTimeDisplay.isHidden = true
        magnitudeDisplay.isHidden = true
        depthDisplay.isHidden = true
        longitudeDisplay.isHidden = true
        latitudeDisplay.isHidden = true
        eqidDisplay.isHidden = true
        srcDisplay.isHidden = true
    }

    @IBAction func searchForQuakes(_ sender: Any) {
        let alert = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter City or Address" })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                self.cityName = name;
                self.cityNameDisplay.text = "\(name)"
               
                let addressString = name
                CLGeocoder().geocodeAddressString(addressString, completionHandler:
                    {(placemarks, error) in
                            
                        if error != nil {
                            print("\(error!.localizedDescription)")
                        }
                                
                        else if placemarks!.count > 0 {
                            let placemark = placemarks![0]
                                
                            self.cityLatitudeDisplay.text = "\(placemark.location!.coordinate.latitude)"
                            self.cityLongitudeDisplay.text = "\(placemark.location!.coordinate.longitude)"
                            self.cityLatitude = placemark.location!.coordinate.latitude
                            self.cityLongitude = placemark.location!.coordinate.longitude
                            
                            self.cityNameDisplay.isHidden = false
                            self.cityLongitudeDisplay.isHidden = false
                            self.cityLatitudeDisplay.isHidden = false
                            
                            self.cityNameDisplay.textColor = UIColor.blue
                            self.cityLongitudeDisplay.textColor = UIColor.purple
                            self.cityLatitudeDisplay.textColor = UIColor.purple
                               
                            self.north = abs(Double(self.cityLatitude!)) + 10.0
                            self.south = abs(Double(self.cityLatitude!)) - 10.0
                            self.east = abs(Double(self.cityLongitude!)) -  10.0
                            self.west  = abs(Double(self.cityLongitude!)) +  10.0
                        }
                    })
           }
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func loadFromWeb(_ sender: Any) {
        let full_URL = "http://api.geonames.org/earthquakesJSON?north=\(Double(north!))&south=\(Double(south!))&east=\(Double(east!))&west=\(Double(west!))&username=\(username)"
        //let urlAsString = "http://api.geonames.org/earthquakesJSON?north=43.45&south=23.45&east=102.06&west=122.06&username=chasebrownn"
        let url = URL(string: full_URL)!
        let url_session = URLSession.shared
        let JSON_query = url_session.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil)
            {
                print(error!.localizedDescription)
            }
            var err: NSError?
           
           
            var JSON_result = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if (err != nil) {
               print("\(err!.localizedDescription)")
            }
           
            self.index = 0
            //print(JSON_result)
            let setEarthQuake = JSON_result["earthquakes"]! as! NSArray
            let earthQuake = setEarthQuake[self.index] as? [String: AnyObject]
        
            self.date = (earthQuake!["datetime"]! as! String)
            self.magnitude = (earthQuake!["magnitude"] as? NSNumber)!.doubleValue
            self.depth = (earthQuake!["depth"] as? NSNumber)!.doubleValue
            self.longitude = (earthQuake!["lng"] as? NSNumber)!.doubleValue
            self.latitude = (earthQuake!["lat"] as? NSNumber)!.doubleValue
            self.eqid = (earthQuake!["eqid"]! as! String)
            self.src = (earthQuake!["src"]! as! String)
            self.totalEarthquakes = earthQuake!.count;
            
        })
        
        JSON_query.resume()
        
        self.earthquakesFoundDisplay.text = "\(totalEarthquakes)"
        self.currentIndexDisplay.text = "\(index)"
        self.DateTimeDisplay.text = "\(date)"
        self.magnitudeDisplay.text = "\(magnitude)"
        self.depthDisplay.text = "\(depth)"
        self.longitudeDisplay.text = "\(longitude)"
        self.latitudeDisplay.text = "\(latitude)"
        self.eqidDisplay.text = "\(eqid)"
        self.srcDisplay.text = "\(src)"
        
        earthquakesFoundDisplay.isHidden = false
        currentIndexDisplay.isHidden = false
        DateTimeDisplay.isHidden = false
        magnitudeDisplay.isHidden = false
        depthDisplay.isHidden = false
        longitudeDisplay.isHidden = false
        latitudeDisplay.isHidden = false
        eqidDisplay.isHidden = false
        srcDisplay.isHidden = false
        
        self.systemMessage.text = "Press Load Info to load geo information"
        
    }
    
    @IBAction func loadInfo(_ sender: AnyObject?) {
        
        self.earthquakesFoundDisplay.text = "\(totalEarthquakes)"
        self.currentIndexDisplay.text = "\(index)"
        self.DateTimeDisplay.text = "\(date)"
        self.magnitudeDisplay.text = "\(magnitude)"
        self.depthDisplay.text = "\(depth)"
        self.longitudeDisplay.text = "\(longitude)"
        self.latitudeDisplay.text = "\(latitude)"
        self.eqidDisplay.text = "\(eqid)"
        self.srcDisplay.text = "\(src)"
        
        earthquakesFoundDisplay.isHidden = false
        currentIndexDisplay.isHidden = false
        DateTimeDisplay.isHidden = false
        magnitudeDisplay.isHidden = false
        depthDisplay.isHidden = false
        longitudeDisplay.isHidden = false
        latitudeDisplay.isHidden = false
        eqidDisplay.isHidden = false
        srcDisplay.isHidden = false
        
    }
    
    @IBAction func nextEarthquake(_ sender: Any) {
        if ((index == totalEarthquakes-1)||(index == 10))
        {
            self.systemMessage.text = "CANNOT GO FORWARD"
            self.systemMessage.textColor = UIColor.red
        }
        else
        {
            self.systemMessage.text = "Press Load Info to load geo information"
            self.systemMessage.textColor = UIColor.purple
            
            let fullURL = "http://api.geonames.org/earthquakesJSON?north=\(Double(north!))&south=\(Double(south!))&east=\(Double(east!))&west=\(Double(west!))&username=betuzen"
            let url = URL(string: fullURL)!
            let url_session = URLSession.shared
            let JSON_query = url_session.dataTask(with: url, completionHandler: { data, response, error -> Void in
                if (error != nil)
                {
                    print(error!.localizedDescription)
                }
                var err: NSError?
                       
                var JSON_result = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                if (err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                
                self.index = self.index + 1;
                let setEarthQuake = JSON_result["earthquakes"]! as! NSArray
                let earthQuake = setEarthQuake[self.index] as? [String: AnyObject]
                self.totalEarthquakes = earthQuake!.count
                self.date = (earthQuake!["datetime"]! as! String)
                self.magnitude = (earthQuake!["magnitude"] as? NSNumber)!.doubleValue
                self.depth = (earthQuake!["depth"] as? NSNumber)!.doubleValue
                self.longitude = (earthQuake!["lng"] as? NSNumber)!.doubleValue
                self.latitude = (earthQuake!["lat"] as? NSNumber)!.doubleValue
                self.eqid = (earthQuake!["eqid"]! as! String)
                self.src = (earthQuake!["src"]! as! String)
                
            })
            
            JSON_query.resume()
            
            /*
            self.earthquakesFoundDisplay.text = "\(totalEarthquakes)"
            self.currentIndexDisplay.text = "\(index)"
            self.DateTimeDisplay.text = "\(date)"
            self.magnitudeDisplay.text = "\(magnitude)"
            self.depthDisplay.text = "\(depth)"
            self.longitudeDisplay.text = "\(longitude)"
            self.latitudeDisplay.text = "\(latitude)"
            self.eqidDisplay.text = "\(eqid)"
            self.srcDisplay.text = "\(src)"
            
            earthquakesFoundDisplay.isHidden = false
            currentIndexDisplay.isHidden = false
            DateTimeDisplay.isHidden = false
            magnitudeDisplay.isHidden = false
            depthDisplay.isHidden = false
            longitudeDisplay.isHidden = false
            latitudeDisplay.isHidden = false
            eqidDisplay.isHidden = false
            srcDisplay.isHidden = false
             */
        }
    }
    
    @IBAction func prevEarthquake(_ sender: Any) {
        if (index == 0)
        {
            self.systemMessage.text = "CANNOT GO BACK"
            self.systemMessage.textColor = UIColor.red
        }
        else
        {
            self.systemMessage.text = "Press Load Info to load geo information"
            self.systemMessage.textColor = UIColor.purple
            
            let fullURL = "http://api.geonames.org/earthquakesJSON?north=\(Double(north!))&south=\(Double(south!))&east=\(Double(east!))&west=\(Double(west!))&username=betuzen"
            let url = URL(string: fullURL)!
            let url_session = URLSession.shared
            let JSON_query = url_session.dataTask(with: url, completionHandler: { data, response, error -> Void in
                if (error != nil)
                {
                    print(error!.localizedDescription)
                }
                var err: NSError?
                       
                var JSON_result = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                if (err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                    
                
                self.index = self.index - 1;
                let setEarthQuake = JSON_result["earthquakes"]! as! NSArray
                let earthQuake = setEarthQuake[self.index] as? [String: AnyObject]
                self.totalEarthquakes = earthQuake!.count
                self.date = (earthQuake!["datetime"]! as! String)
                self.magnitude = (earthQuake!["magnitude"] as? NSNumber)!.doubleValue
                self.depth = (earthQuake!["depth"] as? NSNumber)!.doubleValue
                self.longitude = (earthQuake!["lng"] as? NSNumber)!.doubleValue
                self.latitude = (earthQuake!["lat"] as? NSNumber)!.doubleValue
                self.eqid = (earthQuake!["eqid"]! as! String)
                self.src = (earthQuake!["src"]! as! String)
                
            })
            
            JSON_query.resume()
            
            /*
            self.earthquakesFoundDisplay.text = "\(totalEarthquakes)"
            self.currentIndexDisplay.text = "\(index)"
            self.DateTimeDisplay.text = "\(date)"
            self.magnitudeDisplay.text = "\(magnitude)"
            self.depthDisplay.text = "\(depth)"
            self.longitudeDisplay.text = "\(longitude)"
            self.latitudeDisplay.text = "\(latitude)"
            self.eqidDisplay.text = "\(eqid)"
            self.srcDisplay.text = "\(src)"
            
            earthquakesFoundDisplay.isHidden = false
            currentIndexDisplay.isHidden = false
            DateTimeDisplay.isHidden = false
            magnitudeDisplay.isHidden = false
            depthDisplay.isHidden = false
            longitudeDisplay.isHidden = false
            latitudeDisplay.isHidden = false
            eqidDisplay.isHidden = false
            srcDisplay.isHidden = false
             */
        }
    }
    
}

