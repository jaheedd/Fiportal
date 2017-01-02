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
			action = "XslReportOfInvoiceDifferenceGrid.action";
		else if (format == 'PDF')
			action = "pdfReportOfInvoiceDifferenceGrid.action";
		var postData = $("#invoiceGridID").jqGrid("getGridParam", "postData");
		var filterString = $(".divSearchCondition").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString;
		document.forms['invoiceDifferenceForm'].action = action + parameters;
		document.forms['invoiceDifferenceForm'].submit();
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
		$("#invoiceGridID").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadGrids");
	});
	$.subscribe('validateDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#dateEnd').datepicker('option', 'minDate', date);
		}
	});
	$.subscribe('onGridComplete', function(event, data) {
		var records = $("#invoiceGridID").jqGrid("getGridParam", "records");
		$("#invoiceDifferenceTblSummary").html(
				"<tr><td>TOTAL NUMBER OF ACCOUNTS GENERATED </td><td align='right'> "
						+toInteger(records) + "</td></tr>");
	});
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="invoiceDifferenceForm" method="post" theme="css_xhtml">

		<table class="filterTable">
			<tr>
				<td><sj:datepicker name="startDate" id="dateStart"
						labelposition="left" showOn="focus" label="Select from Date"
						displayFormat="dd/mm/yy" readonly="false" maxDate="today"
						onChangeTopics="validateDate"
						onkeydown="return datepickerKeyDown(event);" /></td>
				<td><sj:datepicker name="endDate" id="dateEnd"
						label="Select to Date" showOn="focus" value="today"
						labelposition="left" displayFormat="dd/mm/yy" readonly="false"
						maxDate="today" onkeydown="return datepickerKeyDown(event);" /></td>
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
		<s:url var="invoiceDifferenceGridURL" action="invoiceDifferenceGrid.action" />
		<sjg:grid id="invoiceGridID" caption="Invoice Difference Report"
			dataType="json" sortable="true" autowidth="true"
			formIds="invoiceDifferenceForm" href="%{invoiceDifferenceGridURL}" pager="true"
			sortname="branchCode" gridModel="gridModel" viewrecords="true"
			rowList="10,15,20,25" rowNum="15" rownumbers="true"
			onCompleteTopics="onGridComplete" reloadTopics="reloadGrids"
			navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
			navigatorSearch="true" navigator="true" navigatorView="true" navigatorRefresh="false"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch,dragable:true}"
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
			<sjg:gridColumn name="custName" index="custName"
				title="Customer Name" sortable="true" width="320" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="cbsAcc" index="cbsAcc" title="CBS Account No."
				sortable="true" width="200" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
		</sjg:grid>

		<table width="100%">
			<tr>
				<td width="60%"><table class="tblTotalSummary"
						id="invoiceDifferenceTblSummary"></table></td>
			</tr>
		</table>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>

</body>
</html>
