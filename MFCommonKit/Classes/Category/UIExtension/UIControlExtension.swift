//
//  UIControlExtension.swift
//  SKEdu
//
//  Created by iOS开发 on 2019/6/13.
//  Copyright © 2019 shanxidongda. All rights reserved.
//

import Foundation
import UIKit

class EventsWrapper: NSObject {
    var events: UIControl.Event?
    var handler: ((AnyObject?) -> ())?    
    init(handler:@escaping ((AnyObject?) -> ()),events:UIControl.Event ) {
        super.init()
        self.handler = handler
        self.events = events
    }    
    @objc func invoke(sender: AnyObject) {
        if let block = handler {
            weak var weakSelf = self
            block(weakSelf)
        }
    }
    
}

extension UIControl {    
    static var EventsMapKey: String = "EventsMapKey"    
    func getEventsMap() -> NSMutableDictionary {
        var eventsMap: NSMutableDictionary? = objc_getAssociatedObject(self, UIControl.EventsMapKey) as? NSMutableDictionary
        if  eventsMap == nil {
            eventsMap = NSMutableDictionary()
            objc_setAssociatedObject(self, UIControl.EventsMapKey, eventsMap, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return eventsMap!
    }    
    func addClick(callback:@escaping () -> ()) {
        self.addEvents(events: UIControl.Event.touchUpInside, callBack: callback)
    }    
    func addDown(callback:@escaping () -> ()) {
        self.addEvents(events: UIControl.Event.touchDown, callBack: callback)
    }    
    func addEvents(events: UIControl.Event,callBack:@escaping (() -> ())) {
        self.addEvents(event: events) { (sender) in
             callBack()
        }
    }    
    func addEvents(event: UIControl.Event,handler:@escaping (AnyObject?) -> ()){
        let eventsKey = "\(event)"
        var eventWrapper: EventsWrapper? = self.getEventsMap().object(forKey: eventsKey) as? EventsWrapper
        if let wrapper = eventWrapper {
            wrapper.handler = handler
        } else {
            eventWrapper = EventsWrapper(handler: handler, events: event)
            self.getEventsMap().setValue(eventWrapper, forKey: eventsKey)
        }
        self.addTarget(eventWrapper, action: #selector(EventsWrapper.invoke(sender:)), for: event)
    }
    
}
