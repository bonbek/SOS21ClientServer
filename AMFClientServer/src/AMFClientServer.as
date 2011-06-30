package
{

	import com.sos21.proxy.*;
	import com.sos21.net.*;

	import ddgame.server.*;
	import amf.model.*;
	import amf.service.*;
	import amf.delegate.*;

	/**
	 * ClientServer pour connexion avec services AMFPHP
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Christopher Corbin
	 * @since 15.03.2011
	 */
	public class AMFClientServer extends AbstractModuleProxy implements IClientServer
	{
		
			//--------------------------------------
			// CLASS CONSTANTS
			//--------------------------------------

			public function AMFClientServer ()
			{ super(); }

			//--------------------------------------
			//  PRIVATE VARIABLES
			//--------------------------------------

			protected var _connection:Service;
			protected var _config:Object;
			
			protected var placeServices:IDocumentServices;
			protected var playerServices:IDocumentServices;			
			protected var objectServices:IDocumentServices;
			protected var nullServices:IDocumentServices;

			//--------------------------------------
			//  GETTER/SETTERS
			//--------------------------------------
			
			/**
			 * @private
			 * Option de configuration, logiquement le noeud services
			 * du XML de config
			 */
			public function set config (conf:Object) : void
			{
				_config = conf;
				_connection.connect(_config.gateway); 
			}
			
			//--------------------------------------
			//  PUBLIC METHODS
			//--------------------------------------
			
			/**
			 * Service de connection
			 *	@param credentials Object
			 *	@param successCallBack Function
			 *	@param faultCallBack Function
			 */
			public function connect (	credentials:Object = null,
												successCallBack:Function = null, faultCallBack:Function = null) : void
			{
				var serviceDelegate:ConnectionDelegate = new ConnectionDelegate(_connection);
				serviceDelegate.connect(credentials, successCallBack, faultCallBack);
			}
			
			/**
			 * TODO Documenter
			 *	@param scope String
			 *	@return IDocumentServices
			 */
			public function getServices (scope:String) : IDocumentServices
			{
				var s:IDocumentServices;
				switch (scope)
				{
					case "player" :
						if (!playerServices) {
							playerServices = new GenericDocumentServices(_connection, "Players", PlayerDocument);
						}
						s = playerServices;
						break;
					case "place" :
						if (!placeServices) {
							placeServices = new GenericDocumentServices(_connection, "Places", PlaceDocument);
						}
						s = placeServices;
						break;
					case "object" :
						if (!objectServices) {
							objectServices = new GenericDocumentServices(_connection, "Objects", ObjectDocument);
						}
						s = objectServices;
						break;
					default :
						if (!nullServices) {
							nullServices = new NullDocumentServices();
						}
						s = nullServices;
						break;
				}

				return s;
			}
			
			//--------------------------------------
			//  PRIVATE & PROTECTED INSTANCE METHODS
			//--------------------------------------
			
			/**
			 *	@private
			 */
			public function initialize () : void
			{
				_connection = new Service();
				_connection.service = "sos21Services";
			}
	}

}
