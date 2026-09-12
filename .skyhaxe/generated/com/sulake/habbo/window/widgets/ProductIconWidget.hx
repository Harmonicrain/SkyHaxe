package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import flash.display.BitmapData;
    import flash.events.Event;

     class ProductIconWidget implements IProductIconWidget implements  IGetImageListener
    {
        public static inline final PRODUCT_ICON= "product_icon";

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _productInfo:IProductDisplayInfo;
        var _imageCallbackId:Int = -1;
        var _blend:Float = 1;
        var _pendingHabbiconId:Int = 0;

        public function new(widgetWindow:IWidgetWindow, windowManager:HabboWindowManagerComponent, layoutAssetName:String="product_icon_xml")
        {
            this._widgetWindow = widgetWindow;
            this._windowManager = windowManager;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName(layoutAssetName).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
            this.clearPreviewer();
        }

        
        public var productInfo(get,set):IProductDisplayInfo;
public function  set_productInfo(value:IProductDisplayInfo):IProductDisplayInfo        {
            this._productInfo = value;
            this.previewImage(value);
return value;
        }
public function  get_productInfo():IProductDisplayInfo
        {
            return this._productInfo;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            return [];
        }
public function  set_properties(value:Array<ASAny>):Array<ASAny>        {
return value;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        public function previewImage(info:IProductDisplayInfo)
        {
            var furniture:IFurnitureData = null;
            var image:ImageResult = null;
            var iconStyle = 0;

            if (info == null)
            {
                this.setUnknownImage();
                return;
            }

            switch (info.productTypeId)
            {
                case 0:
                    this.setUnknownImage();
                    
                case 1:
                    furniture = this._windowManager.sessionDataManager.getWallItemData(ASCompat.parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        return;
                    }
                    this.imageResult = this._windowManager.roomEngine.getWallItemIcon(furniture.id, this, info.extraData);
                    
                case 2
                   | 12:
                    furniture = this._windowManager.sessionDataManager.getFloorItemData(ASCompat.parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        return;
                    }
                    this.imageResult = this._windowManager.roomEngine.getFurnitureIcon(furniture.id, this);
                    
                case 5:
                    this.badgeResult = info.itemTypeId;
                    
                case 9:
                    iconStyle = ActivityPointTypeEnum.getIconStyleFor(ASCompat.parseInt(info.itemTypeId), this._windowManager.context.configuration, true);
                    if (iconStyle == 0)
                    {
                        this.clearPreviewer();
                    }
                    else
                    {
                        this.iconResult = iconStyle;
                    }
                    
                case 11:
                    this.petResult = info.petFigureString;
                    
                case 7300:
                    HabbiconAssetManager.configure(this._windowManager.context.configuration);
                    this.habbiconResult = ASCompat.parseInt(info.itemTypeId);
                    
                default:
                    this.clearPreviewer();
            }
        }

        public function clearPreviewer()
        {
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._pendingHabbiconId = 0;
            this._imageCallbackId = -1;
            if (this.productPreviewBitmap != null)
            {
                this.productPreviewBitmap.visible = false;
            }
            if (this.badgeImageWidget != null)
            {
                this.badgeImageWidget.visible = false;
            }
            if (this.petImageWidget != null)
            {
                this.petImageWidget.visible = false;
            }
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.visible = false;
            }
            if (this.iconWindow != null)
            {
                this.iconWindow.visible = false;
            }
        }

        var imageResult(never,set):ImageResult;
function  set_imageResult(value:ImageResult):ImageResult        {
            this.clearPreviewer();
            if (value != null)
            {
                this._imageCallbackId = value.id;
                this.setPreviewImage(value.data);
            }
return value;
        }

        var badgeResult(never,set):String;
function  set_badgeResult(value:String):String        {
            var badgeWidget:IBadgeImageWidget = null;
            this.clearPreviewer();
            if (this.badgeImageWidget != null)
            {
                this.badgeImageWidget.visible = true;
                badgeWidget = Std.downcast(this.badgeImageWidget.widget , IBadgeImageWidget);
                if (badgeWidget != null)
                {
                    badgeWidget.badgeId = value;
                }
            }
return value;
        }

        var petResult(never,set):String;
function  set_petResult(value:String):String        {
            var petWidget:_Str_18605 = null;
            this.clearPreviewer();
            if (this.petImageWidget != null)
            {
                this.petImageWidget.visible = true;
                petWidget = Std.downcast(this.petImageWidget.widget , _Str_18605);
                if (petWidget != null)
                {
                    petWidget.figure = value;
                }
            }
return value;
        }

        var iconResult(never,set):Int;
function  set_iconResult(value:Int):Int        {
            var icon:IIconWindow = null;
            this.clearPreviewer();
            if (this.iconWindow != null)
            {
                icon = this.iconWindow;
                icon.visible = true;
                icon.style = value;
                icon.fitToSize();
                if (this._root != null)
                {
                    icon.x = Std.int((this._root.width - icon.width) / 2);
                    icon.y = Std.int((this._root.height - icon.height) / 2);
                }
            }
return value;
        }

        var habbiconResult(never,set):Int;
function  set_habbiconResult(value:Int):Int        {
            var bitmap:BitmapData = null;
            this.clearPreviewer();
            bitmap = HabbiconAssetManager.getPreviewBitmap(value, false);
            if (bitmap == null)
            {
                this._pendingHabbiconId = value;
                HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
                return value;
            }
            this.setPreviewImage(bitmap);
return value;
        }

        function onHabbiconAssetsLoaded(event:Event)
        {
            var habbiconId= this._pendingHabbiconId;
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._pendingHabbiconId = 0;
            if (habbiconId > 0)
            {
                this.setPreviewImage(HabbiconAssetManager.getPreviewBitmap(habbiconId, false));
            }
        }

        function setUnknownImage()
        {
            this.clearPreviewer();
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.visible = true;
            }
            else
            {
                this.setPlaceholderImage();
            }
        }

        function setPreviewImage(value:BitmapData)
        {
            if (this.productPreviewBitmap == null)
            {
                return;
            }
            if (value == null)
            {
                this.productPreviewBitmap.visible = false;
                return;
            }
            this.productPreviewBitmap.bitmap = value.clone();
            this.productPreviewBitmap.disposesBitmap = true;
            this.productPreviewBitmap.visible = true;
        }

        function setPlaceholderImage()
        {
            var asset= this._windowManager.assets.getAssetByName("placeholder_furni_small_png");
            if (asset != null)
            {
                this.setPreviewImage(ASCompat.dynamicAs(asset.content , BitmapData));
            }
        }

        public function imageReady(id:Int, data:BitmapData)
        {
            if (this._imageCallbackId == id)
            {
                this.setPreviewImage(data);
            }
        }

        public function imageFailed(id:Int)
        {
        }

        public var unknownImageUri(never,set):String;
