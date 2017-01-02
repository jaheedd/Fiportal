<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- jquerytheme = south-street, redmod, lightness, humanity, cupertino -->
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	media="screen" title="Style">
<head>
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript">
	$.subscribe('districtCellSelection', function(event, data) {
		var grid = event.originalEvent.grid;
		var sel_id = grid.jqGrid('getGridParam', 'selrow');
		var districtCode = grid.jqGrid('getCell', sel_id, 'districtCode');
		var districtName = grid.jqGrid('getCell', sel_id, 'districtName');
		var captionText = "Taluka Wise Enrollments [District Code : "
				+ districtCode + ",  District Name : " + districtName + "]";
		$('#talukaGrid').jqGrid('setGridParam', {
			postData : {
				'districtCode' : districtCode,
				'districtName' : districtName
			}
		});
		$('#talukaGrid').jqGrid('setCaption', captionText);
		$('#talukaGrid').trigger("reloadGrid");
		$('#talukaGrid').jqGrid('setGridState', 'visible');
		$('#districtGrid').jqGrid('setGridState', 'hidden');
		$('#villageGrid').jqGrid('setGridState', 'hidden');
	});
	$.subscribe('onDistrictGridComplete', function(event, data) {
		$('#talukaGrid').jqGrid('setGridState', 'hidden');
		$('#villageGrid').jqGrid('setGridState', 'hidden');
	});
	$.subscribe('talukaCellSelection', function(event, data) {

		var grid = event.originalEvent.grid;
		var sel_id = grid.jqGrid('getGridParam', 'selrow');
		var talukaCode = grid.jqGrid('getCell', sel_id, 'talukaCode');
		var talukaName = grid.jqGrid('getCell', sel_id, 'talukaName');
		var captionText = "Village Wise Enrollments [Taluka Code : "
				+ talukaCode + ", Taluka Name : " + talukaName + "]";
		$('#villageGrid').jqGrid('setGridParam', {
			postData : {
				'talukaCode' : talukaCode,
				'talukaName' : talukaName
			}
		});
		$('#villageGrid').jqGrid('setCaption', captionText);
		$('#villageGrid').trigger("reloadGrid");
		$('#districtGrid').jqGrid('setGridState', 'hidden');
		$('#talukaGrid').jqGrid('setGridState', 'hidden');
		$('#villageGrid').jqGrid('setGridState', 'visible');
	});

	$.subscribe('loadTalukaTotal', function(event, data) {
		var userData = $('#talukaGrid').jqGrid('getGridParam', 'userData');
		$('#talukaGrid').jqGrid('footerData', 'set', {
			talukaName : userData.districtName,
			enrollments : userData.enrollments
		});
	});
	$.subscribe('loadVillageTotal', function(event, data) {
		var userData = $('#villageGrid').jqGrid('getGridParam', 'userData');
		$('#villageGrid').jqGrid('footerData', 'set', {
			bcName : userData.districtName,
			enrollments : userData.enrollments
		});
	});
	$.subscribe('ExportToExcelDistrict', function(pID, id) {
		generateReportDistrict('Excel');
	});
	$.subscribe('ExportToPDFDistrict', function(pID, id) {
		generateReportDistrict('PDF');
	});
	$.subscribe('ExportToExcelTaluka', function(pID, id) {
		generateReportTaluka('Excel');
	});
	$.subscribe('ExportToPDFTaluka', function(pID, id) {
		generateReportTaluka('PDF');
	});
	$.subscribe('ExportToExcelVillage', function(pID, id) {
		generateReportVillage('Excel');
	});
	$.subscribe('ExportToPDFVillage', function(pID, id) {
		generateReportVillage('PDF');
	});
	function getRecords(grid) {
		var records = $(grid).jqGrid("getGridParam", "records");
		if (records == 0)
			return false;
		else
			return true;
	}
	function generateReportDistrict(format) {

		var postData = $("#districtGrid").jqGrid("getGridParam", "postData");
		var action = "";
		if (format == 'Excel')
			action = "XslDistrictEnrollment.action";
		else if (format == 'PDF')
			action = "PdfDistrictEnrollment.action";
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord;
		document.forms['DistrictEnrollmentForm'].action = action + parameters;
		document.forms['DistrictEnrollmentForm'].submit();
	}
	function generateReportTaluka(format) {
		if (getRecords($("#talukaGrid"))) {
			var postData = $("#talukaGrid").jqGrid("getGridParam", "postData");
			var action = "";
			if (format == 'Excel' || format == '1')
				action = "XslTalukaEnrollment.action";
			else if (format == 'PDF')
				action = "PdfTalukaEnrollment.action";
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&districtCode=" + postData.districtCode
					+ "&districtName=" + postData.districtName;
			document.forms['DistrictEnrollmentForm'].action = action
					+ parameters;
			document.forms['DistrictEnrollmentForm'].submit();
		}
	}
	function generateReportVillage(format) {
		if (getRecords($("#villageGrid"))) {
			var postData = $("#villageGrid").jqGrid("getGridParam", "postData");
			var action = "";
			if (format == 'Excel' || format == '1')
				action = "XslVillageEnrollment.action";
			else if (format == 'PDF')
				action = "PdfVillageEnrollment.action";
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&talukaCode=" + postData.talukaCode
					+ "&talukaName=" + postData.talukaName;
			document.forms['DistrictEnrollmentForm'].action = action
					+ parameters;
			document.forms['DistrictEnrollmentForm'].submit();
		}
	}
