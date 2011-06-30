package com.gravityblast.couchdb
{
	import com.adobe.serialization.json.JSON;
	import com.gravityblast.couchdb.errors.DatabaseError;
	import com.gravityblast.couchdb.events.CouchRestEvent;
	import com.gravityblast.couchdb.events.DatabaseEvent;
	
	import flash.events.EventDispatcher;
	

	public class Database extends EventDispatcher
	{
		
		public var couchdb:CouchDb;
		public var name:String;
		
		public function Database(couchdb:CouchDb, name:String)
		{
			this.couchdb = couchdb;
			this.name 	 = name;
			super();
		}
		
		public function create(completeCallback:Function=null):void
		{
			var couchRest:CouchRest = this.buildCouchRest(completeCallback);			
			couchRest.put(this.couchdb.uri + "/" + this.name);
		}
		
		public function del(completeCallback:Function=null):void
		{
			var couchRest:CouchRest = this.buildCouchRest(completeCallback);			
			couchRest.del(this.couchdb.uri + "/" + this.name);
		}
		
		public function saveDocument(document:Object, completeCallback:Function=null):void
		{
			var couchRest:CouchRest = this.buildCouchRest(completeCallback);
			if (document._id)			
				couchRest.put(this.couchdb.uri + "/" + this.name + "/" + document._id, null, JSON.encode(document));	
			else			
				couchRest.post(this.couchdb.uri + "/" + this.name, null, JSON.encode(document));					
		}
		
		public function get(id:String, params:Object=null, completeCallback:Function=null):void
		{			
			var couchRest:CouchRest = this.buildCouchRest(completeCallback);
			couchRest.get(this.couchdb.uri + "/" + this.name + "/" +  id);
		}

		/**
		 * (@from http://wiki.apache.org/couchdb/HTTP_Bulk_Document_API) :
		 *	To fetch multiple documents by adding in params
		 * include_docs:true you can get the documents themselves, not just their id and rev
		 * keys:["xx","yy"...] you can get the documents in the keys list
		 *	startkey:"xx", endkey:"yy" you can get the documents with keys in a certain range
		 * Simple example to fetch the keys bar and baz and include the complete document in the result set:
		 * database.documents({include_docs:true, keys:["bar","baz"]}, callBack);
		 */
		public function documents(params:Object=null, completeCallback:Function=null):void
		{
			var couchRest:CouchRest = this.buildCouchRest(completeCallback);
			if (!params)
			{
				couchRest.get(this.couchdb.uri + "/" + this.name + "/" +  "_all_docs");
			}
			else
			{
				var urlParam:String = "?include_docs=" + String(("include_docs" in params) ? params.include_docs : false);																				
				couchRest.post(this.couchdb.uri + "/" + this.name + "/" +  "_all_docs" + urlParam,
									null, JSON.encode(params));
			}
		}				
		
		protected function couchRestErrorHandler(event:CouchRestEvent):void
		{
			if (hasEventListener(DatabaseEvent.ERROR))
			{
				var _event:DatabaseEvent = new DatabaseEvent(DatabaseEvent.ERROR);
				this.dispatchEvent(_event);
			}
			else
			{
				throw new DatabaseError();
			}				
		}
		
		protected function buildCouchRest(completeCallback:Function=null):CouchRest
		{
			var couchRest:CouchRest = new CouchRest();
			couchRest.addEventListener(CouchRestEvent.IO_ERROR, this.couchRestErrorHandler);
			if (completeCallback != null)			
				couchRest.addEventListener(CouchRestEvent.COMPLETE, completeCallback);											
			return couchRest;
		}
	}
}