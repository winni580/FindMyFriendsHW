//
//  AQIDownloader.swift
//  FindMyFriendsHW
//
//  Created by winni on 2018/6/27.
//  Copyright © 2018年 winni. All rights reserved.
//

import Foundation
struct SiteInfo:Codable {//新聞有20則就有20個 struct 這裡有7個
    
    //...公開資料裡 要呈現蛇麼 就抓什麼下來
    //    var SiteName: String?
    //    var County: String?
    //    var AQI:String?
    //    var Latitude: String?
    //    var Longitude: Sting?
    
    
    var result: Bool = false
    var friends  = [Friends]()
    
    
    //以上兩種都可以 有科學型別String?  一般型別 加 ""空字串
    
    
    //下面是 原本開頭都是大寫 若換成小寫 要加下面的 讓程式 JSON 知道 對照表
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case friends = "friends"
       
        
       
    }
    
}
struct Friends:Codable{
    
var id: String?
var friendName: String?
var lat: String?
var lon: String?

}



typealias AQIDownloadHandler = (Error?, SiteInfo?) ->Void


class AQIDownloader{
    
    
    let targetURL: URL
    
    init(rssURL: URL) {
        targetURL = rssURL //下載targetURL
    }
    
    //func download(doneHandler: (Error?, [NewsItem]?) -> Void) { 復雜版 在上面加上typealias 用法 只要寫下面簡單版即可 兩行相同
    func download(doneHandler: @escaping AQIDownloadHandler){  // 簡單版
        
        //ＵＲＬ基本使用
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
            //Parse JSON form data.
            let decoder = JSONDecoder()
            var results: SiteInfo?
            
            do{
                  results = try decoder.decode(SiteInfo.self, from: data)
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
