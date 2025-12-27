//
//  DebugLog.swift
//  Util
//
//  Created by 김민준 on 12/27/25.
//

import Foundation
import OSLog

public enum Debug {
    
    static let logger = Logger(
        subsystem: "dbk_log",
        category: "Debug"
    )

    /// 디버그 로그를 출력합니다.
    public static func log(_ message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
        let fileName = getFileName(file)
        logger.log("[\(fileName, privacy: .public):\(line, privacy: .public)] \(message, privacy: .public)")
        #endif
    }
}

// MARK: - Helper
extension Debug {
    
    /// 파일명을 반환합니다.
    private static func getFileName(_ file: String) -> String {
        let fileName = (file as NSString).lastPathComponent
        return fileName.replacingOccurrences(of: ".", with: "")
    }
}
