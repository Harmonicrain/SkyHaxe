package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PatternMatchData implements IDisposable
    {
        var _pattern:String;
        var _startIndex:Int = 0;
        var _endIndex:Int = 0;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._pattern = k.readString();
            this._startIndex = k.readInteger();
            this._endIndex = k.readInteger();
        }

        public function dispose()
        {
            this._disposed = true;
            this._pattern = "";
            this._startIndex = -1;
            this._endIndex = -1;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var pattern(get,never):String;
function  get_pattern():String
        {
            return this._pattern;
        }

        public var startIndex(get,never):Int;
function  get_startIndex():Int
        {
            return this._startIndex;
        }

        public var endIndex(get,never):Int;
function  get_endIndex():Int
        {
            return this._endIndex;
        }
    }