</script>
</head>
<body>
	<hr color="#F28500">

	<s:form name="DistrictEnrollmentForm" id="DistrictEnrollmentForm"
		method="post" theme="simple">
		<s:url id="districtEnrReport" action="districtEnrReport.action" />
		<sjg:grid id="districtGrid" caption="District Wise Enrollments"
			onSelectRowTopics="districtCellSelection" dataType="json"
			cssStyle="cursor: pointer;" href="%{districtEnrReport}" pager="true"
			sortable="true" sortname="districtCode" gridModel="selectedList"
			viewrecords="true" onCellSelectTopics="" rowList="10,15,20,25"
			rowNum="15" rownumbers="true" width="1090" footerrow="true"
			shrinkToFit="true" navigator="true" navigatorAdd="false"
			navigatorDelete="false" navigatorSearch="false" navigatorView="true"
			navigatorEdit="false" userDataOnFooter="true"
			onCompleteTopics="onDistrictGridComplete"
			navigatorExtraButtons="{ seperator: {}, exportToExcel : {title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelDistrict'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFDistrict'}}">

			<sjg:gridColumn name="districtCode" index="districtCode"
				sorttype="integer" title="District Code" sortable="true" width="100"
				align="left" />
			<sjg:gridColumn name="districtName" index="districtName"
				sorttype="string" title="District Name" sortable="true" width="100" />
			<sjg:gridColumn name="enrollments" index="enrollments"
				sorttype="integer" title="Enrollments" sortable="true" width="100"
				align="right" formatter="integer" />
			<sjg:gridColumn name="temp" title="" search="false" sortable="false"
				width="100"></sjg:gridColumn>
		</sjg:grid>


		<s:url var="talukaGridURL" action="talukaEnrReport"></s:url>
		<sjg:grid id="talukaGrid" caption="Taluka Wise Enrollments"
			href="%{talukaGridURL}" dataType="json" pager="true"
			gridModel="selectedTalukaList" rownumbers="true" width="1090"
			cssStyle="cursor: pointer;" sortable="true" sortname="talukaCode"
			sortorder="asc" onSelectRowTopics="talukaCellSelection"
			viewrecords="true" onCellSelectTopics="" rowList="10,15,20,25"
			rowNum="15" shrinkToFit="true" footerrow="true"
			onCompleteTopics="loadTalukaTotal" navigator="true"
			navigatorAdd="false" navigatorDelete="false" navigatorSearch="false"
			navigatorView="true" navigatorEdit="false"
			navigatorExtraButtons="{ seperator: {}, exportToExcelTaluka : {title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelTaluka'}, exportToPDFTaluka : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFTaluka'}}">

			<sjg:gridColumn name="talukaCode" index="talukaCode"
				title="Taluka Code" sortable="true" align="left" width="100" />
			<sjg:gridColumn name="talukaName" index="talukaName"
				title="Taluka Name" sortable="true" width="100" />
			<sjg:gridColumn name="enrollments" index="enrollments"
				title="Enrollments" sortable="true" align="right"
				formatter="integer" width="100" />
			<sjg:gridColumn name="temp" title="" search="false" sortable="false"
				width="100"></sjg:gridColumn>
		</sjg:grid>
		<s:url var="villageGridURL" action="villageEnrReport"></s:url>
		<sjg:grid id="villageGrid" caption="Village Wise Enrollments"
			href="%{villageGridURL}" dataType="json" pager="true"
			rowList="10,15,20,25" rowNum="15" gridModel="selectedVillageList"
			sortable="true" viewrecords="true" sortname="villageCode"
			sortorder="asc" rownumbers="true" width="1090" footerrow="true"
			onCompleteTopics="loadVillageTotal" navigator="true"
			navigatorAdd="false" navigatorDelete="false" navigatorSearch="false"
			navigatorView="true" navigatorEdit="false" hiddengrid="false"
			shrinkToFit="true"
			navigatorExtraButtons="{ seperator: {}, exportToExcelVillage: {title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelVillage'}, exportToPDFVillage: { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFVillage'}}">

			<sjg:gridColumn name="villageCode" index="villageCode"
				title="Village Code" sortable="true" align="left" width="100" />
			<sjg:gridColumn name="villageName" index="villageName"
				title="Village Name" sortable="true" width="100" />
			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="false" align="left" width="100" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="100" />
			<sjg:gridColumn name="enrollments" index="enrollments"
				title="Enrollments" sortable="true" align="right"
				formatter="integer" width="100" />
			<sjg:gridColumn name="temp" title="" search="false" sortable="false"
				width="100"></sjg:gridColumn>
		</sjg:grid>
	</s:form>
</body>
</html>