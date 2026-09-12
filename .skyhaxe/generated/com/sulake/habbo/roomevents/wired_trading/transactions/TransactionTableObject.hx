package com.sulake.habbo.roomevents.wired_trading.transactions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestTransactionDetailsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

     final class TransactionTableObject implements ITableObject
    {
        var _controller:WiredTransactionLogsController;
        var _info:WiredTransactionInfo;

        public function new(
            controller:WiredTransactionLogsController, info:WiredTransactionInfo)
        {
            this._controller = controller;
            this._info = info;
        }

        public var identifier(get,never):String;
public function  get_identifier():String { return Std.string(this._info.transactionId); }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "type":
                    return new TableCell(TableCell.TYPE_TEXT,
                        this.loc("wired_transactions.type." + Std.string(this._info.transactionType)));
                case "timestamp":
                    return new TableCell(TableCell.TYPE_TEXT,
                        this._info.readableTimestamp);
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
                case "chests":
                    return new TableCell(TableCell.TYPE_TEXT,
                        Std.string(this._info.chestCount));
                case "details":
                    return new TableCell(TableCell.TYPE_LINK,
                        this.loc("wiredchests.logs.details_text"), false, false,
                        null, this.onDetails);
            }
            return null;
        }

        function onUsername()
        {
            this._controller.send(
                new GetExtendedProfileMessageComposer(this._info.userId));
        }

        function onDetails()
        {
            this._controller.send(
                new RequestTransactionDetailsMessageComposer(
                    this._info.transactionId));
        }

        function summarize(furni:Int, coins:Int):String
        {
            if (furni <= 0 && coins <= 0) { return "-"; }
            if (furni > 0 && coins == 0)
            {
                return this._controller.localization.getLocalizationWithParams(
                    "wiredchests.logs.only_furni", "", ["amount", furni]);
            }
            if (furni == 0)
            {
                return this._controller.localization.getLocalizationWithParams(
                    "wiredchests.logs.only_coins", "", ["amount", coins]);
            }
            return this._controller.localization.getLocalizationWithParams(
                "wiredchests.logs.furni_and_coins", "", ["amount", furni,
                "amount2", coins]);
        }

        function loc(key:String):String
        {
            return this._controller.localization.getLocalization(key, key);
        }

        public function isPropertyUpdated(columnId:String, previous:ASObject):Bool
        {
            return false;
        }
        public function isUpdated(previous:ASObject):Bool { return false; }
    }

