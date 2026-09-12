package com.sulake.core.communication.wireformat
;
    import flash.utils.ByteArray;
    import com.sulake.core.communication.util.Byte;
    import com.sulake.core.communication.util.Long;
    import com.sulake.core.communication.util.Short;
    import com.sulake.core.communication.encryption.IEncryption;
    import com.sulake.core.communication.connection.IConnection;

     final class EvaWireFormat implements IWireFormat 
    {
        static final MAX_DATA:UInt = (128 * 0x0400);//131072
		
        public function dispose()
        {
        }

        public function encode(header:Int, messageBuffer:Array<ASAny>):com.sulake.core.utils.ByteArray
        {
var value:ASObject  = null, appendingBuffer:com.sulake.core.utils.ByteArray  = null;            var buffer= new com.sulake.core.utils.ByteArray();
            buffer.writeInt(0);
            buffer.writeShort(header);
            if (checkNullIteratee(messageBuffer)) for (_tmp_ in messageBuffer)
            {
value = _tmp_;
                if (Std.is(value , String))
                {
                    buffer.writeUTF(ASCompat.asString(value ));
                }
                else
                {
                    if (Std.is(value , Int))
                    {
                        buffer.writeInt(ASCompat.asInt(value ));
                    }
                    else
                    {
                        if (Std.is(value , Bool))
                        {
                            buffer.writeBoolean(ASCompat.asBoolean(value ));
                        }
                        else
                        {
                            if (Std.is(value , Byte))
                            {
                                buffer.writeByte(ASCompat.dynamicAs(value , Byte).value);
                            }
                            else if (Std.is(value , Short))
                            {
                                buffer.writeShort(ASCompat.dynamicAs(value , Short).value);
                            }
                            else if (Std.is(value , Long))
                            {
                                buffer.writeInt(ASCompat.dynamicAs(value , Long).high);
                                buffer.writeUnsignedInt(ASCompat.dynamicAs(value , Long).low);
                            }
                            else
                            {
                                if (ASCompat.isByteArray(value ))
                                {
appendingBuffer= ASCompat.asByteArray(value );
                                    buffer.writeInt(ASCompat.toInt(appendingBuffer.length));
ASCompat.byteArrayWriteBytes(                                    buffer, appendingBuffer);
                                }
                            }
                        }
                    }
                }
            }
            var length= buffer.length;
            buffer.position = 0;
            buffer.writeInt(ASCompat.toInt(length - 4));
            buffer.position = length;
            return buffer;
        }

        public function decode(buffer:com.sulake.core.utils.ByteArray, socket:IConnection):Array<ASAny>
        {
var decipherLength:com.sulake.core.utils.ByteArray  = null, output:com.sulake.core.utils.ByteArray  = null, content:com.sulake.core.utils.ByteArray  = null;            var readerIndex:UInt = 0;
            var messageLength:UInt = 0;
            var encryption:IEncryption = null;
            var header = 0;
            var messageLengthBuffer:com.sulake.core.utils.ByteArray = null;
            var dataWrapper= new Array<ASAny>();
            while (true)
            {
                if (buffer.bytesAvailable < 6)
                {
                    return dataWrapper;
                }
                readerIndex = buffer.position;
                messageLength = 0;
                encryption = socket.getServerToClientEncryption();
                if (encryption != null)
                {	
                    encryption.mark();
                    messageLengthBuffer = new com.sulake.core.utils.ByteArray();
                    messageLengthBuffer.writeByte(buffer.readByte());
                    messageLengthBuffer.writeByte(buffer.readByte());
                    messageLengthBuffer.writeByte(buffer.readByte());
                    messageLengthBuffer.writeByte(buffer.readByte());
decipherLength= encryption.decipher(messageLengthBuffer);
                    messageLength = (((((0xFF & ASCompat.toInt(decipherLength[0])) << 24) | 
									   ((0xFF & ASCompat.toInt(decipherLength[1])) << 16)) | 
									   ((0xFF & ASCompat.toInt(decipherLength[2])) << 8))  | 
									   (0xFF & ASCompat.toInt(decipherLength[3])));
                }
                else
                {
                    messageLength = buffer.readInt();
                }

                if (messageLength < 2)// || (messageLength > MAX_DATA)))
                {
                    return null;//throw (new Error(("Invalid message length " + messageLength)));
                }
                
                if (buffer.bytesAvailable < messageLength)
                {
                    buffer.position = readerIndex;
                    if (encryption != null)
                    {
                        encryption.reset();
                    }
                    return dataWrapper;
                }
output= new com.sulake.core.utils.ByteArray();
                if (encryption != null)
                {
content= new com.sulake.core.utils.ByteArray();
ASCompat.byteArrayWriteBytes(                    content, buffer, buffer.position, messageLength);
ASCompat.byteArrayWriteBytes(                    output, encryption.decipher(content), 0, messageLength);
                    output.position = 0;
                }
                else
                {
ASCompat.byteArrayWriteBytes(                    output, buffer, buffer.position, messageLength);
                    output.position = 0;
                }
                buffer.position = (buffer.position + messageLength);
                header = output.readShort();
                dataWrapper.push(new EvaMessageDataWrapper(header, output));
            }
            return null; //dead code
        }
public function new(){}
    }

