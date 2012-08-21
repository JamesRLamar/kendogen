<cfparam name="url.overwrite" default="false">
<!DOCTYPE html>
<html>
<head>
<title>KENDO UI DEMO</title>
<link href="kendoui/examples/content/shared/styles/examples-offline.css" rel="stylesheet">
<link href="kendoui/styles/kendo.common.min.css" rel="stylesheet">
<link href="kendoui/styles/kendo.default.min.css" rel="stylesheet">
<script src="kendoui/js/jquery.min.js"></script>
<script src="kendoui/js/kendo.web.min.js"></script>
<script src="kendoui/examples/content/shared/js/console.js"></script>
</head>
<body>
<h1>KENDO UI DEMO</h1>
<div id="example" class="k-content">
	<cfinclude template="KENDO.cfc">
	<cfoutput>#KENDO_Get_Grid( model = "art", include = true, pKey = "ARTISTID", overwrite = url.overwrite )#</cfoutput>
</div>
</body>
</html>
