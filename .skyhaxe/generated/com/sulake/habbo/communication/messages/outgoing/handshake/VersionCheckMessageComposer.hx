package com.sulake.habbo.communication.messages.outgoing.handshake
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class VersionCheckMessageComposer implements IMessageComposer
    {
        var _clientID:Int = 0;
        var _clientURL:String;
        var _externalVariablesURL:String;

        public function new(clientID:Int, clientURL:String, externalVariablesURL:String)
        {
            this._clientID = clientID;
            this._clientURL = clientURL;
            this._externalVariablesURL = externalVariablesURL;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._clientID, this._clientURL, this._externalVariablesURL];
        }
    }

