<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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
			$.publish('reloadDistrictList');
			$.publish('reloadDistrictList');
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
		var totalValue = $("#enrollmentAndTxnGrid").jqGrid("getGridParam",
				"userData");
		$('#divTotal')
				.html(
						"<strong><table cellpadding='5' cellspacing='5' class='tblTotalSummary'> <tr>"
								+ "<td>TOTAL ENROLLMENTS</td><td align='right'>"
								+ toInteger(totalValue.enrollment)
								+ "</td><td>TOTAL AUTHORIZED</td><td align='right'>"
								+ toInteger(totalValue.authorized)
								+ "</td></tr><tr><td>TOTAL DEPOSIT TRANSACTION COUNT</td><td align='right'>"
								+ toInteger(totalValue.cdCount)
								+ "</td><td>TOTAL DEPOSIT TRANSACTION AMOUNT(in Rs.)</td><td align='right'>"
								+ toCurrency(totalValue.cdAmount)
								+ "</td></tr><tr><td>TOTAL FUND TRANSFER TRANSACTION COUNT</td><td align='right'>"
								+ toInteger(totalValue.ftCount)
								+ "</td><td>TOTAL FUND TRANSFER TRANSACTION AMOUNT(in Rs.)</td><td align='right'>"
								+ toCurrency(totalValue.ftAmount)
								+ "</td></tr><tr><td>TOTAL WITHDRAWAL TRANSACTION COUNT</td><td align='right'>"
								+ toInteger(totalValue.cwCount)
								+ "</td><td>TOTAL WITHDRAWAL TRANSACTION AMOUNT(in Rs.)</td><td align='right'>"
								+ toCurrency(totalValue.cwAmount)
								+ "</td></tr><tr><td>TOTAL TRANSACTION COUNT</td><td align='right'>"
								+ toInteger(totalValue.totalTxnCount)
								+ "</td><td>TOTAL TRANSACTION AMOUNT(in Rs.)</td><td align='right'>"
								+ toCurrency(totalValue.totalTxnAmount)
								+ "</td></tr></table></strong>");

	}
	$.subscribe('validateEnrDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "")
			$('#enrEndDate').datepicker('option', 'minDate', date);
		$("#enrEndDate").removeAttr("disabled");

	});
	/* $.subscribe('validateTxnDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "")
			$('#txnEndDate').datepicker('option', 'minDate', date);
		$("#txnEndDate").removeAttr("disabled");

	}); */
	function getRecords() {
		return $("#enrollmentAndTxnGrid").jqGrid("getGridParam", "records");
	}
	function getFilterVO() {
		var stateName = $("#stateSelect option:selected").text().split(':')[0]
				.trim();
		var districtName = $("#districtSelect option:selected").text().split(
				':')[0].trim();
		var talukaName = $("#talukaSelect option:selected").text().split(':')[0]
				.trim();
		var pmName = $("#pmSelect option:selected").text().split(':')[0]
				.trim(); 
		var acName = $("#acSelect option:selected").text().split(':')[0]
		.trim(); 
		var filterVO = stateName + "," + districtName + "," + talukaName+","+pmName+","+acName;

		return filterVO;
	}
	function generateReport(format) {
		var action = "";
		if (format == 'Excel')
			action = "XslEnrollmentAndTxn.action";
		else if (format == 'PDF')
			action = "PdfEnrollmentAndTxn.action";
		var postData = $("#enrollmentAndTxnGrid").jqGrid("getGridParam",
				"postData");
		var filterString = $(".divSearchCondition").text();
		var filterVO = getFilterVO();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString + "&filterVO=" + filterVO;

		document.forms['enrollmentAndTxnID'].action = action + parameters;
		document.forms['enrollmentAndTxnID'].submit();
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
		$("#enrollmentAndTxnGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});//.trigger("reloadGrid");
		$.publish("reloadGrids");
	});
