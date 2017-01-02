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
	title="Style">
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<head>
<script>
	function stateChange() {
		removeSelectValues("talukaSelect");
	}
	function changeFilter(option) {
		if (option == 'state') {
			removeSelectValues("pmSelect");
			removeSelectValues("acSelect");
			$("#pmSelect").attr("disabled", "true");
			$("#acSelect").attr("disabled", "true");
			$("#stateSelect").removeAttr("disabled");
			$("#districtSelect").removeAttr("disabled");
			$("#talukaSelect").removeAttr("disabled");
			$.publish('reloadStateList');
		} else if (option == 'pm_ac') {
			removeSelectValues("stateSelect");
			removeSelectValues("districtSelect");
			removeSelectValues("talukaSelect");
			$("#stateSelect").attr("disabled", "true");
			$("#districtSelect").attr("disabled", "true");
			$("#talukaSelect").attr("disabled", "true");
			$("#pmSelect").removeAttr("disabled");
			$("#acSelect").removeAttr("disabled");
			$.publish('reloadMPList');
			$.publish('reloadAcList');
		}
	}
	function talukaChange() {
		$("#endDate").val('');
		$("#startDate").val('');
	}

	function loadDivTotal() {
		var totalValue = $("#reverseMigrationGrid").jqGrid("getGridParam",
				"userData");
		$('#divTotal')
				.html(
						"<strong><table cellpadding='7' cellspacing='7' class='tblTotalSummary'> <tr>"
								+ "<td>TOTAL A/c RECEIVED FROM BANK </td><td align='right'>"
								+ toInteger(totalValue.totalReceived)
								+ "</td></tr><tr><td> TOTAL FP CAPTURED</td><td align='right'>"
								+ toInteger(totalValue.totalCaptured)
								+ "</td></tr><tr><td> FP UPLOADED TO BANK </td><td align='right'>"
								+ toInteger(totalValue.fpUploadedToBank)
								+ "</td></tr><tr><td>PENDING TO CAPTURE FP</td><td align='right'>"
								+ toInteger(totalValue.pendingToCapture)
								+ "</td></tr><tr><td>TOTAL FP MAPPING WITH FIGS </td><td align='right'>"
								+ toInteger(totalValue.totalFpMappedWithBank)
								+ "</td></tr><tr><td>FP MAPPING PENDING FROM BANK </td><td align='right'>"
								+ toInteger(totalValue.fpMappingPendingfromBank)
								+ "</td></tr><tr><td>TOTAL TRANSACTIONS</td><td align='right'>"
								+ toInteger(totalValue.txnCount)
								+ "</td></tr></table></strong>");

	}
	$.subscribe('validateDate', function(event, data) {
		var date = event.originalEvent.dateText;
		// event.originalEvent.inst
		if (date != "")
			$('#endDate').datepicker('option', 'minDate', date);
		$("#endDate").removeAttr("disabled");

	});
	function getRecords() {
		return $("#reverseMigrationGrid").jqGrid("getGridParam", "records");
	}
	function getFilterVO() {
		var stateName = $("#stateSelect option:selected").text().split(':')[0]
				.trim();
		var districtName = $("#districtSelect option:selected").text().split(
				':')[0].trim();
		var talukaName = $("#talukaSelect option:selected").text().split(':')[0]
				.trim();
		var pmName = $("#pmSelect option:selected").text().split(':')[0].trim();
		var acName = $("#acSelect option:selected").text().split(':')[0].trim();
		var filterVO = stateName + "," + districtName + "," + talukaName + ","
				+ pmName + "," + acName;

		return filterVO;
	}
	function generateReport(format) {
		if (getRecords()) {
			var action = "";
			if (format == 'Excel')
				action = "XslReverseMigration.action";
			else if (format == 'PDF')
				action = "PdfReverseMigration.action";
			var postData = $("#reverseMigrationGrid").jqGrid("getGridParam",
					"postData");
			var filterString = $(".divSearchCondition").text();
			var filterVO = getFilterVO();
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&filters=" + postData.filters
					+ "&filterString=" + filterString + "&filterVO=" + filterVO;
			document.forms['reverseMigrationFormID'].action = action
					+ parameters;
			document.forms['reverseMigrationFormID'].submit();
		}
	}
	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	$.subscribe('gridComplete', function(event, data) {
		loadDivTotal();
	});
	$.subscribe('loadGrid', function(event, data) {
		$("#reverseMigrationGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});//.trigger("reloadGrid");
		$.publish("reloadGrids");
	});
	function datepickerKeyPress(event) {
		if (event.which == 8) {
			var id = '#' + event.target.id + '';
			$(id).val("");
			return true;
		} else
			return false;
	}
</script>
</head>
<body>
	<hr color="#F28500">

	<s:form name="reverseMigrationFormID" id="reverseMigrationFormID"
		method="post" theme="css_xhtml">

		<table cellpadding="8" class="filterTable" width="90%">
			<tr>
				<td rowspan="1" style="max-width: 30px; min-width: 20px;"><input
					id="filterOptionsstate" type="radio" value="state"
					name="filterOptions" align="middle" checked="checked"
					onchange="changeFilter('state');"></td>
				<td><s:url var="stateListUrl" action="loadStateList.action" />
					<img id="stateListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <sj:select id="stateSelect"
						headerKey="-1" headerValue="All" list="stateList"
						href="%{stateListUrl}" label="State" labelposition="left"
						indicator="stateListIndicator" onChangeTopics="reloadDistrictList"
						labelSeparator="<br>" listValue="displayValue" listKey="key"
						name="stateCode" onchange="stateChange()"
						reloadTopics="reloadStateList" /></td>
				<td><img id="districtListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="districtListUrl"
						action="loadDistrictByStateEnr" /> <sj:select headerKey="-1"
						id="districtSelect" label="District" labelposition="left"
						indicator="districtListIndicator" deferredLoading="true"
						listCssStyle="white-space:pre;float:right;" labelSeparator="<br>"
						headerValue="All" href="%{districtListUrl}" list="districtList"
						listValue="displayValue" listKey="key" name="districtCode"
						reloadTopics="reloadDistrictList"
						onChangeTopics="reloadTalukaList" /></td>
				<td><img id="talukaListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="talukaListUrl"
						action="loadTalukaByDistEnr" /> <sj:select headerKey="-1"
						id="talukaSelect" label="Taluka" labelposition="left"
						indicator="talukaListIndicator" labelSeparator="<br>"
						headerValue="All" deferredLoading="true" href="%{talukaListUrl}"
						list="talukaList" listValue="displayValue" listKey="key"
						name="talukaCode" reloadTopics="reloadTalukaList" /></td>

			<%-- 	<td rowspan="2"><fieldset class="dateFields">
						<legend>Date</legend>
						<sj:datepicker name="startDate" id="startDate"
							labelposition="left" showOn="focus" label="From Date "
							labelSeparator="<br>" onChangeTopics="validateDate"
							displayFormat="dd/mm/yy" readonly="false" maxDate="today"
							onkeydown="return datepickerKeyDown(event);" />
						<sj:datepicker name="endDate" id="endDate" disabled="true"
							labelSeparator="<br>" label="To Date " showOn="focus"
							labelposition="left" displayFormat="dd/mm/yy" readonly="false"
							maxDate="today" onkeydown="return datepickerKeyDown(event);" />
					</fieldset></td> --%>
				<td rowspan="2" align="center"><sj:a button="true"
						buttonIcon="ui-icon-refresh" id="filter" name="filter"
						onClickTopics="loadGrid">
						Generate Report
					</sj:a></td>
			</tr>
			<tr>
				<td><input id="filterOptionspm_ac" type="radio" value="pm_ac"
					name="filterOptions" align="middle"
					onchange="changeFilter('pm_ac');"></td>
				<td><img id="pmListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="pmListUrl"
						action="loadPMList" /> <sj:select headerKey="-1" id="pmSelect"
						href="%{pmListUrl}" deferredLoading="true"
						reloadTopics="reloadMPList" indicator="pmListIndicator"
						label="Project Manager" labelposition="left" labelSeparator="<br>"
						headerValue="All" list="pmList" listKey="key"
						listValue="displayValue" name="pmCode" disabled="true"
						onChangeTopics="reloadAcList" /></td>

				<td><img id="acListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="acListUrl"
						action="loadACByPM" /> <sj:select headerKey="-1" id="acSelect"
						formIds="reverseMigrationFormID" href="%{acListUrl}"
						indicator="acListIndicator" label="Area Coordinator "
						labelposition="left" labelSeparator="<br>" headerValue="All"
						list="acList" listKey="key" listValue="displayValue"
						disabled="true" reloadTopics="reloadAcList" name="acCode" /></td>
				<td></td>
				<td></td>
				<td></td>

			</tr>
		</table>
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="loadGrid" action="reverseMigrationGrid.action" />
		<sjg:grid id="reverseMigrationGrid" caption="Reverse Migration Report"
			href="%{loadGrid}" dataType="json" pager="true" autowidth="true"
			sortable="true" sortname="bcCode" gridModel="selectedListVO"
			shrinkToFit="false" rowList="10,15,20,25" rowNum="15"
			rownumbers="true" viewrecords="true" formIds="reverseMigrationFormID"
			reloadTopics="reloadGrids" navigatorAdd="false"
			navigatorRefresh="false" navigatorDelete="false"
			navigatorSearch="true" navigator="true" navigatorView="true"
			navigatorEdit="false" footerrow="true" userDataOnFooter="true"
			onCompleteTopics="gridComplete"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				marksearched:true,onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="true" align="center" width="70" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
				sortable="false" align="center" width="85" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="cbsOdAcc" index="cbsOdAcc" title="BC OD A/c"
				sortable="true" width="90" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="stateName" index="stateName" title="State Name"
				sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="districtName" index="districtName"
				title="District Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="talukaName" index="talukaName"
				title="Taluka Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="villageName" index="villageName"
				title="Village Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="branchName" index="branchName"
				title="Branch Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="regionName" index="regionName"
				title="Region Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="totalReceived" index="totalReceived"
				formatter="integer" title="Total A/c Received From Bank"
				sortable="true" align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="totalCaptured" index="totalCaptured"
				formatter="integer" title="Total FP Captured" sortable="true"
				align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="fpUploadedToBank" index="fpUploadedToBank"
				formatter="integer" title="FP Uploaded To Bank" sortable="true"
				align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="pendingToCapture" index="pendingToCapture"
				align="right" title="Pending To Capture FP" sortable="true"
				formatter="integer" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="totalFpMappedWithBank" index="totalFpMappedWithBank"
				align="right" title="Total FP Mapping With FIGS " sortable="true"
				width="70" search="true" formatter="integer"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="fpMappingPendingfromBank" index="fpMappingPendingfromBank" align="right"
				title="FP Mapping Pending From Bank" formatter="integer"
				sortable="true" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="txnCount" index="txnCount" align="right"
				title="Total Transactions" formatter="integer" sortable="true"
				width="70" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="" index="" search="false" sortable="false"
				displayTitle="false" width="20" align="right" title="" />
		</sjg:grid>
		<table>
			<tr>
				<td width="700"><sj:div id="divTotal">
					</sj:div></td>
			</tr>

		</table>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>
</body>
</html>