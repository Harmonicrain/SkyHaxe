package com.sulake.habbo.communication.messages.parser.campaign
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CampaignCalendarData 
    {
        var _campaignName:String;
        var _campaignImage:String;
        var _currentDay:Int = 0;
        var _campaignDays:Int = 0;
        var _openedDays:Vector<Int>;
        var _missedDays:Vector<Int>;


        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2:Int;
            var _local_3:Int;
            this._campaignName = k.readString();
            this._campaignImage = k.readString();
            this._currentDay = k.readInteger();
            this._campaignDays = k.readInteger();
            this._openedDays = new Vector<Int>(0);
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._openedDays.push(k.readInteger());
                _local_2++;
            }
            this._missedDays = new Vector<Int>(0);
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._missedDays.push(k.readInteger());
                _local_2++;
            }
            return true;
        }

        public function clone():CampaignCalendarData
        {
            var k= new CampaignCalendarData();
            k._Str_8399 = this._campaignDays;
            k._Str_19589 = this._campaignImage;
            k._Str_11123 = this._campaignName;
            k._Str_5472 = this._currentDay;
            k._Str_14267 = this._missedDays;
            k._Str_10724 = this._openedDays;
            return k;
        }

        
        public var _Str_11123(get,set):String;
function  get__Str_11123():String
        {
            return this._campaignName;
        }

        
        public var _Str_19589(get,set):String;
function  get__Str_19589():String
        {
            return this._campaignImage;
        }

        
        public var _Str_5472(get,set):Int;
function  get__Str_5472():Int
        {
            return this._currentDay;
        }

        
        public var _Str_8399(get,set):Int;
function  get__Str_8399():Int
        {
            return this._campaignDays;
        }

        
        public var _Str_10724(get,set):Vector<Int>;
function  get__Str_10724():Vector<Int>
        {
            return this._openedDays;
        }

        
        public var _Str_14267(get,set):Vector<Int>;
function  get__Str_14267():Vector<Int>
        {
            return this._missedDays;
        }
function  set__Str_11123(k:String):String        {
            return this._campaignName = k;
        }
function  set__Str_19589(k:String):String        {
            return this._campaignImage = k;
        }
function  set__Str_5472(k:Int):Int        {
            return this._currentDay = k;
        }
function  set__Str_8399(k:Int):Int        {
            return this._campaignDays = k;
        }
function  set__Str_10724(k:Vector<Int>):Vector<Int>        {
            return this._openedDays = k;
        }
function  set__Str_14267(k:Vector<Int>):Vector<Int>        {
            return this._missedDays = k;
        }
public function new(){}
    }

