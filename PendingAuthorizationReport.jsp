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
<script src="./js/JavaScript.js?v=2.4"></script>
<head>
<script type="text/javascript">
	$.subscribe('onGridCompleteBranch', function(event, data) {
		$.getJSON('daysWiseCount.action', function(data) {
			var list = (data.daysWiseList);
			getDaysWiseList(list, "branch");
		});

	});
	$.subscribe('onGridCompleteBC', function(event, data) {
		$.getJSON('daysWiseCount.action', function(data) {
			var list = (data.daysWiseList);
			getDaysWiseList(list, "bc");
		});

	});
	/*  function showDaysWiseBranch() {
		var branchCode = $('#branchSelect').val();
		var startDate = $('#sDateBranch').val();
		var endDate = $('#eDateBranch').val();
		$.getJSON('PendAuthDaysWiseGrid.action', {
			'branchCode' : branchCode,
			'startDateBranch' : startDate,
			'endDateBranch' : endDate
		}, function(jData) {
			var list = jData.daysWiseList;
			getDaysWiseList(list, 'branch');
		});
	}
	 function showDaysWiseBC() {
		var branchCode = $('#bcSelect').val();
		var startDate = $('#sDateBc').val();
		var endDate = $('#eDateBc').val();
		$.getJSON('PendAuthDaysWiseGrid.action', {
			'branchCode' : branchCode,
			'startDateBranch' : startDate,
			'endDateBranch' : endDate
		}, function(jData) {
			var list = jData.daysWiseList;
			getDaysWiseList(list, 'bc');
		});
	} */
	function getByDaysPendAuth(tabID, days) {
		$('#daysWiseAuthDialog').dialog('option', 'title',
				"Pending Authorization report : " + days);
		
		var sDate = "";
		var eDate = "";
		var code = "-1";
		if (tabID == "branch") {
			sDate = $('#sDateBranch').val();
			eDate = $('#eDateBranch').val();
			code = $('#branchSelect').val();
		} else {
			sDate = $('#sDateBC').val();
			eDate = $('#eDateBC').val();
			code = $('#bcSelect').val();
		}
		$('#daysWiseAuthGridID').jqGrid("setGridParam", {
			"postData" : {
				'tabID' : tabID,
				'days' : days,
				'startDate' : sDate,
				'endDate' : eDate,
				'code' : code
			},
			records : 0,
			page : 1
		});
		$('#daysWiseAuthDialog').dialog('open');
		$.publish("loadPendAuthDaysWiseGrid");
	}
	$.subscribe('clearGrid', function(grid, data) {
		$('#daysWiseAuthDialog').jqGrid('clearGridData');
		$("#daysWiseAuthDialog").jqGrid("setGridParam", {
			search : false,
			postData : {
				'_search' : false,
				"filters" : ""
			}
		});
		clearSearchReasonWise();
	});
	$.subscribe('ExportToExcelAgeWise', function(pID, id) {
		generateReportDaysWise('Excel');
	});
	$.subscribe('ExportToPDFAgeWise', function(pID, id) {
		generateReportDaysWise('PDF');
	});
	function generateReportDaysWise(format) {
		if (getRecords("#daysWiseAuthGridID")) {
			var action = "";
			if (format == 'Excel')
				action = "XslPendAuthDaysWise.action";
			else if (format == 'PDF')
				action = "PdfPendAuthDaysWise.action";
			var filterString = $(".divSearchConditionReasonWise").text();
			var postData = $("#daysWiseAuthGridID").jqGrid("getGridParam",
					"postData");
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&filters=" + postData.filters
					+ "&filterString=" + filterString + "&days="
					+ postData.days + "&tabID="
					+ postData.tabID;
			document.forms['pendingAuthorizationReportForm'].action = action
					+ parameters;
			document.forms['pendingAuthorizationReportForm'].submit();
		}
	}

	function getDaysWiseList(list, tabID) {
		var rows = "";
		var l = list.length;
		for (var index = 0; index < l; index++) {
			rows += "<tr><td align='center'><a title-text='"
					+ list[index].key
					+ "' class='class-with-tooltip' onclick='getByDaysPendAuth(\""
					+ tabID + "\",\"" + list[index].key + "\")'>"
					+ list[index].key + "</a></td><td align='right'>"
					+ toInteger(list[index].displayValue) + "</td>";

			if (index < l - 1) {

				rows += "<td align='center'><a title-text='"
						+ list[++index].key
						+ "' class='class-with-tooltip' onclick='getByDaysPendAuth(\""
						+ tabID + "\",\"" + list[index].key + "\")'>"
						+ list[index].key + "</a></td><td align='right'>"
						+ toInteger(list[index].displayValue) + "</td></tr>";
			}
			//$("#tempDiv").text("Value "+rows);
		}
		var id = tabID == 'branch' ? '#pendingAuthorizationBranchTblSummary'
				: '#pendingAuthorizationBCTblSummary';
		$(id)
				.html(
						"<strong><table class='tbl-txn-failed-Summary' cellpadding='5' cellspacing='5'><tr><th>Day Wise Pending Authorization<th width='80px'>No. of Enrollments</th>"
								+ "<th>Day Wise Pending Authorization<th width='80px'>No. of Enrollments</th></tr>"
								+ rows + "</table></strong>");
	}

	function onBCChange() {
		$('#bcDetail').html('');
		var bcCode = $('#bcSelect').val();
		if (bcCode != "-1")
			$
					.getJSON(
							'findBcHeaderData.action',
							{
								'bcCode' : bcCode,
							},
							function(data) {
								var region = (data.bcHeader.regionName);
								var district = (data.bcHeader.districtName);
								var branchCode = (data.bcHeader.branchCode);
								var branchName = (data.bcHeader.branchName);
								$('#bcDetail')
										.html(
												"<table cellpadding='5' cellspacing='5' style='font-size: 2; font-family: times new roman; font-weight: bold;'> <tr>"
														+ "<td>REGION :</td><td>      "
														+ region
														+ "</td><td>DISTRICT :</td><td>"
														+ district
														+ "</td><td>BRANCH CODE : </td><td>"
														+ branchCode
														+ "</td><td>BRANCH NAME : </td><td>"
														+ branchName
														+ "</td></tr></table>");
							});
	}
	function onBranchChange() {
		var branchCode = $('#branchSelect').val();
		$('#branchDetail').html('');
		if (branchCode != "-1")
			$
					.getJSON(
							'findBranchHeaderData.action',
							{
								'branchCode' : branchCode,
							},
							function(data) {
								var region = (data.branchHeader.regionName);
								var district = (data.branchHeader.districtName);
								$('#branchDetail')
										.html(
												"<table cellpadding='5' cellspacing='5' style='font-size: 2; font-family: times new roman; font-weight: bold;'> <tr>"
														+ "<td>REGION : </td><td>      "
														+ region
														+ "</td><td>DISTRICT : </td><td>"
														+ district
														+ "</td></tr></table>");
							});

	}
	function getRecords(id) {
		return $(id).jqGrid("getGridParam", "records");
	}
	function changeFilter(action) {
		if (action == 'branch') {
			removeSelectValues("pmSelectBranch");
			removeSelectValues("acSelectBranch");
			$("#pmSelectBranch").attr("disabled", "true");
			$("#acSelectBranch").attr("disabled", "true");
			$("#branchSelect").removeAttr("disabled");
			$.publish('reloadBranchList');
		} else if (action == 'bc') {
			removeSelectValues("pmSelectBC");
			removeSelectValues("acSelectBC");
			$("#pmSelectBC").attr("disabled", "true");
			$("#acSelectBC").attr("disabled", "true");
			$("#bcSelect").removeAttr("disabled");
			$.publish('reloadBCList');
		} else if (action == 'pm_acBranch') {
			removeSelectValues("branchSelect");
			$("#branchSelect").attr("disabled", "true");
			$("#pmSelectBranch").removeAttr("disabled");
			$("#acSelectBranch").removeAttr("disabled");
			$.publish('reloadMPListBranch');
			$.publish('reloadAcListBranch');
			$("#branchDetail").html('');
		} else if (action == 'pm_acBC') {
			removeSelectValues("bcSelect");
			$("#bcSelect").attr("disabled", "true");
			$("#pmSelectBC").removeAttr("disabled");
			$("#acSelectBC").removeAttr("disabled");
			$.publish('reloadMPListBC');
			$.publish('reloadAcListBC');
			$("#bcDetail").html('');
		}
	}
	function generateBranchReport(format) {
		var action = "";
		if (format == 'Excel')
			action = "XslPendingAuthorizationBranch.action";
		else if (format == 'PDF')
			action = "PdfPendingAuthorizationBranch.action";
		var postData = $("#branchGrid").jqGrid("getGridParam", "postData");
		var branchName = $('#branchSelect option:selected').text().split(':')[0];
		var pmNameBranch = $("#pmSelectBranch option:selected").text().split(
				':')[0].trim();
		var acNameBranch = $("#acSelectBranch option:selected").text().split(
				':')[0].trim();
		var filterString = $(".divSearchConditionBranch").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString + "&branchName=" + branchName + "&pmNameBranch="
				+ pmNameBranch + "&acNameBranch=" + acNameBranch;
		document.forms['pendingAuthorizationReportForm'].action = action
				+ parameters;
		document.forms['pendingAuthorizationReportForm'].submit();
	}
	$.subscribe('ExportToExcelBranch', function(pID, id) {
		generateBranchReport('Excel');
	});
	$.subscribe('ExportToPDFBranch', function(pID, id) {
		generateBranchReport('PDF');
	});
	function generateBCReport(format) {
		var action = "";
		if (format == 'Excel')
			action = "XslPendingAuthorizationBC.action";
		else if (format == 'PDF')
			action = "PdfPendingAuthorizationBC.action";
		var postData = $("#bcGrid").jqGrid("getGridParam", "postData");
		var bcName = $('#bcSelect option:selected').text().split(':')[0];
		var pmNameBC = $("#pmSelectBC option:selected").text().split(':')[0]
				.trim();
		var acNameBC = $("#acSelectBC option:selected").text().split(':')[0]
				.trim();
		var filterString = $(".divSearchConditionBC").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString + "&bcName=" + bcName + "&pmNameBC=" + pmNameBC
				+ "&acNameBC=" + acNameBC;
		document.forms['pendingAuthorizationReportForm'].action = action
				+ parameters;
		document.forms['pendingAuthorizationReportForm'].submit();
	}
	$.subscribe('ExportToExcelBC', function(pID, id) {
		generateBCReport('Excel');
	});
	$.subscribe('ExportToPDFBC', function(pID, id) {
		generateBCReport('PDF');
	});
	$(document).ready(function() {
		var d = new Date();
		d.setDate(1);
		var month = d.getMonth() + 1;
		var date = d.getDate() + "/" + month + "/" + d.getFullYear();
		$("#dateStartBranch").val(date);
		$("#dateStartBC").val(date);

	});
	$.subscribe('validateBranchDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#dateEndBranch').datepicker('option', 'minDate', date);
		}
	});
	$.subscribe('validateBCDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#dateEndBC').datepicker('option', 'minDate', date);
		}
	});
	$.subscribe('loadBranchGrid', function(event, data) {
		$("#branchGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBranchGrid");
	});
	$.subscribe('loadBCGrid', function(event, data) {
		$("#bcGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBCGrid");
	});

	/*  $.subscribe('onGridCompleteBranch',
				function(event, data) {
					var records = $("#branchGrid").jqGrid("getGridParam",
							"records");
					$("#pendingAuthorizationBranchTblSummary")
							.html(
									"<tr><td>TOTAL NUMBER OF A/c PENDING FOR AUTHORIZATION</td><td align='right'> "
											+ toInteger(records)
											+ "</td></tr>");
				});  */
	/* $.subscribe('onGridCompleteBC',
					function(event, data) {
						var records = $("#bcGrid").jqGrid("getGridParam",
								"records");
						$("#pendingAuthorizationBCTblSummary")
								.html(
										"<tr><td>TOTAL NUMBER OF A/c PENDING FOR AUTHORIZATION</td><td align='right'> "
												+ toInteger(records)
												+ "</td></tr>");
					}); */
