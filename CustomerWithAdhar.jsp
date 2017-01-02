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
	function doChange(action) {
		if (action == 'branch') {
			$('#displayBranchDetails').html('');
			var branchCode = $('#branchSelect').val();
			if (branchCode != '-1')
				$
						.getJSON(
								'findBranchHeaderData.action',
								{
									'branchCode' : branchCode,
								},
								function(data) {
									var region = (data.branchHeader.regionName);
									var district = (data.branchHeader.districtName);
									$('#displayBranchDetails')
											.html(
													"<table cellpadding='5' cellspacing='5' style='font-size: 2; font-family: times new roman; font-weight: bold;'> <tr>"
															+ "<td>REGION : </td><td>      "
															+ region
															+ "</td><td>DISTRICT : </td><td>"
															+ district
															+ "</td></tr></table>");
								});
		} else if (action == 'bc') {
			$('#displayBcDetails').html('');
			var bcCode = $('#bcSelect').val();
			if (bcCode != '-1')
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
									$('#displayBcDetails')
											.html(
													"<table cellpadding='5' cellspacing='5' style='font-size: 2; font-family: times new roman; font-weight: bold;'> <tr>"
															+ "<td>REGION:</td><td>      "
															+ region
															+ "</td><td>DISTRICT : </td><td>"
															+ district
															+ "</td><td>BRANCH CODE : </td><td>"
															+ branchCode
															+ "</td><td>BRANCH NAME : </td><td>"
															+ branchName
															+ "</td></tr></table>");
								});
		}
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
			$("#displayBranchDetails").html('');
		}
		else if(action == 'pm_acBC'){
			removeSelectValues("bcSelect");
			$("#bcSelect").attr("disabled", "true");
			$("#pmSelectBC").removeAttr("disabled");
			$("#acSelectBC").removeAttr("disabled");
			$.publish('reloadMPListBC');
			$.publish('reloadAcListBC');
			$("#displayBcDetails").html('');
			}
	}
	function generateBranchReport(format) {
		var action = "";
		if (format == 'Excel')
			action = "xslCustomerWithAdharBranch.action";
		else if (format == 'PDF')
			action = "pdfCustomerWithAdharBranch.action";
		var postData = $("#branchGridID").jqGrid("getGridParam", "postData");
		var branchName = $('#branchSelect option:selected').text().split(':')[0];
		var pmNameBranch = $("#pmSelectBranch option:selected").text().split(':')[0].trim();
		var acNameBranch = $("#acSelectBranch option:selected").text().split(':')[0].trim();
		var filterString = $(".divSearchConditionBranch").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString + "&branchName=" + branchName + "&pmNameBranch=" +pmNameBranch + "&acNameBranch=" + acNameBranch;
		document.forms['custWithAdharForm'].action = action + parameters;
		document.forms['custWithAdharForm'].submit();
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
			action = "xslCustomerWithAdharBC.action";
		else if (format == 'PDF')
			action = "pdfCustomerWithAdharBC.action";
		var postData = $("#bcGridID").jqGrid("getGridParam", "postData");
		var bcName = $('#bcSelect option:selected').text().split(':')[0];
		var pmNameBC = $("#pmSelectBC option:selected").text().split(':')[0].trim();
		var acNameBC= $("#acSelectBC option:selected").text().split(':')[0].trim();
		var filterString = $(".divSearchConditionBC").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString + "&bcName=" + bcName + "&pmNameBC=" + pmNameBC + "&acNameBC=" +acNameBC;
		document.forms['custWithAdharForm'].action = action + parameters;
		document.forms['custWithAdharForm'].submit();
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
	$.subscribe('loadBranchGrid', function(event, data) {
		$("#branchGridID").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBranchGrid");
	});
	$.subscribe('loadBCGrid', function(event, data) {
		$("#bcGridID").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBCGrid");
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
	$.subscribe('onGridComplete', function(event, data) {
		var records = $("#branchGridID").jqGrid("getGridParam", "records");
		$("#custWithAdharBranchTblSummary").html(
				"<tr><td>TOTAL AADHAAR NUMBER MAPPED WITH A/c NUMBER </td><td align='right'> "
						+ toInteger(records) + "</td></tr>");
	});
	$.subscribe('onGridComplete', function(event, data) {
		var records = $("#bcGridID").jqGrid("getGridParam", "records");
		$("#custWithAdharBCTblSummary").html(
				"<tr><td>TOTAL AADHAAR NUMBER MAPPED WITH A/c NUMBER </td><td align='right'> "
						+ toInteger(records) + "</td></tr>");
	});
</script>
</head>
<body class="tabsBody">
	<hr color="#F28500">
	<s:form id="custWithAdharForm" method="post" theme="css_xhtml">
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
							<sj:select label="Select Branch"
									headerKey="-1" id="branchSelect" headerValue="All" indicator="branchListIndicator"
									labelSeparator="<br>" labelposition="left" list="branchList"
									listValue="displayValue" listKey="key" href="%{loadBranchList}"
									name="branchCode" onchange="doChange('branch')"
									reloadTopics="reloadBranchList" /></td>
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
								src="images/indicator_small.gif" />
							<s:url var="pmListUrl" action="loadPMList" /> <sj:select
									headerKey="-1" id="pmSelectBranch" href="%{pmListUrl}" indicator="pmListIndicator"
									deferredLoading="true" reloadTopics="reloadMPListBranch"
									label="Project Manager" labelposition="left"
									labelSeparator="<br>" headerValue="All" list="pmList"
									listKey="key" listValue="displayValue" name="pmCodeBranch"
									disabled="true" onChangeTopics="reloadAcListBranch" /></td>

							<td><img id="acListIndicator" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="acListUrl"
									action="loadACByPMBranch" /> <sj:select headerKey="-1"
									id="acSelectBranch" formIds="custWithAdharForm"
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
					<sj:div id="displayBranchDetails" style="height: 40px;"></sj:div>
					<table width="100%">
						<tr>
							<td colspan="4" align="left">
								<div class="divSearchConditionBranch"></div>
							</td>
						</tr>
					</table>
					<s:url var="custWithAdharGridBranchURL"
						action="custWithAdharBranchGrid.action" />
					<sjg:grid id="branchGridID"
						caption="Customers having Aadhaar Number" dataType="json"
						sortable="true" autowidth="true" shrinkToFit="false"
						formIds="custWithAdharForm" href="%{custWithAdharGridBranchURL}"
						pager="true" sortname="custName" gridModel="vosBranch"
						viewrecords="true" rowList="10,15,20,25" rowNum="15"
						rownumbers="true" reloadTopics="reloadBranchGrid"
						navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
						navigatorSearch="true" navigator="true" navigatorView="true"
						onCompleteTopics="onGridComplete" navigatorRefresh="false"
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
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="districtName" index="districtName"
							title="District Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="talukaName" index="talukaName"
							title="Taluka Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchCode" index="branchCode"
							title="Branch Code" sortable="true" width="55" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchName" index="branchName"
							title="Branch Name" sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
							sorttype="int" sortable="true" search="true" searchtype="text"
							width="55" searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="custName" index="custName"
							title="Customer Name" sortable="true" width="130" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="cbsAcc" index="cbsAcc" title="CBS A/c No."
							sortable="true" width="90" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="docType" index="docType"
							title="ID Proof Doc." sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="adharNo" index="adharNo" title="Aadhaar No."
							sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
					</sjg:grid>

					<table width="100%">
						<tr>
							<td width="60%"><table class="tblTotalSummary"
									id="custWithAdharBranchTblSummary"></table></td>
						</tr>
					</table>
				</div>
			</sj:tab>
			<sj:tab target="divBC" label="BC ">
				<div id="divBC">
					<s:url var="loadBCList" action="loadBC.action" />
					<table cellpadding="6" class="filterTable-tabs" width="70%">
						<tr>
							<td rowspan="1" style="max-width: 30px; min-width: 20px;"><input
								id="filterOptionsstate_BC" type="radio" value="bc"
								name="filterOptionsBC" align="middle" checked="checked"
								onchange="changeFilter('bc');"></td>
							<td width="120px"><img id="bcListIndicator" class="indicator-small"
								src="images/indicator_small.gif" />
							<sj:select label="Select BC" indicator="bcListIndicator"
									headerKey="-1" labelposition="left" headerValue="All"
									labelSeparator="<br>" id="bcSelect" list="bcList"
									href="%{loadBCList}" listValue="displayValue"
									onchange="doChange('bc')" reloadTopics="reloadBCList"
									listKey="key" name="bcCode" formIds="custWithAdharForm" /></td>
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

							<td><small><sj:a button="true" id="filterBC"
										buttonIcon="ui-icon-refresh" name="filterBC"
										onClickTopics="loadBCGrid">
						Generate Report
					</sj:a></small></td>
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
									id="acSelectBC" formIds="custWithAdharForm"
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
					<sj:div id="displayBcDetails" style="height: 40px;"></sj:div>
					<table width="100%">
						<tr>
							<td colspan="4" align="left">
								<div class="divSearchConditionBC"></div>
							</td>
						</tr>
					</table>
					<s:url var="custWithAdharGridBCURL"
						action="custWithAdharBCGrid.action" />
					<s:url var="custWithAdharGridURL" action="custWithAdharByBC.action" />
					<sjg:grid id="bcGridID" caption="Customers having Aadhaar Number"
						dataType="json" sortable="true" autowidth="true"
						shrinkToFit="false" formIds="custWithAdharForm"
						href="%{custWithAdharGridBCURL}" pager="true" sortname="custName"
						gridModel="vosBC" viewrecords="true" rowList="10,15,20,25"
						rowNum="15" rownumbers="true" reloadTopics="reloadBCGrid"
						navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
						navigatorSearch="true" navigator="true" navigatorView="true"
						onCompleteTopics="onGridComplete" navigatorRefresh="false"
						navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBC,
				marksearched:true,onReset:clearSearchBC,dragable:true}"
						navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadBCGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelBC'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFBC'}}">

						<sjg:gridColumn name="regionName" index="regionName"
							title="Region Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="districtName" index="districtName"
							title="District Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="talukaName" index="talukaName"
							title="Taluka Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchCode" index="branchCode"
							title="Branch Code" sortable="true" width="55" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchName" index="branchName"
							title="Branch Name" sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
							sorttype="int" sortable="true" search="true" searchtype="text"
							width="55" searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="custName" index="custName"
							title="Customer Name" sortable="true" width="130" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="cbsAcc" index="cbsAcc" title="CBS A/c No."
							sortable="true" width="90" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="docType" index="docType"
							title="ID Proof Doc." sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="adharNo" index="adharNo" title="Aadhaar No."
							sortable="true" width="120" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
					</sjg:grid>

					<table width="100%">
						<tr>
							<td><table class="tblTotalSummary"
									id="custWithAdharBCTblSummary"></table></td>
						</tr>
					</table>
				</div>
			</sj:tab>
		</sj:tabbedpanel>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>

</body>
</html>
