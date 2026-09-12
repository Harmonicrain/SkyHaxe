package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /** July's compact four-column room transaction preview row. */
     final class WiredMenuChestTransactionTableObject implements ITableObject
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _info:WiredTransactionInfo;

        public function new(
            roomEvents:HabboUserDefinedRoomEvents, info:WiredTransactionInfo)
        {
            this._roomEvents = roomEvents;
            this._info = info;
        }

        public var identifier(get,never):String;
public function  get_identifier():String { return Std.string(this._info.transactionId); }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "type":
                    return new TableCell(TableCell.TYPE_TEXT, this.localize(
                        "transaction.type." + Std.string(this._info.transactionType),
                        "wired_transactions.type." + Std.string(this._info.transactionType)));
                case "username":
                    return new TableCell(TableCell.TYPE_LINK, this._info.username,
                        false, true, null, this.onUsername);
                case "withdraws":
                    return new TableCell(TableCell.TYPE_TEXT, this.summarize(
                        this._info.withdrawFurniCount,
                        this._info.withdrawCoinsCount));
                case "deposits":
                    return new TableCell(TableCell.TYPE_TEXT, this.summarize(
                        this._info.depositFurniCount,
                        this._info.depositCoinsCount));
            }
            return null;
        }

        function onUsername()
        {
            this._roomEvents.send(
                new GetExtendedProfileMessageComposer(this._info.userId));
        }

        function summarize(furni:Int, coins:Int):String
        {
            if (furni <= 0 && coins <= 0) { return "-"; }
            var exact:String = null;
            var fallback:String = null;
            if (furni > 0 && coins == 0)
            {
                exact = "wiredmenu.chests.room_logs.only_furni";
                fallback = "wiredchests.logs.only_furni";
            }
            else if (furni == 0)
            {
                exact = "wiredmenu.chests.room_logs.only_coins";
                fallback = "wiredchests.logs.only_coins";
            }
            else
            {
                exact = "wiredmenu.chests.room_logs.furni_and_coins";
                fallback = "wiredchests.logs.furni_and_coins";
            }
            var template= this._roomEvents.localization.getLocalization(
                exact, this._roomEvents.localization.getLocalization(fallback, exact));
            return ASCompat.stringReplace(ASCompat.stringReplace(template, "%amount%", furni)
, "%amount2%", coins);
        }

        function localize(key:String, fallback:String):String
        {
            return this._roomEvents.localization.getLocalization(
                "wiredmenu.chests." + key,
                this._roomEvents.localization.getLocalization(fallback, fallback));
        }

        public function isPropertyUpdated(columnId:String, previous:ASObject):Bool
        {
            return false;
        }
        public function isUpdated(previous:ASObject):Bool { return false; }
    }

