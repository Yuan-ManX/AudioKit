//
//  AKAudioOutputPlot.swift
//  AudioKit For iOS
//
//  Created by Aurelius Prochazka on 12/9/15.
//  Copyright © 2015 AudioKit. All rights reserved.
//

import Foundation

@objc public class AKAudioOutputPlot: EZAudioPlot {
    public func setupNode() {
        AKManager.sharedInstance.engine.outputNode.installTapOnBus(0, bufferSize: bufferSize, format: nil) { [weak self] (buffer, time) -> Void in
            if let strongSelf = self {
                buffer.frameLength = strongSelf.bufferSize;
                let offset: Int = Int(buffer.frameCapacity - buffer.frameLength);
                let tail = buffer.floatChannelData[0];
                strongSelf.updateBuffer(&tail[offset],
                    withBufferSize: strongSelf.bufferSize);
            }
        }
    }

    
    let bufferSize: UInt32 = 512
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNode()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNode()
    }
    #if os(OSX)
    public static func createView(width: CGFloat = 1000.0, height: CGFloat = 500.0) -> NSView {

        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        let plot = AKAudioOutputPlot(frame: frame)
        
        plot.plotType = .Buffer
        plot.backgroundColor = NSColor.whiteColor()
        plot.shouldCenterYAxis = true
        
        let containerView = NSView(frame: frame)
        containerView.addSubview(plot)
        return containerView
    }
    #else
    public static func createView(width: CGFloat = 1000.0, height: CGFloat = 500.0) -> UIView {
    
    let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
    let plot = AKAudioOutputPlot(frame: frame)
    
    plot.plotType = .Buffer
    plot.backgroundColor = UIColor.whiteColor()
    plot.shouldCenterYAxis = true
    
    let containerView = UIView(frame: frame)
    containerView.addSubview(plot)
    return containerView
    }
    #endif
}
