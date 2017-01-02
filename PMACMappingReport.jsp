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
	function getRecords() {
		return $("#pmacMappingReportsGrid").jqGrid("getGridParam", "records");
	}
	function generateReport(format) {
		if (getRecords()) {
			var action = "";
			if (format == 'Excel')
				action = "XslReportOfPMACMappingReports.action";
			else if (format == 'PDF')
				action = "PdfReportOfPMACMappingReports.action";
			var filterString = $(".divSearchCondition").text();
			var villageName = $('#villageSelect option:selected').text().split(':')[0];
			var postData = $("#pmacMappingReportsGrid").jqGrid("getGridParam", "postData");
			var parameters = "?sidx=" + postData.sidx + "&sord=" + postData.sord + "&filters=" + postData.filters + "&villageName=" + villageName
					+ "&filterString=" + filterString;
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
		$("#pmacMappingReportsGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		});//.trigger("reloadGrid");
		$.publish("reloadGrids");
	});

</script>
<style type="text/css">
.linkStyle {
	cursor: pointer;
	font-weight: bold;
	text-decoration: underline;
	color: buttonface;
}
.abcd{
	color: black;
}
</style>
</head>
<body>

	<hr color="#F28500">

	<s:form name="frmSelection" id="frmSelection" method="post"
		theme="css_xhtml">
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="loadGrid" action="filterAllReports.action" />
		<sjg:grid id="pmacMappingReportsGrid" caption="PM AC Mapping Report"
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
			<sjg:gridColumn name="pmCode" index="pmCode" title="PM Code"
				sortable="true" align="center" width="70" search="true"
				searchoptions=" {sopt:['eq','cn','bw']}"/>
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
				search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="uploadedEnroll" index="uploadedEnroll"
				title="Total Uploded" sortable="true" align="right" width="70"
				 search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="yetToProcess" index="yetToProcess"
				 align="right" title="Yet To Upload"
				sortable="true" width="70" search="true"
				searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="accountOpenInCBS" index="accountOpenInCBS"
				align="right" title="A/c Generated" sortable="true" width="70"
				 search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="rejectedEnroll" index="rejectedEnroll"
				align="right" title="A/c Rejected" sortable="true" width="70"
				search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
			<sjg:gridColumn name="yetToAuth" index="yetToAuth" align="right"
				title="Pending to Authorize" sortable="true" width="70"
				 search="true" searchoptions="{sopt: ['eq','lt','gt']}" />
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
		<sj:dialog id="pmacMappingDetailDlg" width="1000" position="['100','100']"
			height="530" cssStyle="font-size: small; padding: 0 20px 0 20px;"
			modal="true" cssClass="dstyle" autoOpen="false" draggable="true"
			loadingText="Loading......" formIds="frmSelection"
			closeOnEscape="true"
			buttons="{'Export To Excel': function() { exportToXslPMACMappingDlg();},
			'Export To Pdf':function() { exportToPdfEnrDlg(); },
			'Close': function(){$(this).dialog('close');}}">
			<s:label id="txtPMACMappingType" name="pmacMappingByType"
				cssStyle="align: center; font-size: medium;font-weight:bold;" />
			<s:label id="dateField" name="dateField"
				cssStyle="align: center; font-size: medium;font-weight:bold;" />
			<table id="pmacMappingDlgTable" class="mystyle">
			</table>
			<img id="pmacMappingDialogIndicator" class="indicator"
				src="images/indicator.gif" />
		</sj:dialog>
	</s:form>
</body>
</html>