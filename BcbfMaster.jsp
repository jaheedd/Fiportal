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
<script type="text/javascript">
	function getRecords() {
		return $("#bcbfMasterGrid").jqGrid("getGridParam", "records");
	}
	function generateBcbfMaster() {
		if (getRecords()) {
			var sidx = $("#bcbfMasterGrid").jqGrid("getGridParam", "sortname");
			var sord = $("#bcbfMasterGrid").jqGrid("getGridParam", "sortorder");
			document.forms['BcbfCodeMasterForm'].action = "generateBcbfMaster.action?sidx="
					+ sidx + "&sord=" + sord;
			document.forms['BcbfCodeMasterForm'].submit();
		}
	}
</script>
</head>
<body>
	<center>
		<h2>
			<u>BCBF Master</u>
		</h2>
	</center>
	<hr color="#F28500">
	<s:form name="BcbfCodeMasterForm" id="BcbfCodeForm" method="post"
		theme="css_xhtml">

		<s:url var="getAllBcbfCodeDetails"
			action="getAllBcbfCodeDetails.action" />
		<sjg:grid id="bcbfMasterGrid" caption="BCBF Details"
			dataType="json" autowidth="true" href="%{getAllBcbfCodeDetails}"
			pager="true" sortname="bcbfCode" sortable="true"
			gridModel="allBcbfCodeSubList" viewrecords="true"
			rowList="10,15,20,25" rowNum="15" rownumbers="true">

			<sjg:gridColumn name="tspCorporateBcCode" index="tspCorporateBcCode"
				title="Tsp|CorporateBcCode|" sortable="true" />
			<sjg:gridColumn name="bcbfCode" index="bcbfCode" title="BCBF Code"
				sortable="true" />
			<sjg:gridColumn name="bcName" index="bcName" title="Bc Name."
				sortable="true" />
			<sjg:gridColumn name="cbsodAccNo" index="cbsodAccNo"
				title="CBSOD A/c" sortable="true" />
		</sjg:grid>
		<table width="100%">
			<tr>
				<td style="float: right;"><small><sj:a button="true"
							id="generateBcbfMaster" name="generateBcbfMaster"
							onclick="generateBcbfMaster();">
							Generate BCBF Master
						</sj:a></small></td>
			</tr>
			<tr>
				<td style="float: right;"><s:actionerror /></td>
			</tr>
		</table>
	</s:form>
</body>
</html>
