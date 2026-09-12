package com.sulake.habbo.navigator.context
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SavedSearch;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.TopLevelContext;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorMetaDataParser;

     class ContextContainer 
    {
        var _navigator:HabboNewNavigator;
        var _topLevelSearchesQuicklinks:Map;
        var _savedSearches:Vector<SavedSearch>;

        public function new(k:HabboNewNavigator)
        {
            this._savedSearches = new Vector<SavedSearch>();
            this._navigator = k;
        }

        public function _Str_23059(k:String):Bool
        {
            if (this._topLevelSearchesQuicklinks == null)
            {
                return false;
            }
            return this._topLevelSearchesQuicklinks.hasKey(k);
        }

        public function initialize(k:NavigatorMetaDataParser)
        {
            var _local_2:TopLevelContext = null;
            this._topLevelSearchesQuicklinks = new Map();
            final _iter_ = k._Str_23833; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._topLevelSearchesQuicklinks.add(_local_2.searchCode, _local_2._Str_21438);
            }
        }

        public function _Str_9965():Array<ASAny>
        {
            return this._topLevelSearchesQuicklinks.getKeys();
        }

        
        public var _Str_8597(get,set):Vector<SavedSearch>;
public function  get__Str_8597():Vector<SavedSearch>
        {
            return this._savedSearches;
        }
public function  set__Str_8597(k:Vector<SavedSearch>):Vector<SavedSearch>        {
            return this._savedSearches = k;
        }

        public function isReady():Bool
        {
            return !(this._topLevelSearchesQuicklinks == null);
        }
    }

