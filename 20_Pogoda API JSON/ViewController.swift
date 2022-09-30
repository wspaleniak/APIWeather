//
//  ViewController.swift
//  20_Pogoda API JSON
//
//  Created by Wojciech Spaleniak on 19/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    func returnClosure(nameUserCity: UILabel, tempForUserCity: UILabel, weatherForUserCity: UILabel) -> ((Data?, URLResponse?, Error?) -> Void) {
        
        let myClosure = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error!)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let name = jsonResult["name"] as? String,
                           let temp = (jsonResult["main"] as? AnyObject)?["temp"] as? Double,
                           let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                            
                            let tempInCelsius = (String(format: "%.1f", temp - 273.15) + " °C").replacingOccurrences(of: ".", with: ",")
                            
                            DispatchQueue.main.sync(execute: {
                                nameUserCity.text = name
                                tempForUserCity.text = tempInCelsius
                                weatherForUserCity.text = description.uppercased()
                            })
                        }
                    } catch {
                        print("Błąd w przetwarzaniu JSON")
                    }
                }
            }
        }
        return myClosure
    }
    
    @IBOutlet weak var userCity: UITextField!
    @IBOutlet weak var nameUserCity: UILabel!
    @IBOutlet weak var tempForUserCity: UILabel!
    @IBOutlet weak var weatherForUserCity: UILabel!
    @IBAction func checkWeather(_ sender: Any) {
        
        let appId = "Place for your KEY to API Open Weather Map"
        let city = userCity.text!.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(appId)")
        
        if let url = url {
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: returnClosure(nameUserCity: nameUserCity, tempForUserCity: tempForUserCity, weatherForUserCity: weatherForUserCity))
            
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
