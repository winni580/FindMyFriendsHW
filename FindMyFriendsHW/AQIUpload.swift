//
//  AQIUpload.swift
//  FindMyFriendsHW
//
//  Created by winni on 2018/7/3.
//  Copyright © 2018年 winni. All rights reserved.
//

import Foundation

struct JsonUpLoad:Codable { //
    
    
    
    
    var result: Bool = false
    //    var friends  = [Friends]()
    
    
    //以上兩種都可以 有科學型別String?  一般型別 加 ""空字串
    
    
    //    //下面是 原本開頭都是大寫 若換成小寫 要加下面的 讓程式 JSON 知道 對照表
    //    enum CodingKeys: String, CodingKey {
    //        case result = "result"
    //        case friends = "friends"
    
    
    
}






typealias AQIUploadHandler = (Error?, JsonUpLoad?) ->Void

///****
class AQIUpload {
    //    var lat = 24.985518
    //    var lon = 121.242276
    
    
    let targetURL: URL
    
    init(rssURL: URL) {
        targetURL = rssURL //下載targetURL
    }
    
    
    func upload(doneHandler: @escaping AQIUploadHandler){  // 簡單版
        
        //URL基本使用
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: targetURL) { (data, response, error) in
            
            
            if let error = error{
                print("Download Fail: \(error)")
                DispatchQueue.main.async {       //要用main.async 把doneHandler(error, nil)包在裡面 方便別人使用 不會出錯
                    doneHandler(error, nil)
                }
                
                return
            }
            
            guard let data = data else{
                print("Data is nil.")
                let error = NSError(domain: "Data is nil.", code: -1, userInfo: nil) // 自行創立error範例 用NSError創造 用負數- 來呈現-1數字自己選
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
                return
                
            }
            //Parse 解析 JSON form data.
            let decoder = JSONDecoder()
            var results: JsonUpLoad?
            
            do{
                results = try decoder.decode(JsonUpLoad.self, from: data)
            }
            catch{
                print("JSON Parse Fail: \(error)")
            }
            
            
            
            
            if let results = results {
                DispatchQueue.main.async {
                    doneHandler(nil, results)
                }
                
            }else {
                //Parse Fail.
                let error = NSError(domain: "Parse JSON Fail!", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
            }
            
            
        }
        
        task.resume()
        
    }
    
}

