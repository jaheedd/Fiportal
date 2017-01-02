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
<%-- <sj:head jqueryui="true" jquerytheme="ranjan-theme" customBasepath="template/themes"/> --%>
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript">
	function generateReport(format) {
		/* var action = "";
		if (format == 'Excel' || format == '1')
			action = "XslReportOfAllBCReport.action";
		else if (format == 'PDF')
			action = "PdfReportOfAllBCReport.action";
		var postData = $("#vasReportGridID").jqGrid("getGridParam", "postData");
		var filterString = $(".divSearchCondition").text();
		var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord + "&filters=" + postData.filters + "&filterString=" + filterString;
		document.forms['frmSelection'].action = action + parameters;
		document.forms['frmSelection'].submit(); */
	}

	$.subscribe('onCompleteGrid', function(event, data) {
		/* $.getJSON('activeBCCount.action', function(data) {
			var activeBC = (data.activeBC);
			$('#divActiveBC').html(
					"<strong><table cellpadding='5' cellspaceing='5' class='tblTotalSummary'> <tr>"
							+ "<td>TOTAL NUMBER OF BCs  </td><td align='right'>      " + toInteger(activeBC.totalBC)
							+ "</td><td>TOTAL SYNC. BCs  </td><td align='right'>      " + toInteger(activeBC.syncBC)
							+ "</td></tr><tr><td>TOTAL ACTIVE BCs</td><td align='right'>      " + toInteger(activeBC.activeBC)
							+ "</td><td>TOTAL INACTIVE BCs </td><td align='right'>      " + toInteger(activeBC.inactiveBC)
							+ "</td></tr><tr><td>TODAY LOGGED IN BCs  </td><td align='right'>      " + toInteger(activeBC.loggedinBC)
							+ "</td><td>TOTAL NOT WORKING BCs</td><td align='right'>      " + toInteger(activeBC.notWorkingBC)
							+ "</td></tr></table></strong>");
		}); */

	});

	$.subscribe('ExportToExcel', function(pID, id) {
		generateReport('Excel');
	});
	$.subscribe('ExportToPDF', function(pID, id) {
		generateReport('PDF');
	});
	$.subscribe('loadGrid', function(event, data) {
		$("#vasReportGridID").jqGrid("setGridParam", {
			records : 0,
			page : 1
		}).trigger("reloadGrid");
		//$.publish("reloadGrids");
	});
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
	<s:form name="vasReportForm" id="vasReportForm" method="post">
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="vasReportURL" action="vasReportGrid.action" />
		<sjg:grid id="vasReportGridID" caption="Value Added Services Report"
			dataType="json" autowidth="true" shrinkToFit="false"
			href="%{vasReportURL}" pager="true" sortname="bcCode"
			sortable="true" gridModel="selectedList" viewrecords="true"
			rowList="10,15,20,25" rowNum="15" rownumbers="true"
			navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
			navigatorSearch="true" navigator="true" navigatorView="true"
			navigatorRefresh="false" onCompleteTopics="onCompleteGrid"
			navigatorViewOptions="{closeOnEscape:true}"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true,odata:[{ oper:'nu', text:'is null'},{ oper:'lt', text:' less than'},
			{ oper:'gt', text:' greater than'},
			{ oper:'eq', text:' equal'}, { oper:'nn', text:'is not null'},{ oper:'is', text:'is'}],
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch,dragable:true}"
			navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}, exportToExcel : { id:'excelBtnID',title : 'Export To Excel', 
			icon: 'ui-icon-document', caption : 'Export to Excel',topic:'ExportToExcel'}, 
			exportToPDF : { title : 'Export To PDF', icon: 'ui-icon-document',caption : 'Export to PDF',topic:'ExportToPDF'}}">

			<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
				sortable="true" width="70" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
				sortable="true" width="110" searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="customerName" index="customerName"
				title="Customer Name" sortable="true" width="100"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="districtName" index="districtName"
				title="District Name" sortable="true" width="100"
				searchoptions=" {sopt:['eq','cn','bw']}"/>
			<sjg:gridColumn name="talukaName" index="talukaName"
				title="Taluka Name" sortable="true" width="100"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="villageName" index="villageName"
				title="Village Name" sortable="true" width="120"
				searchoptions=" {sopt:['eq','cn','bw']}" />
			<sjg:gridColumn name="numberOfCows" index="numberOfCows"
				title="No. of Cows" sortable="true" width="70" formatter="integer"
				searchoptions=" {sopt:['eq','lt','gt']}" align="right"/>
			<sjg:gridColumn name="numberOfBuffalows" index="numberOfBuffalows"
				title="No.of Buffalows" sortable="true" width="70" search="true"
				formatter="integer" searchoptions=" {sopt:['eq','lt','gt']}" align="right"/>
			<sjg:gridColumn name="milkingCattle" index="milkingCattle"
				title="Milking Cattle" sortable="true" width="60"
				searchtype="select" formatter="checkbox"
				searchoptions=" {sopt:['is'],value:'Y:YES;N:NO'}" />
			<sjg:gridColumn name="cowMilk" index="cowMilk" title="Cow Milk"
				formatter="integer" sortable="true" width="70"
				searchoptions="{sopt:['eq','lt','gt']}" align="right"/>
			<sjg:gridColumn name="buffalowMilk" index="buffalowMilk"
				title="Buffalow Milk" formatter="integer" sortable="true" width="70"
				searchoptions="{sopt:['eq','lt','gt']}" align="right"/>
			<sjg:gridColumn name="cattleInsured" index="cattleInsured"
				title="Cattle Innsured" sortable="true" width="60"
				searchtype="select" formatter="checkbox"
				searchoptions=" {sopt:['is'],value:'Y:YES;N:NO'}" />
			<sjg:gridColumn name="cowShed" index="cowShed" title="Cow Shed"
				formatter="integer" sortable="true" width="70"
				searchoptions="{sopt:['eq','lt','gt']}" align="right"/>
			<sjg:gridColumn name="insuranceCompany" index="insuranceCompany"
				title="Insurance Company" sortable="true"
				width="110" searchoptions=" {sopt:['cn','eq']}" />
			<sjg:gridColumn name="insurancePremium" index="insurancePremium" title="Insurance Premium"
				formatter="integer" sortable="true" width="70"
				searchoptions="{sopt:['eq','lt','gt']}" />	
			<sjg:gridColumn name="dailyConsumption" index="dailyConsumption" title="Daily Consumption"
				formatter="integer" sortable="true" width="70"
				searchoptions="{sopt:['eq','lt','gt']}" align="right"/>
			<sjg:gridColumn name="animalTagging" index="animalTagging"
				title="AnimalTagging" sortable="true" width="70"
				searchtype="select" formatter="checkbox"
				searchoptions=" {sopt:['is'],value:'Y:YES;N:NO'}" />
			<sjg:gridColumn name="greenFodderProvider" index="greenFodderProvider" title="Green Fodder Provider"
				sortable="true" width="70"
				searchoptions="{sopt:['eq','lt','gt']}" />
			<sjg:gridColumn name="monthlyConsumption" index="monthlyConsumption" title="Monthly Consumption"
				formatter="integer" sortable="true" width="70"
				searchoptions="{sopt:['eq','lt','gt']}" align="right"/>
			<sjg:gridColumn name="milkingMachine" index="milkingMachine"
				title="Milking Machine" sortable="true" width="70"
				searchtype="select" formatter="checkbox"
				searchoptions=" {sopt:['is'],value:'Y:YES;N:NO'}" />
			<sjg:gridColumn name="milkingMachineType" index="milkingMachineType"
				title="Milking Machine Type" sortable="true"
				width="110" searchoptions=" {sopt:['cn','eq']}" />
			<sjg:gridColumn name="milkingMachineVendor" index="milkingMachineVendor"
				title="Milking Machine Vendor" sortable="true"
				width="110" searchoptions=" {sopt:['cn','eq']}" />
			<sjg:gridColumn name="insuranceCompany" index="insuranceCompany"
				title="Insurance Company" sortable="true"
				width="210" searchoptions=" {sopt:['cn','eq']}" />
		</sjg:grid>           
		<table width="100%">
			<tr>
				<td><sj:div id="divActiveBC" /></td>
			</tr>

		</table>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>

</body>
</html>
