package com.sulake.habbo.avatar.common
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.structure.figure.IFigurePartSet;
    import flash.geom.Rectangle;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.avatar._enum.AvatarFigurePartType;
    import com.sulake.habbo.avatar.structure.figure.IFigurePart;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.core.assets.IAsset;
    import flash.geom.ColorTransform;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import flash.geom.Matrix;

     class AvatarEditorGridPartItem implements IAvatarImageListener 
    {
        static var _Str_8581:BitmapData;
        static var _Str_2983:Array<ASAny> = [];

        final _Str_7127:Array<ASAny> = [2, 6, 0, 4, 3, 1];

        var _model:IAvatarEditorCategoryModel;
        var _view:IWindowContainer;
        var _Str_2779:IWindow;
        var _partSet:IFigurePartSet;
        var _Str_611:Array<ASAny>;
        var _Str_16386:Bool = false;
        var _Str_2968:Bool = false;
        var _Str_3155:BitmapData;
        var _Str_6176:Rectangle;
        var _Str_18982:Int = 0;
        var _Str_1599:IAvatarRenderManager;
        var _disposed:Bool = false;
        var _Str_8318:Bool = false;

        public function new(k:IWindowContainer, _arg_2:IAvatarEditorCategoryModel, _arg_3:IFigurePartSet, _arg_4:Array<ASAny>, _arg_5:Bool=true, _arg_6:Bool=false)
        {
            var _local_7:IFigurePart = null;
            var _local_8:Array<ASAny> = null;
            this._model = _arg_2;
            this._partSet = _arg_3;
            this._view = k;
            this._Str_2779 = this._view.findChildByTag("BG_COLOR");
            this._Str_611 = _arg_4;
            this._Str_16386 = _arg_5;
            this._Str_8318 = _arg_6;
            if (_arg_3 == null)
            {
                this._Str_3155 = new BitmapData(1, 1, true, 0xFFFFFF);
            }
            if (_arg_3 != null)
            {
                _local_8 = _arg_3.parts;
                if (checkNullIteratee(_local_8)) for (_tmp_ in _local_8)
                {
_local_7  = _tmp_;
                    this._Str_18982 = Std.int(Math.max(this._Str_18982, _local_7._Str_827));
                }
            }
            this._Str_1599 = this._model.controller.manager.avatarRenderManager;
            this._view.addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
            this._view.addEventListener(WindowMouseEvent.OUT, this._Str_17495);
            this._Str_8768();
        }

        function _Str_17495(k:WindowMouseEvent)
        {
            if (!this._Str_2968)
            {
                this._Str_2779.visible = false;
            }
            this._Str_2779.blend = 1;
        }

        function onMouseOver(k:WindowMouseEvent)
        {
            if (!this._Str_2968)
            {
                this._Str_2779.visible = true;
                this._Str_2779.blend = 0.5;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._model = null;
            this._partSet = null;
            if (this._view != null)
            {
                if (!this._view.disposed)
                {
                    this._view.dispose();
                }
            }
            this._view = null;
            if (this._Str_3155 != null)
            {
                this._Str_3155.dispose();
            }
            this._Str_3155 = null;
            this._disposed = true;
            _Str_8581 = null;
            this._Str_2779 = null;
            this._Str_6176 = null;
            this._Str_1599 = null;
            this._disposed = true;
            this._Str_611 = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }

        
        public var Selected(get,set):Bool;
public function  get_Selected():Bool
        {
            return this._Str_2968;
        }
public function  set_Selected(k:Bool):Bool        {
            this._Str_2968 = k;
            this._Str_8768();
return k;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            if (this._partSet == null)
            {
                return -1;
            }
            return this._partSet.id;
        }

        public var _Str_17445(get,never):Int;
public function  get__Str_17445():Int
        {
            return this._Str_18982;
        }

        public function update()
        {
            this._Str_8768();
        }

        public var icon(never,set):BitmapData;
public function  set_icon(k:BitmapData):BitmapData        {
            this._Str_3155 = k;
            this._Str_8768();
return k;
        }

        public var partSet(get,never):IFigurePartSet;
public function  get_partSet():IFigurePartSet
        {
            return this._partSet;
        }

        public var colors(never,set):Array<ASAny>;
public function  set_colors(k:Array<ASAny>):Array<ASAny>        {
            this._Str_611 = k;
            this._Str_8768();
return k;
        }

        function _Str_8768()
        {
            var _local_4:BitmapData = null;
            var _local_5:BitmapData = null;
            var _local_6 = 0;
            var _local_7 = 0;
            if (((!(this._view != null)) || this._view.disposed))
            {
                return;
            }
            var k= Std.downcast(this._view.findChildByName("bitmap") , IBitmapWrapperWindow);
            if (k != null)
            {
                if (((!(this._Str_3155 == null)) && (!this._Str_16386)))
                {
                    _local_4 = this._Str_3155;
                }
                else
                {
                    _local_4 = this._Str_23219();
                    if (_local_4 == null)
                    {
                        return;
                    }
                }
                _local_5 = ((k.bitmap != null) ? k.bitmap : new BitmapData(k.width, k.height));
                _local_5.fillRect(_local_5.rect, 0xFFFFFF);
                _local_6 = Std.int((_local_5.width - _local_4.width) / 2);
                _local_7 = Std.int((_local_5.height - _local_4.height) / 2);
                _local_5.copyPixels(_local_4, _local_4.rect, new Point(_local_6, _local_7), null, null, true);
                k.bitmap = _local_5;
            }
            var _local_2= this._view.findChildByTag("CLUB_ICON");
            var _local_3= Std.downcast(this._view.findChildByTag("SELLABLE_ICON") , IStaticBitmapWrapperWindow);
            if (this._partSet != null)
            {
                _local_2.visible = (this._partSet.clubLevel > 0);
                _local_3.visible = this._partSet.isSellable;
            }
            else
            {
                _local_2.visible = false;
                _local_3.visible = false;
            }
            if (this._Str_8318)
            {
                this.setAlpha(_local_5, 0.2);
            }
            if (this._Str_2779 == null)
            {
                return;
            }
            this._Str_2779.visible = this._Str_2968;
            this._Str_2779.blend = 1;
            this._view.invalidate();
        }

        function _Str_21262():Bool
        {
            var _local_2:IFigurePart = null;
            var _local_3:String = null;
            var _local_4:BitmapDataAsset = null;
            var _local_5:BitmapData = null;
            if (this._model == null)
            {
                this._Str_6176 = null;
                return false;
            }
            if ((((!(this.partSet != null)) || (!(this.partSet.parts != null))) || (this.partSet.parts.length == 0)))
            {
                this._Str_6176 = null;
                return false;
            }
            if (this._Str_1599 == null)
            {
                return false;
            }
            var k= this._Str_1599._Str_718(((this.partSet.type + "-") + Std.string(this.partSet.id)));
            if (!this._Str_1599._Str_961(k))
            {
                this._Str_1599._Str_889(k, this);
                return false;
            }
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8= new Rectangle();
            final _iter_ = this.partSet.parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_7)
                {
                    _local_3 = ((((((((((FigureData.H + "_") + FigureData.STD) + "_") + _local_2.type) + "_") + Std.string(_local_2.id)) + "_") + this._Str_7127[_local_6]) + "_") + FigureData._Str_2028);
                    _local_4 = Std.downcast(this._Str_1599.getAssetByName(_local_3) , BitmapDataAsset);
                }
                else
                {
                    _local_6 = 0;
                    while (((!_local_7) && (_local_6 < this._Str_7127.length)))
                    {
                        _local_3 = ((((((((((FigureData.H + "_") + FigureData.STD) + "_") + _local_2.type) + "_") + Std.string(_local_2.id)) + "_") + this._Str_7127[_local_6]) + "_") + FigureData._Str_2028);
                        _local_4 = Std.downcast(this._Str_1599.getAssetByName(_local_3) , BitmapDataAsset);
                        if (((_local_4 != null) && ASCompat.toBool(_local_4.content)))
                        {
                            _local_7 = true;
                        }
                        else
                        {
                            _local_6++;
                        }
                    }
                }
                if (((_local_4 != null) && ASCompat.toBool(_local_4.content)))
                {
                    _local_5 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                    _local_8 = _local_8.union(new Rectangle((-1 * _local_4.offset.x), (-1 * _local_4.offset.y), _local_4.rectangle.width, _local_4.rectangle.height));
                }
            }
            if (((_local_8 != null) && (_local_8.width > 0)))
            {
                this._Str_6176 = _local_8;
                return true;
            }
            return false;
        }

        function _Str_23219():BitmapData
        {
            var k:BitmapData = null;
            var _local_2:IFigurePart = null;
            var _local_3:String = null;
            var _local_4:BitmapDataAsset = null;
            var _local_5:BitmapData = null;
            var _local_9:IAsset = null;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12:ColorTransform = null;
            var _local_13:IPartColor = null;
            var _local_14:Rectangle = null;
            if (this.partSet == null)
            {
                return null;
            }
            if (this._model == null)
            {
                return null;
            }
            if (this._Str_6176 == null)
            {
                if (!this._Str_21262())
                {
                    if (_Str_8581 == null)
                    {
                        _local_9 = this._model.controller.manager.windowManager.assets.getAssetByName("avatar_editor_avatar_editor_download_icon");
                        _Str_8581 = ASCompat.dynamicAs(_local_9.content , BitmapData);
                    }
                    return _Str_8581;
                }
            }
            if (this._Str_1599 == null)
            {
                return null;
            }
            k = new BitmapData(Std.int(this._Str_6176.width), Std.int(this._Str_6176.height), true, 0xFFFFFF);
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8= ASCompat.ASArray.sort(this.partSet.parts.copy(), this._Str_25408);
            if (checkNullIteratee(_local_8)) for (_tmp_ in _local_8)
            {
_local_2  = _tmp_;
                _local_4 = null;
                if (_local_7)
                {
                    _local_3 = ((((((((((FigureData.H + "_") + FigureData.STD) + "_") + _local_2.type) + "_") + Std.string(_local_2.id)) + "_") + this._Str_7127[_local_6]) + "_") + FigureData._Str_2028);
                    _local_4 = Std.downcast(this._Str_1599.getAssetByName(_local_3) , BitmapDataAsset);
                }
                else
                {
                    _local_6 = 0;
                    while (((!_local_7) && (_local_6 < this._Str_7127.length)))
                    {
                        _local_3 = ((((((((((FigureData.H + "_") + FigureData.STD) + "_") + _local_2.type) + "_") + Std.string(_local_2.id)) + "_") + this._Str_7127[_local_6]) + "_") + FigureData._Str_2028);
                        _local_4 = Std.downcast(this._Str_1599.getAssetByName(_local_3) , BitmapDataAsset);
                        if (((_local_4 != null) && ASCompat.toBool(_local_4.content)))
                        {
                            _local_7 = true;
                        }
                        else
                        {
                            _local_6++;
                        }
                    }
                }
                if (_local_4 != null)
                {
                    _local_5 = cast(_local_4.content, BitmapData);
                    _local_10 = Std.int((-1 * _local_4.offset.x) - this._Str_6176.x);
                    _local_11 = Std.int((-1 * _local_4.offset.y) - this._Str_6176.y);
                    _local_12 = null;
                    if ((this._Str_16386 && (_local_2._Str_827 > 0)))
                    {
                        _local_13 = this._Str_611[(_local_2._Str_827 - 1)];
                        if (_local_13 != null)
                        {
                            _local_12 = _local_13.colorTransform;
                        }
                    }
                    if (_local_12 != null)
                    {
                        _local_14 = new Rectangle(_local_10, _local_11, _local_4.rectangle.width, _local_4.rectangle.height);
                        k.draw(ASCompat.dynamicAs(_local_4.content , BitmapData), new Matrix(1, 0, 0, 1, (-_local_4.rectangle.x + _local_10), (-_local_4.rectangle.y + _local_11)), _local_12, null, _local_14);
                    }
                    else
                    {
                        k.copyPixels(_local_5, _local_4.rectangle, new Point(_local_10, _local_11), null, null, true);
                    }
                }
            }
            return k;
        }

        function setAlpha(k:BitmapData, _arg_2:Float):BitmapData
        {
            var _local_3= new Rectangle(0, 0, k.width, k.height);
            var _local_4= new ColorTransform();
            _local_4.alphaMultiplier = _arg_2;
            k.colorTransform(_local_3, _local_4);
            return k;
        }

        function _Str_25408(k:IFigurePart, _arg_2:IFigurePart):Float
        {
            var _local_3:Float = _Str_2983.indexOf(k.type);
            var _local_4:Float = _Str_2983.indexOf(_arg_2.type);
            if (_local_3 < _local_4)
            {
                return -1;
            }
            if (_local_3 > _local_4)
            {
                return 1;
            }
            if (k.index < _arg_2.index)
            {
                return -1;
            }
            if (k.index > _arg_2.index)
            {
                return 1;
            }
            return 0;
        }

        public function avatarImageReady(k:String)
        {
            if (!this._Str_21262())
            {
                return;
            }
            this._Str_8768();
        }

        public var _Str_14863(get,never):Bool;
