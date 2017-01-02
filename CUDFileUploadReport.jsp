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
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript">
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
			$("#displayBranchDetails").html('');
		} else if (action == 'pm_acBC') {
			removeSelectValues("bcSelect");
			$("#bcSelect").attr("disabled", "true");
			$("#pmSelectBC").removeAttr("disabled");
			$("#acSelectBC").removeAttr("disabled");
			$.publish('reloadMPListBC');
			$.publish('reloadAcListBC');
			$("#displayBCDetails").html('');
		}
	}
	function generateBranchReport(format) {
		var action = "";
		if (format == 'Excel')
			action = "XslCUD_File_Upload_Branch.action";
		else if (format == 'PDF')
			action = "PdfCUD_File_Upload_Branch.action";
		var postData = $("#CUDFileUploadBranchGrid").jqGrid("getGridParam",
				"postData");
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
		document.forms['CUDFileUploadForm'].action = action + parameters;
		document.forms['CUDFileUploadForm'].submit();
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
			action = "XslCUD_File_Upload_BC.action";
		else if (format == 'PDF')
			action = "PdfCUD_File_Upload_BC.action";
		var postData = $("#CUDFileUploadBCGrid").jqGrid("getGridParam",
				"postData");
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
		document.forms['CUDFileUploadForm'].action = action + parameters;
		document.forms['CUDFileUploadForm'].submit();
	}
	$.subscribe('ExportToExcelBC', function(pID, id) {
		generateBCReport('Excel');
	});
	$.subscribe('ExportToPDFBC', function(pID, id) {
		generateBCReport('PDF');
	});
	$.subscribe('validateBranchDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#dateEndBranch').datepicker('option', 'minDate', date);
			$("#dateEndBranch").removeAttr("disabled");
		}
	});
	$.subscribe('validateBCDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#dateEndBC').datepicker('option', 'minDate', date);
			$("#dateEndBC").removeAttr("disabled");
		}
	});
	$.subscribe('loadBranchGrid', function(event, data) {
		$('#displayBranchDetails').html('');
		$("#CUDFileUploadBranchGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBranchGrid");
	});
	$.subscribe('loadBCGrid', function(event, data) {
		$('#displayBCDetails').html('');
		$("#CUDFileUploadBCGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBCGrid");
	});
	$
			.subscribe(
					'onloadBranchGrid',
					function(event, data) {
						var branchCode = $("#branchSelect").val();
						if (branchCode != '-1' && branchCode != ''
								&& getRecords("#CUDFileUploadBranchGrid")) {
							var row = $("#CUDFileUploadBranchGrid").jqGrid(
									"getRowData", 1);
							$("#CUDFileUploadBranchGrid")
									.jqGrid(
											'hideCol',
											[ 'regionName', 'branchCode',
													'branchName' ]);
							$('#displayBranchDetails')
									.html(
											"<table cellpadding='5' cellspacing='5' style='font-size: 2; font-family: times new roman; font-weight: bold;'> <tr>"
													+ "<td>REGION : </td><td>      "
													+ row.regionName
													+ ",</td><td>DISTRICT : </td><td>"
													+ row.districtName
													+ "</td></tr></table>");
						} else {
							$("#CUDFileUploadBranchGrid")
									.jqGrid(
											'showCol',
											[ 'regionName', 'branchCode',
													'branchName' ]);
						}
						loadTotal("#CUDFileUploadBranchGrid",
								"#divTotal_Branch");
					});
	$
			.subscribe(
					'onloadBCGrid',
					function(event, data) {
						var bcCode = $("#bcSelect").val();
						if (bcCode != '-1' && bcCode != ''
								&& getRecords("#CUDFileUploadBCGrid")) {
							var row = $("#CUDFileUploadBCGrid").jqGrid(
									"getRowData", 1);
							$("#CUDFileUploadBCGrid").jqGrid(
									'hideCol',
									[ 'bcCode', 'bcName', 'districtName',
											'regionName', 'mobile' ]);
							$('#displayBCDetails')
									.html(
											"<table cellpadding='5' cellspacing='5' style='font-size: 2; font-family: times new roman; font-weight: bold;'> <tr>"
													+ "<td>REGION : </td><td>      "
													+ row.regionName
													+ ",</td><td>DISTRICT : </td><td>"
													+ row.districtName
													+ ",</td><td>MOBILE No. : </td><td>"
													+ row.mobile
													+ "</td></tr></table>");
						} else {
							$("#CUDFileUploadBCGrid").jqGrid(
									'showCol',
									[ 'bcCode', 'bcName', 'districtName',
											'regionName', 'mobile' ]);
						}
						loadTotal("#CUDFileUploadBCGrid", "#divTotal_BC");
					});
	function loadTotal(gridid, tableid) {
		var totalValue = $(gridid).jqGrid("getGridParam", "userData");
		$(tableid)
				.html(
						"<table cellpadding='5' cellspacing='5' class='tblTotalSummary'> <tr>"
								+ "<td>TOTAL ENROLLMENTS  </td><td align='right'>"
								+ toInteger(totalValue.noOfAcc)
								+ "</td></tr><tr><td>TOTAL ENROLLMENTS AUTHORIZED </td><td align='right'>"
								+ toInteger(totalValue.authorized)
								+ "</td></tr><tr><td>TOTAL ENROLLMENTS PENDING FOR AUTHORIZATION </td><td align='right'>"
								+ toInteger(totalValue.pendingToAuthorize)
								+ "</td></tr><tr><td>TOTAL ENROLLMENTS REJECTED</td><td align='right'>"
								+ toInteger(totalValue.rejected)
								+ "</td></tr></table>");

	}
	$(document).ready(function() {
		var d = new Date();
		d.setDate(1);
		var month = d.getMonth() + 1;
		var date = d.getDate() + "/" + month + "/" + d.getFullYear();
		$("#dateStartBranch").val(date);
		$("#dateStartBC").val(date);

	});
