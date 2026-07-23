sub init()
    m.audio = m.top.findNode("audioPlayer")
    m.status = m.top.findNode("statusLabel")
    m.urlLabel = m.top.findNode("urlLabel")

    m.streamUrl = "http://192.168.1.65:5901/stream/swyh.flac?ss=u32maxnotchunked&bd=16"

    m.urlLabel.text = m.streamUrl
    print "===== SWYH channel starting ====="
    print "Stream URL: "; m.streamUrl

    m.audio.observeField("state", "onStateChange")
    m.audio.observeField("bufferingStatus", "onBufferingStatus")
    startStream()
end sub

sub startStream()
    content = CreateObject("roSGNode", "ContentNode")
    content.url = m.streamUrl
    content.live = true
    content.streamFormat = "flac"

    m.audio.content = content
    m.audio.control = "play"
    m.status.text = "Connecting..."
    print "===== Calling play on audio node ====="
end sub

sub onBufferingStatus()
    bs = m.audio.bufferingStatus
    print "===== Buffering status: "; bs
end sub

sub onStateChange()
    state = m.audio.state
    m.status.text = "Status: " + state
    print "===== Audio state changed to: "; state

    if state = "error"
        errCode = m.audio.errorCode
        errMsg = m.audio.errorMsg
        print "===== ERROR CODE: "; errCode
        print "===== ERROR MSG: "; errMsg
        m.status.text = "Error - retrying in 3s..."
        retryTimer = CreateObject("roSGNode", "Timer")
        retryTimer.duration = 3
        retryTimer.observeField("fire", "onRetry")
        retryTimer.control = "start"
        m.retryTimer = retryTimer
    end if
end sub

sub onRetry()
    startStream()
end sub