public function  get__Str_14863():Bool
        {
            return this._Str_8318;
        }

	static final ___init = {

        {
            _Str_2983.push(AvatarFigurePartType.LEFT_HAND_ITEM);
            _Str_2983.push(AvatarFigurePartType.LEFT_HAND);
            _Str_2983.push(AvatarFigurePartType.LEFT_SLEEVE);
            _Str_2983.push(AvatarFigurePartType.LEFT_COAT_SLEEVE);
            _Str_2983.push("mcl");
            _Str_2983.push("ptl");
            _Str_2983.push(AvatarFigurePartType.BODY);
            _Str_2983.push(AvatarFigurePartType.SHOES);
            _Str_2983.push(AvatarFigurePartType.LEGS);
            _Str_2983.push(AvatarFigurePartType.CHEST);
            _Str_2983.push(AvatarFigurePartType.CHEST_ACCESSORY);
            _Str_2983.push(AvatarFigurePartType.COAT_CHEST);
            _Str_2983.push(AvatarFigurePartType.CHEST_PRINT);
            _Str_2983.push("mc");
            _Str_2983.push("pt");
            _Str_2983.push(AvatarFigurePartType.WAIST_ACCESSORY);
            _Str_2983.push(AvatarFigurePartType.RIGHT_HAND);
            _Str_2983.push(AvatarFigurePartType.RIGHT_SLEEVE);
            _Str_2983.push(AvatarFigurePartType.RIGHT_COAT_SLEEVE);
            _Str_2983.push("mcr");
            _Str_2983.push("ptr");
            _Str_2983.push(AvatarFigurePartType.HEAD);
            _Str_2983.push(AvatarFigurePartType.FACE);
            _Str_2983.push(AvatarFigurePartType.EYES);
            _Str_2983.push(AvatarFigurePartType.HAIR);
            _Str_2983.push(AvatarFigurePartType.HAIR_BIG);
            _Str_2983.push(AvatarFigurePartType.FACE_ACCESSORY);
            _Str_2983.push(AvatarFigurePartType.EYE_ACCESSORY);
            _Str_2983.push(AvatarFigurePartType.HEAD_ACCESSORY);
            _Str_2983.push(AvatarFigurePartType.HEAD_ACCESSORY_EXTRA);
            _Str_2983.push(AvatarFigurePartType.RIGHT_HAND_ITEM);
        }

	null;
	};
    }

