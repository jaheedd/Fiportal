<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<head>
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript">
	function generateReport(format) {
		var action = "";
		if (format == 'Excel')
			action = "XslReportOfCbsAccBrRegionGrid.action";
		else if (format == 'PDF')
			action = "PdfReportOfCbsAccBrRegionGrid.action";
		var postData = $("#cbsAccBrRegionGrid").jqGrid("getGridParam",
				"postData");
		var filterString = $(".divSearchCondition").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString;
		document.forms['cbsAccBrRegionForm'].action = action + parameters;
		document.forms['cbsAccBrRegionForm'].submit();
	}

	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	$(document).ready(function() {
		var d = new Date();
		d.setDate(1);
		var month = d.getMonth() + 1;
		var date = d.getDate() + "/" + month + "/" + d.getFullYear();
		$("#dateStart").val(date);

	});
	$.subscribe('loadGrid', function(event, data) {
		$("#cbsAccBrRegionGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadGrids");
	});
	$.subscribe('onGridComplete', function(event, data) {
		var userdata = $("#cbsAccBrRegionGrid").jqGrid("getGridParam",
				"userData");
		$("#cbsAccRegWiseTblSummary").html(
				"<tr><td>TOTAL NUMBER OF ENROLLMENTS </td><td align='right'> "
						+ toInteger(userdata.enrollment) + "</td></tr>");
	});
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="cbsAccBrRegionForm" method="post" theme="css_xhtml">

		<table class="filterTable">
			<tr>
				<td><sj:datepicker name="startDate" id="dateStart"
						labelposition="left" showOn="focus" label="Select from Date"
						displayFormat="dd/mm/yy" readonly="false" maxDate="today"
						onChangeTopics="enableEndDate"
						onkeydown="return datepickerKeyDown(event);" /></td>
				<td><sj:datepicker name="endDate" id="dateEnd" value="today"
						label="Select to Date" showOn="focus" labelposition="left"
						displayFormat="dd/mm/yy" readonly="false" maxDate="today"
						onkeydown="return datepickerKeyDown(event);" /></td>
				<td><small> <sj:a button="true"
							buttonIcon="ui-icon-refresh" id="filter" name="filter"
							onClickTopics="loadGrid">
						Generate Report
					</sj:a></small></td>
			</tr>
		</table>
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="cbsAccBrRegionGridURL" action="cbsAccBrRegionGrid.action" />
		<sjg:grid id="cbsAccBrRegionGrid"
			caption="Branch Wise Enrollment Report" dataType="json"
			sortable="true" autowidth="true" formIds="cbsAccBrRegionForm"
			href="%{cbsAccBrRegionGridURL}" pager="true" sortname="regionName"
			gridModel="gridModel" viewrecords="true" rowList="10,15,20,25"
			rowNum="15" rownumbers="true" reloadTopics="reloadGrids"
			onCompleteTopics="onGridComplete" navigatorEdit="false"
			navigatorAdd="false" navigatorDelete="false" navigatorSearch="true"
			navigator="true" navigatorView="true" footerrow="true"
			userDataOnFooter="true" navigatorRefresh="false"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				marksearched:true,onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="regionName" index="regionName"
				title="Region Name" sortable="true" width="320" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="districtName" index="districtName"
				title="District Name" sortable="true" width="320" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="branchCode" index="branchCode"
				title="Branch Code" sortable="true" width="320" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="branchName" index="branchName"
				title="Branch Name" sortable="true" width="320" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="enrollment" index="enrollment" align="right"
				formatter="integer" title="Total Enrollment" sortable="true"
				width="100" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
		</sjg:grid>

		<table width="100%">
			<tr>
				<td width="60%"><table class="tblTotalSummary"
						id="cbsAccRegWiseTblSummary"></table></td>
			</tr>
		</table>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>

</body>
</html>
