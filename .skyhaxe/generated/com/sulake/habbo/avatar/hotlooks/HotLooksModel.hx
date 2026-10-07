package com.sulake.habbo.avatar.hotlooks
;
    import com.sulake.habbo.avatar.common.CategoryBaseModel;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.habbo.avatar.wardrobe.Outfit;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.assets.XmlAsset;
    import flash.events.Event;
    import com.sulake.habbo.avatar.common.CategoryData;
    import com.sulake.habbo.avatar.figuredata.*;

     class HotLooksModel extends CategoryBaseModel implements IAvatarEditorCategoryModel 
    {
        public static inline final HOT_LOOKS= "hot_looks";
        public static inline final MY_LOOKS= "my_looks";
        static inline final MAXIMUM_HOT_LOOKS= 20;

        var _hotLooks:ASDictionary<ASAny,ASAny>;

        public function new(k:HabboAvatarEditor)
        {
            super(k);
            this._hotLooks = new ASDictionary<ASAny,ASAny>();
            this._hotLooks[FigureData.M] = new Array<ASAny>();
            this._hotLooks[FigureData.F] = new Array<ASAny>();
            this._hotLooks[(FigureData.M + ".index")] = 0;
            this._hotLooks[(FigureData.F + ".index")] = 0;
            this.requestHotLooks();
        }

        override public function dispose()
        {
            super.dispose();
            this._hotLooks = null;
        }

        override function init()
        {
            if (_view == null)
            {
                _view = new HotLooksView(this);
            }
            _view.init();
            _isInitialized = true;
        }

        public function selectHotLook(k:Int)
        {
            var _local_2:Array<ASAny> = this._hotLooks[_controller.gender];
            var _local_3:Outfit = _local_2[k];
            if (_local_3 != null)
            {
                if (_local_3.figure == "")
                {
                    return;
                }
                _controller.loadAvatarInEditor(_local_3.figure, _local_3.gender, _controller.clubMemberLevel);
            }
        }

        public var hotLooks(get,never):Array<ASAny>;
public function  get_hotLooks():Array<ASAny>
        {
            return this._hotLooks[_controller.gender];
        }

        function requestHotLooks()
        {
            var k= _controller.manager.getProperty("avatareditor.promohabbos");
            var _local_2= new URLRequest(k);
            var _local_3= _controller.manager.assets.loadAssetFromFile("hotLooksConfiguration", _local_2, "text/xml");
            _local_3.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onHotLooksConfiguration);
        }

        function onHotLooksConfiguration(event:Event=null)
        {
            var habbos:com.sulake.core.utils.xml.XML = null;
            var processedHotLooks = 0;
            var habbo:com.sulake.core.utils.xml.XML = null;
            var hotLook:Outfit = null;
            var loaderStruct= ASCompat.dynamicAs(event.target , AssetLoaderStruct);
            if (loaderStruct == null)
            {
                return;
            }
            var xmlAsset= Std.downcast(_controller.manager.assets.getAssetByName("hotLooksConfiguration") , XmlAsset);
            if (xmlAsset != null)
            {
                try
                {
                    habbos = ((xmlAsset.content : com.sulake.core.utils.xml.XML) );
                    processedHotLooks = 0;
                    final _iter_ = habbos.child("habbo"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
habbo  = _tmp_;
                        if (processedHotLooks > MAXIMUM_HOT_LOOKS)
                        {
                            break;
                        }
                        hotLook = new Outfit(_controller, habbo.attribute("figure").toString(), habbo.attribute("gender").toString());
                        ((ASCompat.dynamicAs(this._hotLooks[hotLook.gender] , Array) : Array<ASAny>)).push(hotLook);
                        processedHotLooks = (processedHotLooks + 1);
                    }
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        override public function switchCategory(k:String="")
        {
        }

        override public function getCategoryData(k:String):CategoryData
        {
            return null;
        }

        override public function selectPart(k:String, _arg_2:Int)
        {
        }
    }

