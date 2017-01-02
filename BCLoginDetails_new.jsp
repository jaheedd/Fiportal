<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.1" type="text/css"
	title="Style">
<script type="text/javascript" src="./js/JavaScript.js"></script>
<title>BC Login Details as on</title>
<script type="text/javascript">
	$.subscribe('onGridComplete', function(event, data) {
		var records = $("#loginBCGrid").jqGrid("getGridParam", "records");
		var loginDate = $("#dateID").val();
		$("#loginBCGrid").jqGrid('setCaption',
				"BC Logged in details on " + loginDate);
		var userData = $("#loginBCGrid").jqGrid("getGridParam", "userData");
		$.getJSON('activeBCCount.action', function(data) {
			var bcStatus = (data.bcStatusList);
			getBCStatus(bcStatus, userData);
			/* $('#divActiveBC')
					.html(
							"<strong><table cellpadding='5' cellspaceing='5' class='tblTotalSummary'>"
									+ "<tr><td>TOTAL NUMBER OF BCs  </td><td align='right'> "
									+ toInteger(activeBC.totalBC)
									+ "</td><td>TOTAL SYNC. BCs  </td><td align='right'> "
									+ toInteger(activeBC.syncBC)
									+ "</td></tr><tr><td>TOTAL ACTIVE BCs</td><td align='right'> "
									+ toInteger(activeBC.activeBC)
									+ "</td><td>TOTAL INACTIVE BCs </td><td align='right'> "
									+ toInteger(activeBC.inactiveBC)
									+ "</td></tr><tr><td>TOTAL LOGGED IN BCs  </td><td align='right'> "
									+ toInteger(records)
									+ "</td><td>TOTAL NOT WORKING BCs</td><td align='right'>      "
									+ toInteger(activeBC.notWorkingBC)
									+ "</td></tr><tr><td>TOTAL ENROLLMENTS OF THE DAY</td><td align='right'> "
									+ toInteger(userdata.enrollments)
									+ "</td><td>TOTAL TRANSACTIONS OF THE DAY</td><td align='right'>      "
									+ toInteger(userdata.transactions)
									+ "</td></tr><tr><td>TOTAL ENROLLMENTS PENDING AT MOBILIZ TILL DATE</td><td align='right'>      "
									+ toInteger(userdata.notUploaded)
									+ "</td></tr></table></strong>"); */
		});

	});

	function getBCStatus(bcStatus, userData) {
		var rows = "";
		var l = bcStatus.length;
		for (var index = 0; index < l; index++) {

			if (index == 0) {
				rows += "<tr><td align='left'>" + bcStatus[index].key
						+ "</td><td align='right'  width='100px'>"
						+ toInteger(bcStatus[index].displayValue) + "</td>";
				rows += "<td align='left'>TOTAL ACHIEVED SSA (%)</td><td align='right' width='100px'>"
						+ toCurrency((toInteger(bcStatus[2].displayValue) * 100)
								/ (toInteger(bcStatus[1].displayValue)))
						+ "</td>";
				continue;

			}
			rows += "<tr><td align='left'><a title-text='"
					+ bcStatus[index].key
					+ "' class='class-with-tooltip'  width='400'  onclick='getByBCStatus(\""
					+ bcStatus[index].key + "\")'>" + bcStatus[index].key
					+ "</a></td><td align='right'  width='100px'>"
					+ toInteger(bcStatus[index].displayValue) + "</td>";

			if (index < l - 1) {
				rows += "<td align='left'><a title-text='"
						+ bcStatus[++index].key
						+ "' class='class-with-tooltip'  width='400' onclick='getByBCStatus(\""
						+ bcStatus[index].key + "\")'>" + bcStatus[index].key
						+ "</a></td><td align='right'  width='100px'>"
						+ toInteger(bcStatus[index].displayValue)
						+ "</td></tr>";
			}
		}

		rows += "</td><td align='left'>TOTAL ENROLLMENTS OF THE DAY</td><td align='right' width='100px'>"
				+ toInteger(userData.enrollments)
				+ "</td></td><td align='left'>LOGGED IN BCs (%)</td><td align='right' width='100px'>"
				+ toCurrency((toInteger(bcStatus[6].displayValue) * 100)
						/ (toInteger(bcStatus[3].displayValue)))
				+ "</td></tr><tr><td  align='left'>TOTAL TRANSACTIONS OF THE DAY</td><td align='right'>      "
				+ toInteger(userData.transactions)
				+ "</td><td  align='left'>TOTAL ENROLLMENTS PENDING AT MOBILIZ TILL DATE</td><td align='right'>      "
				+ toInteger(userData.notUploaded) + "</td></tr>";
		$('#divActiveBC')
				.html(
						"<strong><table class='tbl-txn-failed-Summary' cellpadding='5' cellspacing='5'>"
								+ rows + "</table></strong>");
	}
	function getByBCStatus(status) {

		alert(status);
		$('#bcStatusDialog').dialog('option', 'title', status);
		$('#bcStatusWiseGridID').jqGrid("setGridParam", {
			"postData" : {
				'bcStatus' : status
			},
			records : 0,
			page : 1
		}).trigger('reloadGrids');

		$('#bcStatusDialog').dialog('open');
	}

	$.subscribe('clearGrid', function(grid, data) {
		$('#bcStatusDialog').jqGrid('clearGridData');
		$("#bcStatusDialog").jqGrid("setGridParam", {
			search : false,
			postData : {
				'_search' : false,
				"filters" : ""
			}
		});
		clearSearchReasonWise();
	});

	$.subscribe('ExportToExcelStatusWise', function(pID, id) {
		generateReportReasonWise('Excel');
	});
	$.subscribe('ExportToPDFStatusWise', function(pID, id) {
		generateReportReasonWise('PDF');
	});
	function getRecords(id) {
		return $(id).jqGrid("getGridParam", "records");
	}
	function generateReportReasonWise(format) {
		if (getRecords("#bcStatusWiseGridID")) {
			var action = "";
			if (format == 'Excel')
				action = "XslStatusWiseBCDetails.action";
			else if (format == 'PDF')
				action = "PdfStatusWiseBCDetails.action";
			var status = $("#bcStatusDialog").dialog("option", "title");
			var filterString = $(".divSearchConditionReasonWise").text();
			var postData = $("#bcStatusWiseGridID").jqGrid("getGridParam",
					"postData");
			var parameters = "?sidx=" + postData.sidx + "&sord="
					+ postData.sord + "&filters=" + postData.filters
					+ "&filterString=" + filterString + "&bcStatus=" + status;
			document.forms['BCAttendenceForm'].action = action + parameters;
			document.forms['BCAttendenceForm'].submit();
		}
	}

	function setDate() {
		$('#dateHead').html($("#dateID").val());
	}
	$
			.subscribe(
					'bcSelection',
					function(event, data) {
						$('#detailDialog').dialog('open');
						showIndicator();
						var grid = event.originalEvent.grid;
						var sel_id = grid.jqGrid('getGridParam', 'selrow');
						var bcCode = grid.jqGrid('getCell', sel_id, 'bcCode');
						var bcName = grid.jqGrid('getCell', sel_id, 'bcName')
								.split('&nbsp;')[0];
						$("#dateLabel").html("Loading......");
						var date = $("#dateID").val();
						$
								.getJSON(
										'bcWiseLogin.action',
										{
											'bcCode' : bcCode,
											'date' : date
										},
										function(jData) {
											var list = jData.singleBCLoginVOs;
											hideIndicator();
											$("#dateLabel").html(
													"<b>Till Date : " + date
															+ "</b>");
											$('#detailDialog').dialog('option',
													'title',
													bcCode + " : " + bcName);
											$('#dlgTable')
													.html(
															"<tr><th>Login</th><th>Logout</th><th>Duration (H:M)</th><th>Last A/c No.</th><th>Pending at Mobiliz</th></tr>");
											for ( var i in list) {
												$('#dlgTable')
														.append(

																"<tr><td>"
																		+ list[i].login
																		+ "</td><td>"
																		+ list[i].logout
																		+ "</td><td>"
																		+ list[i].loginDuration
																		+ "</td><td>"
																		+ list[i].lastAccNo
																		+ "</td><td>"
																		+ list[i].notUploaded
																		+ "</td></tr>");
												;

											}

										});

					});

	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	function generateReport(format) {
		var postData = $("#loginBCGrid").jqGrid("getGridParam", "postData");
		var filterString = $(".divSearchCondition").text();
		var action = "";
		if (format == 'Excel')
			action = "XslReportOfBcAttendance.action";
		else if (format == 'PDF')
			action = "PdfReportOfBcAttendance.action";
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString;
		document.forms['BCAttendenceForm'].action = action + parameters;
		document.forms['BCAttendenceForm'].submit();

	}
	$.subscribe('loadGrid', function(event, data) {
		$("#loginBCGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});
		$.publish("reloadGrids");
	});
</script>
</head>

<body>
	<hr color="#F28500">
	<s:form id="BCAttendenceForm" name="BCAttendenceForm">
		<sj:datepicker id="dateID" name="date" value="today"
			showAnim="slideDown" labelposition="left" showOn="focus"
			label=" Select Date " displayFormat="dd/mm/yy" readonly="true"
			maxDate="today" onChangeTopics="loadGrid" />
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="todayBCLogin" action="todayBCLogin.action" />
		<sjg:grid id="loginBCGrid" dataType="json" href="%{todayBCLogin}"
			pager="true" sortname="login" sortable="true" autowidth="true"
			gridModel="selectedList" rowList="10,15,20,25" rowNum="15"
			viewrecords="true" rownumbers="true" cssStyle="cursor: pointer;"
			onSelectRowTopics="bcSelection" formIds="BCAttendenceForm"
			reloadTopics="reloadGrids" onCompleteTopics="onGridComplete"
			navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
			footerrow="true" userDataOnFooter="true" navigatorSearch="true"
			navigator="true" navigatorView="true" navigatorRefresh="false"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Export to Excel',topic:'ExportToExcel'}, exportToPDF : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="true" width="90" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="160" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="districtName" index="districtName"
				title="District Name" sortable="true" width="160" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="login" index="login" title="Login Time"
				formatter="date" search="false"
				formatoptions="{newformat : ' g:i A', srcformat : 'Y-m-d H:i:s'}"
				sortable="true" width="90" />
			<sjg:gridColumn name="logout" index="logout" title="Logout Time"
				formatter="date" search="false"
				formatoptions="{newformat : ' g:i A', srcformat : 'Y-m-d H:i:s'}"
				sortable="true" width="90" />
			<sjg:gridColumn name="loginDuration" index="loginDuration"
				title="Login Duration (hh:mm)" sortable="true" width="90"
				search="false" />
			<sjg:gridColumn name="lastAccNo" index="lastAccNo" align="right"
				title="Last A/c No." sortable="true" width="90" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="notUploaded" index="notUploaded" align="right"
				title="Enrollments Pending at Mobiliz" sortable="true" width="70"
				search="true" searchoptions=" {sopt:['eq','gt','lt']}" />
			<sjg:gridColumn name="enrollments" index="enrollments" align="right"
				title="Total Enrollments" sortable="true" width="70" search="true"
				searchoptions=" {sopt:['eq','gt','lt']}" />
			<sjg:gridColumn name="transactions" index="transactions"
				align="right" title="Total Transactions" sortable="true" width="70"
				search="true" searchoptions=" {sopt:['eq','gt','lt']}" />
		</sjg:grid>
		<table width="100%">
			<tr>
				<td><sj:div id="divActiveBC" /></td>
			</tr>
		</table>

		<sj:dialog id="detailDialog" width="650" position="center"
			height="500" draggable="true"
			buttons="{ 'Close': function(){ $('#detailDialog').dialog( 'close');}}"
			modal="true" cssClass="dstyle" autoOpen="false">
			<s:label id="dateLabel" />
			<img class="indicator" src="images/indicator.gif"></img>
			<table id="dlgTable" class="mystyle" align="center">
			</table>
		</sj:dialog>

		<sj:dialog id="bcStatusDialog" autoOpen="false" width="900"
			modal="true" onCloseTopics="clearGrid" position="[200,0]"
			draggable="false" height="520"
			buttons="{'Close': function(){$('#bcStatusDialog').dialog('close');}}">
			<table width="100%">
				<tr>
					<td align="left">
						<div class="divSearchConditionReasonWise"></div>
					</td>
				</tr>
			</table>
			<s:url var="bcStatusWiseGridURL" action="bcStatusWiseGrid.action"></s:url>
			<sjg:grid id="bcStatusWiseGridID" href="%{bcStatusWiseGridURL}"
				formIds="BCAttendenceForm" gridModel="selectedBCStatusWiseList"
				shrinkToFit="false" autowidth="false" width="840" pager="true"
				viewrecords="true" rowList="10,15,20,25" rowNum="15"
				rownumbers="true" sortname="bcCode" sortorder="asc" navigator="true"
				navigatorAdd="false" navigatorDelete="false" navigatorEdit="false"
				navigatorRefresh="false" navigatorView="false"
				reloadTopics="loadGrid"
				navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchReasonWise,
				onReset:clearSearchReasonWise,dragable:true}"
				navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'reloadGrids'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcelStatusWise : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Excel',topic:'ExportToExcelStatusWise'}, exportToPDFStatusWise : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'PDF',topic:'ExportToPDFStatusWise'}}">
				<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
					sortable="true" width="70" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
					sortable="true" width="110"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcbfCode" index="bcbfCode" title="BCBF Code"
					sortable="true" width="90" searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
					sortable="false" width="70"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="districtName" index="districtName"
					title="District Name" sortable="true" width="100"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="talukaName" index="talukaName"
					title="Taluka Name" sortable="true" width="100"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="branchCode" index="branchCode"
					title="Branch Code" sortable="true" width="70"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="mobilisid" index="mobilisid"
					title="Mobiliz ID" sortable="true" width="100"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="joinDate" index="joinDate"
					title="Joining Date" formatter="date" sortable="true" width="70"
					formatoptions="{newformat : 'd-M-y'}" search="true"
					searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}" />
				<sjg:gridColumn name="cbscifNo" index="cbscifNo" title="CBS CIF No."
					sortable="true" width="100"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="cbsodAccNo" index="cbsodAccNo"
					title="CBS OD  A/c No." sortable="true" width="100"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="bcsbac" index="bcsbac" title="BC SB A/c"
					sortable="true" width="80"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="bcfdac" index="bcfdac" title="BC FD A/c"
					sortable="true" width="85"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="lastWorkingDay" index="lastWorkingDay"
					formatter="date" title="Last Login Day" sortable="true"
					searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}"
					formatoptions="{newformat : 'd-M-y',prefix:'Time'}" width="70" />
				<sjg:gridColumn name="inactiveDays" index="inactiveDays"
					title="No. of Inactive Days" sortable="true" width="70"
					align="center" formatter="inactiveBCCellFormat"
					searchoptions=" {sopt:['eq','lt','gt']}" />
				<sjg:gridColumn name="hwVersion" index="hwVersion"
					title="Hardware Version" sortable="true" width="80"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="mobilizSerial" index="mobilizSerial"
					title="Mobiliz Serial Number" sortable="true" width="90"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="simNumber" index="simNumber"
					title="SIM Number" sortable="true" width="100"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="swVersion" index="swVersion"
					title="System Software Version" sortable="true" width="80"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="appVersion" index="appVersion"
					title="Application Version" sortable="true" width="100"
					searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
				<sjg:gridColumn name="syncDate" index="syncDate" title="Sync. Date"
					sortable="true" width="80" formatter="date"
					formatoptions="{newformat : 'd-M-y', srcformat : 'Y-m-d H:i:s'}"
					search="true"
					searchoptions="{sopt:['eq','lt','gt'],dataInit:dateField}" />
				<sjg:gridColumn name="isActive" index="isActive"
					title="Working Status" sortable="true" formatter="checkbox"
					width="50" search="true" searchtype="select"
					searchoptions=" {sopt:['is'],value:'1:Active;0:Inactive'}" />
				<sjg:gridColumn name="villages" index="villages" formatter="list"
					title="Assigned Village(s)" sortable="true" width="210"
					searchoptions=" {sopt:['cn']}" />
			</sjg:grid>
		</sj:dialog>
	</s:form>
</body>
</html>