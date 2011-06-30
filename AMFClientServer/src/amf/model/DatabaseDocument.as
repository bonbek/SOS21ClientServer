package amf.model {

	import com.adobe.serialization.json.JSON;
	import ddgame.server.IDatabaseDocument;
	import ddgame.server.IDocumentServices;
	import amf.service.DocumentServices;

	/**
	 *	Class template pour les documents de données
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  24.06.2011
	 */
	public class DatabaseDocument implements IDatabaseDocument {
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _id:String;
		protected var _services:IDocumentServices;

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get id () : String
		{ return _id; }
		
		public function set services (val:IDocumentServices) : void
		{  _services = val; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function save (	params:Object = null,
										successCallBack:Function = null,
										faultCallBack:Function = null	) : void
		{
			_services.save(this, params, successCallBack, faultCallBack);
		}
		
		/**
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function destroy (successCallBack:Function = null, faultCallBack:Function = null) : void
		{ _services.destroy(this, successCallBack, faultCallBack); }
		
		/**
		 * Injection des données au shéma document IClientServer
		 * Utilisé lors de la création d'objet depuis les services
		 * @see	service.DocumentService.create()
		 */
		public function setData (data:Object) : void
		{
			for (var p:String in data)
				this[p] = data[p];
		}
		
		/**
		 * Injection des données au shéma serveur
		 * Utilisé lors de la réception de données serveur
		 * pour créer les documents
		 * @see	service.LoadResponder / CreateResponder
		 */
		public function setBackData (data:Object) : void
		{
//			trace("setBackData");
//			trace(JSON.encode(data));
			
			for (var p:String in data)
			{
					if (p == "id") _id = data[p];
					else
						this[p] = data[p];
			}
		}
		
		
		/**
		 * A overrider dans les sous classes
		 * Retourne un objet de données compatible avec
		 * le schéma de données du document dans sa "version serveur"
		 * @see	service.DocumentService.save()
		 * @param	attributes		objet shéma des propriétés dans sa version IClientServer,
		 * 								si ce param est null la méthode devra retourner
		 * 								l'ensemble des données converties
		 */
		public function getBackData (attributes:Object = null) : Object
		{ return null; }
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
	
	}

}

