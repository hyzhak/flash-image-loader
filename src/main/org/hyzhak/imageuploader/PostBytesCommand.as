/**
 * Created with IntelliJ IDEA.
 * User: Eugene-Krevenets
 * Date: 3/12/13
 * Time: 12:03 PM
 * To change this template use File | Settings | File Templates.
 */
package org.hyzhak.imageuploader {
    import com.codecatalyst.promise.Deferred;
    import com.codecatalyst.promise.Promise;

    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.OutputProgressEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;

    import flash.utils.setTimeout;

    import mx.utils.Base64Encoder;

    public class PostBytesCommand {

        private static var _commands:Vector.<PostBytesCommand> = new Vector.<PostBytesCommand>();

        public static function execute(url:String, template:String, id:String, data:ByteArray) : Promise {
            var deferred:Deferred = new Deferred();
            var command:PostBytesCommand = new PostBytesCommand(deferred, url, template, id, data);
            addCommand(command);

            return deferred.promise.then(function (value:*):* {
                removeCommand(command);
                return value;
            }, function (value:*):Promise {
                removeCommand(command);
                var deferred:Deferred = new Deferred();
                setTimeout(function():void {
                    deferred.reject(value);
                },0)
                return deferred.promise;
            });
        }

        private static function removeCommand(command:PostBytesCommand):void {
            var index : int = _commands.indexOf(command);
            _commands.splice(index,  0);
        }

        private static function addCommand(command:PostBytesCommand):void {
            _commands.push(command);
        }

        private const ID_MARK:String = "{{id}}";
        private const ID_DATA:String = "{{userpic_data}}";

        private var _deferred:Deferred;
        private var _encoder:Base64Encoder = new Base64Encoder();

        public function PostBytesCommand(deferred:Deferred, url:String, template:String, id:String, data:ByteArray) {
            _deferred = deferred;

            _encoder.reset();
            _encoder.encodeBytes(data);

            template = template.replace(ID_MARK, id);
            template = template.replace(ID_DATA, _encoder.toString());

            var request:URLRequest = new URLRequest();
            request.url = url;
            request.method = URLRequestMethod.POST;
            request.data = template;
            
            var loader:URLLoader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE, onCompleteHandler);
            loader.addEventListener(Event.OPEN, onOpenHandler);
            loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
            loader.addEventListener(ProgressEvent.SOCKET_DATA, onProgressHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
            loader.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onOutputProgress);
            loader.load(request);
        }

        private function onCompleteHandler(event:Event):void {
            _deferred.resolve(event);
        }

        private function onOpenHandler(event:Event):void {

        }

        private function onProgressHandler(event:ProgressEvent):void {

        }

        private function onSecurityErrorHandler(event:SecurityErrorEvent):void {
            _deferred.reject(event);
        }

        private function onHttpStatusHandler(event:HTTPStatusEvent):void {

        }

        private function onIOErrorHandler(event:IOErrorEvent):void {
            _deferred.reject(event);
        }

        private function onOutputProgress(event:OutputProgressEvent):void {
            
        }
    }
}
