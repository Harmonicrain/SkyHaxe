package com.sulake.habbo.catalog.purchase
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.FurniRentOrBuyoutOfferMessageEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.GetRentOrBuyoutOfferMessageComposer;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.ExtendRentOrBuyoutFurniMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.ExtendRentOrBuyoutStripItemMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;

     class RentConfirmationWindow implements IDisposable implements  IGetImageListener 
    {
        static inline final MODE_INFOSTAND= 1;
        static inline final MODE_INVENTORY= 2;
        static inline final MODE_CATALOGUE= 3;

        var _disposed:Bool = false;
        var _offerMessageEvent:FurniRentOrBuyoutOfferMessageEvent;
        var _window:IWindowContainer;
        var _isBuyout:Bool = false;
        var _id:Int = -1;
        var _catalog:HabboCatalog;
        var _furniData:IFurnitureData;
        var _mode:Int = 0;
        var _roomInstanceId:Int = -1;
        var _stripId:Int = 0;

        public function new(k:HabboCatalog)
        {
            this._catalog = k;
            this._offerMessageEvent = new FurniRentOrBuyoutOfferMessageEvent(this.onFurniRentOrBuyoutOffer);
            this._catalog.connection.addMessageEvent(this._offerMessageEvent);
        }

        function onFurniRentOrBuyoutOffer(k:FurniRentOrBuyoutOfferMessageEvent)
        {
            var _local_3:ImageResult = null;
            if (this._furniData == null)
            {
                return;
            }
            var _local_2= k.getParser();
            if (this._furniData.fullName != _local_2._Str_17878)
            {
                return;
            }
            this._isBuyout = _local_2.buyout;
            if (this._catalog.getPurse().credits < _local_2.priceInCredits)
            {
                this._catalog.showNotEnoughCreditsAlert();
                return;
            }
            if (this._catalog.getPurse().getActivityPointsForType(_local_2.activityPointType) < _local_2.priceInActivityPoints)
            {
                this._catalog.showNotEnoughActivityPointsAlert(_local_2.activityPointType);
                return;
            }
            this._window = Std.downcast(this._catalog.windowManager.buildFromXML(((this._catalog.assets.getAssetByName("rent_confirmation").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (_local_2.priceInCredits > 0)
            {
                this._window.findChildByName("price_amount").caption = Std.string(_local_2.priceInCredits);
                cast(this._window.findChildByName("price_type"), IStaticBitmapWrapperWindow).assetUri = "toolbar_credit_icon_0";
            }
            else
            {
                this._window.findChildByName("price_amount").caption = Std.string(_local_2.priceInActivityPoints);
            }
            if (this._isBuyout)
            {
                this._window.caption = "${rent.confirmation.title.buyout}";
                this._window.findChildByName("rental_description").visible = false;
                this._window.findChildByName("ok_button").caption = "${catalog.purchase_confirmation.buy}";
            }
            this._window.findChildByName("furni_name").caption = this._furniData.localizedName;
            cast(this._window.findChildByName("content_list"), IItemListWindow).arrangeListItems();
            this._window.center();
            this._window.procedure = this.windowProcedure;
            switch (this._furniData.type)
            {
                case ProductTypeEnum.FLOOR:
                    _local_3 = this.roomEngine.getFurnitureImage(this._furniData.id, new Vector3d(90, 0, 0), 64, this);
                    
                case ProductTypeEnum.WALL:
                    _local_3 = this.roomEngine.getWallItemImage(this._furniData.id, new Vector3d(90, 0, 0), 64, this);
                    
            }
            cast(this._window.findChildByName("image"), IBitmapWrapperWindow).bitmap = _local_3.data;
            this._id = _local_3.id;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.close();
            if (this._offerMessageEvent != null)
            {
                this._catalog.connection.removeMessageEvent(this._offerMessageEvent);
                this._offerMessageEvent = null;
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show(k:IFurnitureData, _arg_2:Bool, _arg_3:Int=-1, _arg_4:Int=-1, _arg_5:Bool=false)
        {
            this.close();
            this._furniData = k;
            this._roomInstanceId = _arg_3;
            this._stripId = _arg_4;
            if (_arg_5)
            {
                this._mode = MODE_CATALOGUE;
            }
            else
            {
                if (this._roomInstanceId > -1)
                {
                    this._mode = MODE_INFOSTAND;
                }
                else
                {
                    this._mode = MODE_INVENTORY;
                }
            }
            var _local_6:ASAny = (k.type == ProductTypeEnum.WALL);
            this._catalog.connection.send(new GetRentOrBuyoutOfferMessageComposer(_local_6, k.fullName, _arg_2));
        }

        var roomEngine(get,never):IRoomEngine;
function  get_roomEngine():IRoomEngine
        {
            return this._catalog.roomEngine;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowMouseEvent.CLICK)) || (this._window == null)))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "cancel_button"
                   | "header_button_close":
                    this.close();
                    return;
                case "ok_button":
                    switch (this._mode)
                    {
                        case MODE_INFOSTAND:
                            this._catalog.connection.send(new ExtendRentOrBuyoutFurniMessageComposer((this._furniData.type == ProductTypeEnum.WALL), this._roomInstanceId, this._isBuyout));
                            
                        case MODE_INVENTORY:
                            this._catalog.connection.send(new ExtendRentOrBuyoutStripItemMessageComposer(this._stripId, this._isBuyout));
                            
                        case MODE_CATALOGUE:
                            this._catalog.purchaseOffer(this._furniData.rentOfferId);
                            
                    }
                    this.close();
                    return;
            }
        }

        function close()
        {
            if (this._window == null)
            {
                return;
            }
            this._window.dispose();
            this._window = null;
            this._id = -1;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (((!(this._window == null)) && (k == this._id)))
            {
                cast(this._window.findChildByName("image"), IBitmapWrapperWindow).bitmap = _arg_2;
            }
        }

        public function imageFailed(k:Int)
        {
        }
    }

