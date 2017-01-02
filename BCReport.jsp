<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<head>
<%-- <sj:head jqueryui="true" jquerytheme="ranjan-theme" customBasepath="template/themes"/> --%>
<sj:head jqueryui="true" jquerytheme="south-street" ajaxcache="false" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript">
	function inactiveBCCellFormat(cellvalue, options, rowObject) {

		if (cellvalue > 15)
			return '<b style="color: red;font-weight: bolder;">' + cellvalue
					+ '</b>';
		else if (cellvalue == -1)
			return '';
		else
			return '<b>' + cellvalue + '</b>';
	}
	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	$.subscribe('reloadBCGrid', function(event, data) {
		$("#gridBCMaster").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});//.trigger("reloadGrid");
		$.publish("reloadBCReportGrid");
	});
	function villageList(cellvalue, options, rowObject) {
		var values = cellvalue.split(",");
		if (values.length > 1) {
			var list = "";
			for (var i = 0; i < values.length; i++)
				list += "<option value='"+values[i]+"'>" + (i + 1) + ". "
						+ values[i] + "</option>";
			return "<select class='gridColumnSelect'>" + list + "</select>";
		} else
			return values[0];
	}
	function generateReport(format) {
		var action = "";
		if (format == 'Excel' || format == '1')
			action = "XslReportOfAllBCReport.action";
		else if (format == 'PDF')
			action = "PdfReportOfAllBCReport.action";
		var postData = $("#gridBCMaster").jqGrid("getGridParam", "postData");
		var pmName = $("#pmSelect option:selected").text().split(':')[0].trim();
		var acName = $("#acSelect option:selected").text().split(':')[0].trim();
		var filterString = $(".divSearchCondition").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord
				+ "&filters=" + postData.filters + "&filterString="
				+ filterString + "&pmName=" + pmName + "&acName=" + acName;
		document.forms['bcReportForm'].action = action + parameters;
		document.forms['bcReportForm'].submit();
	}

	$.subscribe('onCompleteGrid', function(event, data) {
		$.getJSON('activeBCCount.action', function(data) {
			var bcStatus = (data.bcStatusList);
			getBCStatus(bcStatus);
		});

	});
	function getBCStatus(bcStatus) {
		var rows = "";
		var l = bcStatus.length;
		for (var index = 0; index < l; index++) {

			if (index == 0) {
				rows += "<tr><td align='left'>" + bcStatus[index].key
						+ "</td><td align='right'  width='100px'>"
						+ toInteger(bcStatus[index].displayValue) + "</td>";
				rows += "<td align='left'>TOTAL ACHIEVED SSA (%)</td><td align='right' width='100px'>"
						+ toCurrency((toInteger(bcStatus[2].displayValue) * 100)
								/ (toInteger(bcStatus[index].displayValue)))
						+ "</td>";
				continue;

			}
			if (index == 1)
				continue;
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

		rows += "<td align='left'>LOGGED IN BCs (%)</td><td align='right' width='100px'>"
				+ toCurrency((toInteger(bcStatus[6].displayValue) * 100)
						/ (toInteger(bcStatus[3].displayValue))) + "</td>";
		$('#divActiveBC')
				.html(
						"<strong><table class='tbl-txn-failed-Summary' cellpadding='5' cellspacing='5'>"
								+ rows + "</table></strong>");
	}
	function getByBCStatus(status) {
		$('#bcStatusDialog').dialog('option', 'title', status);
		$('#bcStatusWiseGridID').jqGrid("setGridParam", {
			"postData" : {
				'bcStatus' : status
			},
			records : 0,
			page : 1
		}).trigger('reloadGrid');
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
			document.forms['bcReportForm'].action = action + parameters;
			document.forms['bcReportForm'].submit();
		}
	}
</script>
<style type="text/css">
.ui-jqgrid .ui-jqdialog-content add-rule ui-add {
	font-size: xx-large;
	background-color: #459E00;
}

td .gridColumnSelect {
	font-size: 11px;
}
</style>
</head>

