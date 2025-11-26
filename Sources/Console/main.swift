//
//  main.swift
//  console
//
//  Created by Jim Derry on 2021/7/13.
//  Copyright © 2021 Jim Derry. All rights reserved.
//
//  Modified by AthanasiusOfAlex on 2025/11/26.
//

import Foundation
import SwLibTidy
import os.log

let logger = Logger(subsystem: "com.example.SwLibTidy", category: "General")


/* If the linked Tidy is older than the mininum supported, then
   a console message will be output when the TidyDoc is created. */
if let tdoc: TidyDoc = tidyCreate() {
    tidyRelease( tdoc )
    logger.log("tidyCreate succeeded.")
} else {
    logger.error("tidyCreate failed.")
}

/* Simply print some LibTidy details. */
logger.log("LibTidy \(tidyLibraryVersion()) released on \(tidyReleaseDate()) for \(tidyPlatform()).")
