package com.sulake.habbo.freeflowchat.history.visualization.entry
;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import com.sulake.habbo.freeflowchat.history.visualization._enum.ChatHistoryLayoutEnum;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;

     class ChatHistoryRoomChangeEntry implements IChatHistoryEntryBitmap 
    {
        static inline final _Str_9511= 4;

        var _bitmap:BitmapData;
        var _overlap:Rectangle= new Rectangle(0, 0, 0, 0);

        public function new(k:GuestRoomData, _arg_2:HabboFreeFlowChat)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_3= new TextField();
            _local_3.defaultTextFormat = ChatHistoryLayoutEnum._Str_16769;
            _local_3.thickness = -15;
            _local_3.sharpness = 80;
            _local_3.antiAliasType = AntiAliasType.ADVANCED;
            _local_3.embedFonts = true;
            _local_3.gridFitType = GridFitType.PIXEL;
            _local_3.text = ((k == null) ? "null" : k.roomName);
            _local_3.width = (_local_3.textWidth + 10);
            _local_3.height = (_local_3.textHeight + 5);
            var _local_4= new TextField();
            _local_4.defaultTextFormat = ChatHistoryLayoutEnum._Str_14898;
            _local_4.thickness = -15;
            _local_4.sharpness = 80;
            _local_4.antiAliasType = AntiAliasType.ADVANCED;
            _local_4.embedFonts = true;
            _local_4.gridFitType = GridFitType.PIXEL;
            _local_4.text = HabboFreeFlowChat.getTimeStampNow();
            _local_4.width = (_local_4.textWidth + 5);
            _local_4.height = (_local_4.textHeight + 5);
            _local_5 = (ChatHistoryLayoutEnum._Str_7140 + 20);
            _local_6 = Std.int(Math.max(ChatHistoryLayoutEnum._Str_18359, ((_local_5 + _local_3.width) + ChatHistoryLayoutEnum._Str_10820)));
            _local_7 = Std.int(((_local_3.textHeight + 5) + ChatHistoryLayoutEnum._Str_6853) + _Str_9511);
            this._bitmap = new BitmapData(_local_6, _local_7, true, 0);
            this._bitmap.copyPixels(_arg_2.getRoomChangeBitmap(), _arg_2.getRoomChangeBitmap().rect, new Point(ChatHistoryLayoutEnum._Str_7140, (1 + _Str_9511)));
            this._bitmap.draw(_local_4, new Matrix(1, 0, 0, 1, 0, _Str_9511));
            this._bitmap.draw(_local_3, new Matrix(1, 0, 0, 1, _local_5, _Str_9511));
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
            return -1;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return -1;
        }

        public var _Str_6123(get,never):Bool;
public function  get__Str_6123():Bool
        {
            return false;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return "";
        }
    }

