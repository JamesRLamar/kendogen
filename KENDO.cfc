/**
*
* @author  James R Lamar - Nautilus Technology Solutions Inc. - gonautilus.com
* @description This software is issued wihtout warranty under GPL v3 and is meant to be used with the open source version of Kendo UI Web widgets
*
*/

component output="false" displayname="KENDO"  {

	public string function KENDO_Get_Grid( 
	
		required string model,
		string directory = "includes/",
		boolean overwrite = false,
		boolean include = false,
		boolean CRUD = true,
		string data_Type = "JSON",
		numeric page_Size = 0,
		numeric height = 400,
		string pKey = "",
		string component = "KENDO"
		
		) {

		APPLICATION.BASE_PATH = "E:\ColdFusion10\cfusion\wwwroot\kendogen\";

		//NOTE NO TRAILING SLASH FOR THE BASE_URL

		APPLICATION.BASE_URL = "http://localhost:8501/kendogen";
				
		KENDO_Include_Path = arguments.directory;

		KENDO_URL = APPLICATION.BASE_URL;

		KENDO_Datasource = "cfartgallery";

		KENDO_Create_Method = "create_Model";

		KENDO_Read_Method = "read_Model";

		KENDO_Update_Method = "update_Model";

		KENDO_Delete_Method = "delete_Model";

		var unique_Name = "kendo_Grid_" & UCASE(arguments.model) & "_" & UCASE(arguments.data_Type);
		
		var generated_File_Name = unique_Name & ".js";

		KENDO_Include_Path = KENDO_Include_Path & generated_File_Name;

		var abs_Path = APPLICATION.BASE_PATH & arguments.directory & generated_File_Name;	

		var primary_Key = arguments.pKey;
		
		try {
			
			//OVERWRITE

			if ( arguments.overwrite ) {
			
				writeOutput('<div id="' & unique_Name & '"></div>');

				KENDO_Get_URL();

				throw("overwrite", "Any");	
			}

			//GET EXISTING
			
			else if ( FileExists(abs_Path) ) {
				
				writeOutput('<div id="' & unique_Name & '"></div>') ;

				KENDO_Get_URL();
				
				if (arguments.include) {
					
					writeOutput('<script>' & chr(10) );

					include KENDO_Include_Path;

					writeOutput('</script>');	
				}
			}

			//FILE DOES NOT EXIST
			
			else {
				
				writeOutput('<div id="' & unique_Name & '"></div>') ;

				KENDO_Get_URL();

				throw("nonexistance", "Any");
			}
			
		}
		
		catch(Any e) {
			
			var generated_Output = '// JavaScript Document' & chr(10) ;;
			
			var qModel = KENDO_Get_DBINFO( type = "columns", table = arguments.model);

			if ( primary_Key == "" ) {

				primary_Key = KENDO_Get_Key( qModel );
			}
					
			generated_Output = generated_Output &  '$(document).ready(function () {' & chr(10) & chr(10);

			generated_Output = generated_Output &  '	var crud_Service_Base_Url = Kendo_URL + "/' & arguments.component & '.cfc?method=",' & chr(10) & chr(10) ;
		
			generated_Output = generated_Output &  '	dataSource = new kendo.data.DataSource({' & chr(10) & chr(10);

			generated_Output = generated_Output &  '		transport: {' & chr(10) & chr(10);

			generated_Output = generated_Output &  '			read:  {' & chr(10) & chr(10);

			generated_Output = generated_Output &  '				url: crud_Service_Base_Url + "'

																	&  KENDO_Read_Method & '_' & arguments.data_Type & '&model='

																	&  arguments.model 

																	&  '",' 

																	&  chr(10) & chr(10);
				
			if (arguments.CRUD) {
			
				generated_Output = generated_Output &  '				dataType: "' & arguments.data_Type & '"' & chr(10) ;

				generated_Output = generated_Output &  '			},' & chr(10) & chr(10) ;

				generated_Output = generated_Output &  '			update: {' & chr(10) ;

				generated_Output = generated_Output &  '				url: crud_Service_Base_Url + "' 

																		& KENDO_Update_Method & '_' & arguments.data_Type & '&model='

																		& arguments.model 

																		& '",' 

																		& chr(10) & chr(10);

				generated_Output = generated_Output &  '				dataType: "' & arguments.data_Type & '"' & chr(10) ;

				generated_Output = generated_Output &  '			},' & chr(10)  & chr(10);

				generated_Output = generated_Output &  '			destroy: {' & chr(10) & chr(10);

				generated_Output = generated_Output &  '				url: crud_Service_Base_Url + "' 

																		& KENDO_Delete_Method & '_' & arguments.data_Type & '&model='

																		& arguments.model 

																		& '",' 

																		& chr(10) & chr(10);

				generated_Output = generated_Output &  '				dataType: "' & arguments.data_Type & '"' & chr(10) ;

				generated_Output = generated_Output &  '			},' & chr(10) & chr(10);

				generated_Output = generated_Output &  '			create: {' & chr(10) & chr(10);

				generated_Output = generated_Output &  '				url: crud_Service_Base_Url + "' 

																		& KENDO_Create_Method & '_' & arguments.data_Type & '&model='

																		& arguments.model 

																		& '",' 

																		& chr(10) & chr(10);
			}
			
			generated_Output = generated_Output &  '				dataType: "' & arguments.data_Type & '"' & chr(10) ;

			generated_Output = generated_Output &  '			},' & chr(10) & chr(10);

			generated_Output = generated_Output &  '			parameterMap: function(options, operation) {' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '				if (operation !== "read" && options.models) {' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '					return {models: kendo.stringify(options.models)};' & chr(10) ;

			generated_Output = generated_Output &  '				}' & chr(10) ;

			generated_Output = generated_Output &  '			}' & chr(10) ;

			generated_Output = generated_Output &  '		},' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '		batch: true,' & chr(10)  & chr(10);
			
			if (arguments.page_Size) {
				
				generated_Output = generated_Output &  '		pageSize: ' & arguments.page_Size & ',' & chr(10)  & chr(10);	
			}
			
			generated_Output = generated_Output &  '		schema: {' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '			model: {' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '				id: "' & Ucase(primary_Key) & '",' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '				fields: {' & chr(10)  & chr(10);
			
			for (col = 1; col LTE qModel.RecordCount; col++) {
				
				if (qModel["IS_PRIMARYKEY"][col]) {
					
					generated_Output = generated_Output & '					' & Ucase(qModel["COLUMN_NAME"][col]) & ': { editable: false, nullable: true }'  ;
					
					if (col NEQ qModel.RecordCount) {
						
						generated_Output = generated_Output &  ',' & chr(10);
					}
				}
				
				else {
				
					generated_Output = generated_Output & '					' & Ucase(qModel["COLUMN_NAME"][col]) 

						& ': { ' 

						& KENDO_Get_Column_Info(

							qModel["TYPE_NAME"][col],

							qModel["REMARKS"][col],

							qModel["ORDINAL_POSITION"][col],

							qModel["IS_NULLABLE"][col],

							qModel["COLUMN_DEFAULT_VALUE"][col]) 

						& ' }' ;
					
					if (col NEQ qModel.RecordCount) {
						
						generated_Output = generated_Output &  ',' & chr(10) & chr(10);
					}
				}
			}
			
			generated_Output = generated_Output & chr(10) & '					}' & chr(10);

			generated_Output = generated_Output &  '				}' & chr(10) ;

			generated_Output = generated_Output &  '			}' & chr(10) ;

			generated_Output = generated_Output &  '		} );' & chr(10) & chr(10);
				
			generated_Output = generated_Output &  '	var grid = $("##' & unique_Name & '").kendoGrid({' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '		dataSource: dataSource,' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '		navigatable: true,' & chr(10)  & chr(10);
			
			if (arguments.page_Size NEQ 0) {
				
				generated_Output = generated_Output &  '		pageable: true,' & chr(10)  & chr(10);
			}
			
			generated_Output = generated_Output &  '		sortable: true,' & chr(10)  & chr(10);

			generated_Output = generated_Output &  '		filterable: true,' & chr(10)  & chr(10);
			
			if (arguments.CRUD) {
				
				generated_Output = generated_Output &  '		editable: true,' & chr(10)  & chr(10);

				generated_Output = generated_Output &  '		toolbar: ["create", "save", "cancel"],' & chr(10) & chr(10) ;
			}
			
			generated_Output = generated_Output &  '		height: ' & arguments.height & ',' & chr(10) & chr(10);

			generated_Output = generated_Output &  '		columns: [' & chr(10) & chr(10);
			
			for (col = 1; col LTE qModel.RecordCount; col++) {
				
				if (NOT qModel["IS_PRIMARYKEY"][col]) {
					
					generated_Output = generated_Output &  '			{ field: "' & Ucase(qModel["COLUMN_NAME"][col]) & '", title: "' & Replace(qModel["COLUMN_NAME"][col], "_", " ", "All") & '"}' ;
						
						if (arguments.CRUD) {
						
							generated_Output = generated_Output & ',' & chr(10) & chr(10);
						}
						
						else if ( col NEQ qModel.RecordCount ) {
							
							generated_Output = generated_Output & ',' & chr(10) & chr(10);
						}
				}
			}
			
			if (arguments.CRUD) {
				
				generated_Output = generated_Output &  '			{ command: "destroy", title: "&nbsp;", width: "110px" }]' & chr(10) ;
			}
			
			else {
				
				generated_Output = generated_Output &  '		]' & chr(10) ;
			}
			
			generated_Output = generated_Output &  '	} );' & chr(10) ;

			generated_Output = generated_Output &  '} );' & chr(10) ;
					
			FileWrite("memory", "#generated_Output#"); 

			var file_Output = FileRead("memory");

			FileWrite(abs_Path, "#file_Output#");
			
			if (arguments.include) {
					
				writeOutput('<script>' & chr(10) );

				include KENDO_Include_Path;

				writeOutput('</script>');	
			}
		}
	}

	private string function KENDO_Get_URL() {
		
		writeOutput( chr(10) & '<script>' & chr(10) );

		writeOutput( 
			
			'$(document).ready(function() { ' & chr(10)
				& '#toScript( Kendo_URL , "Kendo_URL")#' & chr(10)
			& '});' & chr(10)
		);

		writeOutput('</script>');
	}

	remote any function read_Model_JSON() returnformat="JSON" {
		
		data = '[{"PRICE":10000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Pastels\/Charcoal","ARTISTID":1,"ARTNAME":"charles1","LARGEIMAGE":"aiden01.jpg","ARTID":1},{"PRICE":13900,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels\/Charcoal","ARTISTID":1,"ARTNAME":"Michael","LARGEIMAGE":"aiden02.jpg","ARTID":2},{"PRICE":12500,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Pastels\/Charcoal","ARTISTID":1,"ARTNAME":"Freddy","LARGEIMAGE":"aiden03.jpg","ARTID":3},{"PRICE":11100,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Pastels\/Charcoal","ARTISTID":1,"ARTNAME":"Paulo","LARGEIMAGE":"aiden04.jpg","ARTID":4},{"PRICE":13550,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Pastels\/Charcoal","ARTISTID":1,"ARTNAME":"Mary","LARGEIMAGE":"aiden05.jpg","ARTID":5},{"PRICE":9800,"MEDIAID":2,"ISSOLD":1,"DESCRIPTION":"Mixed Media","ARTISTID":3,"ARTNAME":"Space","LARGEIMAGE":"elecia01.jpg","ARTID":6},{"PRICE":7800,"MEDIAID":2,"ISSOLD":1,"DESCRIPTION":"Mixed Media","ARTISTID":3,"ARTNAME":"Leaning House","LARGEIMAGE":"elecia02.jpg","ARTID":7},{"PRICE":5600,"MEDIAID":2,"ISSOLD":1,"DESCRIPTION":"Mixed Media","ARTISTID":3,"ARTNAME":"Dude","LARGEIMAGE":"elecia03.jpg","ARTID":8},{"PRICE":8900,"MEDIAID":2,"ISSOLD":0,"DESCRIPTION":"Mixed Media","ARTISTID":3,"ARTNAME":"Hang Ten","LARGEIMAGE":"elecia04.jpg","ARTID":9},{"PRICE":10500,"MEDIAID":2,"ISSOLD":0,"DESCRIPTION":"Mixed Media","ARTISTID":3,"ARTNAME":"Life is a Horse","LARGEIMAGE":"elecia05.jpg","ARTID":10},{"PRICE":75000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Charcoal ","ARTISTID":2,"ARTNAME":1958,"LARGEIMAGE":"austin01.jpg","ARTID":11},{"PRICE":22000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Charcoal","ARTISTID":2,"ARTNAME":"Toxic","LARGEIMAGE":"austin02.jpg","ARTID":12},{"PRICE":25000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Charcoal ","ARTISTID":2,"ARTNAME":"Prize Fight","LARGEIMAGE":"austin03.jpg","ARTID":13},{"PRICE":42700,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Charcoal","ARTISTID":2,"ARTNAME":"You Don`t Know Me","LARGEIMAGE":"austin04.jpg","ARTID":14},{"PRICE":30000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Charcoal","ARTISTID":2,"ARTNAME":"Do it","LARGEIMAGE":"austin05.jpg","ARTID":15},{"PRICE":11800,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Acrylic","ARTISTID":4,"ARTNAME":"Bowl of Flowers","LARGEIMAGE":"jeff01.jpg","ARTID":16},{"PRICE":25000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Acrylic ","ARTISTID":4,"ARTNAME":"60 Vibe","LARGEIMAGE":"jeff02.jpg","ARTID":17},{"PRICE":30000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Acrylic","ARTISTID":4,"ARTNAME":"Naked","LARGEIMAGE":"jeff03.jpg","ARTID":18},{"PRICE":15000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Acrylic","ARTISTID":4,"ARTNAME":"Sky","LARGEIMAGE":"jeff04.jpg","ARTID":19},{"PRICE":20000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Acrylic","ARTISTID":4,"ARTNAME":"Slices of Life","LARGEIMAGE":"jeff05.jpg","ARTID":20},{"PRICE":250000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Oil","ARTISTID":6,"ARTNAME":"Morning Forest","LARGEIMAGE":"maxwell01.jpg","ARTID":21},{"PRICE":300000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Oil","ARTISTID":6,"ARTNAME":"Things","LARGEIMAGE":"maxwell02.jpg","ARTID":22},{"PRICE":150000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Oil","ARTISTID":6,"ARTNAME":"The Lake","LARGEIMAGE":"maxwell03.jpg","ARTID":23},{"PRICE":10500,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Oil","ARTISTID":6,"ARTNAME":"Morph","LARGEIMAGE":"maxwell04.jpg","ARTID":24},{"PRICE":250000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Oil","ARTISTID":6,"ARTNAME":"Ideas","LARGEIMAGE":"maxwell05.jpg","ARTID":25},{"PRICE":54000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Pastels","ARTISTID":5,"ARTNAME":"Christmas","LARGEIMAGE":"lori01.jpg","ARTID":26},{"PRICE":65000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Pastels","ARTISTID":5,"ARTNAME":"Happiness","LARGEIMAGE":"lori02.jpg","ARTID":27},{"PRICE":40000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels","ARTISTID":5,"ARTNAME":"Closed","LARGEIMAGE":"lori03.jpg","ARTID":28},{"PRICE":350000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels","ARTISTID":5,"ARTNAME":"Enchanted Tree","LARGEIMAGE":"lori04.jpg","ARTID":29},{"PRICE":200000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels","ARTISTID":5,"ARTNAME":"Melon","LARGEIMAGE":"lori05.jpg","ARTID":30},{"PRICE":72000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Oils","ARTISTID":7,"ARTNAME":"Music","LARGEIMAGE":"paul01.jpg","ARTID":31},{"PRICE":35000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Oils","ARTISTID":7,"ARTNAME":"Empty","LARGEIMAGE":"paul02.jpg","ARTID":32},{"PRICE":58000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Oils","ARTISTID":7,"ARTNAME":"My Venus","LARGEIMAGE":"paul03.jpg","ARTID":33},{"PRICE":100000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Oils","ARTISTID":7,"ARTNAME":"Man in Jeans","LARGEIMAGE":"paul04.jpg","ARTID":34},{"PRICE":90000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Oils","ARTISTID":7,"ARTNAME":"Man on Stool","LARGEIMAGE":"paul05.jpg","ARTID":35},{"PRICE":250000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels","ARTISTID":8,"ARTNAME":"Mystery","LARGEIMAGE":"raquel01.jpg","ARTID":36},{"PRICE":300000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels","ARTISTID":8,"ARTNAME":"Paradise","LARGEIMAGE":"raquel02.jpg","ARTID":37},{"PRICE":150000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Pastels","ARTISTID":8,"ARTNAME":"Mountains","LARGEIMAGE":"raquel03.jpg","ARTID":38},{"PRICE":85000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels","ARTISTID":8,"ARTNAME":"Mom","LARGEIMAGE":"raquel04.jpg","ARTID":39},{"PRICE":100000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Pastels","ARTISTID":8,"ARTNAME":"Beauty","LARGEIMAGE":"raquel05.jpg","ARTID":40},{"PRICE":40000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Watercolor","ARTISTID":9,"ARTNAME":"Cowboy","LARGEIMAGE":"viata01.jpg","ARTID":41},{"PRICE":35000,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Watercolor","ARTISTID":9,"ARTNAME":"Pretty Life","LARGEIMAGE":"viata02.jpg","ARTID":42},{"PRICE":56500,"MEDIAID":1,"ISSOLD":0,"DESCRIPTION":"Watercolor","ARTISTID":9,"ARTNAME":"Singer","LARGEIMAGE":"viata03.jpg","ARTID":43},{"PRICE":36000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Watercolor","ARTISTID":9,"ARTNAME":"Windy","LARGEIMAGE":"viata04.jpg","ARTID":44},{"PRICE":20000,"MEDIAID":1,"ISSOLD":1,"DESCRIPTION":"Watercolor","ARTISTID":9,"ARTNAME":"Yellow to Me","LARGEIMAGE":"viata05.jpg","ARTID":45},{"PRICE":35000,"MEDIAID":6,"ISSOLD":1,"DESCRIPTION":"Photograph","ARTISTID":19,"ARTNAME":"Garden","LARGEIMAGE":"anthony01.jpg","ARTID":46},{"PRICE":20000,"MEDIAID":6,"ISSOLD":0,"DESCRIPTION":"Photograph","ARTISTID":19,"ARTNAME":"Flower","LARGEIMAGE":"anthony02.jpg","ARTID":47},{"PRICE":45000,"MEDIAID":6,"ISSOLD":1,"DESCRIPTION":"Photograph","ARTISTID":19,"ARTNAME":"White Flowers","LARGEIMAGE":"anthony03.jpg","ARTID":48},{"PRICE":20000,"MEDIAID":6,"ISSOLD":0,"DESCRIPTION":"Photograph","ARTISTID":19,"ARTNAME":"Ground Cover","LARGEIMAGE":"anthony04.jpg","ARTID":49},{"PRICE":30000,"MEDIAID":6,"ISSOLD":1,"DESCRIPTION":"Photograph","ARTISTID":19,"ARTNAME":"Blue Moon","LARGEIMAGE":"anthony05.jpg","ARTID":50},{"PRICE":23000,"MEDIAID":0,"ISSOLD":0,"DESCRIPTION":"Painting","ARTISTID":20,"ARTNAME":"Cow","LARGEIMAGE":"ellery01.jpg","ARTID":51},{"PRICE":14000,"MEDIAID":0,"ISSOLD":0,"DESCRIPTION":"Painting","ARTISTID":20,"ARTNAME":"Picasso","LARGEIMAGE":"ellery02.jpg","ARTID":52},{"PRICE":10000,"MEDIAID":0,"ISSOLD":0,"DESCRIPTION":"Painting","ARTISTID":21,"ARTNAME":"Miro","LARGEIMAGE":"emma01.jpg","ARTID":53},{"PRICE":12000,"MEDIAID":0,"ISSOLD":0,"DESCRIPTION":"Painting","ARTISTID":22,"ARTNAME":"Dino","LARGEIMAGE":"taylor01.jpg","ARTID":54},{"PRICE":10,"MEDIAID":"","ISSOLD":"","DESCRIPTION":"","ARTISTID":4,"ARTNAME":"sda","LARGEIMAGE":7,"ARTID":55}]';
		
		return data;
	}

	private query function KENDO_Get_DBINFO(
		
		string datasource = KENDO_Datasource,
		string type = "tables",
		string dbname,
		string password,
		string username,
		string pattern,
		string table
	) {

		d = new dbinfo( datasource = #datasource#, table = #table#, type = #type# ).columns();

		return d;
	}

	private string function KENDO_Get_Key(
		
		required query model
	) {
		
		//model argument must come from KENDO_Get_DBINFO

		var qModel = arguments.model;
		
		//ADD SORT BY IS_PRIMARYKEY AND LOOP WILL NO LONGER BE NECESSARY
		
		for (col = 1; col LTE qModel.RecordCount; col++) {
			
			if (qModel["IS_PRIMARYKEY"][col]) {
				
				primary_Key = qModel["COLUMN_NAME"][col];
				break;
			}
		}
		
		return primary_Key;
	}

	private string function KENDO_Get_Column_Info(

		required string col_Type = "", 
		string remarks = "", 
		string position = "", 
		string is_Nullable = false,
		string default_Value = "" 
		
		) {
		
		var col_Info = "";

		var numeric_Data_Types = "INT,TINYINT,DOUBLE,INTEGER";

		var string_Data_Types = "VARCHAR,LONGTEXT,TEXT";

		var boolean_Data_Types = "BIT,SMALLINT";
		
		if ( arguments.is_Nullable EQ "NO" ) {
			
			arguments.is_Nullable = "false";
		}
		
		else {
		
			arguments.is_Nullable = "true";	
		}
		
		if ( Find(arguments.col_Type, numeric_Data_Types) ) {
			
			col_Info = 'type: "number"';
			
			if ( arguments.is_Nullable EQ "false" ) {
			
				col_Info = col_Info & ', validation: { required: true, nullable: ' & arguments.is_Nullable & ' }';
				
				if ( arguments.default_Value NEQ "" ) {
			
					col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
				}
			}
			
			else {
			
				col_Info = col_Info & ', validation: { required: false, nullable: ' & arguments.is_Nullable & ' }';
				
				if ( arguments.default_Value NEQ "" ) {
			
					col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
				}
			}
		}
		
		else if ( Find(arguments.col_Type, boolean_Data_Types) ) {
						
			col_Info = 'type: "boolean"';
			
			if ( arguments.is_Nullable EQ "false" ) {
			
				col_Info = col_Info & ', validation: { required: true, nullable: ' & arguments.is_Nullable & ' }';
				
				if ( arguments.default_Value NEQ "" ) {
			
					col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
				}
			}
			
			else {
			
				col_Info = col_Info & ', validation: { required: false, nullable: ' & arguments.is_Nullable & ' }';
				
				if ( arguments.default_Value NEQ "" ) {
			
					col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
				}

				else {

					col_Info = col_Info & ', default_Value: "b' & "'" & "0'" & '"'; 
				}
			}
		}
		
		else if ( Find(arguments.col_Type, string_Data_Types) ) {
			
			if ( arguments.position EQ "2" ) {
			
				col_Info = 'type: "string"';
			
				if ( arguments.is_Nullable EQ "false" ) {
				
					col_Info = col_Info & ', validation: { required: true, nullable: ' & arguments.is_Nullable & ' }';
					
					if ( arguments.default_Value NEQ "" ) {
				
						col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
					}
				}
				
				else {
				
					col_Info = col_Info & ', validation: { required: false, nullable: ' & arguments.is_Nullable & ' }';
					
					if ( arguments.default_Value NEQ "" ) {
				
						col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
					}
				}
			}
			
			else {
				
				col_Info = 'type: "string"';
			
				if ( arguments.is_Nullable EQ "false" ) {
				
					col_Info = col_Info & ', validation: { required: true, nullable: ' & arguments.is_Nullable & ' }';
					
					if ( arguments.default_Value NEQ "" ) {
				
						col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
					}
				}
				
				else {
				
					col_Info = col_Info & ', validation: { required: false, nullable: ' & arguments.is_Nullable & ' }';
					
					if ( arguments.default_Value NEQ "" ) {
				
						col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
					}
				}
			}
		}
		
		else {
			
			col_Info = 'type: "' & arguments.col_Type & '"';
					
			if ( arguments.is_Nullable EQ "false" ) {
			
				col_Info = col_Info & ', validation: { required: true, nullable: ' & arguments.is_Nullable & ' }';
				
				if ( arguments.default_Value NEQ "" ) {
			
					col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
				}
			}
			
			else {
			
				col_Info = col_Info & ', validation: { required: false, nullable: ' & arguments.is_Nullable & ' }';
				
				if ( arguments.default_Value NEQ "" ) {
			
					col_Info = col_Info & ', default_Value: "' & arguments.default_Value & '"';
				}
			}
		}

		return col_Info;
	}
}