package couchdb.service {
	
	import ddgame.server.IDocumentServices;
	import ddgame.server.IDatabaseDocument;
	import ddgame.server.IPlayerDocument;
	import ddgame.server.IPlaceDocument;
	import ddgame.server.NullDocument;
	import couchdb.model.ActionDocument;
	import com.gravityblast.couchdb.Database;
	
	/**
	 *	Services documents action pour tests
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ActionServices implements IDocumentServices {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function ActionServices (database:Database)
		{
			this.database = database;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var database:Database;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function load (	params:Object,
										successCallBack:Function = null,
										faultCallBack:Function = null	) : void
		{
			// TODO
		}
		
		/**
		 * Pour l'instant cette méthode n'est appelée que depuis
		 * TileTriggersProxy avec un shéma data :
		 * {	
		 * 	player: 	IPlayerDocument document joueur actuel
		 * 	place: 	IPlaceDocument document lieu actuelement joué
		 * 	action: 	TriggerProperty data action executée
		 * }
		 *	@param data Object
		 *	@return IDatabaseDocument
		 */
		public function create (data:Object = null) : IDatabaseDocument
		{
			var document:ActionDocument;
			try
			{
				var playerDocument:IPlayerDocument = data.player;
				var placeDocument:IPlaceDocument = data.place;
				var descriptor:Object = data.action;
				// Check si bonus
				var bonus:Object = descriptor.arguments["completeBonus"];
				if (bonus)
				{
					// Check si verb définit dans titre de l'action
					if ("title" in descriptor)
					{
						var verb:String = descriptor.title.match(/(?<=verb:)(\w*)/gi).toString();
						if (verb.length > 1)
						{
							document = new ActionDocument(this);
							document.character = playerDocument.pseudo;
							document.place = placeDocument.title;
							document.verb = verb;
							var effects:Object = {};
							if ("psoc" in bonus ) effects.social = int(bonus.psoc);
							if ("penv" in bonus ) effects.environment = int(bonus.penv);
							if ("peco" in bonus ) effects.economy = int(bonus.peco);
							document.effects = effects;
						}
					}					
				}
			} catch (e:Error) {}
			
			return document ? document : new NullDocument();
		}
		
		/**
		 * Sauvegarde de l'action
		 *	@param document IDatabaseDocument
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function save (	document:IDatabaseDocument, params:Object = null,
										successCallBack:Function = null, faultCallBack:Function = null	) : void
		{
			var castDocument:ActionDocument = document as ActionDocument;
			database.saveDocument(castDocument.getCouchData());
		}
		
		public function destroy (	document:IDatabaseDocument,
											successCallBack:Function = null, faultCallBack:Function = null	) : void
		{ }
			
	}

}