public function  set_unknownImageUri(value:String):String        {
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.assetUri = value;
            }
return value;
        }

        
        public var blend(get,set):Float;
public function  set_blend(value:Float):Float        {
            this._blend = value;
            if (this.productPreviewBitmap != null)
            {
                this.productPreviewBitmap.blend = value;
            }
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.blend = value;
            }
            if (this.badgeImageWidget != null)
            {
                this.badgeImageWidget.blend = value;
            }
            if (this.petImageWidget != null)
            {
                this.petImageWidget.blend = value;
            }
return value;
        }
public function  get_blend():Float
        {
            return this._blend;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._imageCallbackId = -1;
            this._productInfo = null;
            if (this._root != null)
            {
                this._root.dispose();
                this._root = null;
            }
            if (this._widgetWindow != null)
            {
                this._widgetWindow.rootWindow = null;
                this._widgetWindow = null;
            }
            this._windowManager = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        var productPreviewBitmap(get,never):IBitmapWrapperWindow;
function  get_productPreviewBitmap():IBitmapWrapperWindow
        {
            return (this._root == null) ? null : Std.downcast(this._root.findChildByName("bitmap") , IBitmapWrapperWindow);
        }

        var badgeImageWidget(get,never):IWidgetWindow;
function  get_badgeImageWidget():IWidgetWindow
        {
            return (this._root == null) ? null : Std.downcast(this._root.findChildByName("badge_image_widget") , IWidgetWindow);
        }

        var petImageWidget(get,never):IWidgetWindow;
function  get_petImageWidget():IWidgetWindow
        {
            return (this._root == null) ? null : Std.downcast(this._root.findChildByName("pet_image_widget") , IWidgetWindow);
        }

        var unknownImageWindow(get,never):IStaticBitmapWrapperWindow;
function  get_unknownImageWindow():IStaticBitmapWrapperWindow
        {
            return (this._root == null) ? null : Std.downcast(this._root.findChildByName("unknown_image") , IStaticBitmapWrapperWindow);
        }

        var iconWindow(get,never):IIconWindow;
function  get_iconWindow():IIconWindow
        {
            return (this._root == null) ? null : Std.downcast(this._root.findChildByName("icon") , IIconWindow);
        }
    }