<body>
	<hr color="#F28500">
	<s:form id="bcReportForm" method="post" theme="css_xhtml">
		<table cellpadding="8" class="filterTable" width="70%">
			<tr>
				<td><s:url var="pmListUrl" action="loadPMList" /><img
					id="pmListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <sj:select id="pmSelect"
						headerKey="-1" headerValue="All" href="%{pmListUrl}"
						label="Project Manager" labelposition="left" labelSeparator="<br>"
						indicator="pmListIndicator" list="pmList" listKey="key"
						listValue="displayValue" name="pmCode"
						onChangeTopics="reloadAcList" /></td>

				<td><img id="acListIndicator" class="indicator-small"
					src="images/indicator_small.gif" /> <s:url var="acListUrl"
						action="loadACByPM" /> <sj:select headerKey="-1" id="acSelect"
						formIds="bcReportForm" href="%{acListUrl}" labelSeparator="<br>"
						indicator="acListIndicator" label="Area Coordinator "
						labelposition="left" headerValue="All" list="acList" listKey="key"
						listValue="displayValue" reloadTopics="reloadAcList" name="acCode" /></td>
				<td rowspan="2" align="center"><sj:a button="true"
						buttonIcon="ui-icon-refresh" id="filter" name="filter"
						onClickTopics="reloadBCGrid">
						Generate Report
					</sj:a></td>
			</tr>
		</table>
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="bcGridURL" action="getAllBCDetails" />
		<sjg:grid id="gridBCMaster" caption="All BC Details" dataType="json"
			autowidth="true" shrinkToFit="false" href="%{bcGridURL}" pager="true"
			sortname="bcCode" sortable="true" formIds="bcReportForm"
			gridModel="selectedBCList" viewrecords="true" rowList="10,15,20,25"
			rowNum="15" rownumbers="true" navigatorEdit="false"
			reloadTopics="reloadBCReportGrid" navigatorAdd="false"
			navigatorDelete="false" navigatorSearch="true" navigator="true"
			navigatorView="true" navigatorRefresh="false"
			onCompleteTopics="onCompleteGrid"
			navigatorViewOptions="{closeOnEscape:true}"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true,odata:[{ oper:'nu', text:'is null'},{ oper:'lt', text:' less than'},
			{ oper:'gt', text:' greater than'},
			{ oper:'eq', text:' equal'}, { oper:'nn', text:'is not null'},{ oper:'is', text:'is'}],
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'reloadBCGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { id:'excelBtnID',title : 'Export To Excel', 
			icon: 'ui-icon-document', caption : 'Export to Excel',topic:'ExportToExcel'}, 
			exportToPDF : { title : 'Export To PDF', icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="true" width="70" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="110" searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="acName" index="acName" title="AC Name"
				sortable="true" width="120" searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="pmName" index="pmName" title="PM Name"
				sortable="true" width="120" searchoptions=" {sopt:['eq','cn','bw']}" />
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
			<sjg:gridColumn name="mobilisid" index="mobilisid" title="Mobiliz ID"
				sortable="true" width="100"
				searchoptions=" {sopt:['eq','cn','bw','nu','nn']}" />
			<sjg:gridColumn name="joinDate" index="joinDate" title="Joining Date"
				formatter="date" sortable="true" width="70"
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
			<sjg:gridColumn name="simNumber" index="simNumber" title="SIM Number"
				sortable="true" width="100" searchoptions=" {sopt:['eq','cn','bw']}" />
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
			<sjg:gridColumn name="villages" index="villages"
				formatter="villageList" title="Assigned Village(s)" sortable="true"
				width="210" searchoptions=" {sopt:['cn']}" />
		</sjg:grid>
		<table width="100%">
			<tr>
				<td><sj:div id="divActiveBC" /></td>
			</tr>

		</table>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>

		<sj:dialog id="bcStatusDialog" autoOpen="false" width="900"
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
			<s:url var="bcStatusWiseGridURL" action="bcStatusWiseGrid"></s:url>
			<sjg:grid id="bcStatusWiseGridID" href="%{bcStatusWiseGridURL}"
				formIds="bcReportForm" gridModel="selectedBCStatusWiseList"
				shrinkToFit="false" autowidth="false" width="840" pager="true"
				viewrecords="true" rowList="10,15,20,25" rowNum="15"
				rownumbers="true" sortname="bcCode" sortorder="asc" navigator="true"
				navigatorAdd="false" navigatorDelete="false" navigatorEdit="false"
				navigatorRefresh="false" navigatorView="false"
				reloadTopics="loadStatusWiseGrid"
				navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearchReasonWise,
				onReset:clearSearchReasonWise,dragable:true}"
				navigatorExtraButtons="{ refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadStatusWiseGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcelStatusWise : { title : 'Export To Excel', icon: 'ui-icon-document',
			caption : 'Excel',topic:'ExportToExcelStatusWise'}, exportToPDFStatusWise : { title : 'Export To PDF', 
			icon: 'ui-icon-document',caption : 'PDF',topic:'ExportToPDFStatusWise'}}">
				<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
					sortable="true" width="70" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
					sortable="true" width="110"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="acName" index="acName" title="AC Name"
					sortable="true" width="120"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="pmName" index="pmName" title="PM Name"
					sortable="true" width="120"
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
				<sjg:gridColumn name="villages" index="villages"
					formatter="villageList" title="Assigned Village(s)" sortable="true"
					width="210" searchoptions=" {sopt:['cn']}" />
			</sjg:grid>
		</sj:dialog>
	</s:form>

</body>
</html>