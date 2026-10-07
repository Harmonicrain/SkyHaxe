package com.sulake.habbo.communication.messages.parser.poll
;
     class QuestionChoice 
    {
        var _value:String;
        var _choiceText:String;
        var _Str_18282:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:Int)
        {
            this._value = k;
            this._choiceText = _arg_2;
            this._Str_18282 = _arg_3;
        }

        
        public var value(get,set):String;
public function  get_value():String
        {
            return this._value;
        }
public function  set_value(value:String):String        {
            return this._value = value;
        }

        
        public var choiceText(get,set):String;
public function  get_choiceText():String
        {
            return this._choiceText;
        }
public function  set_choiceText(choiceText:String):String        {
            return this._choiceText = choiceText;
        }

        
        public var _Str_19972(get,set):Int;
public function  get__Str_19972():Int
        {
            return this._Str_18282;
        }
public function  set__Str_19972(k:Int):Int        {
            return this._Str_18282 = k;
        }
    }

