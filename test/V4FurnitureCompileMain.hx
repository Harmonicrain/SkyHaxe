/** Compile-only root for the generated floor-furniture, wall-item and user message path.
 *
 *  These are the parsers V4 needs to place objects in a room. They convert through the general
 *  ax3 pipeline rather than the bespoke IMessageParser generator, which rejects them: their
 *  shape is a delegated per-element struct build, not a straight-line field read.
 */
class V4FurnitureCompileMain {
    static var objects:com.sulake.habbo.communication.messages.parser.room.engine.ObjectsMessageParser;
    static var objectData:com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataParser;
    static var objectAdd:com.sulake.habbo.communication.messages.parser.room.engine.ObjectAddMessageParser;
    static var items:com.sulake.habbo.communication.messages.parser.room.engine.ItemsMessageParser;
    static var itemAdd:com.sulake.habbo.communication.messages.parser.room.engine.ItemAddMessageParser;
    static var users:com.sulake.habbo.communication.messages.parser.room.engine.UsersMessageParser;
    static var objectMessage:com.sulake.habbo.communication.messages.incoming.room.engine.ObjectMessageData;

    public static function main():Void {}
}
