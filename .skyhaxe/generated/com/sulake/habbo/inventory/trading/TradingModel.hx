package com.sulake.habbo.inventory.trading
;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import flash.events.Event;
    import com.sulake.habbo.inventory.events.HabboInventoryTrackingEvent;
    import com.sulake.habbo.inventory._enum.InventorySubCategory;
    import com.sulake.habbo.inventory.furni.FurniModel;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingItemListEvent;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingCloseEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingOpenFailedEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingOpenFailedEventParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingAcceptEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingConfirmationEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingCompletedEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingCloseParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingNotOpenEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingOtherNotAllowedEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingYouAreNotAllowedEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.utils.PerkChecker;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.OpenTradingComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.AddItemToTradeComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.AddItemsToTradeComposer;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.RemoveItemFromTradeComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.AcceptTradingComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.UnacceptTradingComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.ConfirmAcceptTradingComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.ConfirmDeclineTradingComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.trading.CloseTradingComposer;

     class TradingModel implements IInventoryModel implements  IGetImageListener implements  ITradingModel
    {
        public static inline final MAX_ITEMS_TO_TRADE:UInt = 9;
        public static inline final TRADING_STATE_READY:UInt = 0;
        public static inline final TRADING_STATE_RUNNING:UInt = 1;
        public static inline final TRADING_STATE_COUNTDOWN:UInt = 2;
        public static inline final TRADING_STATE_CONFIRMING:UInt = 3;
        public static inline final TRADING_STATE_CONFIRMED:UInt = 4;
        public static inline final TRADING_STATE_COMPLETED:UInt = 5;
        public static inline final TRADING_STATE_CANCELLED:UInt = 6;

        var _inventory:HabboInventory;
        var _assetLibrary:IAssetLibrary;
        var _roomEngine:IRoomEngine;
        var _communication:IHabboCommunicationManager;
        var _localization:IHabboLocalizationManager;
        var _soundManager:IHabboSoundManager;
        var _tradingView:TradingView;
        var _disposed:Bool = false;
        var _running:Bool = false;
        var _state:UInt = 0;
        var _ownUserIndex:Int = -1;
        var _ownUserName:String = "";
        var _ownUserItems:Map;
        var _ownUserNumItems:Int = 0;
        var _ownUserNumCredits:Int = 0;
        var _ownUserAccepts:Bool = false;
        var _ownUserCanTrade:Bool = false;
        var _otherUserIndex:Int = -1;
        var _otherUserName:String = "";
        var _otherUserItems:Map;
        var _otherUserNumItems:Int = 0;
        var _otherUserNumCredits:Int = 0;
        var _otherUserAccepts:Bool = false;
        var _otherUserCanTrade:Bool = false;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IHabboCommunicationManager, _arg_4:IAssetLibrary, _arg_5:IRoomEngine, _arg_6:IHabboLocalizationManager, _arg_7:IHabboSoundManager)
        {
            this._inventory = k;
            this._communication = _arg_3;
            this._assetLibrary = _arg_4;
            this._roomEngine = _arg_5;
            this._localization = _arg_6;
            this._soundManager = _arg_7;
            this._tradingView = new TradingView(this, _arg_2, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        public static function _Str_16998(k:Int, _arg_2:IStuffData):String
        {
            var _local_3= Std.string(k);
            var _local_4= Std.downcast(_arg_2 , StringArrayStuffData);
            if (_local_4 == null)
            {
                return _local_3;
            }
            var _local_5= 1;
            while (_local_5 < 5)
            {
                _local_3 = (_local_3 + ("," + _local_4.getValue(_local_5)));
                _local_5++;
            }
            return _local_3;
        }


        public var running(get,never):Bool;
public function  get_running():Bool
        {
            return !(this._state == TRADING_STATE_READY);
        }

        
        public var state(get,set):UInt;
public function  get_state():UInt
        {
            return this._state;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_6240(get,never):Int;
public function  get__Str_6240():Int
        {
            return this._ownUserIndex;
        }

        public var _Str_16805(get,never):String;
public function  get__Str_16805():String
        {
            return this._ownUserName;
        }

        public var _Str_5319(get,never):Map;
public function  get__Str_5319():Map
        {
            return this._ownUserItems;
        }

        public var _Str_11659(get,never):Bool;
public function  get__Str_11659():Bool
        {
            return this._ownUserAccepts;
        }

        public var _Str_23201(get,never):Bool;
public function  get__Str_23201():Bool
        {
            return this._ownUserCanTrade;
        }

        public var _Str_21380(get,never):Int;
public function  get__Str_21380():Int
        {
            return this._otherUserIndex;
        }

        public var _Str_17035(get,never):String;
public function  get__Str_17035():String
        {
            return this._otherUserName;
        }

        public var _Str_5629(get,never):Map;
public function  get__Str_5629():Map
        {
            return this._otherUserItems;
        }

        public var _Str_21829(get,never):Bool;
public function  get__Str_21829():Bool
        {
            return this._otherUserAccepts;
        }

        public var _Str_13374(get,never):Bool;
public function  get__Str_13374():Bool
        {
            return this._otherUserCanTrade;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (((this._tradingView != null) && (!this._tradingView.disposed)))
                {
                    this._tradingView.dispose();
                    this._tradingView = null;
                }
                this._inventory = null;
                this._communication = null;
                this._assetLibrary = null;
                this._roomEngine = null;
                this._localization = null;
                this._disposed = true;
            }
        }

        public function _Str_23457(k:Int, _arg_2:String, _arg_3:Bool, _arg_4:Int, _arg_5:String, _arg_6:Bool)
        {
            this._ownUserIndex = k;
            this._ownUserName = _arg_2;
            this._ownUserItems = new Map();
            this._ownUserAccepts = false;
            this._ownUserCanTrade = _arg_3;
            this._otherUserIndex = _arg_4;
            this._otherUserName = _arg_5;
            this._otherUserItems = new Map();
            this._otherUserAccepts = false;
            this._otherUserCanTrade = _arg_6;
            this._running = true;
            this.state = TRADING_STATE_RUNNING;
            this._tradingView.setup(k, _arg_3, _arg_4, _arg_6);
            this._tradingView._Str_9059(this._ownUserIndex);
            this._tradingView._Str_9059(this._otherUserIndex);
            this._tradingView._Str_11244();
            this._tradingView._Str_24697();
            this._inventory.toggleInventoryPage(InventoryCategory.FURNI);
            this._inventory.events.dispatchEvent(new Event(HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_TRADING));
        }

        public function close()
        {
            if (this._running)
            {
                if (((!(this._state == TRADING_STATE_READY)) && (!(this._state == TRADING_STATE_COMPLETED))))
                {
                    this.requestCancelTrading();
                    this.state = TradingModel.TRADING_STATE_CANCELLED;
                }
                this.state = TRADING_STATE_READY;
                this._inventory.toggleInventorySubPage(InventorySubCategory.EMPTY);
                this._running = false;
            }
            this._tradingView._Str_5129(false);
        }

        public function initCategory(k:String)
        {
            this._tradingView._Str_5129((!(k == InventoryCategory.FURNI)));
            this._inventory._Str_24527();
        }
public function  set_state(k:UInt):UInt        {
            Logger.log([((((((("OLD STATE: " + Std.string(this._state)) + " NEW STATE: ") + Std.string(k)) + " OWN: ") + Std.string(this._ownUserAccepts)) + " OTHER: ") + Std.string(this._otherUserAccepts))]);
            var _local_2 = false;
            if (this._state == k)
            {
                return k;
            }
            switch (this._state)
            {
                case TRADING_STATE_READY:
                    if (((k == TRADING_STATE_RUNNING) || (k == TRADING_STATE_COMPLETED)))
                    {
                        this._state = k;
                        _local_2 = true;
                    }
                    
                case TRADING_STATE_RUNNING:
                    if (k == TRADING_STATE_COUNTDOWN)
                    {
                        this._state = k;
                        _local_2 = true;
                        this._Str_17610();
                    }
                    else
                    {
                        if (k == TRADING_STATE_CANCELLED)
                        {
                            this._state = k;
                            this._tradingView._Str_5129(false);
                            _local_2 = true;
                        }
                    }
                    
                case TRADING_STATE_COUNTDOWN:
                    if (k == TRADING_STATE_CONFIRMING)
                    {
                        this._state = k;
                        _local_2 = true;
                    }
                    else
                    {
                        if (k == TRADING_STATE_CANCELLED)
                        {
                            this._state = k;
                            this._tradingView._Str_5129(false);
                            _local_2 = true;
                        }
                        else
                        {
                            if (k == TRADING_STATE_RUNNING)
                            {
                                this._state = k;
                                _local_2 = true;
                                this._Str_18651();
                            }
                        }
                    }
                    
                case TRADING_STATE_CONFIRMING:
                    if (k == TRADING_STATE_CONFIRMED)
                    {
                        this._state = k;
                        _local_2 = true;
                    }
                    else
                    {
                        if (k == TRADING_STATE_COMPLETED)
                        {
                            this._state = k;
                            _local_2 = true;
                            this.close();
                        }
                        else
                        {
                            if (k == TRADING_STATE_CANCELLED)
                            {
                                this._state = k;
                                this._tradingView._Str_5129(false);
                                _local_2 = true;
                                this.close();
                            }
                        }
                    }
                    
                case TRADING_STATE_CONFIRMED:
                    if (k == TRADING_STATE_COMPLETED)
                    {
                        this._state = k;
                        this._tradingView._Str_5129(false);
                        _local_2 = true;
                        this.close();
                    }
                    else
                    {
                        if (k == TRADING_STATE_CANCELLED)
                        {
                            this._state = k;
                            this._tradingView._Str_5129(false);
                            _local_2 = true;
                            this.close();
                        }
                    }
                    
                case TRADING_STATE_COMPLETED:
                    if (k == TRADING_STATE_READY)
                    {
                        this._state = k;
                        _local_2 = true;
                    }
                    
                case TRADING_STATE_CANCELLED:
                    if (k == TRADING_STATE_READY)
                    {
                        this._state = k;
                        _local_2 = true;
                    }
                    else
                    {
                        if (k == TRADING_STATE_RUNNING)
                        {
                            this._state = k;
                            _local_2 = true;
                        }
                    }
                    
                default:
                    throw new ASError((('Unknown trading progress state: "' + Std.string(this._state)) + '"'));
            }
            if (_local_2)
            {
                this._tradingView._Str_11244();
            }
            else
            {
                throw new ASError(((("Error assigning trading process status! States does not match: (from) " + Std.string(this._state)) + " (to) ") + Std.string(k)));
            }
return k;
        }

        public function _Str_19254():FurniModel
        {
            return this._inventory.furniModel;
        }

        public function getInventory():HabboInventory
        {
            return this._inventory;
        }

        public function _Str_25000(k:TradingItemListEvent, _arg_2:Map, _arg_3:Map)
        {
            if (this._inventory == null)
            {
                return;
            }
            if (this._ownUserItems != null)
            {
                this._ownUserItems.dispose();
            }
            if (this._otherUserItems != null)
            {
                this._otherUserItems.dispose();
            }
            if (k.firstUserID == this._ownUserIndex)
            {
                this._ownUserItems = _arg_2;
                this._ownUserNumItems = k.firstUserNumItems;
                this._ownUserNumCredits = k.firstUserNumCredits;
                this._otherUserItems = _arg_3;
                this._otherUserNumItems = k.secondUserNumItems;
                this._otherUserNumCredits = k.secondUserNumCredits;
            }
            else
            {
                this._ownUserItems = _arg_3;
                this._ownUserNumItems = k.secondUserNumItems;
                this._ownUserNumCredits = k.secondUserNumCredits;
                this._otherUserItems = _arg_2;
                this._otherUserNumItems = k.firstUserNumItems;
                this._otherUserNumCredits = k.firstUserNumCredits;
            }
            this._ownUserAccepts = false;
            this._otherUserAccepts = false;
            this._tradingView._Str_9059(this._ownUserIndex);
            this._tradingView._Str_9059(this._otherUserIndex);
            this._tradingView._Str_11244();
            var _local_4= this._inventory.furniModel;
            if (_local_4 != null)
            {
                _local_4._Str_17963();
            }
        }

        public function _Str_21112():Array<ASAny>
        {
            var _local_2:GroupItem = null;
            var _local_3:IFurnitureItem = null;
            var _local_5 = 0;
            var k= new Array<ASAny>();
            if (((this._ownUserItems == null) || this._ownUserItems.disposed))
            {
                return k;
            }
            var _local_4 = 0;
            while ((_local_4 : UInt) < this._ownUserItems.length)
            {
                _local_2 = ASCompat.dynamicAs(this._ownUserItems.getWithIndex(_local_4) , GroupItem);
                if (_local_2 != null)
                {
                    _local_5 = 0;
                    while (_local_5 < _local_2.getTotalCount())
                    {
                        _local_3 = _local_2._Str_5087(_local_5);
                        if (_local_3 != null)
                        {
                            k.push(_local_3.ref);
                        }
                        _local_5++;
                    }
                }
                _local_4++;
            }
            return k;
        }

        public function getOwnItemIdsInTrade():Array<ASAny>
        {
            return this._Str_21112();
        }

        public var _Str_24153(get,never):Int;
public function  get__Str_24153():Int
        {
            return this._ownUserNumItems;
        }

        public var _Str_25441(get,never):Int;
public function  get__Str_25441():Int
        {
            return this._ownUserNumCredits;
        }

        public var _Str_24984(get,never):Int;
public function  get__Str_24984():Int
        {
            return this._otherUserNumItems;
        }

        public var _Str_23259(get,never):Int;
public function  get__Str_23259():Int
        {
            return this._otherUserNumCredits;
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._tradingView.getWindowContainer();
        }

        public function onInventoryOpen()
        {
        }

        public function onCategorySwitch(k:String)
        {
            if (this._running)
            {
                if (this._state != TRADING_STATE_READY)
                {
                    this.requestCancelTrading();
                }
            }
        }

        public function onInventoryClose()
        {
            if (this._running)
            {
                this.close();
            }
        }

        public function _Str_17610()
        {
            this._tradingView._Str_17610();
        }

        public function _Str_18651()
        {
            this._tradingView._Str_18651();
        }

        public function _Str_24577()
        {
            if (this._state == TRADING_STATE_COUNTDOWN)
            {
                this.state = TRADING_STATE_CONFIRMING;
            }
        }

        public function _Str_9836(k:FurnitureItem):BitmapData
        {
            var _local_2:ImageResult = null;
            if (!k.isWallItem)
            {
                _local_2 = this._roomEngine.getFurnitureImage(k.type, new Vector3d(180, 0, 0), 64, this, 0, Std.string(k.extra), -1, -1, k.stuffData);
            }
            else
            {
                _local_2 = this._roomEngine.getWallItemImage(k.type, new Vector3d(180, 0, 0), 64, this, 0, k.stuffData.getLegacyString());
            }
            return _local_2.data ;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            this._tradingView._Str_23654(k, _arg_2);
        }

        public function imageFailed(k:Int)
        {
        }

        public function _Str_6457(k:IMessageEvent)
        {
            var _local_2:TradingCloseEvent = null;
            if (Std.is(k , TradingOpenFailedEvent))
            {
                Logger.log(["TRADING::TradingOpenFailedEvent"]);
                if (this._Str_17680)
                {
                    this._tradingView._Str_24174(cast(k, TradingOpenFailedEvent));
                }
                else
                {
                    if (((cast(k, TradingOpenFailedEvent).getParser().reason == TradingOpenFailedEventParser._Str_18150) || (cast(k, TradingOpenFailedEvent).getParser().reason == TradingOpenFailedEventParser._Str_18383)))
                    {
                        this._tradingView._Str_17682(TradingView._Str_14838);
                    }
                }
            }
            else
            {
                if (Std.is(k , TradingAcceptEvent))
                {
                    Logger.log(["TRADING::TradingAcceptEvent"]);
                    if (cast(k, TradingAcceptEvent).userID == this._ownUserIndex)
                    {
                        this._ownUserAccepts = (!(ASCompat.toNumber(cast(k, TradingAcceptEvent)._Str_15794 )== 0));
                    }
                    else
                    {
                        this._otherUserAccepts = (!(ASCompat.toNumber(cast(k, TradingAcceptEvent)._Str_15794 )== 0));
                    }
                    this._tradingView._Str_11244();
                }
                else
                {
                    if (Std.is(k , TradingConfirmationEvent))
                    {
                        Logger.log(["TRADING::TradingConfirmationEvent"]);
                        this.state = TRADING_STATE_COUNTDOWN;
                    }
                    else
                    {
                        if (Std.is(k , TradingCompletedEvent))
                        {
                            Logger.log(["TRADING::TradingCompletedEvent"]);
                            this.state = TRADING_STATE_COMPLETED;
                        }
                        else
                        {
                            if (Std.is(k , TradingCloseEvent))
                            {
                                Logger.log(["TRADING::TradingCloseEvent"]);
                                if (!this._running)
                                {
                                    Logger.log(["Received TradingCloseEvent, but trading already stopped!!!"]);
                                    return;
                                }
                                _local_2 = Std.downcast(k , TradingCloseEvent);
                                if (_local_2.getParser().reason == TradingCloseParser.ERROR_WHILE_COMMIT)
                                {
                                    if (this._inventory.getBoolean("trading.commiterror.enabled"))
                                    {
                                        this._tradingView.windowManager.simpleAlert("${inventory.trading.notification.title}", "${inventory.trading.notification.commiterror.caption}", "${inventory.trading.notification.commiterror.info}");
                                    }
                                }
                                else
                                {
                                    if (_local_2.getParser().userID != this._ownUserIndex)
                                    {
                                        this._tradingView._Str_17682(TradingView._Str_15599);
                                    }
                                }
                                this.close();
                            }
                            else
                            {
                                if (Std.is(k , TradingNotOpenEvent))
                                {
                                    Logger.log(["TRADING::TradingNotOpenEvent"]);
                                }
                                else
                                {
                                    if (Std.is(k , TradingOtherNotAllowedEvent))
                                    {
                                        this._tradingView._Str_16189("${inventory.trading.warning.others_account_disabled}");
                                    }
                                    else
                                    {
                                        if (Std.is(k , TradingYouAreNotAllowedEvent))
                                        {
                                            this._tradingView._Str_16518("${inventory.trading.warning.own_account_disabled}");
                                        }
                                        else
                                        {
                                            Logger.log([("TRADING/Unknown message event: " + k)]);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        public function _Str_24199()
        {
            this._inventory.toggleInventoryPage(InventoryCategory.FURNI);
        }

        public function requestOpenTrading(k:Int)
        {
            if (PerkChecker.isPerkAllowed(this._inventory.sessionData, this._inventory.windowManager, PerkEnum.TRADE))
            {
                this._communication.connection.send(new OpenTradingComposer(k));
            }
        }

        public function requestAddItemsToTrading(k:Vector<Int>, _arg_2:Bool, _arg_3:Int, _arg_4:Int, _arg_5:Bool, _arg_6:IStuffData)
        {
            var _local_7:Vector<Int> = null;
            var _local_8 = 0;
            if (((!_arg_5) && (k.length > 0)))
            {
                this._communication.connection.send(new AddItemToTradeComposer(k.pop()));
            }
            else
            {
                _local_7 = new Vector<Int>();
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_8  = _tmp_;
                    if (this._Str_24974(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6))
                    {
                        _local_7.push(_local_8);
                    }
                }
                if (_local_7.length > 0)
                {
                    if (_local_7.length == 1)
                    {
                        this._communication.connection.send(new AddItemToTradeComposer(_local_7.pop()));
                    }
                    else
                    {
                        this._communication.connection.send(new AddItemsToTradeComposer(_local_7));
                    }
                }
            }
        }

        public function _Str_24974(k:Bool, _arg_2:Int, _arg_3:Int, _arg_4:Bool, _arg_5:IStuffData):Bool
        {
            var _local_6:String = null;
            if (this._ownUserAccepts)
            {
                return false;
            }
            if (this._ownUserItems == null)
            {
                return false;
            }
            if (this._ownUserItems.length < MAX_ITEMS_TO_TRADE)
            {
                return true;
            }
            if (!_arg_4)
            {
                return false;
            }
            _local_6 = Std.string(_arg_2);
            if (_arg_3 == FurniCategory.POSTER)
            {
                _local_6 = ((Std.string(_arg_2) + "poster") + _arg_5.getLegacyString());
            }
            else
            {
                if (_arg_3 == FurniCategory.GUILD_FURNI)
                {
                    _local_6 = _Str_16998(_arg_2, _arg_5);
                }
                else
                {
                    _local_6 = ((k ? "I" : "S") + _local_6);
                }
            }
            return !(this._ownUserItems.getValue(_local_6) == null);
        }

        public function requestRemoveItemFromTrading(k:Int)
        {
            var _local_3:IFurnitureItem = null;
            if (this._ownUserAccepts)
            {
                return;
            }
            var _local_2:GroupItem = this._Str_5319.getWithIndex(k);
            if (_local_2 != null)
            {
                _local_3 = _local_2._Str_3205();
                if (_local_3 != null)
                {
                    this._communication.connection.send(new RemoveItemFromTradeComposer(_local_3.id));
                }
            }
        }

        public function requestAcceptTrading()
        {
            this._communication.connection.send(new AcceptTradingComposer());
        }

        public function requestUnacceptTrading()
        {
            this._communication.connection.send(new UnacceptTradingComposer());
        }

        public function requestConfirmAcceptTrading()
        {
            this.state = TRADING_STATE_CONFIRMED;
            this._communication.connection.send(new ConfirmAcceptTradingComposer());
        }

        public function requestConfirmDeclineTrading()
        {
            this._communication.connection.send(new ConfirmDeclineTradingComposer());
        }

        public function requestCancelTrading()
        {
            this._communication.connection.send(new CloseTradingComposer());
        }

        public function _Str_24618():Bool
        {
            return (this._ownUserNumCredits > 0) || (this._otherUserNumCredits > 0);
        }

        var _Str_17680(get,never):Bool;
function  get__Str_17680():Bool
        {
            return this._inventory.getBoolean("talent.track.citizenship.enabled");
        }

        public function updateView()
        {
        }

        public function onSubcategorySwitch(k:String)
        {
            Logger.log(["NOT SUPPORTED: TRADING VIEW SELECT BY ID"]);
        }
    }

