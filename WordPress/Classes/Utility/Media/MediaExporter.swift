import Foundation

/// Generic Error protocol for detecting and type classifying known errors that occur while exporting.
///
protocol MediaExporterError: Error, CustomStringConvertible {
    /// Convert an Error to an NSError with a localizedDescription available.
    ///
    func toNSError() -> NSError
}

/// Generic MediaExporterError tied to a system generated Error.
///
enum MediaExportSystemError: MediaExporterError {
    case failedWith(systemError: Error)
    public var description: String {
        switch self {
        case .failedWith(let systemError):
            return String(describing: systemError)
        }
    }
    func toNSError() -> NSError {
        switch self {
        case .failedWith(let systemError):
            return systemError as NSError
        }
    }
}

protocol MediaExporter {
    /// Resize the image if needed, according to the user's MediaSettings.
    ///
    var resizesIfNeeded: Bool { get set }

    /// Strip the geoLocation from assets if needed, according to the user's MediaSettings.
    ///
    var stripsGeoLocationIfNeeded: Bool { get set }
}

extension MediaExporter {

    /// Handles wrapping into MediaExporterError type values when the encountered Error type value is unknown.
    ///
    /// - param error: Error with an unknown type value, or nil for easy conversion.
    /// - returns: The ExporterError type value itself, or an ExportError.failedWith
    ///
    func exporterErrorWith(error: Error) -> MediaExporterError {
        switch error {
        case let error as MediaExporterError:
            return error
        default:
            return MediaExportSystemError.failedWith(systemError: error)
        }
    }
}