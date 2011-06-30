package couchdb.model {
	
	import ddgame.server.IDatabaseDocument;
	import ddgame.server.IDocumentServices;
	
	/**
	 *	Document action couchDB pour tests
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ActionDocument implements IDatabaseDocument {
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ActionDocument (services:IDocumentServices)
		{
			this.services = services;
			
			var d:Date = new Date();
			timestamp = String(d.fullYear);
			var m:int = d.month + 1;
			timestamp+= "-" + (m < 10 ? "0" : "") + m;
			timestamp+= "-" + d.date;
			timestamp+= " " + (d.hours < 10 ? "0" : "") + d.hours;
			timestamp+= ":" + (d.minutes < 10 ? "0" : "") + d.minutes;
			timestamp+= ":" + (d.seconds < 10 ? "0" : "") + d.seconds;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var services:IDocumentServices;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get id () : String
		{ return null; }
		
		public var character:String;
		public var verb:String;
		public var timestamp:String;
		public var place:String;
		public var effects:Object;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function save (	params:Object = null,
										successCallBack:Function = null,
										faultCallBack:Function = null	) : void
		{
			services.save(this, params, successCallBack, faultCallBack);
		}
		
		public function destroy (successCallBack:Function = null, faultCallBack:Function = null) : void
		{ services.destroy(this, successCallBack, faultCallBack); }
		
		public function getCouchData () : Object
		{			
			return {
				character: this.character,
				verb: this.verb,
				timestamp: this.timestamp,
				place: this.place,
				effects: this.effects
			};
		}
	
	}

}

