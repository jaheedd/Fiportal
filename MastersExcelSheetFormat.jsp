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
	$
			.subscribe(
					'sendBranchMasterExcelFormat',
					function(event, data) {
						document.forms['mastersExcelFormatFormID'].action = "sendBranchMasterExcelFormat.action";
						document.forms['mastersExcelFormatFormID'].submit();

					});
	$
			.subscribe(
					'sendBCMasterExcelFormat',
					function(event, data) {
						document.forms['mastersExcelFormatFormID'].action = "sendBCMasterExcelFormat.action";
						document.forms['mastersExcelFormatFormID'].submit();

					});
	$
			.subscribe(
					'sendVillageMasterExcelFormat',
					function(event, data) {
						document.forms['mastersExcelFormatFormID'].action = "sendVillageMasterExcelFormat.action";
						document.forms['mastersExcelFormatFormID'].submit();

					});
	$
			.subscribe(
					'bcCreationUtilityExcelFormat',
					function(event, data) {
						document.forms['mastersExcelFormatFormID'].action = "sendBcCreationUtilityExcelFormat.action";
						document.forms['mastersExcelFormatFormID'].submit();

					});
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="mastersExcelFormatFormID" method="post" theme="css_xhtml">
		<br>
		<br>
		<center>
			<table cellpadding="10" cellspacing="10">
				<tr>
					<td><sj:submit id="branchMasterBtnID" button="true"
							value=" Branch Master Excel Sheet Format"
							label="Branch Master Excel Sheet Format"
							cssClass="masterExcelbutton"
							onClickTopics="sendBranchMasterExcelFormat" /></td>

				</tr>
				<tr>
					<td><sj:submit id="bcMasterBtnID" button="true"
							value=" BC Master Excel Sheet Format"
							label="BC Master Excel Sheet Format" cssClass="masterExcelbutton"
							onClickTopics="sendBCMasterExcelFormat" /></td>
				</tr>
				<tr>
					<td><sj:submit id="villageMasterBtnID" button="true"
							value=" Village Master Excel Sheet Format"
							label="Village Master Excel Sheet Format"
							cssClass="masterExcelbutton"
							onClickTopics="sendVillageMasterExcelFormat" /></td>
				</tr>
				<tr>
					<td><sj:submit id="bcCreationUtilityBtnID" button="true"
							value=" BC Creation Utility Excel Sheet Format"
							label="BC Creation Utility Excel Sheet Format"
							cssClass="masterExcelbutton"
							onClickTopics="bcCreationUtilityExcelFormat" /></td>
				</tr>
			</table>
		</center>
	</s:form>
</body>
</html>