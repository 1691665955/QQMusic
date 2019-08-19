//
//  String+Extension.swift
//  QQMusic
//
//  Created by 曾龙 on 2019/8/17.
//  Copyright © 2019 com.mz. All rights reserved.
//

import Foundation

extension String {
    func htmlText() -> String {
        do {
            return try NSAttributedString.init(data: self.data(using: .unicode)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil).string;
        } catch  {
            return self;
        }
    }
}
