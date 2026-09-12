package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;

     class MultiProductContainer extends SingleProductContainer 
    {
        public function new(k:IPurchasableOffer, _arg_2:Vector<IProduct>, _arg_3:HabboCatalog)
        {
            super(k, _arg_2, _arg_3);
        }

        override public function initProductIcon(k:IRoomEngine, _arg_2:IStuffData=null)
        {
            super.initProductIcon(k);
            var _local_3= _view.findChildByName("multiContainer");
            if (_local_3 != null)
            {
                _local_3.visible = true;
            }
            var _local_4= Std.downcast(_view.findChildByName("multiCounter") , ITextWindow);
            if (_local_4 != null)
            {
                _local_4.text = ("x" + Std.string(_Str_6851.productCount));
            }
            this._Str_15497(offer.clubLevel);
        }
    }

