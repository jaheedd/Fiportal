<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<sj:head jqueryui="true" jquerytheme="south-street" />
<script type="text/javascript">
	
</script>
</head>
<body>
	<s:form id="userManualForm">
		<div id="topDiv">
			<ul>
				<li><a href="#navigatorButtons">Navigator buttons</a>
					<ul>
						<li><a href="#navigatorButtons">Button information</a></li>
						<li><a href="#viewField">View a selected row from grid</a></li>
						<li><a href="#searchDialog">Search dialog</a></li>
						<li><a href="#searchResult">Search output</a></li>
						<li><a href="#excelButton">Export report to Excel</a></li>
						<li><a href="#pdfButton">Export report to PDF</a></li>
						<li><a href="#dateSearch">Searching with date</a></li>
					</ul></li>
				<li><a href="#dateFieldClear">How to clear date fields</a></li>
				<li><a href="#subgridID">Date wise enrollments done by
						selected BC</a></li>
				<li><a href="#failedTxnButton">Failed transaction report</a>
					<ul>
						<li><a href="#failedTxnButton">Reason wise failed
								transactions</a></li>
						<li><a href="#failedTxnButtonOutput">Failed transaction
								report for selected reason code</a></li>
					</ul></li>
			</ul>
			<p></p>
		</div>
		<fieldset id="navigatorButtons" class="imageField">
			<h3>Navigator buttons</h3>
			<img alt="" src="./images/UserManual/navigators.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="viewField" class="imageField">
			<h3>View selected row</h3>
			<img alt="" src="./images/UserManual/ViewResult.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>

		<fieldset id="searchDialog" class="imageField">
			<h3>Search dialog</h3>
			<img alt="" src="./images/UserManual/SearchDialog.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="searchResult" class="imageField">
			<h3>Search output</h3>
			<img alt="" src="./images/UserManual/SearchResult.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="dateSearch" class="imageField">
			<h3>Searching with date</h3>
			<img alt="" src="./images/UserManual/SearchDate.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="dateFieldClear" class="imageField">
			<h3>How to clear date fields</h3>
			<img alt="" src="./images/UserManual/DateField.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="excelButton" class="imageField">
			<h3>Export report to Excel</h3>
			<img alt="" src="./images/UserManual/ExportToExcel.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="pdfButton" class="imageField">
			<h3>Export report to PDF</h3>
			<img alt="" src="./images/UserManual/ExportToPDF.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset class="imageField" id="subgridID">
			<h3>Date wise enrollments done by selected BC</h3>
			<img alt="" src="./images/UserManual/Subgrid.PNG"> <br> <a
				href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="failedTxnButton" class="imageField">
			<h3>Reason wise failed transaction</h3>
			<img alt="" src="./images/UserManual/FailedTxnReason.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
		<fieldset id="failedTxnButtonOutput" class="imageField">
			<h3>Failed transaction report for selected reason code</h3>
			<img alt="" src="./images/UserManual/ReasonWiseGrid.PNG"> <br>
			<a href="#topDiv">Back to top</a>
		</fieldset>
	</s:form>
</body>
</html>