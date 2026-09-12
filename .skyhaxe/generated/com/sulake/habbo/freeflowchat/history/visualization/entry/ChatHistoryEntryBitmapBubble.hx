package com.sulake.habbo.freeflowchat.history.visualization.entry
;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import com.sulake.habbo.freeflowchat.history.visualization._enum.ChatHistoryLayoutEnum;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import com.sulake.habbo.freeflowchat.data.ChatItem;

     class ChatHistoryEntryBitmapBubble implements IChatHistoryEntryBitmap 
    {
        var _bitmap:BitmapData;
        var _overlap:Rectangle;
        var _userId:Int = 0;
        var _roomId:Int = 0;
        var _canIgnore:Bool = false;
        var _userName:String;

        public function new(k:ChatItem, _arg_2:Bool, _arg_3:String, _arg_4:BitmapData, _arg_5:Rectangle=null)
        {
            this._overlap = _arg_5;
            this._userId = k.userId;
            this._roomId = k.roomId;
            var _local_6= new TextField();
            _local_6.defaultTextFormat = ChatHistoryLayoutEnum._Str_14898;
            _local_6.text = HabboFreeFlowChat.getTimeStampNow();
            _local_6.thickness = -15;
            _local_6.sharpness = 80;
            _local_6.antiAliasType = AntiAliasType.ADVANCED;
            _local_6.embedFonts = true;
            _local_6.gridFitType = GridFitType.PIXEL;
            var _local_7= _arg_4.height;
            var _local_8= ChatHistoryLayoutEnum._Str_7140;
            var _local_9= Std.int(Math.max(ChatHistoryLayoutEnum._Str_13160, (ChatHistoryLayoutEnum._Str_13160 + _arg_5.top)));
            this._bitmap = new BitmapData((_local_8 + _arg_4.width), _local_7, true, 0);
            this._bitmap.draw(_local_6, new Matrix(1, 0, 0, 1, 0, _local_9));
            this._bitmap.copyPixels(_arg_4, _arg_4.rect, new Point(_local_8, 0));
            this._canIgnore = _arg_2;
            this._userName = _arg_3;
        }

        public var bitmap(get,never):BitmapData;
public function  get_bitmap():BitmapData
        {
            return this._bitmap;
        }

        public var overlap(get,never):Rectangle;
public function  get_overlap():Rectangle
        {
            return this._overlap;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var _Str_6123(get,never):Bool;
public function  get__Str_6123():Bool
        {
            return this._canIgnore;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }
    }

