<%@page import="javax.xml.bind.annotation.XmlElementDecl.GLOBAL"%>
<%@page import="org.apache.catalina.Globals"%>
<%@page import="org.apache.tomcat.jni.Global"%>
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
<head>
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
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
			$.publish('reloadTalukaList');
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
		var stateCode = $('#stateSelect').val();
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		$
				.getJSON(
						'findTotal.action',
						{
							'stateCode' : stateCode,
							'startDate' : startDate,
							'endDate' : endDate
						},
						function(data) {
							var totalValue = $("#enrollReportsGrid").jqGrid(
									"getGridParam", "userData");
							$("#enrollReportsGrid").jqGrid("footerData", "set",
									totalValue, false);
							var cbsAcc = "";
							if (data.totCBSAcc > 0) {
								cbsAcc = ("</td></tr><tr><td>H] TOTAL CBS ACCOUNTS RECEIVED </td><td align='right'>" + toInteger(data.totCBSAcc));
							}
							$('#divTotal')
									.html(
											"<strong><table cellpadding='5' cellspacing='5' class='tblTotalSummary'> <tr>"
													+ "<td>A] TOTAL ENROLLMENT  </td><td align='right'>"
													+ toInteger(totalValue.enrollment)
													+ "</td></tr><tr><td>B] TOTAL UPLOADED FOR AUTHORIZATION </td><td align='right'>"
													+ toInteger(totalValue.uploadedEnroll)
													+ "</td></tr><tr><td>C] TOTAL ENROLLMENT PENDING FOR UPLOADING </td><td align='right'>"
													+ toInteger(totalValue.yetToProcess)
													+ "</td></tr><tr><td>D] TOTAL CBS ACCOUNTS RECEIVED (OUT OF B)</td><td align='right'>"
													+ toInteger(totalValue.accountOpenInCBS)
													+ "</td></tr><tr><td>E] TOTAL ENROLLMENT REJECTED </td><td align='right'>"
													+ toInteger(totalValue.rejectedEnroll)
													+ "</td></tr><tr><td>F] TOTAL ENROLLMENT PENDING FOR AUTHORIZATION</td><td align='right'>"
													+ toInteger(totalValue.yetToAuth)
													+ "</td></tr><tr><td>G] TOTAL ENROLLMENT PENDING AT MOBILIZ </td><td align='right'>"
													+ toInteger(totalValue.pendToMobiliz)
													+ cbsAcc
													+ "</td></tr></table></strong>");
						});

	}
	$.subscribe('validateDate', function(event, data) {
		var date = event.originalEvent.dateText;
		if (date != "") {
			$('#endDate').datepicker('option', 'minDate', date);
			$("#endDate").removeAttr("disabled");
		}
	});
	function getRecords() {
		return $("#enrollReportsGrid").jqGrid("getGridParam", "records");
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
				action = "XslReportOfEnrollmentReports.action";
			else if (format == 'PDF')
				action = "PdfReportOfEnrollmentReports.action";
			var filterString = $(".divSearchCondition").text();
			var filterVO = getFilterVO();
			var villageName = $('#villageSelect option:selected').text().split(
					':')[0];
			var postData = $("#enrollReportsGrid").jqGrid("getGridParam",
					"postData");
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&filters=" + postData.filters
					+ "&villageName=" + villageName + "&filterString="
					+ filterString + "&filterVO=" + filterVO;
			document.forms['frmSelection'].action = action + parameters;
			document.forms['frmSelection'].submit();
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
		$("#enrollReportsGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});//.trigger("reloadGrid");
		$.publish("reloadGrids");
	});
	$.subscribe('subGridExportExcel', function(pID, id) {
		var colNames = $(id).jqGrid("getGridParam", "colNames");
		var bcCode = id.id.split('_')[1];
		var postData = $(id).jqGrid("getGridParam", "postData");
		window.location = "xslEnrollmentDateWise.action?sidx=" + postData.sidx
				+ "&sord=" + postData.sord + "&columnNames=" + colNames
				+ "&id=" + bcCode;
	});
	$.subscribe('subGridExportPDF', function(pID, id) {
		var colNames = $(id).jqGrid("getGridParam", "colNames");
		var bcCode = id.id.split('_')[1];
		var postData = $(id).jqGrid("getGridParam", "postData");
		window.location = "pdfEnrollmentDateWise.action?sidx=" + postData.sidx
				+ "&sord=" + postData.sord + "&columnNames=" + colNames
				+ "&id=" + bcCode;
	});
	function linkFormat(cellvalue, options, rowObject) {
		var column = options.colModel.name;
		if (cellvalue == 0) {
			return cellvalue;
		} else {
			var cellValueInt = toInteger(cellvalue);
			return "<a id=\"id_" + cellvalue
					+ "\" onClick='showEnrollmentDetail(\"" + column + "\",\""
					+ rowObject.bcCode + "\",\"" + rowObject.bcName
					+ "\")' class='linkStyle'>" + cellValueInt + "</a>";
		}
	}
	function showEnrollmentDetail(column, bcCode, bcName) {

		$('#enrollDetailDlg')
				.dialog('option', 'title', bcCode + " : " + bcName);
		$('#enrollDetailDlg').dialog('open');
		$('#enrollDlgTable').html('');
		$('#dateField').html('');
		$('#txtEnrType').html("Loading..........");
		showLargeIndicator();
		var columns = "";
		var type = "";
		if (column == 'enrollment') {
			columns = [ 'Enrollment Date', 'Customer Name', 'FI A/c No.',
					'Village' ];
			type = "Total Enrollments";
		} else if (column == "uploadedEnroll") {
			columns = [ 'Send Date', 'Customer Name', 'FI A/c No.', 'Village' ];
			type = "Total Uploaded To Bank";
		} else if (column == 'yetToProcess') {
			columns = [ 'Enrollment Date', 'Customer Name', 'FI A/c No.',
					'Village' ];
			type = "Yet Upload To Bank";
		} else if (column == "accountOpenInCBS") {
			columns = [ 'A/c Openig Date', 'Customer Name', 'CBS A/c No.',
					'Village' ];
			type = "Accounts Generated";
		} else if (column == "rejectedEnroll") {
			columns = [ 'Enrollment Date', 'Customer Name', 'FI A/c No.',
					'Reason for Rejection', 'Village' ];
			type = "Rejected Enrollments";
		} else if (column == "yetToAuth") {
			columns = [ 'Enrollment Date', 'Customer Name', 'FI A/c No.',
					'Village' ];
			type = "Pending to Authorize";
		}
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		$
				.getJSON(
						"enrDetailByType.action",
						{
							'id' : bcCode,
							'enrByType' : column,
							'startDate' : startDate,
							'endDate' : endDate
						},
						function(data) {
							hideLargeIndicator();
							$('#txtEnrType').html(type);
							if (startDate != "" && endDate != "") {
								$('#dateField')
										.html(
												"From  " + startDate + " To "
														+ endDate);
							}
							var tblData = "";
							tblData += "<tr>";
							for ( var th in columns) {
								tblData += "<th>" + columns[th] + "</th>";
							}
							tblData += "</tr>";
							var villageCount = 0;
							var villageCode = null;
							var rowNo = 0;
							for ( var index in data.enrByTypeVOs) {
								var rowData = data.enrByTypeVOs[index];

								var row = "<tr>";
								if (column == 'enrollment'
										|| column == 'yetToAuth'
										|| column == "yetToProcess") {
									row += "<td>" + rowData.enrollDate
											+ "</td>";
									row += "<td>" + rowData.custName + "</td>";
									row += "<td>" + rowData.fiAccNo + "</td>";
								} else if (column == "uploadedEnroll") {
									row += "<td>" + rowData.sendDate + "</td>";
									row += "<td>" + rowData.custName + "</td>";
									row += "<td>" + rowData.fiAccNo + "</td>";
								} else if (column == "accountOpenInCBS") {
									row += "<td>" + rowData.accOpeningDate
											+ "</td>";
									row += "<td>" + rowData.custName + "</td>";
									row += "<td>" + rowData.cbsAcc + "</td>";
								} else if (column == "rejectedEnroll") {
									row += "<td>" + rowData.enrollDate
											+ "</td>";
									row += "<td>" + rowData.custName + "</td>";
									row += "<td>" + rowData.fiAccNo + "</td>";
									row += "<td>" + rowData.response + "</td>";
								}
								if (rowNo == index) {
									villageCode = rowData.villageCode;
									villageCount = 0;
									for (var i = index; i < data.enrByTypeVOs.length
											&& villageCode == data.enrByTypeVOs[i].villageCode; i++) {
										villageCount++;
										rowNo++;
									}
									var value = "Village Code&nbsp; : "
											+ rowData.villageCode
											+ "\nVillage Name : "
											+ rowData.villageName
											+ "\nEnrollments &nbsp; : "
											+ villageCount;
									row += "<td rowspan='"+villageCount+"' style='font-weight:bold;' title='"+value+"'>Village Code&nbsp; : "
											+ rowData.villageCode
											+ "<br>Village Name : "
											+ rowData.villageName
											+ "<br>Enrollments&nbsp;&nbsp;&nbsp;: "
											+ villageCount + "</b></td>";
								}
								row += "</tr>";
								tblData += row;
							}
							$("#enrollDlgTable").html(tblData);
						});
	}
	function exportToXslEnrDlg() {
		var enrByType = $('#txtEnrType').html();
		var id = $("#enrollDetailDlg").dialog("option", "title");
		document.forms['frmSelection'].action = "xslEnrByType.action?enrByType="
				+ enrByType + "&id=" + id;
		document.forms['frmSelection'].submit();
	}
	function exportToPdfEnrDlg() {
		var enrByType = $('#txtEnrType').html();
		var id = $("#enrollDetailDlg").dialog("option", "title");
		document.forms['frmSelection'].action = "pdfEnrByType.action?enrByType="
				+ enrByType + "&id=" + id;
		document.forms['frmSelection'].submit();
	}
