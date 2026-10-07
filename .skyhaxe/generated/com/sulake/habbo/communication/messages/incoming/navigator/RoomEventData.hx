package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomEventData implements IDisposable
    {
        var _adId:Int = 0;
        var _Str_21450:Int = 0;
        var _Str_20782:String;
        var _flatId:Int = 0;
        var _categoryId:Int = 0;
        var _eventType:Int = 0;
        var _eventName:String;
        var _eventDescription:String;
        var _creationTime:String;
        var _Str_20383:Date;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._adId = k.readInteger();
            this._Str_21450 = k.readInteger();
            this._Str_20782 = k.readString();
            this._flatId = k.readInteger();
            this._eventType = k.readInteger();
            this._eventName = k.readString();
            this._eventDescription = k.readString();
            var _local_2= k.readInteger();
            var _local_3= k.readInteger();
            var _local_4= Date.now();
            var _local_5= _local_4.getTime();
            var _local_6:Float = ((_local_2 * 60) * 1000);
            _local_5 = (_local_5 - _local_6);
            var _local_7= Date.fromTime(_local_5);
            this._creationTime = ((((((((Std.string(_local_7.getDate()) + "-") + Std.string(_local_7.getMonth())) + "-") + Std.string(_local_7.getFullYear())) + " ") + Std.string(_local_7.getHours())) + ":") + Std.string(_local_7.getMinutes()));
            var _local_8= _local_4.getTime();
            var _local_9:Float = ((_local_3 * 60) * 1000);
            _local_8 = (_local_8 + _local_9);
            this._Str_20383 = Date.fromTime(_local_8);
            this._categoryId = k.readInteger();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var adId(get,never):Int;
public function  get_adId():Int
        {
            return this._adId;
        }

        public var _Str_13361(get,never):Int;
public function  get__Str_13361():Int
        {
            return this._Str_21450;
        }

        public var _Str_26367(get,never):String;
public function  get__Str_26367():String
        {
            return this._Str_20782;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }

        public var categoryId(get,never):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }

        public var eventType(get,never):Int;
public function  get_eventType():Int
        {
            return this._eventType;
        }

        public var eventName(get,never):String;
public function  get_eventName():String
        {
            return this._eventName;
        }

        public var eventDescription(get,never):String;
public function  get_eventDescription():String
        {
            return this._eventDescription;
        }

        public var creationTime(get,never):String;
public function  get_creationTime():String
        {
            return this._creationTime;
        }

        public var _Str_21519(get,never):Date;
public function  get__Str_21519():Date
        {
            return this._Str_20383;
        }
    }

