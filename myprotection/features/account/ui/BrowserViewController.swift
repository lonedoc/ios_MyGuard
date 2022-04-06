//
//  BrowserViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 14.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    // swiftlint:disable:next force_cast
    private var rootView: BrowserScreenLayout { return view as! BrowserScreenLayout }

    private let accountId: String
    private let sum: Double
    private let paymentSystemUrl: String

    init(accountId: String, sum: Double, paymentSystemUrl: String) {
        self.accountId = accountId
        self.sum = sum
        self.paymentSystemUrl = paymentSystemUrl

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = BrowserScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.webView.loadHTMLString(
            """
                <!doctype html>
                <html>
                <head>
                    <style>
                        html {
                            height: 100%;
                            overflow: hidden;
                        }

                        body {
                            margin: 0;
                            padding: 0;
                            width: 100%;
                            height: 100%;
                            background: url(/pic/loading.gif) no-repeat center
                        }

                        div {
                            display: none;
                        }
                    </style>
                </head>
                <body>
                    <div>
                        <form method='POST' action='\(paymentSystemUrl)/create/'>
                            <input type='text' name='sum' value='\(sum)'/>
                            <input type='text' name='clientid' value='\(accountId)'/>
                            <input type='submit' value='pay'/>
                        </form>
                    </div>
                    <script>
                        document.forms[0].submit();
                    </script>
                </body>
                </html>
            """,
            baseURL: URL(string: paymentSystemUrl)
        )
    }

}
