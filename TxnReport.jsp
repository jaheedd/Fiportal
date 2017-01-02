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
	function getTxnByType(bcCode, bcName, txnType) {
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		$('#detailDialog').dialog('option', 'title', bcCode + " : " + bcName);
		$('#detailDialog').dialog('open');
		$('#dlgTable').html('');
		$('#dateField').html('');
		$('#txtTxnType').html("Loading..........");
		showLargeIndicator();
		$.getJSON('bcTxnByType.action', {
			'bcCode' : bcCode,
			'txnType' : txnType,
			'startDate' : startDate,
			'endDate' : endDate
		}, function(jData) {
			var txnData = jData.txnByTypeVOs;
			if (jData.records == 0)
				;
			else {
				var indicatorTH = "";
				var toAccTH = "";
				if (txnType == "Financial") {
					indicatorTH = "<th>Txn Type</th>";
					toAccTH = "<th>Transfer To A/c</th><th>Txn to Name</th>";
				}
				if (txnType == "Non Financial") {
					indicatorTH = "<th>Txn Type</th>";
				}
				if (txnType == "Fund Transfer") {
					toAccTH = "<th>Transfer To A/c</th><th>Transfer to Name</th>";
				}
				if (txnType == "Total") {
					toAccTH = "<th>Txn Type</th><th>Transfer To A/c</th><th>Transfer To Name</th>";
				}

				$('#txtTxnType').html("Txn Type : " + txnType);
				if (startDate != "" && endDate != "") {
					$('#dateField').html("From  " + startDate + " To " + endDate);
				}
				hideLargeIndicator();
				$('#dlgTable').html(
						"<tr><th>Txn Time</th><th>PT RRN No.</th><th>Customer A/c No.</th><th >Customer Name</th><th >Txn Amount</th>" + indicatorTH
								+ "<th>Txn Mode</th>" + "<th>Balance</th>" + toAccTH + "</tr>");
				for ( var i in txnData) {
					var indicator = "";
					var toAcc = "";
					if (txnType == "Financial") {
						indicator = "</td><td>" + txnData[i].txnType;
						toAcc = "<td>" + txnData[i].toAcc + "</td><td>" + txnData[i].toName + "</td>";
					}
					if (txnType == "Non Financial") {
						indicator = "</td><td>" + txnData[i].txnType;
					}
					if (txnType == "Fund Transfer") {
						toAcc = "<td>" + txnData[i].toAcc + "</td><td>" + txnData[i].toName + "</td>";
					}
					if (txnType == "Total") {
						toAcc = "<td>" + txnData[i].txnType + "</td><td>" + txnData[i].toAcc + "</td><td>" + txnData[i].toName + "</td>";
					}
					$('#dlgTable').append(
							"<tr><td>" + txnData[i].txnTime + "</td><td>" + txnData[i].ptrrnNo + "</td><td>" + txnData[i].accNo + "</td><td>"
									+ txnData[i].custName + "</td><td align='right'>" + toCurrency(txnData[i].txnAmount) + indicator + "</td><td>"
									+ txnData[i].txnMode + "</td><td align='right'>" + toCurrency(txnData[i].balance) + "</td>" + toAcc + "</tr>");
				}
			}
		});

	}
	$.subscribe('cellSelection', function(event, data) {
		//event.originalEvent.rowid, event.originalEvent.iCol, event.originalEvent.cellcontent, event.originalEvent.e

		var rowid = event.originalEvent.rowid;
		var rowdata = jQuery("#bcTxnGrid").jqGrid('getRowData', rowid);
		var cellId = event.originalEvent.iCol;
		var bcCode = $(rowdata.bcCode).html();
		var bcName = $(rowdata.bcName).html();
		switch (cellId) {
		case 1:
		case 2:
			getTxnByType(bcCode, bcName, "Total");
			break;
		case 12:
			getTxnByType(bcCode, bcName, "Deposit");
			break;
		case 14:
			getTxnByType(bcCode, bcName, "Withdrawal");
			break;
		case 16:
			getTxnByType(bcCode, bcName, "Fund Transfer");
			break;
		case 20:
			getTxnByType(bcCode, bcName, "Financial");
			break;
		case 22:
			getTxnByType(bcCode, bcName, "Non Financial");
			break;
		case 23:
			getTxnByType(bcCode, bcName, "Total");
			break;
		default:
			;
		}
	});

	$.subscribe('loadDivTotal', function(event, data) {
		var totalValue = $("#bcTxnGrid").jqGrid("getGridParam", "userData");
		/*$("#bcTxnGrid").jqGrid("footerData", "set", totalValue,
				false); 
		 */
		$('#divTotal').html(
				"<strong><table cellpadding='5' cellspacing='5' class='tblTotalSummary'> <tr>"
						+ "<td> TOTAL TRANSACTION COUNT </td><td align='right'>"
						+ toInteger(totalValue.txnTotCount)
						+ "</td><td> TOTAL TRANSACTION AMOUNT </td><td align='right'>"
						+ toCurrency(totalValue.finTxnAmt)
						+ "</td></tr><tr><td> CASH DEPOSIT COUNT</td><td align='right'>"
						+ toInteger(totalValue.txnCD)
						+ "</td><td> CASH DEPOSIT AMOUNT</td><td align='right'>"
						+ toCurrency(totalValue.txnAmtCD)
						+ "</td></tr><tr><td> CASH WITHDRAWAL COUNT</td><td align='right'>"
						+ toInteger(totalValue.txnCW)
						+ "</td><td> CASH WITHDRAWAL AMOUNT</td><td align='right'>"
						+ toCurrency(totalValue.txnAmtCW)
						+ "</td></tr><tr><td> FUND TRANSFER COUNT</td><td align='right'>"
						+ toInteger(totalValue.txnFT)
						+ "</td><td> FUND TRANSFER AMOUNT</td><td align='right'>"
						+ toCurrency(totalValue.txnAmtFT)
						+ "</td></tr><tr><td> FINANCIAL TRANSACTION COUNT</td><td align='right'>"
						+ toInteger(totalValue.finTxn)
						+ "</td><td> FINANCIAL TRANSACTION AMOUNT</td><td align='right'>"
						+ toCurrency(totalValue.finTxnAmt)
						+ "</td></tr><tr><td> MINI STATEMENT COUNT</td><td align='right'>"
						+ toInteger(totalValue.txnMiniStmt)
						+ "</td></tr><tr><td> BALANCE ENQUIRY COUNT</td><td align='right'>"
						+ toInteger(totalValue.txnBalEq)
						+ "</td></tr><tr><td>NON FINANCIAL TRANSACTION COUNT </td><td align='right'>"
						+ toInteger(totalValue.nonFinTxn)
						+ "</td></tr></table></strong>");
	});

	//function loadGrid() {
		$.subscribe('loadGrid', function(event, data) {
		$("#bcTxnGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadGrids");
	});
	$.subscribe('validateDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#endDate').datepicker('option', 'minDate', date);
			$("#endDate").removeAttr("disabled");
		}
	});
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
	function stateChange() {
		removeSelectValues("talukaSelect");
	}
 
	function exportToXslDlg() {
		//var txnType =document.getElementById("dlgTable").rows.item(0).innerHTML.split(':')[1].split('<')[0];
		var txnType = $('#txtTxnType').html().split(':')[1];
		var bcCode = $("#detailDialog").dialog("option", "title");

		document.forms['txnReportForm'].action = "exportToXslTxnDlg.action?txnType=" + txnType + "&bcCode=" + bcCode;
		document.forms['txnReportForm'].submit();
	}
	function exportToPdfDlg() {
		//var txnType =document.getElementById("dlgTable").rows.item(0).innerHTML.split(':')[1].split('<')[0];
		var txnType = $('#txtTxnType').html().split(':')[1];
		var bcCode = $("#detailDialog").dialog("option", "title");
		document.forms['txnReportForm'].action = "exportToPdfTxnDlg.action?txnType=" + txnType + "&bcCode=" + bcCode;
		document.forms['txnReportForm'].submit();
	}
	function generateXslReport() {
		if (getRecords()) {
			var stateName = $("#stateSelect option:selected").text().split(':')[0].trim();
			var districtName = $("#districtSelect option:selected").text().split(':')[0].trim();
			var talukaName = $("#talukaSelect option:selected").text().split(':')[0].trim();
			var villageName = $("#villageSelect option:selected").text().split(':')[0].trim();
			var postData = $("#bcTxnGrid").jqGrid("getGridParam", "postData");
			document.forms['txnReportForm'].action = "XslReportOfTransactionReport.action?stateName=" + stateName + "+&districtName=" + districtName
					+ "&talukaName=" + talukaName + "&villageName=" + villageName + "&sidx=" + postData.sidx + "&sord=" + postData.sord + "&filters="
					+ postData.filters;
			document.forms['txnReportForm'].submit();
		}
	}
	function getRecords() {
		return $("#bcTxnGrid").jqGrid("getGridParam", "records");
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
		if (getRecords()) {
			var action = "";
			if (format == 'Excel')
				action = "XslReportOfTransactionReport.action";
			else if (format == 'PDF')
				action = "PdfReportOfTransactionReport.action";
			var filterString = $(".divSearchCondition").text();
			var filterVO = getFilterVO();
			var stateName = $("#stateSelect option:selected").text().split(':')[0].trim();
			var districtName = $("#districtSelect option:selected").text().split(':')[0].trim();
			var talukaName = $("#talukaSelect option:selected").text().split(':')[0].trim();
			var villageName = $("#villageSelect option:selected").text().split(':')[0].trim();
			var postData = $("#bcTxnGrid").jqGrid("getGridParam", "postData");
			var parameters = "?stateName=" + stateName + "+&districtName=" + districtName + "&talukaName=" + talukaName + "&villageName="
					+ villageName + "&sidx=" + postData.sidx + "&sord=" + postData.sord + "&filters=" + postData.filters + "&filterString="
					+ filterString + "&filterVO=" + filterVO;
			document.forms['txnReportForm'].action = action + parameters;
			document.forms['txnReportForm'].submit();
		}
	}
	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	function linkFormat(cellvalue, options, rowObject) {
		return '<u style="font-weight: bolder;cursor:pointer;">' + cellvalue + '</u>';
	}
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="txnReportForm" name="txnReportForm" method="post"
		theme="css_xhtml">
		<table cellpadding="8" class="filterTable" width="90%">
			<tr>
				<td rowspan="1" style="max-width: 30px; min-width: 20px;">
					<%-- <s:radio list="{'state','pm_ac'}" labelSeparator="<br>" id="filterOptions" name="filterOptions"></s:radio> --%>
					<input id="filterOptionsstate" type="radio" value="state"
					name="filterOptions" align="middle" checked="checked"
					onchange="changeFilter('state');">

				</td>
				<td><s:url var="stateListUrl" action="loadStateList.action" />
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
						<sj:datepicker name="startDate" id="startDate"
							labelposition="left" showOn="focus" label="From Date "
							labelSeparator="<br>" onChangeTopics="validateDate"
							displayFormat="dd/mm/yy" readonly="false" maxDate="today"
							onkeydown="return datepickerKeyDown(event);" />
						<sj:datepicker name="endDate" id="endDate" disabled="true"
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
						formIds="txnReportForm" href="%{acListUrl}"
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
		<s:url var="loadGrid" action="filterAllReports.action">
		</s:url>
		<s:url var="bcTxnGridURL" action="bcTxnGrid.action" />
		<sjg:grid id="bcTxnGrid" caption="BC Transaction Details"
			dataType="json" sortable="true" autowidth="true" shrinkToFit="false"
			href="%{bcTxnGridURL}" pager="true" onSelectRowTopics="bcSelection"
			sortname="bcCode" gridModel="selectedBCList" viewrecords="true"
			rowList="10,15,20,25" rowNum="15" formIds="txnReportForm"
			rownumbers="true" onCellSelectTopics="cellSelection"
			reloadTopics="reloadGrids" footerrow="true" userDataOnFooter="true"
			onCompleteTopics="loadDivTotal" navigatorEdit="false"
			navigatorAdd="false" navigatorDelete="false" navigatorSearch="true"
			navigator="true" navigatorView="true"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true,
			odata:[{ oper:'nu', text:'is null'}, { oper:'nn', text:'is not null'},{ oper:'is', text:'is'}], 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				marksearched:true,onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{ seperator: {}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sorttype="int" sortable="true" search="true" searchtype="text"
				searchoptions="{sopt: ['eq','bw','cn']}" width="70"
				formatter="linkFormat" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="130" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" formatter="linkFormat" />
			<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
				sortable="true" width="85" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="cbsOdAcc" index="cbsOdAcc" title="BC OD A/c "
				sortable="true" width="90" search="true"
				searchoptions="{sopt: ['eq','bw','cn','nu','nn']}" />
			<sjg:gridColumn name="stateName" index="stateName" title="State Name"
				sortable="true" width="100" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="districtName" index="districtName"
				title="District Name" sortable="true" width="100" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="talukaName" index="talukaName"
				title="Taluka Name" sortable="true" width="100" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="villageName" index="villageName"
				title="Village Name" sortable="true" width="100" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="branchCode" index="branchCode"
				title="Branch Code" sortable="true" width="70" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="branchName" index="branchName"
				title="Branch Name" sortable="true" width="100" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="regionName" index="regionName"
				title="Region Name" sortable="true" width="100" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="txnCD" index="txnCD" title="Deposit Count"
				sortable="true" align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" formatter="linkFormat" />
			<sjg:gridColumn name="txnAmtCD" index="txnAmtCD"
				title="Deposit Amount (in Rs.)" sortable="true" align="right"
				formatter="currency" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="txnCW" index="txnCW" title="Withdrawal Count"
				sortable="true" align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" formatter="linkFormat" />
			<sjg:gridColumn name="txnAmtCW" index="txnAmtCW"
				title="Withdrawal Amount (in Rs.)" sortable="true" align="right"
				formatter="currency" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="txnFT" index="txnFT" title="FT Count"
				sortable="true" align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" formatter="linkFormat" />
			<sjg:gridColumn name="txnAmtFT" index="txnAmtFT"
				title="FT Amount (in Rs.)" sortable="true" align="right"
				formatter="currency" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="finTxn" index="finTxn"
				title="Financial Txn Count" sortable="true" align="right" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}"
				formatter="linkFormat" />
				<sjg:gridColumn name="finTxnAmt" index="finTxnAmt"
				title="Financial Txn Amount(in Rs.)" sortable="true" align="right"
				formatter="currency" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="txnMiniStmt" index="txnMiniStmt"
				title="Mini Statement Count" sortable="true" align="right"
				width="70" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="txnBalEq" index="txnBalEq"
				title="Balance Enquiry Count" sortable="true" align="right"
				width="70" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="nonFinTxn" index="nonFinTxn"
				title="Non Financial Txn Count" sortable="true" align="right"
				width="75" search="true" searchoptions="{sopt: ['eq','lt','gt']}"
				formatter="linkFormat" />
			<sjg:gridColumn name="txnTotCount" index="txnTotCount"
				title="Total Txn Count" sortable="true" align="right" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}"
				formatoptions="{attr:{style:{'cursor':'pointer'}}}"
				formatter="linkFormat" />
		</sjg:grid>

		<table width="100%">
			<tr>
				<td><sj:div id="divTotal" /></td>
			</tr>
		</table>
		<sj:dialog id="detailDialog" width="1000" position="center"
			height="530" cssStyle="font-size: small; padding: 0 20px 0 20px;"
			modal="true" cssClass="dstyle" autoOpen="false"
			indicator="dialogIndicator" draggable="true"
			buttons="{'Export To Excel': function() { exportToXslDlg();},
			'Export To Pdf':function() { exportToPdfDlg(); },
			'Close': function(){$(this).dialog('close');}}">
			<s:label id="txtTxnType"
				cssStyle="align: center; font-size: medium;font-weight:bold;" />
			<s:label id="dateField"
				cssStyle="align: center; font-size: medium;font-weight:bold;" />
			<table id="dlgTable" class="mystyle">
			</table>
			<center>
				<img id="dialogIndicator" class="indicator"
					src="images/indicator.gif" />
			</center>
		</sj:dialog>
	</s:form>

</body>
</html>
