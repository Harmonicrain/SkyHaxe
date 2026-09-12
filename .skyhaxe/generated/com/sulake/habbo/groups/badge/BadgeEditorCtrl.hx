package com.sulake.habbo.groups.badge
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.groups.HabboGroupsManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.groups.events.HabboGroupsEditorData;
    import com.sulake.habbo.communication.messages.incoming.users.GuildBadgeSettings;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.habbo.groups.*;

     class BadgeEditorCtrl implements IDisposable 
    {
        var _manager:HabboGroupsManager;
        var _window:IWindowContainer;
        var _parentWindow:IWindowContainer;
        var _badgeInitData:Array<ASAny>;
        var _badgeSelectPartCtrl:BadgeSelectPartCtrl;
        var _disposed:Bool = false;
        var _layers:Vector<BadgeLayerCtrl>;
        var _currentLayerOptions:BadgeLayerOptions;
        var _partSelectContainer:IWindowContainer;
        var _partSelectGrid:IItemGridWindow;
        var _partEditContainer:IWindowContainer;
        var _badgePreviewImages:Vector<IBitmapWrapperWindow>;

        public function new(k:HabboGroupsManager)
        {
            this._manager = k;
            this._manager.events.addEventListener(HabboGroupsEditorData.HGE_EDIT_INFO, this._Str_23748);
            this._badgeSelectPartCtrl = new BadgeSelectPartCtrl(this._manager, this);
            this._layers = new Vector<BadgeLayerCtrl>();
            this._layers.push(new BadgeLayerCtrl(this._manager, this, 0));
            this._layers.push(new BadgeLayerCtrl(this._manager, this, 1));
            this._layers.push(new BadgeLayerCtrl(this._manager, this, 2));
            this._layers.push(new BadgeLayerCtrl(this._manager, this, 3));
            this._layers.push(new BadgeLayerCtrl(this._manager, this, 4));
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_23796(get,never):IWindowContainer;
public function  get__Str_23796():IWindowContainer
        {
            return this._partEditContainer;
        }

        public var _Str_20634(get,never):IWindowContainer;
public function  get__Str_20634():IWindowContainer
        {
            return this._partSelectContainer;
        }

        public var _Str_5636(get,never):IItemGridWindow;
public function  get__Str_5636():IItemGridWindow
        {
            return this._partSelectGrid;
        }

        public var _Str_21658(get,never):BadgeLayerOptions;
public function  get__Str_21658():BadgeLayerOptions
        {
            return this._currentLayerOptions;
        }

        public var _Str_19999(get,never):BadgeSelectPartCtrl;
public function  get__Str_19999():BadgeSelectPartCtrl
        {
            return this._badgeSelectPartCtrl;
        }

        public var isIntialized(get,never):Bool;
public function  get_isIntialized():Bool
        {
            return (!(this._window == null)) && (!(this._badgeInitData == null));
        }

        public function dispose()
        {
            var k:BadgeLayerCtrl = null;
            var _local_2:IBitmapWrapperWindow = null;
            if (!this._disposed)
            {
                if (this._layers != null)
                {
                    final _iter_ = this._layers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
k  = _tmp_;
                        k.dispose();
                    }
                    this._layers = null;
                }
                if (this._badgeSelectPartCtrl != null)
                {
                    this._badgeSelectPartCtrl.dispose();
                    this._badgeSelectPartCtrl = null;
                }
                if (this._partSelectContainer != null)
                {
                    this._partSelectContainer.dispose();
                    this._partSelectContainer = null;
                }
                if (this._partSelectGrid != null)
                {
                    this._partSelectGrid.dispose();
                    this._partSelectGrid = null;
                }
                if (this._partEditContainer != null)
                {
                    this._partEditContainer.dispose();
                    this._partEditContainer = null;
                }
                if (this._badgePreviewImages != null)
                {
                    final _iter_ = this._badgePreviewImages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_2  = _tmp_;
                        _local_2.dispose();
                    }
                    this._badgePreviewImages = null;
                }
                if (this._window != null)
                {
                    this._window.dispose();
                    this._window = null;
                }
                this._badgeInitData = null;
                this._currentLayerOptions = null;
                this._window = null;
                this._manager = null;
                this._disposed = true;
            }
        }

        public function _Str_23748(k:HabboGroupsEditorData)
        {
            this._badgeSelectPartCtrl.loadData();
            this.createWindow(null, null);
        }

        public function createWindow(k:IWindowContainer, _arg_2:Array<ASAny>)
        {
            if (((!(this._window == null)) || this._disposed))
            {
                return;
            }
            if (k != null)
            {
                this._parentWindow = k;
            }
            if (_arg_2 != null)
            {
                this._badgeInitData = _arg_2;
            }
            if (((((this._parentWindow == null) || (this._badgeInitData == null)) || (this._manager == null)) || (this._manager.guildEditorData == null)))
            {
                return;
            }
            this._window = Std.downcast(this._manager.getXmlWindow("badge_editor") , IWindowContainer);
            var _local_3= Std.downcast(this._window.findChildByName("guild_badge") , IWindowContainer);
            this._badgePreviewImages = new Vector<IBitmapWrapperWindow>();
            this._badgePreviewImages.push(Std.downcast(_local_3.findChildByName("layer_0") , IBitmapWrapperWindow));
            this._badgePreviewImages.push(Std.downcast(_local_3.findChildByName("layer_1") , IBitmapWrapperWindow));
            this._badgePreviewImages.push(Std.downcast(_local_3.findChildByName("layer_2") , IBitmapWrapperWindow));
            this._badgePreviewImages.push(Std.downcast(_local_3.findChildByName("layer_3") , IBitmapWrapperWindow));
            this._badgePreviewImages.push(Std.downcast(_local_3.findChildByName("layer_4") , IBitmapWrapperWindow));
            this._partEditContainer = Std.downcast(this._window.findChildByName("part_edit") , IWindowContainer);
            this._partSelectContainer = Std.downcast(this._window.findChildByName("part_select") , IWindowContainer);
            this._partSelectContainer.visible = false;
            this._partSelectGrid = Std.downcast(this._partSelectContainer.findChildByName("part_select_grid") , IItemGridWindow);
            var _local_4 = 0;
            while (_local_4 < this._layers.length)
            {
                this._layers[_local_4].createWindow();
                _local_4++;
            }
            this._Str_15567(this._badgeInitData);
            this._parentWindow.addChild(this._window);
        }

        public function _Str_15567(k:Array<ASAny>)
        {
            if (!this.isIntialized)
            {
                return;
            }
            if (this._partSelectContainer.visible)
            {
                this._partSelectContainer.visible = false;
                this._partEditContainer.visible = true;
            }
            this._badgeInitData = k;
            this._currentLayerOptions = null;
            this._partEditContainer.visible = true;
            this._partSelectContainer.visible = false;
            this._badgeSelectPartCtrl.loadData();
            var _local_2 = 0;
            while (_local_2 < this._layers.length)
            {
                this._layers[_local_2].setLayerOptions(this._Str_23257(_local_2));
                this._layers[_local_2].updateSelectedPart();
                _local_2++;
            }
        }

        function _Str_23257(k:Int):BadgeLayerOptions
        {
            var _local_2 = 0;
            var _local_3= ASCompat.dynamicAs(this._badgeInitData[k] , GuildBadgeSettings);
            var _local_4= new BadgeLayerOptions();
            _local_4._Str_3617 = k;
            _local_4.colorIndex = 0;
            _local_4._Str_25730(_local_3.position);
            _local_2 = 0;
            while (_local_2 < this._manager.guildEditorData._Str_9008.length)
            {
                if (this._manager.guildEditorData._Str_9008[_local_2].id == _local_3.colorId)
                {
                    _local_4.colorIndex = _local_2;
                    break;
                }
                _local_2++;
            }
            if (k == BadgeLayerCtrl._Str_5392)
            {
                _local_2 = 0;
                while (_local_2 < this._manager.guildEditorData._Str_11328.length)
                {
                    if (this._manager.guildEditorData._Str_11328[_local_2].id == _local_3.partId)
                    {
                        _local_4._Str_3324 = _local_2;
                        break;
                    }
                    _local_2++;
                }
            }
            else
            {
                _local_2 = 0;
                while (_local_2 < this._manager.guildEditorData._Str_12125.length)
                {
                    if (this._manager.guildEditorData._Str_12125[_local_2].id == _local_3.partId)
                    {
                        _local_4._Str_3324 = _local_2;
                        break;
                    }
                    _local_2++;
                }
            }
            return _local_4;
        }

        public function _Str_24085(k:BadgeSelectPartCtrl)
        {
            this._currentLayerOptions._Str_3324 = k._Str_21609();
            this._layers[this._currentLayerOptions._Str_3617].setLayerOptions(this._Str_21658);
            this._partEditContainer.visible = true;
            this._partSelectContainer.visible = false;
        }

        public function _Str_25349(k:BadgeSelectPartCtrl)
        {
            this._Str_3060(k.layerOptions);
        }

        public function _Str_23517(k:BadgeLayerCtrl)
        {
            this._Str_3060(k.layerOptions);
        }

        public function _Str_3060(k:BadgeLayerOptions)
        {
            var _local_2= this._badgeSelectPartCtrl._Str_21949(k);
            if (_local_2 != null)
            {
                this._badgePreviewImages[k._Str_3617].bitmap = _local_2.clone();
                this._badgePreviewImages[k._Str_3617].visible = true;
            }
            else
            {
                this._badgePreviewImages[k._Str_3617].visible = false;
            }
        }

        public function _Str_24453(k:BadgeLayerCtrl)
        {
            var _local_2= this._currentLayerOptions;
            this._currentLayerOptions = k.layerOptions.clone();
            if (!k.layerOptions._Str_23286(_local_2))
            {
                this._badgeSelectPartCtrl._Str_7044();
            }
            else
            {
                this._badgeSelectPartCtrl.layerOptions = this._currentLayerOptions.clone();
            }
            this._partEditContainer.visible = false;
            this._partSelectContainer.visible = true;
        }

        public function _Str_23176()
        {
            if ((this.isIntialized && this._partSelectContainer.visible))
            {
                this._Str_3060(this._currentLayerOptions);
                this._partEditContainer.visible = true;
                this._partSelectContainer.visible = false;
            }
        }

        public function getBadgeSettings():Array<ASAny>
        {
            var _local_2:BadgeLayerCtrl = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var k= new Array<ASAny>();
            final _iter_ = this._layers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = this._Str_19168(_local_2.layerOptions);
                if (_local_3 < 0)
                {
                }
                else
                {
                    _local_4 = this._Str_21488(_local_2.layerOptions);
                    if (_local_4 < 0)
                    {
                    }
                    else
                    {
                        k.push(_local_3);
                        k.push(_local_4);
                        k.push(_local_2.layerOptions.position);
                    }
                }
            }
            return k;
        }

        public var _Str_23897(get,never):Int;