</script>
<style type="text/css">
.linkStyle {
	cursor: pointer;
	font-weight: bold;
	text-decoration: underline;
	color: buttonface;
}

.abcd {
	color: black;
}
</style>
</head>
<body>

	<hr color="#F28500">

	<s:form name="frmSelection" id="frmSelection" method="post"
		theme="css_xhtml">

		<table cellpadding="8" class="filterTable" width="90%">
			<tr>
				<td rowspan="1" style="max-width: 30px; min-width: 20px;">
					<input id="filterOptionsstate" type="radio" value="state"
					name="filterOptions" align="middle" checked="checked"
					onchange="changeFilter('state');">

				</td>
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
						formIds="frmSelection" href="%{acListUrl}"
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
		<s:url var="loadGrid" action="filterAllReports.action" />
		<sjg:grid id="enrollReportsGrid" caption="Enrollment Summary"
			href="%{loadGrid}" dataType="json" pager="true" autowidth="true"
			sortable="true" sortname="bcCode" gridModel="selectedAllReportsVO"
			shrinkToFit="false" rowList="10,15,20,25" rowNum="15"
			rownumbers="true" viewrecords="true" formIds="frmSelection"
			reloadTopics="reloadGrids" navigatorAdd="false"
			navigatorDelete="false" navigatorSearch="true" navigatorView="true"
			navigatorEdit="false" navigator="true" footerrow="true"
			navigatorRefresh="false" userDataOnFooter="true"
			onCompleteTopics="gridComplete"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				marksearched:true,onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">
			<s:url var="subGridURL" action="findSubGridData.action"></s:url>
			<sjg:grid id="enrReportSubGrid" gridModel="enrSubGridData"
				sortname="enrollDate" sortorder="desc" subGridUrl="%{subGridURL}"
				formIds="frmSelection" pager="true" rowList="10,15,20,25"
				rowNum="10" viewrecords="true" rownumbers="true"
				navigatorAdd="false" navigatorDelete="false" navigatorSearch="false"
				navigator="true" navigatorView="false" navigatorEdit="false"
				navigatorRefresh="false" footerrow="true" userDataOnFooter="true"
				navigatorExtraButtons=" { seperator: { title : 'seperator' }, excel : { 
                        title : 'Export to excel', 
                        caption : 'Excel',
                        icon:'ui-icon-document',position: 'last',
                        topic: 'subGridExportExcel' }
                ,pdf : { 
                        title : 'Export to PDF', 
                        caption : 'PDF',
                        icon:'ui-icon-document',position: 'last',
                        topic: 'subGridExportPDF' }
                }">

				<sjg:gridColumn name="enrollDate" index="enrollDate"
					title="Enrollment Date" formatter="date"
					formatoptions="{newformat : 'd-M-y',prefix:'Time'}" />
				<sjg:gridColumn name="enrollment" index="enrollment"
					title="Total Enrollments" sortable="true" align="center" width="70"
					search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="uploadedEnroll" index="uploadedEnroll"
					title="Total Uploaded To Bank" sortable="true" align="center" width="70"
					search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="yetToProcess" index="yetToProcess"
					align="center" title="Yet Upload To Bank" sortable="true" width="70"
					search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="accountOpenInCBS" index="accountOpenInCBS"
					align="center" title="A/c Generated" sortable="true" width="70"
					search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="rejectedEnroll" index="rejectedEnroll"
					align="center" title="A/c Rejected" sortable="true" width="70"
					search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
				<sjg:gridColumn name="yetToAuth" index="yetToAuth" align="center"
					title="Pending to Authorize" sortable="true" width="70"
					search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			</sjg:grid>
			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="true" align="center" width="70" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" key="true" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="100" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
				sortable="false" align="center" width="85" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="cbsOdAcc" index="cbsOdAcc" title="BC OD A/c"
				sortable="true" width="90" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="stateName" index="stateName" title="State Name"
				sortable="true" width="100" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="districtName" index="districtName"
				title="District Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="talukaName" index="talukaName"
				title="Taluka Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="branchName" index="branchName"
				title="Branch Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="regionName" index="regionName"
				title="Region Name" sortable="true" width="100" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="enrollment" index="enrollment"
				title="Total Enrollments" sortable="true" align="right" width="70"
				formatter="linkFormat" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="uploadedEnroll" index="uploadedEnroll"
				title="Total Uploaded To Bank" sortable="true" align="right" width="70"
				formatter="linkFormat" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="yetToProcess" index="yetToProcess"
				formatter="linkFormat" align="right" title="Yet Upload To Bank"
				sortable="true" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="accountOpenInCBS" index="accountOpenInCBS"
				align="right" title="A/c Generated" sortable="true" width="70"
				formatter="linkFormat" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="rejectedEnroll" index="rejectedEnroll"
				align="right" title="A/c Rejected" sortable="true" width="70"
				formatter="linkFormat" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="yetToAuth" index="yetToAuth" align="right"
				title="Pending to Authorize" sortable="true" width="70"
				formatter="linkFormat" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="pendToMobiliz" index="pendToMobiliz"
				align="right" title="Pending at Mobiliz" sortable="true" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
		</sjg:grid>
		<table width="100%">
			<tr>
				<td><sj:div id="divTotal">
					</sj:div></td>
			</tr>
		</table>
		<sj:dialog id="enrollDetailDlg" width="1000" position="['100','100']"
			height="530" cssStyle="font-size: small; padding: 0 20px 0 20px;"
			modal="true" cssClass="dstyle" autoOpen="false" draggable="true"
			loadingText="Loading......" formIds="frmSelection"
			closeOnEscape="true"
			buttons="{'Export To Excel': function() { exportToXslEnrDlg();},
			'Export To Pdf':function() { exportToPdfEnrDlg(); },
			'Close': function(){$(this).dialog('close');}}">
			<s:label id="txtEnrType" name="enrByType"
				cssStyle="align: center; font-size: medium;font-weight:bold;" />
			<s:label id="dateField" name="dateField"
				cssStyle="align: center; font-size: medium;font-weight:bold;" />
			<table id="enrollDlgTable" class="mystyle">
			</table>
			<img id="enrDialogIndicator" class="indicator"
				src="images/indicator.gif" />
		</sj:dialog>
	</s:form>
</body>
</html>