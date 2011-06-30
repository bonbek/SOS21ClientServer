package
{
	import ddgame.server.IDocumentServices;
	import amf.service.GenericDocumentServices;
	import couchdb.service.*;
	import couchdb.model.*
	import com.gravityblast.couchdb.Database;
	import com.gravityblast.couchdb.CouchDb;

	/**
	 * ClientServer transitionnel
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author toffer
	 */
	public class CouchClientServer extends AMFClientServer
	{
		
			//--------------------------------------
			// CLASS CONSTANTS
			//--------------------------------------

			public function CouchClientServer ()
			{ super(); }

			//--------------------------------------
			//  PRIVATE VARIABLES
			//--------------------------------------

			protected var database:Database;
			protected var actionServices:ActionServices;
			
			//--------------------------------------
			//  PUBLIC METHODS
			//--------------------------------------
			
			/**
			 * @inheritDoc
			 */
			override public function connect (	credentials:Object = null,
															successCallBack:Function = null, faultCallBack:Function = null) : void
			{
				super.connect(credentials, successCallBack, faultCallBack);
				
				// INIT couch
				var couchDB:CouchDb = new CouchDb(String(_config.host), uint(_config.port));
				database = couchDB.database(String(_config.databaseName));
			}
			
			/**
			 * @inheritDoc
			 * Cablage transition, on va retourner petit à petit
			 * les services / documents exclusifs CouchDB en encapsulant / héritant les services et
			 * modèles de document existants.
			 */
			override public function getServices (scope:String) : IDocumentServices
			{
				var s:IDocumentServices;
				switch (scope)
				{
					case "place" :
					{
						if (!placeServices)
						{
							var encapseServices:GenericDocumentServices = new GenericDocumentServices(	_connection,
																																"Places",
																																TransitionalPlaceDocument	);
							placeServices = new TransitionalDocumentServices(database, encapseServices);
							encapseServices.documentServices = placeServices;
						}
						s = placeServices;
						break;
					}
					case "action" :
						if (!actionServices) {
							actionServices = new ActionServices(database);
						}
						s = actionServices;
						break;
				}

				return s ? s : super.getServices(scope);
			}
	}

}
