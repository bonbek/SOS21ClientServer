package amf.model {

	import ddgame.server.IPlaceDocument;
	import amf.model.DatabaseDocument;

	/**
	 *	Document de données lieu (scène)
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  27.06.2011
	 */
	public class PlaceDocument extends DatabaseDocument implements IPlaceDocument {
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var _title:String;
		public var _hidden:Boolean;
		public var backgroundFile:Object;
		public var foregroundFile:Object;
		public var ambientSound:Object;
		public var dimx:int;
		public var dimy:int;
		public var dimz:int;
		public var tilew:int;
		public var tileh:int;
		public var tiled:int;
		public var sceneOffsetX:int;
		public var sceneOffsetY:int;
		public var avatarFactor:Number;
		public var entryPoint:Object;
		public var _collisions:Array;
		public var tileList:Array;
		public var triggers:Array;
		public var _objectsModels:Object;
		public var _camera:Object;
		public var _cellsSize:Object;
		public var _cellsNumber:Object;
		public var _location:Object;
		public var env:Object;
		// résidu
		public var ownerid:String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Intitulé de la scène
		 */
		public function get title () : String
		{ return _title; }

		public function set title (val:String) : void
		{ _title = val; }

		/**
		 * Etat de publication
		 */
		public function get hidden () : Boolean
		{ return _hidden; }

		public function set hidden (val:Boolean) : void
		{ _hidden = val; }

		/**
		 * Fichier arrière, avant plan et fond sonore
		 * Définit en tant qu'objet pour assurer la
		 * compatibilé des versions avant bascule vers
		 * système définitif.
		 * @return l'url pour être compatible avec la version actuelle
		 */		
		public function get background () : Object
		{ return backgroundFile; }

		public function set background (val:Object) : void
		{ backgroundFile = val; }

		public function get foreground () : Object
		{ return foregroundFile; }
		
		public function set foreground (val:Object) : void
		{ foregroundFile = val;  }
		
		public function get music () : Object
		{ return ambientSound; }

		public function set music (val:Object) : void
		{ ambientSound = val; }

		/**
		 * Dimension de la grille, nombre de cellules
		 * en largeur, hauteur et profondeur
		 * { x:int, y:int, z:int }
		 */
		public function get cellsNumber () : Object
		{
			if (!_cellsNumber)
				_cellsNumber = {x:dimx, y:dimy, z:dimz};
				
			return _cellsNumber;
		}

		public function set cellsNumber (val:Object) : void
		{ 
			_cellsNumber = val;
			// Maj data
			dimx = _cellsNumber.x;
			dimy = _cellsNumber.y;
			dimz = _cellsNumber.z;
		}

		/**
		 * Pas de la grille. Dimension des cellules
		 * en largeur, hauteur et profondeur
		 * { width:int, height:int, depth:int }
		 */
		public function get cellsSize () : Object
		{ 
			if (!_cellsSize)
				_cellsSize = {width:tilew, height:tileh, depth:tiled};

			return _cellsSize;
		}
		
		public function set cellsSize (val:Object) : void
		{ 
			_cellsSize = val;
			// Maj data
			tilew = _cellsSize.width;
			tileh = _cellsSize.height;
			tiled = _cellsSize.depth;
		}

		/**
		 * Position du point de vue sur la scène
		 * Regroupe actuelement le décalage x / y des calques
		 * de la scène et du facteur de dimensions (ancien avatarFactor).
		 * A terme devra au moins définir une coordonnée céllule (ex:{x:int,y:int,z:int}).
		 * { xOffset:int, yOffset:int }
		 */
		public function get camera () : Object
		{
			if (!_camera)
				_camera = {	xOffset:sceneOffsetX,
								yOffset:sceneOffsetY,
								scale:avatarFactor	}

			return _camera;
		}
		
		public function set camera (val:Object) : void
		{ 
			_camera = val;
			// Maj data
			sceneOffsetX = _camera.xOffset;
			sceneOffsetY = _camera.yOffset;
			avatarFactor = _camera.scale;
		}

		/**
		 * Point d'entrée dans la scène
		 * { x:Number, y:Number, z:Number }
		 */
		public function get entrance () : Object
		{ return entryPoint; }
		
		public function set entrance (val:Object) : void
		{ entryPoint = val; }
		
		/**
		 * Grille de collisions
		 */
		public function get collisions () : Array
		{ return _collisions; }
		
		public function set collisions (val:Array) : void
		{ _collisions = val; }
		
		/**
		 * Liste des objets
		 */
		public function get objects () : Array
		{ return tileList; }
		
		public function set objects (val:Array) : void
		{ tileList = val; }
		
 		/**
		 * Models des objets, librairie des descripteurs
		 * d'objets.
		 * TODO implémenter
		 */
		public function get objectsModels () : Object
		{
			if (!_objectsModels) _objectsModels = {};
			return _objectsModels;
		}
		public function set objectsModels (val:Object) : void
		{ _objectsModels = val; }
		
		/**
		 * Liste des actions
		 */
		public function get actions () : Array
		{ return triggers; }
		
		public function set actions (val:Array) : void
		{ triggers = val; }
		
		/**
		 * Localisation
		 * { address:String, lat:Number, lon:Number }
		 */
		public function get location () : Object
		{ return _location; }
		
		public function set location (val:Object) : void
		{ _location = val; }
		
		/**
		 * Variables / pointeurs
		 */
		public function get variables () : Object
		{ return env; }

		public function set variables (val:Object) : void
		{ env = val; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function getBackData (attributes:Object = null) : Object
		{
			var res:Object;
			if (attributes)
			{
				res = {};
				for each (var p:String in attributes)
				{
					switch (p)
					{
						case "background" :
							res.backgroundFile = backgroundFile;
							break;
						case "foreground" :
							res.foregroundFile = foregroundFile;
							break;
						case "music" :
							res.ambientSound = ambientSound;
							break;
						case "cellsNumber" :
							res.dimx = cellsNumber.x;
							res.dimy = cellsNumber.y;
							res.dimz = cellsNumber.z;
							break;
						case "cellsSize" :
							res.tilew = cellsSize.width;
							res.tileh = cellsSize.height;
							res.tiled = cellsSize.depth;
							break;		
						case "camera" :
							res.sceneOffsetX = camera.xOffset;
							res.sceneOffsetY = camera.yOffset;
							res.avatarFactor = camera.scale;
							break;		
						case "entrance" :
							res.entryPoint = entryPoint;
							break;
						case "objects" :
							res.tileList = tileList;
							break;
						case "actions" :
							res.triggers = triggers;
							break;
						case "variables" :
							res.env = env;
							break;	
						default :
							res[p] = this[p];
							break;
					}					
				}
			}
			else
			{
				res =
				{
					title: title,
					hidden:hidden,
					backgroundFile: backgroundFile,
					foregroundFile: foregroundFile,
					ambientSound: ambientSound,
					dimx: cellsNumber.x,
					dimy: cellsNumber.y,
					dimz: cellsNumber.z,
					tilew: cellsSize.width,
					tileh: cellsSize.height,
					tiled: cellsSize.depth,
					sceneOffsetX: camera.xOffset,
					sceneOffsetY: camera.yOffset,
					avatarFactor: camera.scale,
					entryPoint: entryPoint,
					tileList: tileList,
					triggers: triggers,
					collisions: collisions,
					location: location,
					env: env
				}
			}
			
			return res;
		}
	
	}

}

