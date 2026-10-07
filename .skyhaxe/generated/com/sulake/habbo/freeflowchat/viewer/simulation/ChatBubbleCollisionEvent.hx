package com.sulake.habbo.freeflowchat.viewer.simulation
;
     class ChatBubbleCollisionEvent 
    {
        var _first:ChatBubbleSimulationEntity;
        var _second:ChatBubbleSimulationEntity;

        public function new(k:ChatBubbleSimulationEntity, _arg_2:ChatBubbleSimulationEntity)
        {
            this._first = k;
            this._second = _arg_2;
        }

        public var first(get,never):ChatBubbleSimulationEntity;
public function  get_first():ChatBubbleSimulationEntity
        {
            return this._first;
        }

        public var _Str_6122(get,never):ChatBubbleSimulationEntity;
public function  get__Str_6122():ChatBubbleSimulationEntity
        {
            return this._second;
        }

        public var top(get,never):ChatBubbleSimulationEntity;
public function  get_top():ChatBubbleSimulationEntity
        {
            return (this._first.y < this._second.y) ? this._first : this._second;
        }

        public var bottom(get,never):ChatBubbleSimulationEntity;
public function  get_bottom():ChatBubbleSimulationEntity
        {
            return (this._first.y >= this._second.y) ? this._first : this._second;
        }

        public var left(get,never):ChatBubbleSimulationEntity;
public function  get_left():ChatBubbleSimulationEntity
        {
            return (this._first.x < this._second.x) ? this._first : this._second;
        }

        public var right(get,never):ChatBubbleSimulationEntity;
public function  get_right():ChatBubbleSimulationEntity
        {
            return (this._first.x >= this._second.x) ? this._first : this._second;
        }

        public var _Str_21189(get,never):Bool;
public function  get__Str_21189():Bool
        {
            return Std.int(this._first.y) == Std.int(this._second.y);
        }

        public var _Str_14418(get,never):ChatBubbleSimulationEntity;
public function  get__Str_14418():ChatBubbleSimulationEntity
        {
            return (this._first.timeStamp < this._second.timeStamp) ? this._first : this._second;
        }
    }