</script>
</head>

<body class="tabsBody">

	<hr color="#F28500">
	<s:form id="CUDFileUploadForm" name="CUDFileUploadForm"
		theme="css_xhtml" method="post">
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
							<td width="120px"><img id="branchListIndicator" class="indicator-small"
								src="images/indicator_small.gif" />
							<sj:select label="Select Branch" indicator="branchListIndicator"
									headerKey="-1" id="branchSelect" headerValue="All"
									labelSeparator="<br>" formIds="CUDFileUploadForm" reloadTopics="reloadBranchList"
									labelposition="left" list="branchList" listValue="displayValue"
									listKey="key" href="%{loadBranchList}" name="branchCode" /></td>
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
										cssStyle="margin-bottom:-13px;" buttonIcon="ui-icon-refresh"
										id="filterBranch" name="filterBranch"
										onClickTopics="loadBranchGrid">
						Generate Report
					</sj:a></small></td>
						</tr>
						<tr>
							<td><input id="filterOptionspm_ac_Branch" type="radio"
								value="pm_acBranch" name="filterOptionsBranch" align="middle"
								onchange="changeFilter('pm_acBranch');"></td>
							<td><img id="pmListIndicator" class="indicator-small"
								src="images/indicator_small.gif" />
							<s:url var="pmListUrl" action="loadPMList" /> <sj:select
									headerKey="-1" id="pmSelectBranch" href="%{pmListUrl}"
									deferredLoading="true" reloadTopics="reloadMPListBranch"
									label="Project Manager" labelposition="left" indicator="pmListIndicator"
									labelSeparator="<br>" headerValue="All" list="pmList"
									listKey="key" listValue="displayValue" name="pmCodeBranch"
									disabled="true" onChangeTopics="reloadAcListBranch" /></td>

							<td><img id="acListIndicator" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="acListUrl"
									action="loadACByPMBranch" /> <sj:select headerKey="-1"
									id="acSelectBranch" formIds="CUDFileUploadForm"
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
					<sj:div id="displayBranchDetails" style="height: 40px;"></sj:div>
					<s:url var="branchSelection"
						action="branchEnrollmentRejection.action" />
					<s:url var="CUDFileUploadBranchURL"
						action="CUDFileUploadBranchGrid.action" />
					<sjg:grid id="CUDFileUploadBranchGrid"
						caption="Branch wise CUD File Processing Status Report"
						dataType="json" href="%{CUDFileUploadBranchURL}" pager="true"
						sortname="branchCode" sortable="true" autowidth="true"
						shrinkToFit="false" gridModel="selectedList" rowList="10,15,20,25"
						rowNum="15" viewrecords="true" rownumbers="true"
						onCompleteTopics="onloadBranchGrid" formIds="CUDFileUploadForm"
						reloadTopics="reloadBranchGrid" navigatorEdit="false"
						navigatorAdd="false" navigatorDelete="false"
						navigatorRefresh="false" navigatorSearch="true" navigator="true"
						navigatorView="true" footerrow="true" userDataOnFooter="true"
						navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBranch,
				onReset:clearSearchBranch,dragable:true}"
						navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadBranchGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelBranch'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFBranch'}}">

						<sjg:gridColumn name="sendDate" index="sendDate" title="Send Date"
							formatter="date" sortable="true" width="70"
							formatoptions="{newformat : 'd-M-y'}" search="true"
							searchoptions=" {sopt:['cn','bw'],dataInit:dateField}" />
						<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
							sortable="true" align="center" width="70" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
							sortable="false" align="center" width="85" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="districtName" index="districtName"
							title="District Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="talukaName" index="talukaName"
							title="Taluka Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="branchCode" index="branchCode"
							title="Branch Code" sortable="true" width="90" align="center" />
						<sjg:gridColumn name="branchName" index="branchName"
							title="Branch Name" sortable="true" width="160" align="left" />
						<sjg:gridColumn name="regionName" index="regionName"
							title="Region Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="villageCode" index="villageCode"
							align="center" title="Village Code" sortable="true" width="60"
							search="true" searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="cudFileName" index="cudFileName"
							title="ACC File Name" sortable="true" width="360" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" align="center" />
						<sjg:gridColumn name="noOfAcc" index="noOfAcc" formatter="integer"
							align="right" title="Total Accounts" sortable="true" width="60"
							search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
						<sjg:gridColumn name="authorized" index="authorized"
							formatter="integer" align="right" title="A/c Authorized"
							sortable="true" width="70" search="true"
							searchoptions="{sopt: ['eq','lt','gt']}" />
						<sjg:gridColumn name="rejected" index="rejected" align="right"
							formatter="integer" title="A/c Rejected" sortable="true"
							width="70" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
						<sjg:gridColumn name="pendingToAuthorize" formatter="integer"
							index="pendingToAuthorize" align="right"
							title="Pending to Authorize" sortable="true" width="70"
							search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
					</sjg:grid>
					<table width="100%">
						<tr>

							<td><sj:div id="divTotal_Branch" cssClass="tab-div-total" /></td>
						</tr>

					</table>
				</div>
			</sj:tab>
			<sj:tab target="divBc" label="BC">
				<div id="divBc">
					<s:url var="loadBCList" action="loadBC.action" />
					<table cellpadding="6" class="filterTable-tabs" width="70%">
						<tr>
							<td style="max-width: 30px; min-width: 20px;"><input
								id="filterOptionsstate_BC" type="radio" value="bc"
								name="filterOptionsBC" align="middle" checked="checked"
								onchange="changeFilter('bc');"></td>
							<td width="120px"><img id="bcListIndicator" class="indicator-small"
								src="images/indicator_small.gif" />
							<sj:select label="Select BC" indicator="bcListIndicator" reloadTopics="reloadBCList"
									headerKey="-1" labelposition="left" headerValue="All"
									labelSeparator="<br>" id="bcSelect" list="bcList"
									href="%{loadBCList}" listValue="displayValue" listKey="key"
									name="bcCode" formIds="CUDFileUploadForm" /></td>
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
							<td><sj:a button="true" cssStyle="margin-bottom:-13px;"
									buttonIcon="ui-icon-refresh" id="filterBC" name="filterBC"
									onClickTopics="loadBCGrid">
						Generate Report
					</sj:a></td>
						</tr>
						<tr>
							<td><input id="filterOptionspm_ac_BC" type="radio"
								value="pm_acBC" name="filterOptionsBC" align="middle"
								onchange="changeFilter('pm_acBC');"></td>
							<td><img id="pmListIndicatorBC" class="indicator-small"
								src="images/indicator_small.gif" />
							<s:url var="pmListUrl" action="loadPMList" /> <sj:select
									headerKey="-1" id="pmSelectBC" href="%{pmListUrl}"
									deferredLoading="true" reloadTopics="reloadMPListBC"
									label="Project Manager" labelposition="left" indicator="pmListIndicatorBC"
									labelSeparator="<br>" headerValue="All" list="pmList"
									listKey="key" listValue="displayValue" name="pmCodeBC"
									disabled="true" onChangeTopics="reloadAcListBC" /></td>

							<td><img id="acListIndicatorBC" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="acListUrl"
									action="loadACByPMBC" /> <sj:select headerKey="-1"
									id="acSelectBC" formIds="CUDFileUploadForm"
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

					<sj:div id="displayBCDetails" style="height: 40px;"></sj:div>
					<table width="100%">
						<tr>
							<td colspan="4" align="left">
								<div class="divSearchConditionBC"></div>
							</td>
						</tr>
					</table>
					<s:url var="CUDFileUploadBCURL" action="CUDFileUploadBCGrid.action" />
					<sjg:grid id="CUDFileUploadBCGrid"
						caption="BC wise CUD File Processing Status Report"
						dataType="json" href="%{CUDFileUploadBCURL}" pager="true"
						sortname="branchCode" sortable="true" autowidth="true"
						shrinkToFit="false" gridModel="selectedList" rowList="10,15,20,25"
						rowNum="15" viewrecords="true" rownumbers="true"
						formIds="CUDFileUploadForm" footerrow="true"
						userDataOnFooter="true" reloadTopics="reloadBCGrid"
						navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
						navigatorSearch="true" navigator="true" navigatorView="true"
						onCompleteTopics="onloadBCGrid" navigatorRefresh="false"
						navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBC,
				marksearched:true,onReset:clearSearchBC,dragable:true}"
						navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadBCGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelBC'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFBC'}}">

						<sjg:gridColumn name="sendDate" index="sendDate" title="Send Date"
							formatter="date" sortable="true" width="70"
							formatoptions="{newformat : 'd-M-y'}" search="true"
							searchoptions=" {sopt:['cn','bw']}" />
						<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
							sortable="true" align="center" width="70" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
							sortable="false" align="center" width="85" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="districtName" index="districtName"
							title="District Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="talukaName" index="talukaName"
							title="Taluka Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="branchCode" index="branchCode"
							align="center" title="Branch Code" sortable="true" width="90" />
						<sjg:gridColumn name="branchName" index="branchName"
							title="Branch Name" sortable="true" width="160" align="left" />
						<sjg:gridColumn name="regionName" index="regionName"
							title="Region Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="villageCode" index="villageCode"
							align="center" title="Village Code" sortable="true" width="60"
							search="true" searchoptions=" {sopt:['eq','cn','bw']}" />
						<sjg:gridColumn name="cudFileName" index="cudFileName"
							title="ACC File Name" sortable="true" width="360" search="true"
							searchoptions=" {sopt:['eq','cn','bw']}" align="center" />
						<sjg:gridColumn name="noOfAcc" index="noOfAcc" formatter="integer"
							align="right" title="Total Accounts" sortable="true" width="60"
							search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
						<sjg:gridColumn name="authorized" index="authorized"
							formatter="integer" align="right" title="A/c Authorized"
							sortable="true" width="70" search="true"
							searchoptions="{sopt: ['eq','lt','gt']}" />
						<sjg:gridColumn name="rejected" index="rejected" align="right"
							formatter="integer" title="A/c Rejected" sortable="true"
							width="70" search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
						<sjg:gridColumn name="pendingToAuthorize" formatter="integer"
							index="pendingToAuthorize" align="right"
							title="Pending to Authorize" sortable="true" width="70"
							search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
					</sjg:grid>
					<table width="100%">
						<tr>
							<td><sj:div id="divTotal_BC" cssClass="tab-div-Total" /></td>
						</tr>

					</table>
				</div>
			</sj:tab>
		</sj:tabbedpanel>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>
</body>
</html>
