package com.sulake.core.communication.messages
;
    import com.sulake.core.utils.ClassUtils;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     class MessageClassManager 
    {
        var _messageIdByComposerClass:ASDictionary<ASAny,ASAny>;
        var _messageIdByEventClass:ASDictionary<ASAny,ASAny>;
        var _messageInstancesById:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._messageIdByComposerClass = new ASDictionary<ASAny,ASAny>();
            this._messageIdByEventClass = new ASDictionary<ASAny,ASAny>();
            this._messageInstancesById = new ASDictionary<ASAny,ASAny>();
        }

        public function dispose()
        {
var key:ASObject  = null, messageEvent:IMessageEvent  = null;            if (this._messageInstancesById != null)
            {
                final _iter_ = this._messageInstancesById; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
key = _tmp_;
messageEvent= this._messageInstancesById[key];
                    if (messageEvent != null)
                    {
                        messageEvent.dispose();
                    }
                }
            }
        }

        public function registerMessages(messageConfiguration:IMessageConfiguration)
        {
var name:String  = null;            final _iter_ = messageConfiguration.events; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getKeys())
            {
name = _tmp_;
                this.registerMessageEventClass(ASCompat.parseInt(name), messageConfiguration.events.getValue(name));
            }
            final _iter_ = messageConfiguration.composers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getKeys())
            {
name = _tmp_;
                this.registerMessageComposerClass(ASCompat.parseInt(name), messageConfiguration.composers.getValue(name));
            }
        }

        function registerMessageComposerClass(messageID:Int, composerClass:Class<Dynamic>)
        {
            if (!ClassUtils.implementsInterface(composerClass, IMessageComposer))
            {
                throw new ASError(("Invalid composer class for message ID " + Std.string(messageID)));
            }
            var _local_3= getQualifiedClassName(composerClass);
            if (this._messageIdByComposerClass[_local_3] != null)
            {
                throw new ASError(("Duplicate message ID definition for composer class " + _local_3));
            }
            this._messageIdByComposerClass[_local_3] = messageID;
        }

        function registerMessageEventClass(messageId:Int, eventClass:Class<Dynamic>)
        {
            if (!ClassUtils.implementsInterface(eventClass, IMessageEvent))
            {
                throw new ASError(("Invalid event class for message ID " + Std.string(messageId)));
            }
            var className= getQualifiedClassName(eventClass);
            if (this._messageIdByEventClass[className] != null)
            {
                throw new ASError(("Duplicate message ID definition for event class " + className));
            }
            this._messageIdByEventClass[className] = messageId;
        }

        public function registerMessageEvent(event:IMessageEvent)
        {
            var className= getQualifiedClassName(event);
            var messageEvent:ASObject = this._messageIdByEventClass[className];
            if (messageEvent == null)
            {
                throw new ASError(("Unknown message event class " + className));
            }
            var parser:Array<ASAny> = this._messageInstancesById[messageEvent];
            if (parser != null)
            {
                event.parser = ASCompat.dynamicAs(parser[0] , IMessageEvent).parser;
            }
            else
            {
                parser = new Array<ASAny>();
                this._messageInstancesById[messageEvent] = parser;
                event.parser = Type.createInstance(event.parserClass, []);
            }
            parser.push(event);
        }

        public function unregisterMessageEvent(event:IMessageEvent)
        {
            var className= getQualifiedClassName(event);
            var eventClass:ASObject = this._messageIdByEventClass[className];
            if (eventClass == null)
            {
                return;
            }
            var instances:Array<ASAny> = this._messageInstancesById[eventClass];
            if (instances == null)
            {
                return;
            }
            var index= instances.indexOf(event);
            if (index >= 0)
            {
                instances.splice(index, 1);
                if (instances.length == 0)
                {
                    this._messageInstancesById.remove(eventClass);
                }
            }
        }

        public function getMessageIDForComposer(composer:IMessageComposer):Int
        {
            var composerClass:ASObject = this._messageIdByComposerClass[getQualifiedClassName(composer)];
            if (composerClass == null)
            {
				Habbo.trackLoginStep("No out going packet found for: " + getQualifiedClassName(composer));
                return -1;
            }
            return ASCompat.toInt(composerClass);
        }

        public function getMessageEventsForID(id:Int):Array<ASAny>
        {
            return this._messageInstancesById[id];
        }
    }