public function  get__Str_23897():Int
        {
            var _local_2:BadgeLayerCtrl = null;
            if (this._layers == null)
            {
                return 0;
            }
            var k = 0;
            final _iter_ = this._layers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((this._Str_19168(_local_2.layerOptions) < 0) || (this._Str_21488(_local_2.layerOptions) < 0)))
                {
                }
                else
                {
                    k = _local_2.layerOptions.colorIndex;
                }
            }
            return k;
        }

        public var _Str_24812(get,never):Int;
public function  get__Str_24812():Int
        {
            if (this._layers != null)
            {
                return this._layers[0].layerOptions.colorIndex;
            }
            return 0;
        }

        public function _Str_23597():BitmapData
        {
            var _local_2:IBitmapWrapperWindow = null;
            var k= new BitmapData(Std.int(BadgeEditorPartItem._Str_6696), Std.int(BadgeEditorPartItem._Str_6533), true, 15329761);
            final _iter_ = this._badgePreviewImages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.visible)
                {
                    k.copyPixels(_local_2.bitmap, k.rect, new Point(), null, null, true);
                }
            }
            return k;
        }

        function _Str_19168(k:BadgeLayerOptions):Int
        {
            if (k._Str_3324 < 0)
            {
                return -1;
            }
            if (k._Str_3617 == BadgeLayerCtrl._Str_5392)
            {
                if (k._Str_3324 >= this._manager.guildEditorData._Str_11328.length)
                {
                    return -1;
                }
                return this._manager.guildEditorData._Str_11328[k._Str_3324].id;
            }
            if (k._Str_3324 >= this._manager.guildEditorData._Str_12125.length)
            {
                return -1;
            }
            return this._manager.guildEditorData._Str_12125[k._Str_3324].id;
        }

        function _Str_21488(k:BadgeLayerOptions):Int
        {
            if (((k.colorIndex < 0) || (k.colorIndex >= this._manager.guildEditorData._Str_9008.length)))
            {
                return -1;
            }
            return this._manager.guildEditorData._Str_9008[k.colorIndex].id;
        }
    }

