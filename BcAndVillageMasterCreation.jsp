<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<head>
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/MasterStylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript">
	function readExcelFile() {

		var file = document.getElementById('fileUpload').value;
		if (file == '') {
			$('#actionMessage').html("");
			$('#messageDiv').html("Please select an excel file to upload!");
			return false;

		}
		document.forms['bcAndVillageMasterForm'].action = "readExcelToUploadBCAndVillage.action";
		document.forms['bcAndVillageMasterForm'].submit();
	}
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="bcAndVillageMasterForm" method="post" theme="css_xhtml"
		enctype="multipart/form-data">
		<center>
			<br> <br>


			<table>
				<tr>
					<td><fieldset
							style="width: 700px; height: 70px; border-color: green;">
							<legend>Select An Excel File To Upload</legend>
							<table width="100%">

								<tr>
									<td style="float: center;"><s:file id="fileUpload"
											name="fileUpload" cssClass="wwctrl" /></td>
								</tr>
							</table>
						</fieldset>
					<td><small><sj:a button="true" id="exportToDB"
								onclick="readExcelFile()">
							Upload
						</sj:a></small></td>
				</tr>
			</table>
			<div>
				<table>
					<tr>
						<!-- <td width="800" style="float: right;"></td> -->
						<td><sj:div id="actionMessage" cssClass="errorMessage">
								<s:actionerror />
							</sj:div> <sj:div cssStyle="color:green;">
								<s:actionmessage />
							</sj:div> <sj:div id="messageDiv" cssClass="errorMessage"></sj:div></td>
					</tr>
				</table>
			</div>
		</center>
	</s:form>
</body>
</html>
