package com.sulake.habbo.communication.messages.parser.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class RewardTrackProgressMessageParser implements IMessageParser
    {
        var _trackId:String;
        var _taskId:String;
        var _progressCount:Int = 0;
        var _points:Int = 0;

        public function flush():Bool
        {
            this._trackId = null;
            this._taskId = null;
            this._progressCount = 0;
            this._points = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            this._trackId = wrapper.readString();
            this._taskId = wrapper.readString();
            this._progressCount = wrapper.readInteger();
            this._points = wrapper.readInteger();
            return true;
        }

        public var trackId(get,never):String;
public function  get_trackId():String
        {
            return this._trackId;
        }

        public var taskId(get,never):String;
public function  get_taskId():String
        {
            return this._taskId;
        }

        public var progressCount(get,never):Int;
public function  get_progressCount():Int
        {
            return this._progressCount;
        }

        public var points(get,never):Int;
public function  get_points():Int
        {
            return this._points;
        }

	public function new() {}
    }

