package com.sulake.habbo.navigator.mainview
;
    import com.sulake.habbo.navigator.IViewCtrl;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.navigator.TagRenderer;
    import com.sulake.habbo.communication.messages.incoming.navigator.PopularTagData;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.*;
    import com.sulake.core.window.components.*;
    import com.sulake.core.window.events.*;
    import com.sulake.core.window._enum.*;
    import com.sulake.habbo.navigator.*;

     class PopularTagsListCtrl implements IViewCtrl 
    {
        var _navigator:HabboNavigator;
        var _content:IWindowContainer;
        var _list:IItemListWindow;
        var _rowHeight:Int = 0;
        var _tagRenderer:TagRenderer;

        public function new(k:HabboNavigator)        {
            this._navigator = k;
            this._tagRenderer = new TagRenderer(this._navigator);
        }

        public function dispose()
        {
            if (this._tagRenderer != null)
            {
                this._tagRenderer.dispose();
                this._tagRenderer = null;
            }
        }

        
        public var content(get,set):IWindowContainer;
public function  set_content(k:IWindowContainer):IWindowContainer        {
            this._content = k;
            this._list = ((this._content != null) ? cast(this._content.findChildByName("item_list"), IItemListWindow) : null);
return k;
        }
public function  get_content():IWindowContainer
        {
            return this._content;
        }

        public function refresh()
        {
            var _local_4:PopularTagData = null;
            this._tagRenderer._Str_8651 = true;
            var k= this._navigator.data._Str_6697.tags;
            var _local_2= cast(this._list.getListItemAt(0), IWindowContainer);
            if (_local_2 == null)
            {
                _local_2 = cast(this._navigator.getXmlWindow("grs_popular_tag_row"), IWindowContainer);
                this._list.addListItem(_local_2);
            }
            Util.hideChildren(_local_2);
            var _local_3 = 0;
            while (_local_3 < this._navigator.data._Str_6697.tags.length)
            {
                _local_4 = this._navigator.data._Str_6697.tags[_local_3];
                this._tagRenderer._Str_22102(_local_2, _local_3, _local_4.tagName);
                _local_3++;
            }
            Util._Str_7173(_local_2, _local_2.width, 18, 3);
            _local_2.height = Util.getLowestPoint(_local_2);
            this._content.findChildByName("no_tags_found").visible = (k.length < 1);
        }

        function _Str_26120(k:IWindowContainer, _arg_2:PopularTagData)
        {
            var _local_3= "txt";
            var _local_4= cast(k.findChildByName(_local_3), ITextWindow);
            if (_arg_2 == null)
            {
                return;
            }
            _local_4.visible = true;
            _local_4.text = _arg_2.tagName;
        }
    }


