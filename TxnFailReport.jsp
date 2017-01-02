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
	function getTxnByType(bcCode, bcName, txnType) {
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		$('#detailDialog').dialog('option', 'title', bcCode + " : " + bcName);
		$('#detailDialog').dialog('open');
		$('#dlgTable').html('');
		$('#dateField').html('');
		$('#dlgTable').html('');
		$('#txtTxnType').html("Loading..........");
		showLargeIndicator();
		$.getJSON('bcTxnFailByType.action', {
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
					//indicatorTH = ;
					toAccTH = "<th>Txn Type</th><th>Transfer To A/c</th><th>Txn to Name</th>";
				}
				if (txnType == "Non Financial") {
					indicatorTH = "<th>Txn Type</th>";
				} else
					indicatorTH = "<th>Txn Amount</th>";
				if (txnType == "Fund Transfer") {
					toAccTH = "<th>Transfer To A/c</th><th>Txn to Name</th>";
				}
				if (txnType == "Total") {
					toAccTH = "<th>Txn Type</th><th>Transfer To A/c</th><th>Transfer To Name</th>";
				}

				$('#txtTxnType').html("Transaction Type : " + txnType);
				if (startDate != "" && endDate != "") {
					$('#dateField').html("From  " + startDate + " To " + endDate);
				}
				$('#dlgTable').html(
						"<tr><th>Txn Time</th><th>PT RRN No.</th><th >Customer A/c No.</th><th >Customer Name</th>" + indicatorTH
								+ "<th>Txn Mode</th><th>FP" + "<th>Failure Code</th><th>Failure Reason</th>" + toAccTH + "</tr>");
				for ( var i in txnData) {
					var indicator = "";
					var toAcc = "";
					if (txnType == "Financial") {
						//indicator = "</td><td>"+ txnData[i].txnType;
						toAcc = "</td><td>" + txnData[i].txnType + "</td><td>" + txnData[i].toAcc + "</td><td>" + txnData[i].toName + "</td>";
					}
					if (txnType == "Non Financial") {
						indicator = "</td><td>" + txnData[i].txnType;
					} else
						indicator = "</td><td align='right'>" + toCurrency(txnData[i].txnAmount);
					if (txnType == "Fund Transfer") {
						toAcc = "<td>" + txnData[i].toAcc + "</td><td>" + txnData[i].toName + "</td>";
					}
					if (txnType == "Total") {
						toAcc = "<td>" + txnData[i].txnType + "</td><td>" + txnData[i].toAcc + "</td><td>" + txnData[i].toName + "</td>";
					}
					$('#dlgTable').append(
							"<tr><td>" + txnData[i].txnTime + "</td><td>" + txnData[i].ptrrnNo + "</td><td>" + txnData[i].accNo + "</td><td>"
									+ txnData[i].custName + indicator + "</td><td>" + txnData[i].txnMode + "</td><td>" + txnData[i].fpData
									+ "</td><td align='right'>" + txnData[i].resCode + "</td><td>" + txnData[i].resDesc + "</td>" + toAcc + "</tr>");
				}
			}

			hideLargeIndicator();
		});

	}
	$.subscribe('cellSelection', function(event, data) {
		//event.originalEvent.rowid, event.originalEvent.iCol, event.originalEvent.cellcontent, event.originalEvent.e

		var rowid = event.originalEvent.rowid;
		var rowdata = jQuery("#bcTxnFailGrid").jqGrid('getRowData', rowid);
		var cellId = event.originalEvent.iCol;
		var bcCode = $(rowdata.bcCode).html();
		var bcName = $(rowdata.bcName).html();
		var txnType = "";
		switch (cellId) {
		case 1:
		case 2:
		case 19:
			txnType = "Total";
			break;
		case 12:
			txnType = "Deposit";
			break;
		case 13:
			txnType = "Withdrawal";
			break;
		case 14:
			txnType = "Fund Transfer";
			break;
		case 17:
			txnType = "Financial";
			break;
		case 18:
			txnType = "Non Financial";
			break;
		default:
			return;
		}
		getTxnByType(bcCode, bcName, txnType);
	});
	function getByReason(reasonCode) {
		$('#reasonWiseDialog').dialog('option', 'title', "Failed transaction report for reason code : " + reasonCode);
		$('#reasonWiseDialog').dialog('open');
		$('#reasonWiseGridID').jqGrid("setGridParam", {
			"postData" : {
				'reasonCode' : reasonCode
			}
		}).trigger('reloadGrid');
	}
	$
			.subscribe(
					'loadDivTotal',
					function(event, data) {
						var totalValue = $("#bcTxnFailGrid").jqGrid("getGridParam", "userData");
						/* $("#bcTxnFailGrid").jqGrid("footerData", "set", totalValue,
								false); */

						$('#divTotal')
								.html(
										"<strong><table class='tbl-txn-failed-Summary' cellpadding='5' cellspacing='5'><tr><th>Transaction Type<th width='80px'>Failed Txn Count</th></tr><tr>"
												+ "<td>TOTAL TRANSACTION</td><td align='right'>"
												+ toInteger(totalValue.txnTotCount)
												+ "</td></tr><tr><td>CASH DEPOSIT</td><td align='right'>"
												+ toInteger(totalValue.txnCD)
												+ "</td></tr><tr><td>CASH WITHDRAWAL</td><td align='right'>"
												+ toInteger(totalValue.txnCW)
												+ "</td></tr><tr><td>FUND TRANSFER</td><td align='right'>"
												+ toInteger(totalValue.txnFT)
												+ "</td></tr><tr><td>FINANCIAL TRANSACTION</td><td align='right'>"
												+ toInteger(totalValue.finTxn)
												+ "</td></tr><tr><td>MINI STATEMENT</td><td align='right'>"
												+ toInteger(totalValue.txnMiniStmt)
												+ "</td></tr><tr><td>BALANCE ENQUIRY</td><td align='right'>"
												+ toInteger(totalValue.txnBalEq)
												+ "</td></tr><tr><td>NON FINANCIAL TRANSACTION</td><td align='right'>"
												+ toInteger(totalValue.nonFinTxn) + "</td></tr></table></strong>");
						showTxnReasonWise();
					});
	function showTxnReasonWise() {
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		var stateCode = $('#stateSelect').val();
		var districtCode = $('#districtSelect').val();
		var talukaCode = $('#talukaSelect').val();
		var villageCode = $('#villageSelect').val();
		var pmCode = $('#pmSelect').val();
		var acCode = $('#acSelect').val();
		$.getJSON('TxnFailedReasonWise.action', {
			'stateCode' : stateCode,
			'districtCode' : districtCode,
			'talukaCode' : talukaCode,
			'villageCode' : villageCode,
			'startDate' : startDate,
			'endDate' : endDate,
			'pmCode' : pmCode,
			'acCode' : acCode
		}, function(jData) {
			var list = jData.txnFailedReasonWiseList;

			var rows = "";
			var l = list.length;
			for ( var index = 0; index < l; index++) {
				rows += "<tr><td align='center'><a title-text='" + list[index].reasonDesc + "' class='class-with-tooltip' onclick='getByReason(\""
						+ list[index].reasonCode + "\")'>" + list[index].reasonCode + "</td><td align='right'>" + toInteger(list[index].txnCount)
						+ "</td>";
				if (index < l - 1) {

					rows += "<td align='center'><a title-text='" + list[++index].reasonDesc + "' class='class-with-tooltip' onclick='getByReason(\""
							+ list[index].reasonCode + "\")'>" + list[index].reasonCode + "</a></td><td align='right'>"
							+ toInteger(list[index].txnCount) + "</td></tr>";
				}
			}
			$('#divReasonWiseTotal').html(
					"<strong><table class='tbl-txn-failed-Summary' cellpadding='5' cellspacing='5'><tr><th>Reason Code<th width='80px'>Failed Txn Count</th>"
							+ "<th>Reason Code<th width='80px'>Failed Txn Count</th></tr>" + rows + "</table></strong>");
		});
	}
	$.subscribe('loadGrid', function(event, data) {
		$("#bcTxnGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadGrids");
	});
	$.subscribe('validateDate', function(event, data) {
		var date = event.originalEvent.dateText;
		// event.originalEvent.inst
		if (date != "") {
			$('#endDate').datepicker('option', 'minDate', date);
			$("#endDate").removeAttr("disabled");
		}
	});
	function exportToXslDlg() {
		var txnType = $('#txtTxnType').html().split(':')[1];
		var bcCode = $("#detailDialog").dialog("option", "title");

		document.forms['txnFailReportForm'].action = "exportToXslTxnFailDlg.action?txnType=" + txnType + "&bcCode=" + bcCode;
		document.forms['txnFailReportForm'].submit();
	}
	function exportToPdfDlg() {
		//var txnType =document.getElementById("dlgTable").rows.item(0).innerHTML.split(':')[1].split('<')[0];
		var txnType = $('#txtTxnType').html().split(':')[1];
		var bcCode = $("#detailDialog").dialog("option", "title");
		document.forms['txnFailReportForm'].action = "exportToPdfTxnFailDlg.action?txnType=" + txnType + "&bcCode=" + bcCode;
		document.forms['txnFailReportForm'].submit();
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
				action = "XslReportOfTxnFailReport.action";
			else if (format == 'PDF')
				action = "PdfReportOfTxnFailReport.action";
			var filterString = $(".divSearchCondition").text();
			var filterVO = getFilterVO();
			var stateName = $("#stateSelect option:selected").text().split(':')[0].trim();
			var districtName = $("#districtSelect option:selected").text().split(':')[0].trim();
			var talukaName = $("#talukaSelect option:selected").text().split(':')[0].trim();
			var villageName = $("#villageSelect option:selected").text().split(':')[0].trim();
			var postData = $("#bcTxnFailGrid").jqGrid("getGridParam", "postData");
			var parameters = "?stateName=" + stateName + "+&districtName=" + districtName + "&talukaName=" + talukaName + "&villageName="
					+ villageName + "&sidx=" + postData.sidx + "&sord=" + postData.sord + "&filters=" + postData.filters + "&filterString="
					+ filterString+ "&filterVO=" + filterVO;
			document.forms['txnFailReportForm'].action = action + parameters;
			document.forms['txnFailReportForm'].submit();
		}
	}
	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	$.subscribe('ExportToExcelReasonWise', function(pID, id) {
		generateReportReasonWise('Excel');
	});
	$.subscribe('ExportToPDFReasonWise', function(pID, id) {
		generateReportReasonWise('PDF');
	});
	$.subscribe('clearGridData', function(grid, data) {
		$('#reasonWiseGridID').jqGrid('clearGridData');
		$("#reasonWiseGridID").jqGrid("setGridParam", {
			search : false,
			postData : {
				'_search' : false,
				"filters" : "",
				records : 0,
				page : 1
			}
		});
		clearSearchReasonWise();
	});
	$.subscribe('loadReasonWiseGrid', function(grid, data) {
		$('#reasonWiseGridID').trigger("reloadGrid");
	});
	function generateReportReasonWise(format) {
		if (getRecords()) {
			var action = "";
			if (format == 'Excel')
				action = "XslTxnFailReasonWise.action";
			else if (format == 'PDF')
				action = "PdfTxnFailReasonWise.action";
			var filterString = $(".divSearchConditionReasonWise").text();
			var stateName = $("#stateSelect option:selected").text().split(':')[0].trim();
			var districtName = $("#districtSelect option:selected").text().split(':')[0].trim();
			var talukaName = $("#talukaSelect option:selected").text().split(':')[0].trim();
			var villageName = $("#villageSelect option:selected").text().split(':')[0].trim();
			var postData = $("#reasonWiseGridID").jqGrid("getGridParam", "postData");
			var parameters = "?stateName=" + stateName + "+&districtName=" + districtName + "&talukaName=" + talukaName + "&villageName="
					+ villageName + "&sidx=" + postData.sidx + "&sord=" + postData.sord + "&filters=" + postData.filters + "&filterString="
					+ filterString + "&reasonCode=" + postData.reasonCode;
			document.forms['txnFailReportForm'].action = action + parameters;
			document.forms['txnFailReportForm'].submit();
		}
	}
	function getRecords() {
		return $("#bcTxnFailGrid").jqGrid("getGridParam", "records");
	}
	function linkFormat(cellvalue, options, rowObject) {
		return '<u style="font-weight: bolder;cursor:pointer;">' + cellvalue + '</u>';
	}
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="txnFailReportForm" name="txnFailReportForm" method="post"
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
						formIds="txnFailReportForm" href="%{acListUrl}"
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
		<s:url var="bcTxnFailGridURL" action="TxnFailGrid.action" />
		<sjg:grid id="bcTxnFailGrid" caption="Failed Transaction Details"
			dataType="json" sortable="true" autowidth="true" shrinkToFit="false"
			href="%{bcTxnFailGridURL}" pager="true"
			onSelectRowTopics="bcSelection" sortname="bcCode"
			gridModel="selectedBCList" viewrecords="true" rowList="10,15,20,25"
			rowNum="15" formIds="txnFailReportForm" rownumbers="true"
			onCellSelectTopics="cellSelection" reloadTopics="reloadGrids"
			footerrow="true" userDataOnFooter="true"
			onCompleteTopics="loadDivTotal" navigatorEdit="false"
			navigatorAdd="false" navigatorDelete="false" navigatorSearch="true"
			navigator="true" navigatorView="true" navigatorRefresh="false"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sorttype="int" sortable="true" search="true" searchtype="text"
				searchoptions="{sopt: ['eq','bw','cn']}" width="70"
				formatter="linkFormat" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="120" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" formatter="linkFormat" />
			<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
				sortable="true" width="85" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
			<sjg:gridColumn name="cbsOdAcc" index="cbsOdAcc" title="BC OD A/c "
				sortable="true" width="90" search="true"
				searchoptions="{sopt: ['eq','bw','cn']}" />
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

			<sjg:gridColumn name="txnCW" index="txnCW" title="Withdrawal Count"
				sortable="true" align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" formatter="linkFormat" />

			<sjg:gridColumn name="txnFT" index="txnFT" title="FT Count"
				sortable="true" align="right" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" formatter="linkFormat" />

			<sjg:gridColumn name="txnMiniStmt" index="txnMiniStmt"
				title="Mini Statement Count" sortable="true" align="right"
				width="70" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="txnBalEq" index="txnBalEq"
				title="Balance Enquiry Count" sortable="true" align="right"
				width="70" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="finTxn" index="finTxn"
				title="Financial Txn Count" sortable="true" align="right" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}"
				formatter="linkFormat" />
			<sjg:gridColumn name="nonFinTxn" index="finTxn"
				title="Non Financial Txn Count" sortable="true" align="right"
				width="75" search="true" searchoptions="{sopt: ['eq','lt','gt']}"
				formatter="linkFormat" />
			<sjg:gridColumn name="txnTotCount" index="txnTotCount"
				title="Total Txn Count" sortable="true" align="right" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}"
				formatoptions="{attr:{style:{'cursor':'pointer'}}}"
				formatter="linkFormat" />
		</sjg:grid>

		<table>
			<tr>
				<td><sj:div id="divTotal" /></td>
				<td width="40px"></td>
				<td style="float: left;"><sj:div id="divReasonWiseTotal" /></td>

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
		<sj:dialog id="reasonWiseDialog" autoOpen="false" width="840"
			modal="true" onCloseTopics="clearGridData" position="[0,0]"
			draggable="false" height="530">
			<table width="100%">
				<tr>
					<td align="left">
						<div class="divSearchConditionReasonWise"></div>
					</td>
				</tr>
			</table>
			<s:url var="reasonWiseGridURL"
				action="TxnFailedReasonWiseGrid.action"></s:url>
			<sjg:grid id="reasonWiseGridID" href="%{reasonWiseGridURL}"
				formIds="txnFailReportForm" gridModel="reasonVOs" shrinkToFit="false"
				autowidth="false" width="790" pager="true" viewrecords="true"
				rowList="10,15,20,25" rowNum="15"
				rownumbers="true" sortname="txnTime" sortorder="desc"
				navigator="true" navigatorAdd="false" navigatorDelete="false"
				navigatorEdit="false" navigatorRefresh="false" navigatorView="false"
				navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchReasonWise,
				onReset:clearSearchReasonWise,dragable:true}"
				navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadReasonWiseGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcelReasonWise : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Excel',topic:'ExportToExcelReasonWise'}, exportToPDFReasonWise : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'PDF',topic:'ExportToPDFReasonWise'}}">
				<sjg:gridColumn name="txnTime" index="txnTime"
					title="Transaction Time" sortable="true" width="110" search="true"
					formatter="date"
					formatoptions="{newformat : 'd-M-y g:i A', srcformat : 'Y-m-d g:i k'}"
					searchoptions="{sopt: ['bw','cn'],dataInit:dateField}" />
				<sjg:gridColumn name="ptrrnNo" index="ptrrnNo" title="PT RRN No."
					sortable="true" width="95" search="true" align="left"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="accNo" index="accNo" title="Customer A/c No."
					sortable="true" search="true" width="95"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<%-- 	<sjg:gridColumn name="custName" index="custName"
					title="Customer Name" sortable="true" width="85" search="true"
					searchoptions="{sopt: ['eq','bw','cn']}" /> --%>
				<sjg:gridColumn name="txnAmount" index="txnAmount"
					title="Transaction Amount" sortable="true" width="90" search="true"
					formatter="currency" align="right"
					searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="txnMode" index="txnMode"
					title="Transaction Mode" sortable="true" search="true" width="70"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="fpData" index="fpData" title="FP"
					sortable="true" search="true" width="50"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="txnType" index="txnType"
					title="Transaction Type" sortable="true" width="100" search="true"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="toAcc" index="toAcc" title="Transfer To A/c"
					sortable="true" width="90" search="true" align="left"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<%-- 	<sjg:gridColumn name="toName" index="toName"
					title="Transfer To Name" sortable="true" search="true"
					searchoptions="{sopt: ['eq','bw','cn']}" /> --%>
			</sjg:grid>
		</sj:dialog>
	</s:form>
</body>
</html>
