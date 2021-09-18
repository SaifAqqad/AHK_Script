class SpotifyAPI{
    __New(token){
        this.token := token
        this.ws:= new SpotifyWebSocket(this.token)
    }

    _CallAPI(method, endPoint, body:=""){
        url:= "https://api.spotify.com/v1/" . endpoint
        http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		http.Open(method, url, false)
        http.SetRequestHeader("Authorization", "Bearer " . this.token)
        http.Send(body)
        Try reponse:= JSON.load(http.ResponseText)
        if(http.Status > 299){ ;error
            throw, Exception(Format("(Status code: {1:}) {2:}: {3:}", http.Status, reponse.Error.Reason, reponse.Error.Message))
        }
        return reponse
    }

    Play(){
        return this._CallAPI("PUT", "me/player/play")
    }

    Pause(){
        return this._CallAPI("PUT", "me/player/pause")
    }

    TogglePlayback() {
		return ((this.GetCurrentPlaybackInfo()["is_playing"] = 0) ? (this.ResumePlayback()) : (this.PausePlayback()))
	}

    SetVolume(volume){
        volume:= Min(Max(volume, 0), 100)
        return this._CallAPI("PUT", "me/player/volume?volume_percent=" . volume)
    }

    GetCurrentPlaybackInfo(){
        return this._CallAPI("GET", "me/player")
    }

    Next(){
        return this._CallAPI("POST", "me/player/next")
    }

    Previous(){
        return this._CallAPI("POST", "me/player/previous")
    }

    class SpotifyWebSocket{ ; https://github.com/G33kDude/WebSocket.ahk
        __New(token)
        {
            static wb
            WS_URL:= "wss://dealer.spotify.com/?access_token=" token
            ; Create an IE instance
            Gui, +hWndhOld
            Gui, New, +hWndhWnd
            this.hWnd := hWnd
            Gui, Add, ActiveX, vWB, Shell.Explorer
            Gui, %hOld%: Default
            
            ; Write an appropriate document
            WB.Navigate("about:<!DOCTYPE html><meta http-equiv='X-UA-Compatible'"
            . "content='IE=edge'><body></body>")
            while (WB.ReadyState < 4)
                sleep, 50
            this.document := WB.document
            
            ; Add our handlers to the JavaScript namespace
            this.document.parentWindow.ahk_savews := this._SaveWS.Bind(this)
            this.document.parentWindow.ahk_event := this._Event.Bind(this)
            this.document.parentWindow.ahk_ws_url := WS_URL
            
            ; Add some JavaScript to the page to open a socket
            Script := this.document.createElement("script")
            Script.text := "ws = new WebSocket(ahk_ws_url);`n"
            . "ws.onopen = function(event){ ahk_event('Open', event); };`n"
            . "ws.onclose = function(event){ ahk_event('Close', event); };`n"
            . "ws.onerror = function(event){ ahk_event('Error', event); };`n"
            . "ws.onmessage = function(event){ ahk_event('Message', event); };"
            this.document.body.appendChild(Script)
        }
        
        ; Called by the JS in response to WS events
        _Event(EventName, Event)
        {
            this["On" EventName](Event)
        }
        
        ; Sends data through the WebSocket
        Send(Data)
        {
            this.document.parentWindow.ws.send(Data)
        }
        
        ; Closes the WebSocket connection
        Close(Code:=1000, Reason:="")
        {
            this.document.parentWindow.ws.close(Code, Reason)
        }
        
        ; Closes and deletes the WebSocket, removing
        ; references so the class can be garbage collected
        Disconnect()
        {
            if this.hWnd
            {
                this.Close()
                Gui, % this.hWnd ": Destroy"
                this.hWnd := False
            }
        }
    }
}