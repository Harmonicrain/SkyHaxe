package com.sulake.habbo.communication.messages.outgoing.roomsettings
;
     class SaveableRoomSettingsData 
    {
        var _roomId:Int = 0;
        var _name:String;
        var _description:String;
        var _doorMode:Int = 0;
        var _password:String;
        var _categoryId:Int = 0;
        var _maximumVisitors:Int = 0;
        var _tags:Array<ASAny>;
        var _controllers:Array<ASAny>;
        var _tradeMode:Int = 0;
        var _allowPets:Bool = false;
        var _allowFoodConsume:Bool = false;
        var _allowWalkThrough:Bool = false;
        var _allowNavigatorDynCats:Bool = false;
        var _hideWalls:Bool = false;
        var _wallThickness:Int = 0;
        var _floorThickness:Int = 0;
        var _whoCanMute:Int = 0;
        var _whoCanKick:Int = 0;
        var _whoCanBan:Int = 0;
        var _chatMode:Int = 0;
        var _chatBubbleSize:Int = 0;
        var _chatScrollUpFrequency:Int = 0;
        var _chatFullHearRange:Int = 0;
        var _chatFloodSensitivity:Int = 0;


        
        public var tradeMode(get,set):Int;
public function  get_tradeMode():Int
        {
            return this._tradeMode;
        }
public function  set_tradeMode(k:Int):Int        {
            return this._tradeMode = k;
        }

        
        public var allowPets(get,set):Bool;
public function  get_allowPets():Bool
        {
            return this._allowPets;
        }
public function  set_allowPets(k:Bool):Bool        {
            return this._allowPets = k;
        }

        
        public var allowFoodConsume(get,set):Bool;
public function  get_allowFoodConsume():Bool
        {
            return this._allowFoodConsume;
        }
public function  set_allowFoodConsume(k:Bool):Bool        {
            return this._allowFoodConsume = k;
        }

        
        public var allowWalkThrough(get,set):Bool;
public function  get_allowWalkThrough():Bool
        {
            return this._allowWalkThrough;
        }
public function  set_allowWalkThrough(k:Bool):Bool        {
            return this._allowWalkThrough = k;
        }

        
        public var hideWalls(get,set):Bool;
public function  get_hideWalls():Bool
        {
            return this._hideWalls;
        }
public function  set_hideWalls(k:Bool):Bool        {
            return this._hideWalls = k;
        }

        
        public var wallThickness(get,set):Int;
public function  get_wallThickness():Int
        {
            return this._wallThickness;
        }
public function  set_wallThickness(k:Int):Int        {
            return this._wallThickness = k;
        }

        
        public var floorThickness(get,set):Int;
public function  get_floorThickness():Int
        {
            return this._floorThickness;
        }
public function  set_floorThickness(k:Int):Int        {
            return this._floorThickness = k;
        }

        
        public var roomId(get,set):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
public function  set_roomId(k:Int):Int        {
            return this._roomId = k;
        }

        
        public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }
public function  set_name(k:String):String        {
            return this._name = k;
        }

        
        public var description(get,set):String;
public function  get_description():String
        {
            return this._description;
        }
public function  set_description(k:String):String        {
            return this._description = k;
        }

        
        public var doorMode(get,set):Int;
public function  get_doorMode():Int
        {
            return this._doorMode;
        }
public function  set_doorMode(k:Int):Int        {
            return this._doorMode = k;
        }

        
        public var password(get,set):String;
public function  get_password():String
        {
            return this._password;
        }
public function  set_password(k:String):String        {
            return this._password = k;
        }

        
        public var categoryId(get,set):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }
public function  set_categoryId(k:Int):Int        {
            return this._categoryId = k;
        }

        
        public var maximumVisitors(get,set):Int;
public function  get_maximumVisitors():Int
        {
            return this._maximumVisitors;
        }
public function  set_maximumVisitors(k:Int):Int        {
            return this._maximumVisitors = k;
        }

        
        public var tags(get,set):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return this._tags;
        }
public function  set_tags(k:Array<ASAny>):Array<ASAny>        {
            return this._tags = k;
        }

        
        public var controllers(get,set):Array<ASAny>;
public function  get_controllers():Array<ASAny>
        {
            return this._controllers;
        }
public function  set_controllers(k:Array<ASAny>):Array<ASAny>        {
            return this._controllers = k;
        }

        
        public var whoCanMute(get,set):Int;
public function  get_whoCanMute():Int
        {
            return this._whoCanMute;
        }
public function  set_whoCanMute(k:Int):Int        {
            return this._whoCanMute = k;
        }

        
        public var whoCanKick(get,set):Int;
public function  get_whoCanKick():Int
        {
            return this._whoCanKick;
        }
public function  set_whoCanKick(k:Int):Int        {
            return this._whoCanKick = k;
        }

        
        public var whoCanBan(get,set):Int;
public function  get_whoCanBan():Int
        {
            return this._whoCanBan;
        }
public function  set_whoCanBan(k:Int):Int        {
            return this._whoCanBan = k;
        }

        
        public var chatMode(get,set):Int;
public function  get_chatMode():Int
        {
            return this._chatMode;
        }
public function  set_chatMode(k:Int):Int        {
            return this._chatMode = k;
        }

        
        public var chatBubbleSize(get,set):Int;
public function  get_chatBubbleSize():Int
        {
            return this._chatBubbleSize;
        }
public function  set_chatBubbleSize(k:Int):Int        {
            return this._chatBubbleSize = k;
        }

        
        public var chatScrollUpFrequency(get,set):Int;
public function  get_chatScrollUpFrequency():Int
        {
            return this._chatScrollUpFrequency;
        }
public function  set_chatScrollUpFrequency(k:Int):Int        {
            return this._chatScrollUpFrequency = k;
        }

        
        public var chatFullHearRange(get,set):Int;
public function  get_chatFullHearRange():Int
        {
            return this._chatFullHearRange;
        }
public function  set_chatFullHearRange(k:Int):Int        {
            return this._chatFullHearRange = k;
        }

        
        public var chatFloodSensitivity(get,set):Int;
public function  get_chatFloodSensitivity():Int
        {
            return this._chatFloodSensitivity;
        }
public function  set_chatFloodSensitivity(k:Int):Int        {
            return this._chatFloodSensitivity = k;
        }

        
        public var allowNavigatorDynCats(get,set):Bool;
public function  get_allowNavigatorDynCats():Bool
        {
            return this._allowNavigatorDynCats;
        }
public function  set_allowNavigatorDynCats(k:Bool):Bool        {
            return this._allowNavigatorDynCats = k;
        }
public function new(){}
    }

