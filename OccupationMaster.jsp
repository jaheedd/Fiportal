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
	function list(cellvalue, options, rowObject) {

		if (cellvalue == "B") {
			return "BUSINESS";
		} else if (cellvalue == "I")
			return "INDIVIDUAL";
	}
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form name="OccupationMasterForm" method="post">
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="occupationMasterURL"
			action="occupationMasterGridData.action" />
		<sjg:grid id="OccupationMasterGridID" caption="Occupation Details"
			dataType="json" autowidth="true" shrinkToFit="true"
			href="%{occupationMasterURL}" pager="true" sortname="occupationcode"
			sortable="true" gridModel="selectedList" viewrecords="true"
			rowList="10,15,20,25" rowNum="15" rownumbers="true"
			navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
			navigatorSearch="true" navigator="true" navigatorView="true"
			navigatorRefresh="true"
			navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true,
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				onReset:clearSearch,dragable:true}">

			<sjg:gridColumn name="occupationcode" index="occupationcode"
				title="Occupation Code" sortable="true"
				searchoptions=" {sopt:['eq','bw']}" />
			<sjg:gridColumn name="occupationdesc" index="occupationdesc"
				title="Occupation Description" sortable="true"
				searchoptions=" {sopt:['bw','cn','eq']}" />
			<sjg:gridColumn name="occupationType" index="occupationType"
				title="Occupation Type" sortable="true" searchtype="select"
				searchoptions=" {sopt:['eq'],value:'B:BUSINESS;I:INDIVIDUAL'}"
				formatter="list" />
		</sjg:grid>
		<sj:dialog autoOpen="false" draggable="true"></sj:dialog>
	</s:form>

</body>
</html>
