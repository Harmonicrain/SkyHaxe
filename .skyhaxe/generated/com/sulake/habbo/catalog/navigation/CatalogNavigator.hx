package com.sulake.habbo.catalog.navigation
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.TopViewSelector;
    import com.sulake.habbo.communication.messages.incoming.catalog.NodeData;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.catalog.navigation.events.CatalogPageOpenedEvent;
    import com.sulake.habbo.catalog.event.CatalogEvent;

     class CatalogNavigator implements ICatalogNavigator 
    {
        public static inline final DUMMY_PAGE_ID_FOR_OFFER_SEARCH= -12345678;

        var _catalog:HabboCatalog;
        var _container:IWindowContainer;
        var _catalogType:String;
        var _tabs:ITabContextWindow;
        var _list:IItemListWindow;
        var _index:ICatalogNode;
        var _currentNodes:Vector<ICatalogNode>;
        var _offersToNodes:ASDictionary<ASAny,ASAny>;
        var _topItemTemplate:IWindow;
        var _subItemTemplate:IWindow;
        var _listTemplate:IWindow;
        var _topViewSelector:TopViewSelector;

        public function new(k:HabboCatalog, _arg_2:IWindowContainer, _arg_3:String)
        {
            this._catalog = k;
            this._container = _arg_2;
            this._catalogType = _arg_3;
            this._currentNodes = new Vector<ICatalogNode>(0);
            this._list = Std.downcast(this._container.findChildByName("navigationList") , IItemListWindow);
            this._topItemTemplate = this._list.removeListItem(this._list.getListItemByName((_arg_3.toLowerCase() + "_topitem_template")));
            this._subItemTemplate = this._list.removeListItem(this._list.getListItemByName((_arg_3.toLowerCase() + "_subitem_template")));
            this._listTemplate = this._list.removeListItem(this._list.getListItemByName((_arg_3.toLowerCase() + "_list_template")));
            this._tabs = cast(this._container.findChildByName("tab_context"), ITabContextWindow);
            if (this._tabs != null)
            {
                if (this._catalog.useNonTabbedCatalog())
                {
                    this._tabs.visible = false;
                }
                else
                {
                    this._topViewSelector = new TopViewSelector(this, this._tabs);
                }
            }
        }

        static function _Str_12923(searchTerm:String, potentialPageMatches:Array<ASAny>, node:ICatalogNode, nodes:Vector<ICatalogNode>)
        {
            var child:ICatalogNode = null;
            var nodeAdded = false;
            var hayStack:String = null;
            var furnitureLine:String = null;
            try
            {
                if ((node.visible && (node.pageId > 0)))
                {
                    nodeAdded = false;
                    hayStack = ([node.pageName, node.localization] : Array<Dynamic>).join(" ").toLowerCase();
                    hayStack = new compat.RegExp(" ", "gi").replace(hayStack, "");
                    if (hayStack.indexOf(searchTerm) > -1)
                    {
                        nodes.push(node);
                        nodeAdded = true;
                    }
                    if (!nodeAdded)
                    {
                        if (checkNullIteratee(potentialPageMatches)) for (_tmp_ in potentialPageMatches)
                        {
furnitureLine  = _tmp_;
                            if (hayStack.indexOf(furnitureLine) >= 0)
                            {
                                nodes.push(node);
                                break;
                            }
                        }
                    }
                }
                final _iter_ = node.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
child  = _tmp_;
                    _Str_12923(searchTerm, potentialPageMatches, child, nodes);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([(("Error when loading nodes by name " + searchTerm) + ":"), e]);
            }
 }        }


        public var initialized(get,never):Bool;
