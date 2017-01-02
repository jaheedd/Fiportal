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
<title>BC Login Details as on</title>
<script type="text/javascript">
	$
			.subscribe(
					'onGridComplete',
					function(event, data) {
						var records = $("#loginBCGrid").jqGrid("getGridParam",
								"records");
						var loginDate = $("#dateID").val();
						$("#loginBCGrid").jqGrid('setCaption',
								"BC Logged in details on " + loginDate);
						var userData = $("#loginBCGrid").jqGrid("getGridParam",
								"userData");
						$
								.getJSON(
										'activeBCCount.action',
										function(data) {
											var bcStatus = (data.bcStatusList);
											$('#divActiveBC')
													.html(
															"<strong><table cellpadding='5' cellspaceing='5' class='tblTotalSummary'>"
																	+ "<tr><td>"
																	+ bcStatus[0].key
																	+ "</td><td align='right'> "
																	+ toInteger(bcStatus[0].displayValue)
																	+ "</td><td>TOTAL ACHIEVED SSA (%)  </td><td align='right'> "
																	+ toCurrency((toInteger(bcStatus[2].displayValue) * 100)
																			/ (toInteger(bcStatus[0].displayValue)))
																	+ "</td></tr><tr><td>"
																	+ bcStatus[1].key
																	+ "</td><td align='right'> "
																	+ toInteger(bcStatus[1].displayValue)
																	+ "</td><td>"
																	+ bcStatus[2].key
																	+ "</td><td align='right'> "
																	+ toInteger(bcStatus[2].displayValue)
																	+ "</td></tr><tr><td>"
																	+ bcStatus[3].key
																	+ "  </td><td align='right'> "
																	+ toInteger(bcStatus[3].displayValue)
																	+ "</td><td>"
																	+ bcStatus[4].key
																	+ "</td><td align='right'>      "
																	+ toInteger(bcStatus[4].displayValue)
																	+ "</td></tr><tr><td>"
																	+ bcStatus[6].key
																	+ "</td><td align='right'> "
																	+ toInteger(records)
																	+ "</td><td>LOGGED IN BCs (%)</td><td align='right'>      "
																	+ toCurrency((toInteger(records) * 100)
																			/ (toInteger(bcStatus[3].displayValue)))
																	+ "</td></tr><tr><td>"
																	+ bcStatus[5].key
																	+ "</td><td align='right'> "
																	+ toInteger(bcStatus[5].displayValue)
																	+ "</td><td>TOTAL ENROLLMENTS OF THE DAY</td><td align='right'> "
																	+ toInteger(userData.enrollments)
																	+ "</td></tr><tr><td>TOTAL TRANSACTIONS OF THE DAY</td><td align='right'>      "
																	+ toInteger(userData.transactions)
																	+ "</td><td>TOTAL ENROLLMENTS PENDING AT MOBILIZ TILL DATE</td><td align='right'>      "
																	+ toInteger(userData.notUploaded)
																	+ "</td></tr></table></strong>");
										});

					});
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
			cssClass="filterTable" showAnim="slideDown" labelposition="left"
			showOn="focus" label=" Select Date " displayFormat="dd/mm/yy"
			readonly="true" maxDate="today" onChangeTopics="loadGrid" />
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
	</s:form>
</body>
</html>
