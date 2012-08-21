// JavaScript Document
$(document).ready(function () {

	var crud_Service_Base_Url = Kendo_URL + "/KENDO.cfc?method=",

	dataSource = new kendo.data.DataSource({

		transport: {

			read:  {

				url: crud_Service_Base_Url + "read_Model_JSON&model=art",

				dataType: "JSON"
			},

			update: {
				url: crud_Service_Base_Url + "update_Model_JSON&model=art",

				dataType: "JSON"
			},

			destroy: {

				url: crud_Service_Base_Url + "delete_Model_JSON&model=art",

				dataType: "JSON"
			},

			create: {

				url: crud_Service_Base_Url + "create_Model_JSON&model=art",

				dataType: "JSON"
			},

			parameterMap: function(options, operation) {

				if (operation !== "read" && options.models) {

					return {models: kendo.stringify(options.models)};
				}
			}
		},

		batch: true,

		schema: {

			model: {

				id: "ARTISTID",

				fields: {

					ARTID: { type: "number", validation: { required: true, nullable: false }, default_Value: "GENERATED_BY_DEFAULT" },

					ARTISTID: { type: "number", validation: { required: false, nullable: true } },

					ARTNAME: { type: "string", validation: { required: false, nullable: true } },

					DESCRIPTION: { type: "CLOB", validation: { required: false, nullable: true } },

					PRICE: { type: "DECIMAL", validation: { required: false, nullable: true } },

					LARGEIMAGE: { type: "string", validation: { required: false, nullable: true } },

					MEDIAID: { type: "number", validation: { required: false, nullable: true } },

					ISSOLD: { type: "boolean", validation: { required: false, nullable: true }, default_Value: "b'0'" }
					}
				}
			}
		} );

	var grid = $("#kendo_Grid_ART_JSON").kendoGrid({

		dataSource: dataSource,

		navigatable: true,

		sortable: true,

		filterable: true,

		editable: true,

		toolbar: ["create", "save", "cancel"],

		height: 400,

		columns: [

			{ field: "ARTID", title: "ARTID"},

			{ field: "ARTISTID", title: "ARTISTID"},

			{ field: "ARTNAME", title: "ARTNAME"},

			{ field: "DESCRIPTION", title: "DESCRIPTION"},

			{ field: "PRICE", title: "PRICE"},

			{ field: "LARGEIMAGE", title: "LARGEIMAGE"},

			{ field: "MEDIAID", title: "MEDIAID"},

			{ field: "ISSOLD", title: "ISSOLD"},

			{ command: "destroy", title: "&nbsp;", width: "110px" }]
	} );
} );