</script>
</head>
<body class="tabsBody">
	<hr color="#F28500">

	<s:form name="pendingAuthorizationReportForm"
		id="pendingAuthorizationReportForm" method="post" theme="css_xhtml">
		<sj:tabbedpanel id="taskTabs">
			<sj:tab target="divBranch" label="Branch">

				<div id="divBranch">
					<s:url var="loadBranchList" action="loadBranch.action" />
					<table cellpadding="6" class="filterTable-tabs" width="70%">
						<tr>
							<td style="max-width: 30px; min-width: 20px;"><input
								id="filterOptionsstate_Branch" type="radio" value="branch"
								name="filterOptionsBranch" align="middle" checked="checked"
								onchange="changeFilter('branch');"></td>
							<td width="120px"><img id="branchListIndicator"
								class="indicator-small" src="images/indicator_small.gif" /> <sj:select
									label="Select Branch" reloadTopics="reloadBranchList"
									headerKey="-1" id="branchSelect" headerValue="All"
									labelSeparator="<br>" labelposition="left" list="branchList"
									indicator="branchListIndicator" listValue="displayValue"
									listKey="key" href="%{loadBranchList}" name="branchCode"
									onchange="onBranchChange()" /></td>
							<td colspan="2"><sj:datepicker name="startDateBranch"
									id="dateStartBranch" labelposition="left" showOn="focus"
									label="From Date" labelSeparator="<br>"
									onChangeTopics="validateBranchDate" displayFormat="dd/mm/yy"
									readonly="false" maxDate="today"
									onkeydown="return datepickerKeyDown(event);" /></td>
							<td><sj:datepicker name="endDateBranch" id="dateEndBranch"
									disabled="false" labelSeparator="<br>" label="To Date"
									value="today" showOn="focus" labelposition="left"
									displayFormat="dd/mm/yy" readonly="false" maxDate="today"
									onkeydown="return datepickerKeyDown(event);" /></td>
							<td><small><sj:a button="true"
										buttonIcon="ui-icon-refresh" id="filterBranch"
										name="filterBranch" onClickTopics="loadBranchGrid">
						Generate Report
					</sj:a></small></td>
						</tr>
						<tr>
							<td><input id="filterOptionspm_ac_Branch" type="radio"
								value="pm_acBranch" name="filterOptionsBranch" align="middle"
								onchange="changeFilter('pm_acBranch');"></td>
							<td><img id="pmListIndicator" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="pmListUrl"
									action="loadPMList" /> <sj:select headerKey="-1"
									id="pmSelectBranch" href="%{pmListUrl}"
									indicator="pmListIndicator" deferredLoading="true"
									reloadTopics="reloadMPListBranch" label="Project Manager"
									labelposition="left" labelSeparator="<br>" headerValue="All"
									list="pmList" listKey="key" listValue="displayValue"
									name="pmCodeBranch" disabled="true"
									onChangeTopics="reloadAcListBranch" /></td>

							<td><img id="acListIndicator" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="acListUrl"
									action="loadACByPMBranch" /> <sj:select headerKey="-1"
									id="acSelectBranch" formIds="pendingAuthorizationReportForm"
									href="%{acListUrl}" indicator="acListIndicator"
									label="Area Coordinator " labelposition="left"
									labelSeparator="<br>" headerValue="All" list="acList"
									listKey="key" listValue="displayValue" disabled="true"
									reloadTopics="reloadAcListBranch" name="acCodeBranch" /></td>
							<td></td>
							<td></td>
							<td></td>

						</tr>
					</table>
					<table width="100%">
						<tr>
							<td colspan="4" align="left">
								<div class="divSearchConditionBranch"></div>
							</td>
						</tr>
					</table>
					<sj:div id="branchDetail" style="height: 40px;"></sj:div>
					<s:url var="branchSelection"
						action="PendingAuthorizationByBranch.action" />
					<sjg:grid id="branchGrid"
						caption="Branch Wise Pending Authorization Report" dataType="json"
						href="%{branchSelection}" pager="true" autowidth="true"
						shrinkToFit="false" gridModel="gridModel" rowList="10,15,20,25"
						rowNum="15" sortname="bcCode" sortable="true" viewrecords="true"
						rownumbers="true" formIds="pendingAuthorizationReportForm"
						reloadTopics="reloadBranchGrid"
						onCompleteTopics="onGridCompleteBranch" navigatorEdit="false"
						navigatorAdd="false" navigatorDelete="false"
						navigatorRefresh="false" navigatorSearch="true" navigator="true"
						navigatorView="true"
						navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBranch,
				onReset:clearSearchBranch,dragable:true}"
						navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadBranchGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelBranch'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFBranch'}}">
						<sjg:gridColumn name="regionName" index="regionName"
							title="Region Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="districtName" index="districtName"
							title="District Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="subDistrict" index="subDistrict"
							title="Taluka Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="branchCode" index="branchCode"
							title="Branch Code" sortable="true" width="70" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchName" index="branchName"
							title="Branch Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
							sortable="true" width="80" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="140" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="enrollDate" index="enrollDate"
							title="Enrollment Date" sortable="true" formatter="date"
							formatoptions="{newformat : 'd-M-y'}" width="70" search="true"
							searchoptions="{sopt:['bw','cn'],dataInit:dateField}" />
						<sjg:gridColumn name="eamDate" index="eamDate"
							title="Sent to CBS Date" sortable="true" formatter="date"
							width="70" search="true" formatoptions="{newformat : 'd-M-y'}"
							searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}" />
						<sjg:gridColumn name="enrUrn" index="enrUrn"
							title="Enrollment URN No." sortable="true" width="200"
							search="true" searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="customerName" index="customerName"
							title="Customer Name" sortable="true" width="160" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="address" index="address" title="Address"
							sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="docType" index="docType"
							title="ID Proof Doc." sortable="true" width="200" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="documentNo" index="documentNo"
							title="ID Number" sortable="true" width="90" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="fingerPrintId" index="fingerPrintId"
							title="Captured Fingerprint IDs" sortable="true" width="200"
							search="true" searchoptions=" {sopt:['cn','eq','ne']}" />
					</sjg:grid>
					<table width="100%">
						<tr>
							<td><sj:div id="pendingAuthorizationBranchTblSummary"
									cssClass="tab-div-total" /></td>
						</tr>
					</table>
					<div id="tempDiv"></div>
				</div>
				<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
			</sj:tab>
			<sj:tab target="divBC" label="BC ">
				<div id="divBC">
					<s:url var="loadBCList" action="loadBC.action" />
					<table cellpadding="6" class="filterTable-tabs" width="70%">
						<tr>
							<td style="max-width: 30px; min-width: 20px;"><input
								id="filterOptionsstate_BC" type="radio" value="bc"
								name="filterOptionsBC" align="middle" checked="checked"
								onchange="changeFilter('bc');"></td>
							<td width="120px"><img id="bcListIndicator"
								class="indicator-small" src="images/indicator_small.gif" /> <sj:select
									label="Select BC" reloadTopics="reloadBCList" headerKey="-1"
									labelposition="left" headerValue="All"
									indicator="bcListIndicator" labelSeparator="<br>" id="bcSelect"
									list="bcList" href="%{loadBCList}" listValue="displayValue"
									listKey="key" name="bcCode" onchange="onBCChange()" /></td>
							<td colspan="2"><sj:datepicker name="startDateBC"
									id="dateStartBC" labelposition="left" showOn="focus"
									label="From Date" labelSeparator="<br>"
									onChangeTopics="validateBCDate" displayFormat="dd/mm/yy"
									readonly="false" maxDate="today"
									onkeydown="return datepickerKeyDown(event);" /></td>
							<td><sj:datepicker name="endDateBC" id="dateEndBC"
									disabled="false" labelSeparator="<br>" label="To Date"
									showOn="focus" value="today" labelposition="left"
									displayFormat="dd/mm/yy" readonly="false" maxDate="today"
									onkeydown="return datepickerKeyDown(event);" /></td>
							<td><small><sj:a button="true"
										buttonIcon="ui-icon-refresh" id="filterBC" name="filterBC"
										onClickTopics="loadBCGrid">
						Generate Report
					</sj:a></small></td>
						</tr>
						<tr>
							<td><input id="filterOptionspm_ac_BC" type="radio"
								value="pm_acBC" name="filterOptionsBC" align="middle"
								onchange="changeFilter('pm_acBC');"></td>
							<td><img id="pmListIndicatorBC" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="pmListUrl"
									action="loadPMList" /> <sj:select headerKey="-1"
									id="pmSelectBC" href="%{pmListUrl}" deferredLoading="true"
									reloadTopics="reloadMPListBC" indicator="pmListIndicatorBC"
									label="Project Manager" labelposition="left"
									labelSeparator="<br>" headerValue="All" list="pmList"
									listKey="key" listValue="displayValue" name="pmCodeBC"
									disabled="true" onChangeTopics="reloadAcListBC" /></td>

							<td><img id="acListIndicatorBC" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="acListUrl"
									action="loadACByPMBC" /> <sj:select headerKey="-1"
									id="acSelectBC" formIds="pendingAuthorizationReportForm"
									href="%{acListUrl}" indicator="acListIndicatorBC"
									label="Area Coordinator " labelposition="left"
									labelSeparator="<br>" headerValue="All" list="acList"
									listKey="key" listValue="displayValue" disabled="true"
									reloadTopics="reloadAcListBC" name="acCodeBC" /></td>
							<td></td>
							<td></td>
							<td></td>

						</tr>
					</table>
					<table width="100%">
						<tr>
							<td colspan="4" align="left">
								<div class="divSearchConditionBC"></div>
							</td>
						</tr>
					</table>
					<sj:div id="bcDetail" style="height: 40px;"></sj:div>
					<s:url var="cbsAccByBC" action="PendingAuthorizationByBC.action"
						includeParams="all" />
					<sjg:grid id="bcGrid"
						caption="BC Wise Pending Authorization Report" dataType="json"
						pager="true" sortname="bcCode" viewrecords="true" autowidth="true"
						shrinkToFit="false" href="%{cbsAccByBC}" gridModel="gridModelBC"
						rowList="10,15,20,25" rowNum="15" rownumbers="true"
						formIds="pendingAuthorizationReportForm" sortable="true"
						reloadTopics="reloadBCGrid" navigatorEdit="false"
						navigatorAdd="false" navigatorDelete="false"
						onCompleteTopics="onGridCompleteBC" navigatorSearch="true"
						navigator="true" navigatorView="true" navigatorRefresh="false"
						navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBranch,
				onReset:clearSearchBranch,dragable:true}"
						navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadBCGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelBC'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFBC'}}">
						<sjg:gridColumn name="regionName" index="regionName"
							title="Region Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="districtName" index="districtName"
							title="District Name" sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="subDistrict" index="subDistrict"
							title="Taluka Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchCode" index="branchCode"
							title="Branch Code" sortable="true" width="70" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchName" index="branchName"
							title="Branch Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
							sortable="true" width="80" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="140" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="enrollDate" index="enrollDate" width="60"
							title="Enrollment Date" sortable="true" formatter="date"
							formatoptions="{newformat : 'd-M-y'}" search="true"
							searchoptions="{sopt:['bw','cn'],dataInit:dateField}" />
						<sjg:gridColumn name="eamDate" index="eamDate"
							title="Sent to CBS Date" sortable="true" formatter="date"
							width="70" search="true" formatoptions="{newformat : 'd-M-y'}"
							searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}" />
						<sjg:gridColumn name="enrUrn" index="enrUrn"
							title="Enrollment URN No." sortable="true" width="200"
							search="true" searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="customerName" index="customerName"
							title="Customer Name" sortable="true" width="160" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="address" index="address" title="Address"
							sortable="true" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="docType" index="docType"
							title="ID Proof Doc." sortable="true" width="180" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="documentNo" index="documentNo"
							title="ID Number" sortable="true" width="90" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="fingerPrintId" index="fingerPrintId"
							title="Captured Fingerprint IDs" sortable="true" width="200"
							search="true" searchoptions=" {sopt:['cn']}" />
					</sjg:grid>
					<table width="100%">
						<tr>
							<td><sj:div id="pendingAuthorizationBCTblSummary"
									cssClass="tab-div-total" /></td>
						</tr>
					</table>
				</div>
				<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
			</sj:tab>
		</sj:tabbedpanel>
		<sj:dialog id="daysWiseAuthDialog" autoOpen="false" width="900"
			modal="true" onCloseTopics="clearGrid" position="[200,0]"
			draggable="false" height="520"
			buttons="{'Close': function(){$(this).dialog('close');}}">
			<table width="100%">
				<tr>
					<td align="left">
						<div class="divSearchConditionReasonWise"></div>
					</td>
				</tr>
			</table>
			<s:url var="daysWiseAuthGridURL" action="PendAuthDaysWiseGrid.action"></s:url>
			<sjg:grid id="daysWiseAuthGridID" href="%{daysWiseAuthGridURL}"
				dataType="json" pager="true" sortname="bcCode" viewrecords="true"
				autowidth="true" shrinkToFit="false"
				gridModel="daysWiseGridList" rowList="10,15,20,25" rowNum="15"
				rownumbers="true" formIds="pendingAuthorizationReportForm"
				sortable="true" reloadTopics="loadPendAuthDaysWiseGrid"
				navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
				navigatorSearch="true" navigator="true" navigatorView="true"
				navigatorRefresh="false"
				navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBranch,
				onReset:clearSearchBranch,dragable:true}"
				navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadPendAuthDaysWiseGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelAgeWise'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFAgeWise'}}">
				<sjg:gridColumn name="regionName" index="regionName"
					title="Region Name" sortable="true" width="110" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="districtName" index="districtName"
					title="District Name" sortable="true" width="120" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="subDistrict" index="subDistrict"
					title="Taluka Name" sortable="true" width="110" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="branchCode" index="branchCode"
					title="Branch Code" sortable="true" width="70" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="branchName" index="branchName"
					title="Branch Name" sortable="true" width="100" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
					sortable="true" width="80" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
					sortable="true" width="140" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="enrollDate" index="enrollDate" width="60"
					title="Enrollment Date" sortable="true" formatter="date"
					formatoptions="{newformat : 'd-M-y'}" search="true"
					searchoptions="{sopt:['bw','cn'],dataInit:dateField}" />
				<sjg:gridColumn name="eamDate" index="eamDate"
					title="Sent to CBS Date" sortable="true" formatter="date"
					width="70" search="true" formatoptions="{newformat : 'd-M-y'}"
					searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}" />
				<sjg:gridColumn name="enrUrn" index="enrUrn"
					title="Enrollment URN No." sortable="true" width="200"
					search="true" searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="customerName" index="customerName"
					title="Customer Name" sortable="true" width="160" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="address" index="address" title="Address"
					sortable="true" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="villageName" index="villageName"
					title="Village Name" sortable="true" width="110" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="docType" index="docType" title="ID Proof Doc."
					sortable="true" width="180" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="documentNo" index="documentNo"
					title="ID Number" sortable="true" width="90" search="true"
					searchoptions=" {sopt:['cn','bw','eq']}" />
				<sjg:gridColumn name="fingerPrintId" index="fingerPrintId"
					title="Captured Fingerprint IDs" sortable="true" width="200"
					search="true" searchoptions=" {sopt:['cn']}" />
			</sjg:grid>
		</sj:dialog>

	</s:form>
</body>
</html>