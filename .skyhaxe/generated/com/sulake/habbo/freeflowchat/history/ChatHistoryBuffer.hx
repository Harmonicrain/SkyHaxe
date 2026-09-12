package com.sulake.habbo.freeflowchat.history
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.history.visualization.entry.IChatHistoryEntryBitmap;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.freeflowchat.history.visualization._enum.ChatHistoryLayoutEnum;

     class ChatHistoryBuffer implements IDisposable 
    {
        static inline final _Str_22590= 1000;

        var _component:HabboFreeFlowChat;
        var _entries:Vector<IChatHistoryEntryBitmap>;

        public function new(k:HabboFreeFlowChat)
        {
            this._entries = new Vector<IChatHistoryEntryBitmap>(0);
            this._component = k;
        }

        public function dispose()
        {
            this._entries = null;
            this._component = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._component == null;
        }

        public function insertChat(chatItem:ChatItem)
        {
            var entry:IChatHistoryEntryBitmap = null;
            try
            {
                entry = this._component.chatBubbleFactory._Str_23020(chatItem);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                if (e.errorID == 2015)
                {
                    return;
                }
                throw e;
            }
 }            this._entries.push(entry);
            this._Str_19617(entry);
            if (this._component.chatHistoryScrollView.isActive)
            {
                this._component.chatHistoryScrollView._Str_23438(this._entries[(this._entries.length - 1)]);
            }
        }

        public function _Str_24587(k:GuestRoomData)
        {
            var _local_2= this._component.chatBubbleFactory._Str_23311(k);
            this._entries.push(_local_2);
            this._Str_19617(_local_2);
        }

        function _Str_19617(k:IChatHistoryEntryBitmap)
        {
            if (this._entries.length > ChatHistoryBuffer._Str_22590)
            {
                this._component.chatHistoryScrollView._Str_25251(Std.int((k.bitmap.height - k.overlap.y) - ChatHistoryLayoutEnum._Str_6853));
                this._entries.splice(0, 1);
            }
        }

        public var entries(get,never):Vector<IChatHistoryEntryBitmap>;
public function  get_entries():Vector<IChatHistoryEntryBitmap>
        {
            return this._entries;
        }

        public var totalHeight(get,never):Int;
public function  get_totalHeight():Int
        {
            var _local_2:IChatHistoryEntryBitmap = null;
            var k = 0;
            final _iter_ = this._entries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = Std.int(k + ((_local_2.bitmap.height - _local_2.overlap.y) - ChatHistoryLayoutEnum._Str_6853));
            }
            return k;
        }
    }

