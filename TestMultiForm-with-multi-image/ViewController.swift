//
//  ViewController.swift
//  TestMultiForm-with-multi-image
//
//  Created by sok channy on 12/10/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func uploadPressed(_ sender: Any) {    
        doUpload()
    }
    func doUpload(){
        let url = URL(string:"http://120.136.24.174:15020/v1/api/admin/upload/multiple")
        var request = URLRequest(url:url!)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.addValue("Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==", forHTTPHeaderField: "Authorization")
        
        let body = createBody(parameters: ["name":"Sok Shop","files":[#imageLiteral(resourceName: "image1"),#imageLiteral(resourceName: "image2")]], boundary: boundary) as Data
        
        let session = URLSession.shared
        
        print("Reach 1")
        
        session.uploadTask(with: request as URLRequest, from : body){
            data, response, error in
                print("Reach 2")
            
            
                print(response ?? "NO response")
                if data != nil {
                    let dataJson = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(dataJson)
                }
            
                if error != nil {
                    print(error ?? "NO response")
                }
        }.resume()
    }
    
    func createBody(parameters: NSMutableDictionary?,boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                
                if(value is String || value is NSString){
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    body.append("\(value)\r\n".data(using: .utf8)!)
                }
                    
                else if(value is [UIImage]){
                    var i = 0;
                    for image in value as! [UIImage]{
                        let filename = "image\(i).jpg"
                        let data = UIImageJPEGRepresentation(image,1);
                        
                        let mimetype = "image/jpg"
                        
                        body.append("--\(boundary)\r\n".data(using: .utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
                        body.append(data!)
                        body.append("\r\n".data(using: .utf8)!)
                        i = i + 1;
                    }
                    
                    
                }
            }
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