public function  get_initialized():Bool
        {
            return !(this._index == null);
        }

        public function dispose()
        {
            if (this._index != null)
            {
                this._index.dispose();
            }
            this._index = null;
            this._offersToNodes = null;
            this._currentNodes = null;
            this._catalog = null;
            this._container = null;
            this._list = null;
        }

        public function buildCatalogIndex(k:NodeData)
        {
            this._index = null;
            this._offersToNodes = new ASDictionary<ASAny,ASAny>();
            this._index = this._Str_20450(k, 0, null);
        }

        public function showIndex()
        {
            var k:ICatalogNode = null;
            if (this._index == null)
            {
                return;
            }
            this._list.removeListItems();
            if (this._topViewSelector != null)
            {
                this._topViewSelector._Str_17441();
            }
            final _iter_ = this._index.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.visible)
                {
                    if (this._catalog.useNonTabbedCatalog())
                    {
                        Std.downcast(k , CatalogNodeRenderable)._Str_11512(this._list);
                    }
                    else
                    {
                        this._topViewSelector._Str_5377(k);
                    }
                }
            }
            if (this._topViewSelector != null)
            {
                this._topViewSelector._Str_12925(0);
            }
        }

        public function _Str_20996(k:ICatalogNode)
        {
            var _local_2:ICatalogNode = null;
            if (this._index == null)
            {
                return;
            }
            this._list.removeListItems();
            if (((k == null) || (!k.visible)))
            {
                return;
            }
            if (k.children.length != 0)
            {
                final _iter_ = k.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.visible)
                    {
                        Std.downcast(_local_2 , CatalogNodeRenderable)._Str_11512(this._list);
                    }
                }
                this.activateNode(k.children[0]);
            }
            else
            {
                this.openCatalogPage(k);
            }
        }

        function _Str_25171(k:ICatalogNode):ICatalogNode
        {
            var _local_3 = 0;
            var _local_2= k.parent;
            while ((((!(_local_2 == null)) && (!(_local_2.parent == null))) && (!(_local_2.parent.pageName == "root"))))
            {
                _local_2 = _local_2.parent;
            }
            if (((this._topViewSelector != null) && (_local_2.parent != null)))
            {
                _local_3 = _local_2.parent.children.indexOf(_local_2);
                this._topViewSelector._Str_12925(_local_3);
            }
            this._Str_20996(_local_2);
            return _local_2;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public function activateNode(k:ICatalogNode)
        {
            var _local_5:ICatalogNode = null;
            var _local_6 = Math.NaN;
            var _local_7 = Math.NaN;
            var _local_8 = 0;
            var _local_2:ASAny = (this._currentNodes.indexOf(k) >= 0);
            var _local_3= k.isOpen;
            var _local_4= new Vector<ICatalogNode>(0);
            final _iter_ = this._currentNodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_5.deactivate();
                if (_local_5.depth < k.depth)
                {
                    _local_4.push(_local_5);
                }
                else
                {
                    _local_5.close();
                }
            }
            this._currentNodes = _local_4;
            k.activate();
            if ((ASCompat.toBool(_local_2) && _local_3))
            {
                k.close();
            }
            else
            {
                k.open();
            }
            if (this._currentNodes.indexOf(k) < 0)
            {
                this._currentNodes.push(k);
            }
            if (k.isBranch)
            {
                if (((k.parent != null) && Std.is(k.parent , CatalogNodeRenderable)))
                {
                    Std.downcast(k.parent , CatalogNodeRenderable)._Str_21669();
                }
                _local_6 = 0;
                _local_7 = 0;
                _local_8 = 0;
                while (_local_8 < this._list.numListItems)
                {
                    if (this._list.getListItemAt(_local_8).visible)
                    {
                        _local_7 = (_local_7 + this._list.getListItemAt(_local_8).height);
                    }
                    _local_8++;
                }
                final _iter_ = this._currentNodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    _local_6 = (_local_6 + k.offsetV);
                }
                if ((_local_6 - this._list.height) > 0)
                {
                    this._list.scrollV = (_local_6 / _local_7);
                }
            }
            if (k.pageId > -1)
            {
                this.openCatalogPage(k);
            }
        }

        function openCatalogPage(k:ICatalogNode)
        {
            this._catalog.loadCatalogPage(k.pageId, -1, this._catalogType);
            this._catalog.events.dispatchEvent(new CatalogPageOpenedEvent(k.pageId, k.localization));
        }

        public function openPage(k:String)
        {
            var _local_2= this.getNodeByName(k);
            if (((!(_local_2 == null)) && _local_2.visible))
            {
                this._catalog.loadCatalogPage(_local_2.pageId, -1, this._catalogType);
                this.openNavigatorAtNode(_local_2);
            }
            else
            {
                if (((!(_local_2 == null)) && (!_local_2.visible)))
                {
                    this._catalog.events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_INVISIBLE_PAGE_VISITED));
                }
                this.loadFrontPage();
            }
        }

        public function openPageById(k:Int, _arg_2:Int)
        {
            var _local_3:ICatalogNode = null;
            var _local_4:Vector<ICatalogNode> = null;
            if (!this.initialized)
            {
                this._catalog.openCatalogPageById(k, _arg_2, this._catalogType);
            }
            else
            {
                if (k == DUMMY_PAGE_ID_FOR_OFFER_SEARCH)
                {
                    _local_4 = this.getNodesByOfferId(_arg_2, true);
                    if (_local_4 != null)
                    {
                        _local_3 = _local_4[0];
                    }
                }
                else
                {
                    _local_3 = this.getNodeById(k);
                }
                if (_local_3 != null)
                {
                    this._catalog.loadCatalogPage(_local_3.pageId, _arg_2, this._catalogType);
                    this.openNavigatorAtNode(_local_3);
                }
            }
        }

        public function openPageByOfferId(k:Int)
        {
            var _local_2:Vector<ICatalogNode> = null;
            var _local_3:ICatalogNode = null;
            if (!this.initialized)
            {
                this._catalog.openCatalogPageById(DUMMY_PAGE_ID_FOR_OFFER_SEARCH, k, this._catalogType);
            }
            else
            {
                _local_2 = this.getNodesByOfferId(k);
                if (_local_2 != null)
                {
                    _local_3 = _local_2[0];
                    this._catalog.loadCatalogPage(_local_3.pageId, k, this._catalogType);
                    this.openNavigatorAtNode(_local_3);
                }
            }
        }

        public function deactivateCurrentNode()
        {
            var k:ICatalogNode = null;
            final _iter_ = this._currentNodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.deactivate();
                k.close();
            }
            this._currentNodes = new Vector<ICatalogNode>(0);
        }

        public function filter(k:String, _arg_2:Array<ASAny>)
        {
            var _local_4:ICatalogNode = null;
            var _local_3= new Vector<ICatalogNode>(0);
            _Str_12923(k, _arg_2, this._index, _local_3);
            this._list.removeListItems();
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_4  = _tmp_;
                Logger.log([("Found node: " + ASCompat.toString([_local_4.pageId, _local_4.pageName, _local_4.localization]))]);
                if (_local_4.visible)
                {
                    Std.downcast(_local_4 , CatalogNodeRenderable)._Str_11512(this._list);
                }
            }
        }

        function openNavigatorAtNode(k:ICatalogNode)
        {
            if (k == null)
            {
                return;
            }
            this.deactivateCurrentNode();
            var _local_2= k.parent;
            while (((!(_local_2 == null)) && (!(_local_2.parent == null))))
            {
                _local_2.open();
                if (this._catalog.useNonTabbedCatalog())
                {
                    this._currentNodes.push(_local_2);
                }
                _local_2 = _local_2.parent;
            }
            if (!this._catalog.useNonTabbedCatalog())
            {
                this._Str_25171(k);
            }
            this.activateNode(k);
        }

        public function loadFrontPage()
        {
            if (this._index == null)
            {
                return;
            }
            var k= this.getFirstNavigable(this._index);
            if (k == null)
            {
                return;
            }
            Logger.log([(((("Load front page: " + k.localization) + "(") + Std.string(k.pageId)) + ")")]);
            this._catalog.loadCatalogPage(k.pageId, -1, this._catalogType);
        }

        function getFirstNavigable(k:ICatalogNode):ICatalogNode
        {
            var _local_2:ICatalogNode = null;
            var _local_3:ICatalogNode = null;
            if ((k.visible && (!(k == this._index))))
            {
                return k;
            }
            final _iter_ = k.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = this.getFirstNavigable(_local_2);
                if (_local_3 != null)
                {
                    return _local_3;
                }
            }
            return null;
        }

        function _Str_20450(k:NodeData, _arg_2:Int, _arg_3:ICatalogNode):ICatalogNode
        {
            var _local_5:ICatalogNode = null;
            var _local_6 = 0;
            var _local_7:NodeData = null;
            var _local_4= k.visible;
            if (!_local_4)
            {
                _local_5 = new CatalogNode(this, k, _arg_2, _arg_3);
            }
            else
            {
                _local_5 = new CatalogNodeRenderable(this, k, _arg_2, _arg_3);
            }
            final _iter_ = _local_5.offerIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                if (this._offersToNodes.exists(_local_6 ))
                {
                    this._offersToNodes[_local_6].push(_local_5);
                }
                else
                {
                    this._offersToNodes[_local_6] = Vector.ofArray([_local_5]);
                }
            }
            _arg_2++;
            final _iter_ = k.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_7  = _tmp_;
                _local_5.addChild(this._Str_20450(_local_7, _arg_2, _local_5));
            }
            return _local_5;
        }

        public function getNodesByOfferId(k:Int, _arg_2:Bool=false):Vector<ICatalogNode>
        {
            var _local_3:Vector<ICatalogNode> = null;
            var _local_4:ICatalogNode = null;
            if (this._offersToNodes != null)
            {
                if (_arg_2)
                {
                    _local_3 = new Vector<ICatalogNode>(0);
                    final _iter_:ASAny = this._offersToNodes[k]; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_4  = _tmp_;
                        if (_local_4.visible)
                        {
                            _local_3.push(_local_4);
                        }
                    }
                    if (_local_3.length > 0)
                    {
                        return _local_3;
                    }
                    return null;
                }
                return this._offersToNodes[k];
            }
            return null;
        }

        public function getNodeByName(k:String):ICatalogNode
        {
            return (this._index != null) ? this._Str_16317(k, this._index) : null;
        }

        public function getOptionalNodeByName(k:String):ICatalogNode
        {
            return (this._index != null) ? this._Str_16317(k, this._index) : null;
        }

        public function getNodeById(k:Int, _arg_2:ICatalogNode=null):ICatalogNode
        {
            var _local_4:ICatalogNode = null;
            if (_arg_2 == null)
            {
                _arg_2 = this._index;
            }
            if (!(!(_arg_2 == null)))
            {
                return null;
            }
            var _local_3:ICatalogNode = null;
            if (((_arg_2.pageId == k) && (!(_arg_2 == this._index))))
            {
                _local_3 = _arg_2;
            }
            else
            {
                final _iter_ = _arg_2.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    _local_3 = this.getNodeById(k, _local_4);
                    if (_local_3 != null)
                    {
                        break;
                    }
                }
            }
            return _local_3;
        }

        function _Str_16317(pageName:String, node:ICatalogNode):ICatalogNode
        {
            var child:ICatalogNode = null;
            var found:ICatalogNode = null;
            try
            {
                if (((node.pageName == pageName) && (!(node == this._index))))
                {
                    found = node;
                }
                else
                {
                    final _iter_ = node.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
child  = _tmp_;
                        found = this._Str_16317(pageName, child);
                        if (found != null)
                        {
                            break;
                        }
                    }
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([(("Error when loading node by name " + pageName) + ":"), e]);
            }
 }            return found;
        }

        public var listTemplate(get,never):IWindow;
public function  get_listTemplate():IWindow
        {
            return this._listTemplate;
        }

        public var isDeepHierarchy(get,never):Bool;
public function  get_isDeepHierarchy():Bool
        {
            return this._catalog .getBoolean("catalog.deep.hierarchy");
        }

        public function getItemTemplate(k:Int):IWindow
        {
            if (this.isDeepHierarchy)
            {
                return (k > 2) ? this._subItemTemplate : this._topItemTemplate;
            }
            return (k == 1) ? this._topItemTemplate : this._subItemTemplate;
        }
    }

