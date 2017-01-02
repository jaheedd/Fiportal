<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<sj:head jqueryui="true" jquerytheme="south-street" ajaxcache="false" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script>
	function doChange(action) {
		if (action == 'branch') {
			var branchCode = $('#branchSelect').val();
			$('#displayBranchDetails').html('');
			if (branchCode != "-1")
				$.getJSON('findBranchHeaderData.action', {
					'branchCode' : branchCode,
				}, function(data) {
					var region = (data.branchHeader.regionName);
					var district = (data.branchHeader.districtName);
					$('#displayBranchDetails').html(
							"<table cellpadding='5' cellspacing='5'> <tr>"
									+ "<td>REGION : </td><td>      " + region
									+ "</td><td>DISTRICT : </td><td>"
									+ district + "</td></tr></table>");
				});
		} else if (action == 'bc') {
			var bcCode = $('#bcSelect').val();
			$('#displayBcDetails').html('');
			if (bcCode != "-1")
				$.getJSON('findBcHeaderData.action', {
					'bcCode' : bcCode,
				}, function(data) {
					var region = (data.bcHeader.regionName);
					var district = (data.bcHeader.districtName);
					var branchCode = (data.bcHeader.branchCode);
					var branchName = (data.bcHeader.branchName);
					$('#displayBcDetails').html(
							"<table cellpadding='5'> <tr>"
									+ "<td>REGION:</td><td>      " + region
									+ "</td><td>DISTRICT : </td><td>"
									+ district
									+ "</td><td>BRANCH CODE : </td><td>"
									+ branchCode
									+ "</td><td>BRANCH NAME : </td><td>"
									+ branchName + "</td></tr></table>");
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
		} else if (action == 'pm_acBC') {
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
		if (getRecords("#rejEnrBranchGrid")) {
			var action = "";
			if (format == 'Excel')
				action = "XslReportOfRejectedEnrReportsBranch.action";
			else if (format == 'PDF')
				action = "PdfReportOfRejectedEnrReportsBranch.action";
			var postData = $("#rejEnrBranchGrid").jqGrid("getGridParam",
					"postData");
			var branchName = $('#branchSelect option:selected').text().split(
					':')[0];
			var pmNameBranch = $("#pmSelectBranch option:selected").text()
					.split(':')[0].trim();
			var acNameBranch = $("#acSelectBranch option:selected").text()
					.split(':')[0].trim();
			var filterString = $(".divSearchConditionBranch").text();
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&filters=" + postData.filters
					+ "&filterString=" + filterString + "&branchName="
					+ branchName + "&pmNameBranch=" + pmNameBranch
					+ "&acNameBranch=" + acNameBranch;
			document.forms['enrRejectionForm'].action = action + parameters;
			document.forms['enrRejectionForm'].submit();
		}
	}
	$.subscribe('ExportToExcelBranch', function(pID, id) {
		generateBranchReport('Excel');
	});
	$.subscribe('ExportToPDFBranch', function(pID, id) {
		generateBranchReport('PDF');
	});
	function generateBCReport(format) {
		if (getRecords("#rejEnrBCGrid")) {
			var action = "";
			if (format == 'Excel')
				action = "XslReportOfRejectedEnrReportsBc.action";
			else if (format == 'PDF')
				action = "PdfReportOfRejectedEnrReportsBc.action";
			var postData = $("#rejEnrBCGrid")
					.jqGrid("getGridParam", "postData");
			var bcName = $('#bcSelect option:selected').text().split(':')[0];
			var pmNameBC = $("#pmSelectBC option:selected").text().split(':')[0]
					.trim();
			var acNameBC = $("#acSelectBC option:selected").text().split(':')[0]
					.trim();
			var filterString = $(".divSearchConditionBC").text();
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&filters=" + postData.filters
					+ "&filterString=" + filterString + "&bcName=" + bcName
					+ "&pmNameBC=" + pmNameBC + "&acNameBC=" + acNameBC;
			document.forms['enrRejectionForm'].action = action + parameters;
			document.forms['enrRejectionForm'].submit();

		}
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
		$("#sDateBranch").val(date);
		$("#sDateBC").val(date);

	});
	$.subscribe('validateBranchDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#eDateBranch').datepicker('option', 'minDate', date);
		}
	});
	function onKeyDown(event) {

		if (event.which == 8) {
			$(event.target).val("");
			return true;
		} else
			return false;
	}
	$.subscribe('validateBCDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#eDateBC').datepicker('option', 'minDate', date);
		}
	});
	$.subscribe('loadBranchGrid', function(event, data) {
		$("#rejEnrBranchGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBranchGrid");
	});
	$.subscribe('loadBCGrid', function(event, data) {
		$("#rejEnrBCGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadBCGrid");

	});
	$.subscribe('loadTotalBranch', function(event, data) {
		var records = getRecords("#rejEnrBranchGrid");
		showEnrReasonWiseBranch();
		$("#divBranchTotal").html(
				"TOTAL No. OF REJECTED ENROLLMENTS : " + toInteger(records));
	});
	$.subscribe('loadTotalBC', function(event, data) {
		showEnrReasonWiseBC();
		var records = getRecords("#rejEnrBCGrid");
		$("#divBCTotal").html(
				"TOTAL No. OF REJECTED ENROLLMENTS : " + toInteger(records));
	});
	function showEnrReasonWiseBranch() {
		var branchCode = $('#branchSelect').val();
		var startDate = $('#sDateBranch').val();
		var endDate = $('#eDateBranch').val();
		$.getJSON('EnrRejectionReasonWiseBranch.action', {
			'branchCode' : branchCode,
			'startDateBranch' : startDate,
			'endDateBranch' : endDate
		}, function(jData) {
			var list = jData.reasonWiseList;
			getReasonWiseList(list, 'branch');
		});
	}
	function showEnrReasonWiseBC() {
		var bcCode = $('#bcSelect').val();
		bcCode = bcCode == "" ? "-1" : bcCode;
		var startDate = $('#sDateBC').val();
		var endDate = $('#eDateBC').val();
		$.getJSON('EnrRejectionReasonWiseBC.action', {
			'bcCode' : bcCode,
			'startDateBC' : startDate,
			'endDateBC' : endDate
		}, function(jData) {
			var list = jData.reasonWiseList;
			getReasonWiseList(list, 'bc');
		});
	}
	function getReasonWiseList(list, tabID) {
		var rows = "";
		var l = list.length;
		for (var index = 0; index < l; index++) {
			rows += "<tr><td align='center'><a title-text='"
					+ list[index].reasonDesc
					+ "' class='class-with-tooltip' onclick='getByReasonEnr(\""
					+ tabID + "\",\"" + list[index].reasonDesc + "\")'>"
					+ list[index].reasonDesc + "</a></td><td align='right'>"
					+ toInteger(list[index].txnCount) + "</td>";
			if (index < l - 1) {

				rows += "<td align='center'><a title-text='"
						+ list[++index].reasonDesc
						+ "' class='class-with-tooltip' onclick='getByReasonEnr(\""
						+ tabID + "\",\"" + list[index].reasonDesc + "\")'>"
						+ list[index].reasonDesc
						+ "</a></td><td align='right'>"
						+ toInteger(list[index].txnCount) + "</td></tr>";
			}
		}
		var id = tabID == 'branch' ? '#divEnrReasonWiseTotalBranch'
				: '#divEnrReasonWiseTotalBC';
		$(id)
				.html(
						"<strong><table class='tbl-txn-failed-Summary' cellpadding='5' cellspacing='5'><tr><th>Reason of Rejection<th width='80px'>Rejection Count</th>"
								+ "<th>Reason of Rejection<th width='80px'>Rejection Count</th></tr>"
								+ rows + "</table></strong>");
	}
	function getByReasonEnr(tabID, reason) {
		$('#reasonWiseEnrDialog').dialog('option', 'title',
				"Enrollment rejection report for reason : " + reason);

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
		$('#reasonWiseEnrGridID').jqGrid("setGridParam", {
			"postData" : {
				'tabID' : tabID,
				'rejectionReason' : reason,
				'startDate' : sDate,
				'endDate' : eDate,
				'code' : code
			},
			records : 0,
			page : 1
		}).trigger('reloadGrid');
		$('#reasonWiseEnrDialog').dialog('open');
	}
	$.subscribe('clearGrid', function(grid, data) {
		$('#reasonWiseEnrDialog').jqGrid('clearGridData');
		$("#reasonWiseEnrDialog").jqGrid("setGridParam", {
			search : false,
			postData : {
				'_search' : false,
				"filters" : ""
			}
		});
		clearSearchReasonWise();
	});
	$.subscribe('ExportToExcelReasonWise', function(pID, id) {
		generateReportReasonWise('Excel');
	});
	$.subscribe('ExportToPDFReasonWise', function(pID, id) {
		generateReportReasonWise('PDF');
	});
	function generateReportReasonWise(format) {
		if (getRecords("#reasonWiseEnrGridID")) {
			var action = "";
			if (format == 'Excel')
				action = "XslEnrRejReasonWise.action";
			else if (format == 'PDF')
				action = "PdfEnrRejReasonWise.action";
			var filterString = $(".divSearchConditionReasonWise").text();
			var postData = $("#reasonWiseEnrGridID").jqGrid("getGridParam",
					"postData");
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&filters=" + postData.filters
					+ "&filterString=" + filterString + "&rejectionReason="
					+ postData.rejectionReason + "&code=" + postData.code
					+ "&startDate=" + postData.startDate + "&endDate="
					+ postData.endDate + "&tabID=" + postData.tabID;
			document.forms['enrRejectionForm'].action = action + parameters;
			document.forms['enrRejectionForm'].submit();
		}
	}
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="enrRejectionForm" theme="css_xhtml" method="post">
		<sj:tabbedpanel id="taskTabs">
			<sj:tab target="divBranch" label="Branch">
				<sj:div id="divBranch">
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
									headerKey="-1" id="branchSelect" headerValue="All"
									labelSeparator="<br>" labelposition="left" list="branchList" indicator="branchListIndicator"
									listValue="displayValue" listKey="key" href="%{loadBranchList}" reloadTopics="reloadBranchList"
									name="branchCode" onchange="doChange('branch')" /></td>
							<td colspan="2">
									<sj:datepicker name="startDateBranch" id="sDateBranch"
										labelposition="left" showOn="focus" label="From Date"
										labelSeparator="<br>" onChangeTopics="validateBranchDate"
										displayFormat="dd/mm/yy" readonly="false" maxDate="today"
										onkeydown="return datepickerKeyDown(event);" /></td>
								<td>	<sj:datepicker name="endDateBranch" id="eDateBranch"
										disabled="false" labelSeparator="<br>" label="To Date"
										value="today" showOn="focus" labelposition="left"
										displayFormat="dd/mm/yy" readonly="false" maxDate="today"
										onkeydown="return datepickerKeyDown(event);" />
								</td>
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
									headerKey="-1" id="pmSelectBranch" href="%{pmListUrl}"
									deferredLoading="true" reloadTopics="reloadMPListBranch"
									label="Project Manager" labelposition="left" indicator="pmListIndicator"
									labelSeparator="<br>" headerValue="All" list="pmList"
									listKey="key" listValue="displayValue" name="pmCodeBranch"
									disabled="true" onChangeTopics="reloadAcListBranch" /></td>

							<td><img id="acListIndicator" class="indicator-small"
								src="images/indicator_small.gif" /> <s:url var="acListUrl"
									action="loadACByPMBranch" /> <sj:select headerKey="-1"
									id="acSelectBranch" formIds="enrRejectionForm"
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
					<s:url var="branchSelection"
						action="branchEnrollmentRejection.action" />
					<sjg:grid id="rejEnrBranchGrid"
						caption="Branch Wise Enrollment Rejection Report" dataType="json"
						href="%{branchSelection}" pager="true"
						gridModel="rejEnrBranchSubList" rowList="10,15,20,25" rowNum="15"
						sortname="bcCode" sortable="true" viewrecords="true"
						rownumbers="true" autowidth="true" shrinkToFit="false"
						formIds="enrRejectionForm" reloadTopics="reloadBranchGrid"
						onCompleteTopics="loadTotalBranch" navigatorAdd="false"
						navigatorDelete="false" navigatorSearch="true" navigator="true"
						navigatorView="true" navigatorEdit="false"
						navigatorRefresh="false"
						navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBranch,
				onReset:clearSearchBranch,dragable:true}"
						navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'reloadBranchGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcelBranch'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDFBranch'}}">

						<sjg:gridColumn name="regionName" index="regionName"
							title="Region Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="districtName" index="districtName"
							title="District Name" sortable="true" width="110" search="true"
							searchoptions="{sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="talukaName" index="talukaName"
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
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="150" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="enrollDate" index="enrollDate"
							formatoptions="{newformat : 'd-M-y'}" formatter="date"
							title="Enrollment Date" sortable="true" width="60" search="true"
							searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}" />
						<sjg:gridColumn name="enrUrn" index="enrUrn"
							title="Enrollment URN No." sortable="true" width="150"
							search="true" searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="customerName" index="customerName"
							title="Customer Name" sortable="true" width="150" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="address1" index="address1" title="Address"
							sortable="true" width="150" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="docType" index="docType"
							title="ID Proof Doc." sortable="true" width="130" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="documentNo" index="documentNo"
							title="ID No." sortable="true" width="90" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="rejectedReason" index="rejectedReason"
							title="Reason of Rejection" sortable="true" width="350"
							search="true" searchoptions=" {sopt:['cn','bw','eq']}" />

					</sjg:grid>
					<table width="100%">
						<tr>
							<td style="float: left;"><sj:div
									id="divEnrReasonWiseTotalBranch" /></td>
						</tr>
						<tr>
							<td><sj:div id="divBranchTotal" cssClass="tab-div-total" /></td>
						</tr>
					</table>

				</sj:div>
			</sj:tab>
			<sj:tab target="divBc" label="BC">
				<sj:div id="divBc">
					<s:url var="loadBCList" action="loadBC.action" />
					<table cellpadding="6" class="filterTable-tabs" width="70%">
						<tr>
							<td style="max-width: 20px; min-width: 20px;"><input
								id="filterOptionsstate_BC" type="radio" value="bc"
								name="filterOptionsBC" align="middle" checked="checked"
								onchange="changeFilter('bc');"></td>
							<td width="120px"><img id="bcListIndicator" class="indicator-small"
								src="images/indicator_small.gif" />
							<sj:select label="Select BC"
									headerKey="-1" labelposition="left" headerValue="All" reloadTopics="reloadBCList"
									labelSeparator="<br>" id="bcSelect" list="bcList" indicator="bcListIndicator"
									href="%{loadBCList}" listValue="displayValue" listKey="key"
									name="bcCode" onchange="doChange('bc')"
									formIds="enrRejectionForm" /></td>
							<td colspan="2">
									<sj:datepicker name="startDateBC" id="sDateBC"
										labelposition="left" showOn="focus" label="From Date"
										labelSeparator="<br>" onChangeTopics="validateBCDate"
										displayFormat="dd/mm/yy" readonly="false" maxDate="today"
										onkeydown="return datepickerKeyDown(event);" /></td>
								<td>	<sj:datepicker name="endDateBC" id="eDateBC" disabled="false"
										labelSeparator="<br>" label="To Date" showOn="focus"
										value="today" labelposition="left" displayFormat="dd/mm/yy"
										readonly="false" maxDate="today"
										onkeydown="return datepickerKeyDown(event);" />
								</td>
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
									id="acSelectBC" formIds="enrRejectionForm"
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
					<s:url var="bcSelection" action="bcEnrollmentRejection.action" />
					<sjg:grid id="rejEnrBCGrid"
						caption="BC Wise Enrollment Rejection Report" dataType="json"
						href="%{bcSelection}" pager="true" sortname="bcCode"
						viewrecords="true" gridModel="rejEnrBcSubList"
						rowList="10,15,20,25" rowNum="15" rownumbers="true"
						autowidth="true" formIds="enrRejectionForm" sortable="true"
						shrinkToFit="false" reloadTopics="reloadBCGrid"
						onCompleteTopics="loadTotalBC" navigatorAdd="false"
						navigatorDelete="false" navigatorSearch="true" navigator="true"
						navigatorView="true" navigatorEdit="false"
						navigatorRefresh="false"
						navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchBC,
				onReset:clearSearchBC,dragable:true}"
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
							title="Branch Code" sortable="true" width="70" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="branchName" index="branchName"
							title="Branch Name" sortable="true" width="100" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
							sortable="true" width="80" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
							sortable="true" width="150" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="enrollDate" index="enrollDate"
							formatoptions="{newformat : 'd-M-y'}" formatter="date"
							title="Enrollment Date" sortable="true" width="60" search="true"
							searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}" />
						<sjg:gridColumn name="enrUrn" index="enrUrn"
							title="Enrollment URN No." sortable="true" width="150"
							search="true" searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="customerName" index="customerName"
							title="Customer Name" sortable="true" width="150" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="address1" index="address1" title="Address"
							sortable="true" width="150" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="villageName" index="villageName"
							title="Village Name" sortable="true" width="110" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="docType" index="docType"
							title="ID Proof Doc." sortable="true" width="130" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="documentNo" index="documentNo"
							title="ID No." sortable="true" width="90" search="true"
							searchoptions=" {sopt:['cn','bw','eq']}" />
						<sjg:gridColumn name="rejectedReason" index="rejectedReason"
							title="Reason of Rejection" sortable="true" width="350"
							search="true" searchoptions=" {sopt:['cn','bw','eq']}" />
					</sjg:grid>
					<table width="100%">
						<tr>
							<td style="float: left;"><sj:div
									id="divEnrReasonWiseTotalBC" /></td>
						</tr>
						<tr>
							<td><sj:div id="divBCTotal" cssClass="tab-div-total" /></td>
						</tr>
					</table>
				</sj:div>
			</sj:tab>
		</sj:tabbedpanel>
		<sj:dialog id="reasonWiseEnrDialog" autoOpen="false" width="900"
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
			<s:url var="reasonWiseEnrGridURL"
				action="EnrRejReasonWiseGrid.action"></s:url>
			<sjg:grid id="reasonWiseEnrGridID" href="%{reasonWiseEnrGridURL}"
				formIds="enrRejectionForm" gridModel="reasonWiseGridList"
				shrinkToFit="false" autowidth="false" width="840" pager="true"
				viewrecords="true" rowList="10,15,20,25" rowNum="15"
				rownumbers="true" sortname="enrollDate" sortorder="desc"
				navigator="true" navigatorAdd="false" navigatorDelete="false"
				navigatorEdit="false" navigatorRefresh="false" navigatorView="false"
				reloadTopics="loadEnrRejReasonWiseGrid"
				navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchReasonWise,
				onReset:clearSearchReasonWise,dragable:true}"
				navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadEnrRejReasonWiseGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcelReasonWise : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Excel',topic:'ExportToExcelReasonWise'}, exportToPDFReasonWise : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'PDF',topic:'ExportToPDFReasonWise'}}">
				<sjg:gridColumn name="enrollDate" index="enrollDate"
					title="Enrollment Date" sortable="true" width="70" search="true"
					formatter="date" formatoptions="{newformat : 'd-M-y'}"
					searchoptions="{sopt: ['eq','bw','cn'],dataInit:dateField}" />
				<sjg:gridColumn name="sendDate" index="sendDate" title="Send Date"
					sortable="true" width="70" search="true" formatter="date"
					formatoptions="{newformat : 'd-M-y'}"
					searchoptions="{sopt: ['eq','bw','cn'],dataInit:dateField}" />
				<sjg:gridColumn name="fiAccNo" index="fiAccNo" title="FI A/c No."
					sortable="true" width="70" search="true" align="left"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="custName" index="custName"
					title="Customer Name" sortable="true" search="true" width="150"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="branchCode" index="branchCode"
					title="Branch Code" sortable="true" width="70" search="true"
					align="left" searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="address" index="address"
					title="Customer Address" sortable="true" search="true" width="150"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="villageName" index="villageName"
					title="Village Name" sortable="true" search="true" width="100"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="districtName" index="districtName"
					title="District Name" sortable="true" width="100" search="true"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
					sortable="true" width="90" search="true" align="left"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
					sortable="true" width="110" search="true" align="left"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="dob" index="dob" title="Date of Birth"
					sortable="true" search="true" formatter="date" width="70"
					formatoptions="{newformat : 'd-M-y'}"
					searchoptions="{sopt: ['eq','bw','cn'],dataInit:dateField}" />
				<sjg:gridColumn name="docCode" index="docCode" title="ID Proof Doc."
					sortable="true" search="true" width="120"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="docNo" index="docNo" title="ID No."
					sortable="true" search="true" width="80"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="kycType" index="kycType"
					title="KYC Address Type" sortable="true" search="true" width="80"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="kycAddress" index="kycAddress" width="80"
					title="KYC Address No." sortable="true" search="true"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="introFlag" index="introFlag" width="70"
					title="Introducer Flag" sortable="true" search="true"
					searchoptions="{sopt: ['eq','bw','cn']}" />
				<sjg:gridColumn name="introAcc" index="introAcc" width="70"
					title="Introducer A/c No." sortable="true" search="true"
					searchoptions="{sopt: ['eq','bw','cn']}" />
			</sjg:grid>
		</sj:dialog>
	</s:form>
</body>
</html>