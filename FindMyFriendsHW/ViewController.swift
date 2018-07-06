//
//  ViewController.swift
//  FindMyFriendsHW
//
//  Created by winni on 2018/6/24.
//  Copyright © 2018年 winni. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
    var result2: SiteInfo?
    var coordinates = [CLLocationCoordinate2D]() //宣告變數 用來放後面 自己軌跡的 array
    
   
    
    @IBOutlet weak var qooUISwitch: UISwitch!
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mainMapView.mapType = .standard
        case 1:
            mainMapView.mapType = .satellite
        case 2:
            mainMapView.mapType = .hybrid
        case 3:
            mainMapView.mapType = .satelliteFlyover
            
            
            let coordinate = CLLocationCoordinate2DMake(24.985518, 121.242276)
            let crmera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 800, pitch: 65, heading: 0)
            mainMapView.camera = crmera
            
        default:
            mainMapView.mapType = .standard
        }
        
        
        
    }
    @IBOutlet weak var mainMapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    @IBAction func userTrackingModeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
        case 0:
            mainMapView.userTrackingMode = .none
        case 1:
            mainMapView.userTrackingMode = .follow
        case 2:
            mainMapView.userTrackingMode = .followWithHeading
        default:
            mainMapView.userTrackingMode = .none
        }
       
       

    }
    
    @IBOutlet weak var userTrackingUISegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // userTrackingUISegmentedControl.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2.0))
        
        


            
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        mainMapView.delegate = self  //這行沒打 我們移動地圖 不會有反應所以在DidLoad裡打
        
        
        //Ask user's permission P26頁
        locationManager.requestAlwaysAuthorization()
        
        //Background location update support.
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        //下面是檢查user有們有授權
        guard CLLocationManager.locationServicesEnabled()
            else{
                //Show hint to user....
                return
        }
        
        guard CLLocationManager.authorizationStatus() == .authorizedAlways
            else{
                //Show hint to user...
                return
        }
        //Prepare locationManager
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation//告訴系統活動總類是什麼 讓ＧＰＳ開關時間調整 讓手機續航力提高
        // locationManager.distanceFilter = 5.0//移動20米就會回報,20米內不回報
        locationManager.startUpdatingLocation()//自動回報位置
        

        
        
        
        
        
        
        ///取得伺服器資料
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //....
        refreshBtnPressed() //從伺服器 取得 資料
        
        
        
        
        guard let location = locationManager.location else{
            print("Location is not ready.")
            return
        }
        // Add a annotationView at a fake place. 虛擬一個位置
        var storeCoordinate = location.coordinate
        storeCoordinate.latitude += 0.005
        storeCoordinate.longitude += 0.005
        
        let annotation = MKPointAnnotation() //這是預設大頭針
        annotation.coordinate = storeCoordinate//設定座標
        
        //let annotation = StoreAnnotation() //這是自創大頭針
        //            annotation.coordinate = storeCoordinate
        annotation.title = "啃德雞"
        //            annotation.subtitle = "真好吃"
        //            annotation.storeID = 123456
        //            annotation.storeType = StoreType.seven
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){//一秒鐘後再執行 裡面 大頭針插上去的動作
        //            self.mainMapView.addAnnotation(annotation) // 顯示出大頭針 出來
        //        }
        
        
        // Move and zoom the map to the storecoordinate.
        //           let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        //          let region = MKCoordinateRegion(center: storeCoordinate, span: span)
        //         mainMapView.setRegion(region, animated: false)
        //
        //a)0.001看到範圍變小
        //a)0,01 看到範圍更大
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //test........
    // var detailViewController: DetailViewController? = nil
    // var objects = [SiteInfo]() //原本是newsitem 改成 siteInfo
    
    
    
    //    //////
    
    @objc
    func refreshBtnPressed(){//選網站
        let urlString = "http://class.softarts.cc/FindMyFriends/queryFriendLocations.php?GroupName=CP101"
        
        
        guard let url = URL(string: urlString) else {
            assertionFailure("Invalid URL string.")
            return
        }
        let downloader = AQIDownloader(rssURL: url)
        downloader.download {(error,result) in
            if let error = error{
                print("Error? \(error)")
                //show alert to user.
                return
            }
            if let items = result{
                print("items \(items)")
                self.result2 = items
                
                
                
                
                
                //陣列裡有多少東西
                guard let total = self.result2?.friends.count else{
                    return
                }
                print("\(total)")
                //var sum = 0
                for i in 0...total-1{ //數子從零 從零開始 是因為 取陣列第一個位置 數字 total後面要減1
                    // sum += i
                    
                    // 開始抓朋友的資料 把每一個大頭針 取出來 要放在for裡面 每跑一個 就把朋友們依序取出來 如果 放到外面 會認為都是一樣的 只會顯示一個
                    
                    let friendAnnotation = MKPointAnnotation() //建朋友大頭針實體
                    
                    
                    print("\(self.result2)")
                    print("\(self.result2?.friends[i])")
                    
                    
                    
                    
                    guard let lat = self.result2?.friends[i].lat else { // 如果 要確定沒有空值 前面就要加guard let....else return
                        
                        continue
                    }
                    
                    guard let lat2 = Double(lat)  else { //要將lat 轉成Double 怕遇到空值 一樣前面加guard let..else return
                        continue
                    }
                    
                    ///
                    guard let lon = self.result2?.friends[i].lon else { // 如果 要確定沒有空值 前面就要加guard let....else
                        
                        continue
                    }
                    
                    guard let lon2 = Double(lon)  else {//要將lon 轉成Double 怕遇到空值 一樣前面加guard let..else return
                        continue
                    }
                    
                    guard let friendName = self.result2?.friends[i].friendName else {
                        continue
                    }
                    
                    friendAnnotation.coordinate = CLLocationCoordinate2DMake(lat2, lon2) //設定座標 要把顯示出來 前面要先做物件把他轉成字串 再放進來
                    friendAnnotation.title = friendName
                    
                    
                    self.mainMapView.addAnnotation(friendAnnotation) // 顯示出大頭針 出來
                    print("friendName: \(friendName)")
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
                ////@@@@ 用 迴圈 for each
                
                
                //陣列裡有多少東西
                //                let total = self.result2?.friends.count
                
                
                
                //                //迴圈範例
                //                var sum = 0
                //              for( int i = 1  i<= 13 i++)
                // sum += i
                //
                
                //2次 手動
                //                sum += 1
                //                sum += 2
                //
                //                for i in 1...2{ //2次
                //                    sum += i
                //
                //                }
                //
                //
                //                for i in 1...n{
                //                    sum += i
                //
                //
                //                }
                
                
                
                
                
            }else{
                // Show alert to user.
            }
            
        }
        
        
    }
    
}

extension ViewController: CLLocationManagerDelegate{
    //MARK: - CLLocationManagerDelegate methods.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {// 每次更新 會呼叫這個didUpdateLocations方法CLLocation不只用來提供經緯度
        //coordinat 是用來拿經緯度的
        guard let coordinate = locations.last?.coordinate//locations是allary 會抓很多資料下來 拿最後的經緯度 取一個即可
            else{
                assertionFailure("Invalid coordinate.")//assertionFailure 方便於做Debug如果有跑進來代表有問題 他會卡住
                return
        }
        print("Coordinate:\(coordinate.latitude).\(coordinate.longitude)")// 把鮪鯨度印出來
        
        
        let url = "http://class.softarts.cc/FindMyFriends/updateUserLocation.php?%20GroupName=cp101&UserName=Winni&Lat=\(coordinate.latitude)&Lon=\(coordinate.longitude)"
        print("url: \(url)")
        
        
       
        guard let url3 = URL(string: url) else { // 把字串 轉成ＵＲＬ
            assertionFailure("Invalid URL string.")
            return
        }
        //下面是加了on off 開關 添加 if 判斷式 最前面宣告 把原本上傳的位置丟在裡面 ,如果是 on 就執行回報位置 off 就是不回報
        if qooUISwitch.isOn { let uploader = AQIUpload(rssURL: url3)// 這裡是上傳 我的位置的地方
            
            uploader.upload(doneHandler: {(error, result) in
                if let error = error {
                    print("Error? \(error)")
                    return
                }
                
                
                
                print("result \(result)")
            })
            
        }
       

       coordinates.append(coordinate) // 把coordinates append到 陣列裡 （）裡裝每一次的座標經緯度 有很多個
        //要製造軌跡 地圖上會出現 一條線
        //用 let 自己取一個名字line 用MKPolyline 來畫線 coordinates：放我們宣告的陣列（coordinates） count  取出陣列有多少個內容(coordinates.count)
        let line = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mainMapView.add(line)
    }
    
    
}
extension ViewController:MKMapViewDelegate{//Delegate 是代理的意思 方便我們操作 view
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {//MKMapViewDelegate方法 地圖的顯示區域已經被改變
        
        let region = mapView.region //取得目前地圖顯示區域
        print("Center:\(region.center.latitude),\(region.center.longitude)")
        print("Region:\(region.span.latitudeDelta),\(region.span.longitudeDelta)")
        
    }
    
    
    @objc
    func callOutBtnTapped(sender: Any){
        print("callOutBtnTapped!")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
}




