//
//  StoryViewController.swift
//  Arak
//
//  Created by Abed Qassim on 25/02/2021.
//  
//

import UIKit
import Foundation
import AVKit
import WebKit
import Player
class StoryViewController: UIViewController {
    
    enum Source {
        case Home
        case Favrate
        case History
    }
    // MARK: - Outlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timerLable: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var forwardButtonImage: UIButton!
    @IBOutlet weak var backwardButtonImage: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var learnMoreView: UIView!
    @IBOutlet weak var gradiantView: UIView!
    @IBOutlet weak var timerImageView: UIImageView!

    // MARK: - Properties
    
    private var count: Double = 0
    private var activeIndex = 0
    private var activeAds:Adverisment?
    private var timer = Timer()
    private var viewModel: StoryViewModel?
    private var adsType: AdsTypes = .image
    private var avPlayerController = AVPlayerViewController()
    private var activityIndicator: UIActivityIndicatorView!
    private var path = ""
    private var detailViewModel = DetailViewModel()
    private var source: Source = .Home
    fileprivate var player = Player()
    private var currentImageIndex = 0
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        self.view.addSubview(activityIndicator)
        
        forwardButtonImage.isHidden = true
        backwardButtonImage.isHidden = true
        if let viewModel = viewModel {
            prepareBinding(index: viewModel.index)
        }else {
            self.navigationController?.popViewController(animated: true)
            return
        }
       
        
        learnMoreView.addTapGestureRecognizer {
            let detailVC = self.initViewControllerWith(identifier: DetailViewController.className, and: "") as! DetailViewController
            detailVC.confige(id: self.activeAds?.id)
            self.show(detailVC)
        }
        player.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.stop()
        self.hiddenNavigation(isHidden: true)
    }
    
    deinit {
       
        self.player.willMove(toParent: nil)
        
        self.player.view.removeFromSuperview()
        self.player.removeFromParent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hiddenNavigation(isHidden: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.hiddenNavigation(isHidden: false)
        player.stop()
        player.viewDidDisappear(animated)
    }
    
    @IBAction func Next(_ sender: Any) {
        setView(view: gradiantView, hidden: true)
        prepareBinding(index: activeIndex +  1)
    }
    
    func prepareBinding(index: Int) {
        activeIndex = index
        if (activeIndex >= 0 &&  activeIndex < viewModel?.adsList.count ?? 0 ) {
            activeAds = viewModel?.adsList[activeIndex]
            setupUI()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    // MARK: - Protected Methods
    private func setupUI() {
        learnMoreButton.setTitle("Learn More".localiz(), for: .normal)
        if (source != .Home) {
            timer.invalidate()
            learnMoreView.isHidden = false
            gradiantView.backgroundColor = .clear
            learnMoreButton.isHidden = false
            timerImageView.isHidden = true
            timerLable.text = ""
            setView(view: gradiantView, hidden: false)

            if let activeAds = activeAds {
                if activeAds.adCategoryID == AdsTypes.image.rawValue {
                    imageView.isHidden = false
                    videoView.isHidden = true
                    webView.isHidden = true
                    imageView.getAlamofireImage(urlString: activeAds.adImages?.first?.path)
                    //prepare()
                } else if activeAds.adCategoryID == AdsTypes.video.rawValue   {
                    imageView.isHidden = true
                    videoView.isHidden = false
                    webView.isHidden = true
                    setupVideo(path: activeAds.adImages?.first?.path ?? "")
                } else {
                    imageView.isHidden = true
                    videoView.isHidden = true
                    webView.isHidden = false
                    setupWebView(path: activeAds.websiteURL ?? "")
                }
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            
            gradiantView.isHidden = true
            timerImageView.isHidden = false
            learnMoreView.isHidden = true
            if let activeAds = activeAds {
                if activeAds.adCategoryID == AdsTypes.image.rawValue {
                    timerLable.text = "00:00"
                    imageView.isHidden = false
                    videoView.isHidden = true
                    webView.isHidden = true
                    count = Double(activeAds.duration ?? "5") ?? 5
                    imageView.getAlamofireImage(urlString: activeAds.adImages?.first?.path)
                    fetchImageDetail(id: activeAds.id ?? 0 )
                    print(activeAds.adImages)
                    prepare()
                } else if activeAds.adCategoryID == AdsTypes.video.rawValue   {
                    imageView.isHidden = true
                    videoView.isHidden = false
                    webView.isHidden = true
                    setupVideo(path: activeAds.adImages?.first?.path ?? "")
                } else {
                    count = Double(activeAds.duration ?? "5") ?? 5
                    prepare()
                    imageView.isHidden = true
                    videoView.isHidden = true
                    webView.isHidden = false
                    setupWebView(path: activeAds.websiteURL ?? "")
                }
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
       
        
    }
    
    private func setupWebView(path: String) {
        guard let url = URL(string: path)  else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    @objc func update() {
        if(count > 0) {
            timerLable.isHidden = false
            timerImageView.isHidden = false
            count = count - 1
            timerLable.text = (count).asString(style: .positional)
            setView(view: gradiantView, hidden: true)
        } else {
            updateDetail()
            timer.invalidate()
            timerLable.isHidden = true
            timerImageView.isHidden = true
            learnMoreView.isHidden = false
            player.pause()
            player.stop()
            setView(view: gradiantView, hidden: false)
//            if activeAds?.adCategoryID == AdsTypes.videoWeb.rawValue {
//                learnMoreButton.isHidden = true
//            } else {
//
//            }
        }
    }
    
    private func updateDetail() {
//        detailViewModel.adsDetail(id: activeAds?.id ?? -1) { [weak self] (error) in
//            defer {
//                self?.stopLoading()
//            }
//            if error != nil {
//                return
//            }
//        }
    }
    
 
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    private func prepare() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    private func setupVideo(path: String) {
        if source != .Home {
            activityIndicator.startAnimating()
            timerLable.text = ""
            
            if let videoUrl = URL(string: path) {
                self.player.playerDelegate = self
                self.player.playbackDelegate = self
                
                self.player.playerView.playerBackgroundColor = .black
                try? AVAudioSession.sharedInstance().setCategory(.playback)
                self.addChild(self.player)
                self.videoView.addSubview(self.player.view)
                self.player.didMove(toParent: self)
                self.player.url = videoUrl
                self.player.playbackLoops = true
                
            }
        } else {
            activityIndicator.startAnimating()
            timerLable.text = "00:00"
            
          
            if let videoUrl = URL(string: path) {
                self.player.playerDelegate = self
                self.player.playbackDelegate = self
                
                self.player.playerView.playerBackgroundColor = .black
                try? AVAudioSession.sharedInstance().setCategory(.playback)
                self.addChild(self.player)
                self.videoView.addSubview(self.player.view)
                self.player.didMove(toParent: self)
                self.player.url = videoUrl
                self.player.playbackLoops = true
                self.count = 60
                
            }
        }
        
    }
    
    
    private func fetchImageDetail(id: Int) {
        activityIndicator.startAnimating()
        detailViewModel.adsDetail(id: id) { [weak self] (error) in
            defer {
                self?.activityIndicator.stopAnimating()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            if self?.detailViewModel.adImages.count ?? 0 > 1 {
                self?.forwardButtonImage.isHidden = false
                self?.backwardButtonImage.isHidden = false
            }
//            self?.loadDetailView()
        }
    }
    
    public func config(viewModel: StoryViewModel, source: Source) {
        self.viewModel = viewModel
        self.source = source
    }
    
    @IBAction func Close(_ sender: Any) {
//        player.forceStop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        self.player.willMove(toParent: nil)
        self.player.view.removeFromSuperview()
        self.player.removeFromParent()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forwardButtonAction(_ sender: Any) {
        if currentImageIndex < detailViewModel.adImages.count - 1 {
            currentImageIndex += 1
            imageView.getAlamofireImage(urlString: detailViewModel.adImages[currentImageIndex])
        }
    }
    
    @IBAction func backwardButtonAction(_ sender: Any) {
        if currentImageIndex > 0 {
            currentImageIndex -= 1
            imageView.getAlamofireImage(urlString: detailViewModel.adImages[currentImageIndex])
        }
    }
    
    @IBAction func LearnMore(_ sender: Any) {
        if Helper.userType == Helper.UserType.GUEST.rawValue  {
            showLogin()
            Helper.resetLoggingData()
            return
        }
//        player.forceStop()
        let detailVC = self.initViewControllerWith(identifier: DetailViewController.className, and: "") as! DetailViewController
        detailVC.confige(id: activeAds?.id)
        self.show(detailVC)
    }
    
}
extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        if self < 60 {
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = .pad //pad seconds and minutes ie 00:05
        } else if self >= 60*60 {
            formatter.allowedUnits = [.hour, .minute, .second]
        }
        
        var formattedDuration = formatter.string(from: self) ?? "0"
        if formattedDuration.hasPrefix("00") {
            formattedDuration = String(formattedDuration.dropFirst()) //remove leading 0 ie 0:05
        }
        return formattedDuration
    }
}
extension StoryViewController: PlayerDelegate {
    func playerReady(_ player: Player) {
        print("\(#function) ready")
        self.activityIndicator.stopAnimating()
        self.count = Double(activeAds?.duration ?? "5") ?? 5
        if source == .Home {
            self.prepare()
        }
        self.player.playFromBeginning()
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("\(#function) \(player.playbackState.description)")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print("\(#function) error.description")
        self.activityIndicator.stopAnimating()
    }
    
    
}
extension StoryViewController: PlayerPlaybackDelegate {
    
    func playerCurrentTimeDidChange(_ player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
    }
}
