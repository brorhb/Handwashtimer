//
//  ComplicationController.swift
//  Speedy WatchKit Extension
//
//  Created by Bror Brurberg on 07/03/2020.
//  Copyright © 2020 Bror Brurberg. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    private func createComplication(for complication: CLKComplication) -> CLKComplicationTemplate? {
        let imageName = "droplet_icon.png"
        var template = CLKComplicationTemplate()
        switch complication.family {
            case .modularSmall:
                let t = CLKComplicationTemplateModularSmallRingImage()
                t.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: imageName)!)
                template = t
            case .utilitarianSmall, .utilitarianSmallFlat:
                let t = CLKComplicationTemplateUtilitarianSmallFlat()
                t.textProvider = CLKSimpleTextProvider(text: "open")
                t.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: imageName)!)
                template = t
            case .circularSmall:
                let t = CLKComplicationTemplateCircularSmallSimpleImage()
                t.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: imageName)!)
                template = t
            case .extraLarge:
                let t = CLKComplicationTemplateExtraLargeSimpleImage()
                t.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: imageName)!)
                template = t
            case .graphicCircular:
                let t = CLKComplicationTemplateGraphicCircularStackText()
                t.line1TextProvider = CLKSimpleTextProvider(text: "wash")
                t.line2TextProvider = CLKSimpleTextProvider(text: "hands")
                template = t
            case .graphicCorner:
                let t = CLKComplicationTemplateGraphicCornerStackText()
                t.outerTextProvider = CLKSimpleTextProvider(text: "Open")
                t.innerTextProvider = CLKSimpleTextProvider(text: "Handwashtimer")
                template = t
            default:
                return nil
        }
        return template
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let date = Date()
        guard let template = createComplication(for: complication) else {
            handler(nil)
            return
        }
        
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        handler(entry)
    }

    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        guard let template = createComplication(for: complication) else {
            handler(nil)
            return
        }
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        handler([entry])
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        guard let template = createComplication(for: complication) else {
            handler(nil)
            return
        }
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        handler([entry])
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        guard let template = createComplication(for: complication) else {
            handler(nil)
            return
        }
        handler(template)
    }
    
}
