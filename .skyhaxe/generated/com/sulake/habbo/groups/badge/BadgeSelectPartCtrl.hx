package com.sulake.habbo.groups.badge
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.groups.HabboGroupsManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.users.BadgePartData;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BadgeSelectPartCtrl implements IDisposable 
    {
        var _manager:HabboGroupsManager;
        var _parentCtrl:BadgeEditorCtrl;
        var _badgeLayerParts:Vector<BadgeEditorPartItem>;
        var _badgeBaseParts:Vector<BadgeEditorPartItem>;
        var _layerOptions:BadgeLayerOptions;
        var _selectedItem:IWindowContainer;
        var _chosenItem:IBitmapWrapperWindow;
        var _disposed:Bool = false;

        public function new(k:HabboGroupsManager, _arg_2:BadgeEditorCtrl)
        {
            this._manager = k;
            this._parentCtrl = _arg_2;
        }

        
        public var layerOptions(get,set):BadgeLayerOptions;
public function  get_layerOptions():BadgeLayerOptions
        {
            return this._layerOptions;
        }
public function  set_layerOptions(k:BadgeLayerOptions):BadgeLayerOptions        {
            return this._layerOptions = k;
        }

        public function dispose()
        {
            var k:BadgeEditorPartItem = null;
            if (!this._disposed)
            {
                if (((!(this._parentCtrl._Str_5636 == null)) && (this._parentCtrl._Str_5636.numGridItems > 0)))
                {
                    this._parentCtrl._Str_5636.destroyGridItems();
                }
                if (this._badgeBaseParts != null)
                {
                    final _iter_ = this._badgeBaseParts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
k  = _tmp_;
                        k.dispose();
                    }
                    this._badgeBaseParts = null;
                }
                if (this._badgeLayerParts != null)
                {
                    final _iter_ = this._badgeLayerParts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
k  = _tmp_;
                        k.dispose();
                    }
                    this._badgeLayerParts = null;
                }
                this._layerOptions = null;
                this._chosenItem = null;
                this._selectedItem = null;
                this._parentCtrl = null;
                this._manager = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_21609():Int
        {
            var k= -1;
            if ((((!(this._layerOptions == null)) && (!(this._parentCtrl._Str_5636 == null))) && (!(this._selectedItem == null))))
            {
                k = this._parentCtrl._Str_5636.getGridItemIndex(this._selectedItem);
                if (((!(k == -1)) && (!(this._layerOptions._Str_3617 == BadgeLayerCtrl._Str_5392))))
                {
                    k--;
                }
            }
            return k;
        }

        public function loadData()
        {
            var k:BadgePartData = null;
            if (((!(this._badgeBaseParts == null)) || (!(this._badgeLayerParts == null))))
            {
                return;
            }
            this._badgeBaseParts = new Vector<BadgeEditorPartItem>();
            final _iter_ = this._manager.guildEditorData._Str_11328; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._badgeBaseParts.push(new BadgeEditorPartItem(this._manager, this, this._badgeBaseParts.length, BadgeEditorPartItem._Str_13754, k));
            }
            this._badgeLayerParts = new Vector<BadgeEditorPartItem>();
            this._badgeLayerParts.push(new BadgeEditorPartItem(this._manager, this, -1, BadgeEditorPartItem._Str_13419));
            final _iter_ = this._manager.guildEditorData._Str_12125; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._badgeLayerParts.push(new BadgeEditorPartItem(this._manager, this, (this._badgeLayerParts.length - 1), BadgeEditorPartItem._Str_13419, k));
            }
        }

        public function _Str_7044()
        {
            var k:BadgeEditorPartItem = null;
            this._selectedItem = null;
            this._chosenItem = null;
            this._layerOptions = this._parentCtrl._Str_21658.clone();
            this._parentCtrl._Str_5636.destroyGridItems();
            if (this._layerOptions._Str_3617 == BadgeLayerCtrl._Str_5392)
            {
                final _iter_ = this._badgeBaseParts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._parentCtrl._Str_5636.addGridItem(this._Str_7360(k));
                }
            }
            else
            {
                final _iter_ = this._badgeLayerParts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._parentCtrl._Str_5636.addGridItem(this._Str_7360(k));
                }
            }
        }

        function _Str_7360(k:BadgeEditorPartItem):IWindowContainer
        {
            var _local_2= Std.downcast(this._manager.getXmlWindow("badge_part_item") , IWindowContainer);
            _local_2.procedure = this._Str_23375;
            this._Str_17901(_local_2, k);
            return _local_2;
        }

        public function _Str_25511(k:BadgeEditorPartItem)
        {
            var _local_2:IWindowContainer = null;
            if ((((!(this._layerOptions == null)) && (this._layerOptions._Str_3617 == BadgeLayerCtrl._Str_5392)) && this._parentCtrl._Str_20634.visible))
            {
                _local_2 = Std.downcast(this._parentCtrl._Str_5636.getGridItemAt(k._Str_3324) , IWindowContainer);
                this._Str_17901(_local_2, k);
            }
        }

        public function _Str_22980(k:BadgeEditorPartItem)
        {
            var _local_2:IWindowContainer = null;
            if ((((!(this._layerOptions == null)) && (!(this._layerOptions._Str_3617 == BadgeLayerCtrl._Str_5392))) && this._parentCtrl._Str_20634.visible))
            {
                _local_2 = Std.downcast(this._parentCtrl._Str_5636.getGridItemAt((k._Str_3324 + 1)) , IWindowContainer);
                this._Str_17901(_local_2, k);
            }
        }

        function _Str_17901(k:IWindowContainer, _arg_2:BadgeEditorPartItem)
        {
            var _local_5:IBitmapWrapperWindow = null;
            var _local_3= _arg_2.getComposite(this._layerOptions);
            if (_local_3 != null)
            {
                _local_5 = Std.downcast(k.findChildByName("part") , IBitmapWrapperWindow);
                _local_5.bitmap = new BitmapData(_local_3.width, _local_3.height);
                _local_5.bitmap.copyPixels(_local_3, _local_3.rect, new Point());
            }
            var _local_4= Std.downcast(k.findChildByName("selected") , IBitmapWrapperWindow);
            _local_4.bitmap = this._manager.getButtonImage("badge_part_picker");
            if (_arg_2._Str_3324 == this._layerOptions._Str_3324)
            {
                _local_4.visible = true;
                this._chosenItem = _local_4;
            }
            else
            {
                _local_4.visible = false;
            }
        }

        function _Str_23375(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IBorderWindow = null;
            var _local_4:IWindowContainer = null;
            if (k.type == WindowMouseEvent.OVER)
            {
                if ((this._selectedItem : ASAny) != (_arg_2 : ASAny))
                {
                    if (this._selectedItem != null)
                    {
                        _local_3 = Std.downcast(this._selectedItem.findChildByName("background") , IBorderWindow);
                        if (_local_3 != null)
                        {
                            _local_3.color = 15329761;
                        }
                    }
                    this._selectedItem = Std.downcast(_arg_2 , IWindowContainer);
                    if (this._selectedItem != null)
                    {
                        _local_3 = Std.downcast(this._selectedItem.findChildByName("background") , IBorderWindow);
                        if (_local_3 != null)
                        {
                            _local_3.color = 14210761;
                        }
                        this._layerOptions._Str_3324 = this._Str_21609();
                        this._parentCtrl._Str_25349(this);
                    }
                }
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (this._chosenItem != null)
                {
                    this._chosenItem.visible = false;
                }
                _local_4 = Std.downcast(_arg_2 , IWindowContainer);
                if (_local_4 != null)
                {
                    this._chosenItem = Std.downcast(_local_4.findChildByName("selected") , IBitmapWrapperWindow);
                    this._chosenItem.visible = true;
                }
                this._parentCtrl._Str_24085(this);
            }
        }

        public function _Str_21949(k:BadgeLayerOptions):BitmapData
        {
            if (((k == null) || (k._Str_3324 < 0)))
            {
                return null;
            }
            if (k._Str_3617 == BadgeLayerCtrl._Str_5392)
            {
                if (((!(this._badgeBaseParts == null)) && (k._Str_3324 < this._badgeBaseParts.length)))
                {
                    return this._badgeBaseParts[k._Str_3324].getComposite(k);
                }
            }
            else
            {
                if (((!(this._badgeLayerParts == null)) && ((k._Str_3324 + 1) < this._badgeLayerParts.length)))
                {
                    return this._badgeLayerParts[(k._Str_3324 + 1)].getComposite(k);
                }
            }
            return null;
        }
    }

