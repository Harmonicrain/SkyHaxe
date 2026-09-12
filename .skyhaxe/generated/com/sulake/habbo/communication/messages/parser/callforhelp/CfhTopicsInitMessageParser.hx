package com.sulake.habbo.communication.messages.parser.callforhelp
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CfhTopicsInitMessageParser implements IMessageParser 
    {
        var _callForHelpCategories:Vector<CallForHelpCategoryData>;
        var _disposed:Bool = false;


        public function flush():Bool
        {
            var k:CallForHelpCategoryData = null;
            if (this._disposed)
            {
                return true;
            }
            this._disposed = true;
            final _iter_ = this._callForHelpCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._callForHelpCategories = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._callForHelpCategories = new Vector<CallForHelpCategoryData>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._callForHelpCategories.push(new CallForHelpCategoryData(k));
                _local_3++;
            }
            return true;
        }

        public var callForHelpCategories(get,never):Vector<CallForHelpCategoryData>;
public function  get_callForHelpCategories():Vector<CallForHelpCategoryData>
        {
            return this._callForHelpCategories;
        }

	public function new() {}
    }

