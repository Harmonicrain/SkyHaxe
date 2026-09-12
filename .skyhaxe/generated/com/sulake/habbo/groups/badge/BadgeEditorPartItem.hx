package com.sulake.habbo.groups.badge
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.assets.IAssetReceiver;
    import com.sulake.habbo.groups.HabboGroupsManager;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import com.sulake.habbo.communication.messages.incoming.users.BadgePartData;
    import com.sulake.core.assets.IAsset;
    import flash.geom.Point;

     class BadgeEditorPartItem implements IDisposable implements  IAssetReceiver 
    {
        public static var _Str_13754:Int = 0;
        public static var _Str_13419:Int = 1;
        public static var _Str_6696:Float = 39;
        public static var _Str_6533:Float = 39;
        public static var _Str_12924:Float = 13;
        public static var _Str_15025:Float = 13;

        var _manager:HabboGroupsManager;
        var _parentCtrl:BadgeSelectPartCtrl;
        var _partIndex:Int = 0;
        var _type:Int = 0;
        var _sourceUrl:String;
        var _disposed:Bool = false;
        var _fileName:String;
        var _maskFileName:String;
        var _image:BitmapData;
        var _mask:BitmapData;
        var _composite:BitmapData;
        var _colorTransform:ColorTransform;
        var _hasMask:Bool = false;
        var _isLoaded:Bool = false;
        var _isStatic:Bool = false;

        public function new(k:HabboGroupsManager, _arg_2:BadgeSelectPartCtrl, _arg_3:Int, _arg_4:Int, _arg_5:BadgePartData=null)
        {
            this._colorTransform = new ColorTransform(1, 1, 1);
            this._partIndex = _arg_3;
            this._manager = k;
            this._parentCtrl = _arg_2;
            this._type = _arg_4;
            this._sourceUrl = this._manager.getProperty("image.library.badgepart.url");
            this._composite = new BitmapData(Std.int(_Str_6696), Std.int(_Str_6533));
            if (_arg_5 == null)
            {
                this._isLoaded = true;
                this._isStatic = true;
                this._image = this._manager.getButtonImage("badge_part_empty");
            }
            else
            {
                this._fileName = ASCompat.stringReplace(ASCompat.stringReplace(_arg_5.fileName, ".gif", ""), ".png", "");
                this._maskFileName = ASCompat.stringReplace(ASCompat.stringReplace(_arg_5._Str_22901, ".gif", ""), ".png", "");
                this._hasMask = (this._maskFileName.length > 0);
                this._composite = new BitmapData(Std.int(_Str_6696), Std.int(_Str_6533));
                this._fileName = (((this._sourceUrl + "badgepart_") + this._fileName) + ".png");
                this._maskFileName = (((this._sourceUrl + "badgepart_") + this._maskFileName) + ".png");
                this._manager.windowManager.resourceManager.retrieveAsset(this._fileName, this);
                this._manager.windowManager.resourceManager.retrieveAsset(this._maskFileName, this);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_3324(get,never):Int;
public function  get__Str_3324():Int
        {
            return this._partIndex;
        }

        public function receiveAsset(k:IAsset, _arg_2:String)
        {
            var _local_3= this._manager.windowManager.resourceManager;
            if (_local_3.isSameAsset(this._fileName, _arg_2))
            {
                this._image = ASCompat.dynamicAs(k.content , BitmapData);
            }
            if (_local_3.isSameAsset(this._maskFileName, _arg_2))
            {
                this._mask = ASCompat.dynamicAs(k.content , BitmapData);
            }
            this._Str_22804();
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._image != null)
                {
                    this._image.dispose();
                    this._image = null;
                }
                if (this._mask != null)
                {
                    this._mask.dispose();
                    this._mask = null;
                }
                if (this._composite != null)
                {
                    this._composite.dispose();
                    this._composite = null;
                }
                this._fileName = null;
                this._maskFileName = null;
                this._colorTransform = null;
                this._parentCtrl = null;
                this._manager = null;
                this._disposed = true;
            }
        }

        function _Str_22804()
        {
            if (this._image == null)
            {
                return;
            }
            if ((this._hasMask && (this._mask == null)))
            {
                return;
            }
            this._isLoaded = true;
            if (this._type == _Str_13754)
            {
                this._parentCtrl._Str_25511(this);
            }
            else
            {
                this._parentCtrl._Str_22980(this);
            }
        }

        public function getComposite(k:BadgeLayerOptions):BitmapData
        {
            if (!this._isLoaded)
            {
                return null;
            }
            if (this._isStatic)
            {
                return this._image;
            }
            var _local_2= this._manager.guildEditorData._Str_9008[k.colorIndex] ;
            this._colorTransform.redMultiplier = (_local_2.red / 0xFF);
            this._colorTransform.greenMultiplier = (_local_2.green / 0xFF);
            this._colorTransform.blueMultiplier = (_local_2.blue / 0xFF);
            var _local_3= this.getPosition(k);
            this._composite.dispose();
            this._composite = new BitmapData(Std.int(_Str_6696), Std.int(_Str_6533), true, 0);
            this._composite.copyPixels(this._image, this._image.rect, _local_3);
            this._composite.colorTransform(this._composite.rect, this._colorTransform);
            if (this._hasMask)
            {
                this._composite.copyPixels(this._mask, this._mask.rect, _local_3, null, null, true);
            }
            return this._composite;
        }

        function getPosition(k:BadgeLayerOptions):Point
        {
            var _local_2= (((_Str_12924 * k._Str_7460) + (_Str_12924 / 2)) - (this._image.width / 2));
            var _local_3= (((_Str_15025 * k._Str_8051) + (_Str_15025 / 2)) - (this._image.height / 2));
            if (_local_2 < 0)
            {
                _local_2 = 0;
            }
            if ((_local_2 + this._image.width) > _Str_6696)
            {
                _local_2 = (_Str_6696 - this._image.width);
            }
            if (_local_3 < 0)
            {
                _local_3 = 0;
            }
            if ((_local_3 + this._image.height) > _Str_6533)
            {
                _local_3 = (_Str_6533 - this._image.height);
            }
            return new Point(Math.ffloor(_local_2), Math.ffloor(_local_3));
        }
    }

