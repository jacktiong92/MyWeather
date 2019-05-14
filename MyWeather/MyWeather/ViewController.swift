//
//  ViewController.swift
//  MyWeather
//
//  Created by Techninier on 11/05/2019.
//  Copyright © 2019 byProgrammers. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initialSetup()
    }

    // MARK: - Keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.getWoeid(city: textField.text ?? "") { (woeid) in
            self.getWeather(woeid: woeid, completion: { (weather) in
                
                self.cityLabel.text = weather.title
                self.weatherLabel.text = weather.weather_state_name
                self.tempLabel.text = String(weather.the_temp) + "°"
                
                switch weather.weather_state_abbr {
                case "c":
                    self.bgImage.image = UIImage(named: "clear")
                case "h":
                    self.bgImage.image = UIImage(named: "hail")
                case "hc":
                    self.bgImage.image = UIImage(named: "heavy-cloud")
                case "hr":
                    self.bgImage.image = UIImage(named: "heavy-rain")
                case "lc":
                    self.bgImage.image = UIImage(named: "light-cloud")
                case "lr":
                    self.bgImage.image = UIImage(named: "light-rain")
                case "s":
                    self.bgImage.image = UIImage(named: "showers")
                case "sl":
                    self.bgImage.image = UIImage(named: "sleet")
                case "sn":
                    self.bgImage.image = UIImage(named: "snow")
                case "t":
                    self.bgImage.image = UIImage(named: "thunder")
                default:
                    self.bgImage.image = UIImage(named: "")
                }
            
            })
        }
        
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - Setup
    
    func initialSetup() {
        self.cityTextField.delegate = self
    }
    
    // MARK: - Helper
    
    func getWoeid(city: String, completion: @escaping (String) -> ()) {
        
        let urlPath = Constants.apiBase + Constants.apiLocationSearch
        
        Alamofire.request(urlPath, method: .post, parameters: ["query":city], encoding: URLEncoding(destination: .queryString), headers: [:]).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let httpURLResponse = response.response {
                    if httpURLResponse.statusCode == 200 {
                        if let result = response.result.value, let json = result as? [[String: AnyObject]] {
                            if json.count > 0 {
                                let location = json[0]
                                if let woeid = location["woeid"] as? Int {
                                    completion(String(woeid))
                                } else {
                                    completion("")
                                }
                            } else {
                                completion("")
                            }
                        } else {
                            // .jsonConversionFailure
                            print(".jsonConversionFailure")
                        }
                    } else {
                        // .responseUnsuccessful
                        print(".responseUnsuccessful")
                    }
                } else {
                    // .responseUnsuccessful
                    print(".responseUnsuccessful")
                }
            case .failure:
                print(".requestFailed")
            }
            
        }
        
    }
    
    func getWeather(woeid: String, completion: @escaping (Weather) -> ()) {
        let urlPath = Constants.apiBase + Constants.apiLocation + woeid
        
        Alamofire.request(urlPath, method: .post, parameters: [:], encoding: URLEncoding(destination: .queryString), headers: [:]).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let httpURLResponse = response.response {
                    if httpURLResponse.statusCode == 200 {
                        if let result = response.result.value, let json = result as? [String: AnyObject] {
                            let weather = Weather(json: json)
                            completion(weather)
                        } else {
                            // .jsonConversionFailure
                            print(".jsonConversionFailure")
                        }
                    } else {
                        // .responseUnsuccessful
                        print(".responseUnsuccessful")
                    }
                } else {
                    // .responseUnsuccessful
                    print(".responseUnsuccessful")
                }
            case .failure:
                print(".requestFailed")
            }
            
        }
    }

    
}

