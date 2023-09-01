//
//  PreviewVC.swift
//  Netflix
//
//  Created by macbook on 16/08/2023.
//

import UIKit
import WebKit
class PreviewVC: UIViewController {
    private let label1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let webView: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(button)
        view.addSubview(webView)
        setupConstraint()
    }
    func setupConstraint() {
        let CtWebView = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.heightAnchor.constraint(equalToConstant: 300)
            ]
        let Ctlabel1 = [
            label1.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            
        ]
        let Ctlabel2 = [
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 20),
            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let CtButton = [
            button.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 140),
            button.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(Ctlabel1)
        NSLayoutConstraint.activate(Ctlabel2)
        NSLayoutConstraint.activate(CtButton)
        NSLayoutConstraint.activate(CtWebView)
    }
    func confige(with model: TitlePreviewViewModel) {
        label1.text = model.title
        label2.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    

}
