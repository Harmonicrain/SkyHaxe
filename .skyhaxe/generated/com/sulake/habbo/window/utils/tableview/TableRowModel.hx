package com.sulake.habbo.window.utils.tableview
;
    import com.sulake.core.runtime.IDisposable;

     class TableRowModel implements IDisposable
    {
        var _disposed:Bool = false;
        var _object:ITableObject;
        var _index:Int = 0;
        var _selected:Bool = false;
        var _hovered:Bool = false;
        var _hasFocus:Bool = false;
        var _view:TableRowView;

        public function new(obj:ITableObject, index:Int)
        {
            this._object = obj;
            this._index = index;
        }

        public var index(never,set):Int;
public function  set_index(value:Int):Int        {
            this._index = value;
            if (this._view != null)
            {
                this._view.indexUpdated();
            }
return value;
        }

        public function update(obj:ITableObject)
        {
            if (!obj.isUpdated(this._object))
            {
                this._object = obj;
                return;
            }
            var previous= this._object;
            this._object = obj;
            if (this._view != null)
            {
                this._view.objectUpdated(previous, obj);
            }
        }

        
        public var hasFocus(get,set):Bool;
public function  set_hasFocus(value:Bool):Bool        {
            return this._hasFocus = value;
        }

        
        public var selected(get,set):Bool;
public function  set_selected(value:Bool):Bool        {
            this._selected = value;
            if (this._view != null)
            {
                this._view.selectedUpdated();
            }
return value;
        }

        
        public var hovered(get,set):Bool;
public function  set_hovered(value:Bool):Bool        {
            this._hovered = value;
            if (this._view != null)
            {
                this._view.hoveredUpdated();
            }
return value;
        }

        
        public var view(get,set):TableRowView;
public function  set_view(value:TableRowView):TableRowView        {
            return this._view = value;
        }

        public var object(get,never):ITableObject;
public function  get_object():ITableObject
        {
            return this._object;
        }

        public var i(get,never):Int;
public function  get_i():Int
        {
            return this._index;
        }
public function  get_selected():Bool
        {
            return this._selected;
        }
public function  get_hovered():Bool
        {
            return this._hovered;
        }
public function  get_hasFocus():Bool
        {
            return this._hasFocus;
        }
public function  get_view():TableRowView
        {
            return this._view;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._object = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

