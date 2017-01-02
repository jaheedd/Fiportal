<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript">
	function generateReport(format) {
		var action = "";
		if (format == 'Excel')
			action = "XslReportBC_OD_Balance.action";
		else if (format == 'PDF')
			action = "PdfReportBC_OD_Balance.action";
		var filterString = $(".divSearchCondition").text();
		var postData = $("#BCODBalanceGrid").jqGrid("getGridParam", "postData");
		var pmName = $("#pmSelect option:selected").text().split(':')[0].trim();
		var acName= $("#acSelect option:selected").text().split(':')[0].trim();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString + "&pmName=" + pmName + "&acName=" +acName;
		document.forms['BCODBalanceForm'].action = action + parameters;
		document.forms['BCODBalanceForm'].submit();

	}
	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	/* $.subscribe('loadGrid', function(event, data) {
		$("#BCODBalanceGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadGrids");
	}); */
	$.subscribe('reloadBCODGrid', function(event, data) {
		$("#BCODBalanceGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});//.trigger("reloadGrid");
		$.publish("reloadBCODReportGrid");
	});
	$.subscribe('onGridComplete', function(event, data) {
		var records = $("#BCODBalanceGrid").jqGrid("getGridParam", "records");
		$("#bcodTblSummary").html(
				"<tr><td>TOTAL NUMBER OF BCs WITH OD A/c </td><td align='right'> "
						+ records + "</td></tr>");
	});
</script>
</head>

<body>
	<hr color="#F28500">
	<s:form id="BCODBalanceForm" name="BCODBalanceForm" theme="css_xhtml"
		method="post">
		<table cellpadding="8" class="filterTable" width="70%">
			<tr>
				<td><s:url var="pmListUrl" action="loadPMList" /> 
				<img id="pmListIndicator" class="indicator-small"
					src="images/indicator_small.gif" />
				<sj:select headerKey="-1" id="pmSelect" href="%{pmListUrl}"
						label="Project Manager" labelposition="left" labelSeparator="<br>"
						headerValue="All" list="pmList" listKey="key"
						listValue="displayValue" name="pmCode"
						onChangeTopics="reloadAcList" /></td>

				<td><img id="acListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="acListUrl"
						action="loadACByPM" /> <sj:select headerKey="-1" id="acSelect"
						formIds="BCODBalanceForm" href="%{acListUrl}"
						labelSeparator="<br>" indicator="acListIndicator"
						label="Area Coordinator " labelposition="left" headerValue="All"
						list="acList" listKey="key" listValue="displayValue"
						reloadTopics="reloadAcList" name="acCode" /></td>
				<td rowspan="2" align="center"><sj:a button="true"
						buttonIcon="ui-icon-refresh" id="filter" name="filter"
						onClickTopics="reloadBCODGrid">
						Generate Report
					</sj:a></td>
			</tr>
		</table>
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="BCODBalanceURL" action="BCODBalanceGrid.action" />
		<sjg:grid id="BCODBalanceGrid" caption="BC OD Balance Report"
			dataType="json" href="%{BCODBalanceURL}" pager="true"
			sortname="bcOdAc" sortable="true" autowidth="true"
			gridModel="selectedList" rowList="10,15,20,25" rowNum="15"
			viewrecords="true" rownumbers="true" formIds="BCODBalanceForm"
			reloadTopics="reloadGrids" onCompleteTopics="onGridComplete"
			reloadTopics="reloadBCODReportGrid" navigatorEdit="false"
			navigatorAdd="false" navigatorDelete="false" navigatorRefresh="false"
			navigatorSearch="true" navigator="true" navigatorView="true"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="bcOdAc" index="bcOdAc" title="BC OD A/c No."
				sortable="true" width="90" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="bcbfCode" index="bcbfCode" title="BC BF Code"
				sortable="true" width="70" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="true" width="60" align="center" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="160" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="balance" index="balance" formatter="currency"
				align="right" title="Available Balance" sortable="true" width="90"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="balanceDate" index="balanceDate"
				title="Balance Date" formatter="date" align="center"
				formatoptions="{newformat : 'd-M-y g:i A', srcformat : 'Y-m-d g:i k'}"
				sortable="true" width="100" search="true"
				searchoptions="{sopt:['cn','bw'],dataInit:dateField}" />
		</sjg:grid>
		<table width="100%">
			<tr>
				<td width="60%"><table class="tblTotalSummary"
						id="bcodTblSummary"></table></td>
			</tr>

		</table>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>
</body>
</html>
