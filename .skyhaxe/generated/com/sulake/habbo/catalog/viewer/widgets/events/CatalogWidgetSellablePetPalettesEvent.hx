package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetSellablePetPalettesEvent extends Event 
    {
        var _productCode:String;
        var _sellablePalettes:Array<ASAny>;

        public function new(k:String, _arg_2:Array<ASAny>, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(CatalogWidgetEvent.SELLABLE_PET_PALETTES, _arg_3, _arg_4);
            this._productCode = k;
            this._sellablePalettes = _arg_2;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var _Str_13588(get,never):Array<ASAny>;
public function  get__Str_13588():Array<ASAny>
        {
            if (this._sellablePalettes != null)
            {
                return this._sellablePalettes.slice(0);
            }
            return [];
        }
    }

