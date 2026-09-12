package com.sulake.habbo.nux
;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.nux.NewUserExperienceGiftOptions;
    import com.sulake.habbo.communication.messages.outgoing.nux.NewUserExperienceGetGiftsSelection;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.nux.NewUserExperienceGift;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.nux.NewUserExperienceGiftProduct;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class NuxGiftSelectionView implements IProductDataListener 
    {
        var _frame:IFrameWindow;
        var _component:HabboNuxDialogs;
        var _optionTemplate:IWindowContainer;
        var _giftOptions:Vector<NewUserExperienceGiftOptions>;
        var _currentIndex:Int = 0;
        var _selectedOptions:Vector<NewUserExperienceGetGiftsSelection>;

        public function new(k:HabboNuxDialogs, _arg_2:Vector<NewUserExperienceGiftOptions>)
        {
            this._component = k;
            this._giftOptions = _arg_2;
            this._currentIndex = 0;
            this._selectedOptions = new Vector<NewUserExperienceGetGiftsSelection>();
            if (((this._component.sessionDataManager != null) && this._component.sessionDataManager.loadProductData(this)))
            {
                this.show();
            }
        }

        public function productDataReady()
        {
            this.show();
        }

        public function dispose()
        {
            if (this._frame != null)
            {
                this._frame.dispose();
                this._frame = null;
            }
            this._component = null;
            this._optionTemplate = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._component == null;
        }

        function hide()
        {
            if (this._component != null)
            {
                this._component.destroyNuxOfferView();
            }
        }

        function show()
        {
            if (this._frame != null)
            {
                this._frame.dispose();
            }
            var k= Std.downcast(this._component.assets.getAssetByName("nux_gift_selection_xml") , XmlAsset);
            this._frame = Std.downcast(this._component.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._frame == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            var _local_2= this._frame.findChildByTag("close");
            if (_local_2 != null)
            {
                _local_2.visible = false;
            }
            this.populateStep();
        }

        function populateStep()
        {
            var _local_5:NewUserExperienceGift = null;
            var _local_6:IWindowContainer = null;
            var _local_7:ITextWindow = null;
            var _local_8:IButtonWindow = null;
            var _local_9:IWindowContainer = null;
            var _local_10:IStaticBitmapWrapperWindow = null;
            var _local_11:String = null;
            var _local_12:String = null;
            var _local_13 = 0;
            var _local_14:NewUserExperienceGiftProduct = null;
            var _local_15:String = null;
            var _local_16:String = null;
            var _local_17:IProductData = null;
            if (((!(this._giftOptions != null)) || (!(this._giftOptions.length != 0))))
            {
                return;
            }
            var k= this._giftOptions[this._currentIndex];
            var _local_2= Std.downcast(this._frame.findChildByName("nux_gift_selection_list") , IItemListWindow);
            if (this._optionTemplate == null)
            {
                this._optionTemplate = Std.downcast(_local_2.getListItemAt(0) , IWindowContainer);
            }
            _local_2.removeListItems();
            var _local_3= ASCompat.decodeURI(this._component.localizationManager.getLocalization("nux.gift.selection.separator", ", "));
            var _local_4 = 0;
            while (_local_4 < k.options.length)
            {
                _local_5 = k.options[_local_4];
                _local_6 = Std.downcast(this._optionTemplate.clone() , IWindowContainer);
                _local_7 = Std.downcast(_local_6.getChildByName("option_heading") , ITextWindow);
                _local_8 = Std.downcast(_local_6.getChildByName("option_button") , IButtonWindow);
                _local_9 = Std.downcast(_local_6.getChildByName("option_thumbnail") , IWindowContainer);
                _local_10 = Std.downcast(_local_9.getChildByName("option_bitmap") , IStaticBitmapWrapperWindow);
                _local_11 = "";
                if (_local_5._Str_13979.length != 0)
                {
                    _local_13 = 0;
                    while (_local_13 < _local_5._Str_13979.length)
                    {
                        _local_14 = _local_5._Str_13979[_local_13];
                        _local_15 = _local_14.productCode;
                        _local_16 = _local_14._Str_14499;
                        if (_local_16 != null)
                        {
                            _local_11 = (_local_11 + this._component.localizationManager.getLocalization(_local_16, _local_16));
                        }
                        else
                        {
                            _local_17 = this._component.catalog.getProductData(_local_15);
                            if (((_local_17 != null) && ASCompat.stringAsBool(_local_17.name)))
                            {
                                _local_11 = (_local_11 + _local_17.name);
                            }
                            else
                            {
                                _local_11 = (_local_11 + this._component.localizationManager.getLocalization((("product_" + _local_15) + "_name"), (("product_" + _local_15) + "_name")));
                            }
                        }
                        if (_local_13 < (_local_5._Str_13979.length - 1))
                        {
                            _local_11 = (_local_11 + _local_3);
                        }
                        _local_13++;
                    }
                }
                _local_12 = _local_5.roomTemplateName;
                if (ASCompat.stringAsBool(_local_12))
                {
                    _local_10.assetUri = (this._component.configuration.getProperty("image.library.url") + _local_12);
                }
                _local_7.text = _local_11;
                _local_8.name = Std.string(_local_4);
                _local_8.procedure = this.onSelectOption;
                _local_2.addListItem(_local_6);
                _local_4++;
            }
            _local_2.arrangeListItems();
            if (this._giftOptions.length > 1)
            {
                this._frame.caption = ((((this._component.localizationManager.getLocalization("nux.gift.selection.title") + " ") + Std.string(this._currentIndex + 1)) + "/") + Std.string(this._giftOptions.length));
            }
            this._frame.center();
        }

        function onSelectOption(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:NewUserExperienceGiftOptions = null;
            var _local_4:IItemListWindow = null;
            var _local_5 = 0;
            var _local_6:NewUserExperienceGetGiftsSelection = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._giftOptions[this._currentIndex];
                _local_4 = Std.downcast(this._frame.findChildByName("nux_gift_selection_list") , IItemListWindow);
                _local_5 = _local_4.getListItemIndex(_arg_2.parent);
                if (_local_5 == -1)
                {
                    return;
                }
                _local_6 = new NewUserExperienceGetGiftsSelection(_local_3.dayIndex, _local_3.stepIndex, _local_5);
                this._selectedOptions.push(_local_6);
                this._currentIndex++;
                if (this._currentIndex == this._giftOptions.length)
                {
                    this._component.onSendGetGifts(this._selectedOptions);
                }
                else
                {
                    this.show();
                }
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this.hide();
        }
    }