</script>
</head>
<body>
	<hr color="#F28500">

	<s:form id="enrollmentAndTxnID" method="post" theme="css_xhtml">

		<table cellpadding="8" class="filterTable" width="90%">
			<tr>
				<td rowspan="1" style="max-width: 30px; min-width: 20px;">
					<input id="filterOptionsstate" type="radio" value="state"
					name="filterOptions" align="middle" checked="checked"
					onchange="changeFilter('state');">

				</td>
				<td><s:url var="stateListUrl" action="loadStateList" />
				<img id="stateListIndicator" class="indicator-small" src="images/indicator_small.gif" /> 
				<sj:select id="stateSelect" headerKey="-1" headerValue="All" list="stateList" href="%{stateListUrl}"
						label="State" labelposition="left" indicator="stateListIndicator" onChangeTopics="reloadDistrictList"
						labelSeparator="<br>" listValue="displayValue" listKey="key"
						name="stateCode" onchange="stateChange()" reloadTopics="reloadStateList" /></td>
				<td><img id="districtListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="districtListUrl"
						action="loadDistrictByStateEnr" /> <sj:select headerKey="-1"
						id="districtSelect" label="District" labelposition="left"
						value="-1" deferredLoading="true"
						indicator="districtListIndicator"
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
				<td rowspan="2"><fieldset class="dateFields">
						<legend>Date</legend>
						<sj:datepicker name="enrStartDate" id="enrStartDate"
							labelposition="left" showOn="focus" label="From Date "
							labelSeparator="<br>" onChangeTopics="validateEnrDate"
							displayFormat="dd/mm/yy" readonly="false" maxDate="today"
							onkeydown="return datepickerKeyDown(event);" />
						<sj:datepicker name="enrEndDate" id="enrEndDate" disabled="true"
							labelSeparator="<br>" label="To Date " showOn="focus"
							labelposition="left" displayFormat="dd/mm/yy" readonly="false"
							maxDate="today" onkeydown="return datepickerKeyDown(event);" />
					</fieldset></td>
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
					src="images/indicator_small.gif" />
				<s:url var="pmListUrl" action="loadPMList" /> <sj:select 
						headerKey="-1" id="pmSelect" href="%{pmListUrl}"
						deferredLoading="true" reloadTopics="reloadMPList" indicator="pmListIndicator"
						label="Project Manager" labelposition="left" labelSeparator="<br>"
						headerValue="All" list="pmList" listKey="key"
						listValue="displayValue" name="pmCode" disabled="true"
						onChangeTopics="reloadAcList" /></td>

				<td><img id="acListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="acListUrl"
						action="loadACByPM" /> <sj:select headerKey="-1" id="acSelect"
						formIds="enrollmentAndTxnID" href="%{acListUrl}"
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
		<s:url var="loadGrid" action="enrollmentAndTxnGrid.action" />
		<sjg:grid id="enrollmentAndTxnGrid"
			caption="BC wise Enrollment and Transaction Summary"
			href="%{loadGrid}" dataType="json" pager="true" autowidth="true"
			sortable="true" sortname="bcCode" gridModel="selectedListVO"
			shrinkToFit="false" rowList="10,15,20,25" rowNum="15"
			rownumbers="true" viewrecords="true" formIds="enrollmentAndTxnID"
			reloadTopics="reloadGrids" navigatorAdd="false"
			navigatorDelete="false" navigatorSearch="true" navigator="true"
			navigatorView="true" navigatorEdit="false" footerrow="true"
			userDataOnFooter="true" onCompleteTopics="gridComplete"
			navigatorRefresh="false"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true,
			odata:[{ oper:'nu', text:'is null'}, { oper:'nn', text:'is not null'},{ oper:'is', text:'is'},{ oper:'eq', text:'equal'}], 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">


			<sjg:gridColumn name="regionName" index="regionName"
				title="Region Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="districtName" index="districtName"
				title="District Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="branchCode" index="branchCode"
				title="Branch Code" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" align="center" />
			<sjg:gridColumn name="branchName" index="branchName"
				title="Branch Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="ssaName" index="ssaName" title="SSA Name"
				sortable="true" align="left" width="85" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="population" index="population"
				title="Population" sortable="true" align="center" width="85"
				search="true" searchtype="select"
				searchoptions=" {sopt:['is'],value:'0:More than 10000; 1:5000 - 10000; 2:2000 - 5000;3:1600 - 2000; 4:1000 - 1600; 5:500 - 1000; 6:0 - 500'}" />
			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="true" align="center" width="70" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq']}" />
			<sjg:gridColumn name="bcbfCode" index="bcbfCode" title="BCBF Code"
				sortable="true" width="100" search="true"
				searchoptions=" {sopt:['cn','bw','eq','nu','nn']}" />
			<sjg:gridColumn name="enrollment" index="enrollment"
				formatter="integer" title="Total Enrollments" sortable="true"
				align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="authorized" index="authorized"
				title="Total Enrollments Authorized" sortable="true" align="right"
				width="70" search="true" formatter="integer"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="cdCount" index="cdCount" title="Deposit Count"
				sortable="true" align="right" width="70" search="true"
				formatter="integer" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="cdAmount" index="cdAmount"
				title="Deposit Amount (in Rs.)" sortable="true" align="right"
				formatter="currency" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="ftCount" index="ftCount" align="right"
				title="FT Count" sortable="true" formatter="integer" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="ftAmount" index="ftAmount" formatter="currency"
				align="right" title="FT Amount (in Rs.)" sortable="true" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="cwCount" index="cwCount"
				title="Withdrawal Count" sortable="true" align="right" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}"
				formatter="integer" />
			<sjg:gridColumn name="cwAmount" index="cwAmount"
				title="Withdrawal Amount (in Rs.)" sortable="true" align="right"
				formatter="currency" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="totalTxnCount" index="totalTxnCount"
				align="right" title="Total Txn Count" sortable="true"
				formatter="integer" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="totalTxnAmount" index="totalTxnAmount"
				formatter="currency" align="right" title="Total Txn Amount (in Rs.)"
				sortable="true" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
		</sjg:grid>
		<table>
			<tr>
				<td><sj:div id="divTotal">
					</sj:div></td>
			</tr>

		</table>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>
</body>
</html>