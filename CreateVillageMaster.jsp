<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/MasterStylesheet.css?v=2.4" type="text/css"
	title="Style">
<script>
	$(document).ready(function() {

		$('#buttonUpdateDiv').hide();

	});
	$
			.subscribe(
					'beforeCreate',
					function(event, data) {
						var form = event.originalEvent.form[0];
						if (form.bcSelectCreate.value === "null"
								|| form.bcSelectCreate.value === null
								|| form.bcSelectCreate.value === "-1"
								|| form.bcSelectCreate.value === " "
								|| typeof form.bcSelectCreate.value === "undefined") {
							$('#messageLabel').html("Please provide bc code!");
							event.originalEvent.options.submit = false;
						} else if (form.branchCodeSelectID.value === "null"
								|| form.branchCodeSelectID.value === null
								|| form.branchCodeSelectID.value === "-1"
								|| form.branchCodeSelectID.value === " "
								|| typeof form.branchCodeSelectID.value === "undefined") {
							$('#messageLabel').html(
									"Please select branch code!");
							event.originalEvent.options.submit = false;

						} else if (form.txtPinCreate.value != ""
								&& form.txtPinCreate.value.length != 6) {
							$('#messageLabel').html(
									"Please provide 6 digit pin code!");
							event.originalEvent.options.submit = false;
						} else if (form.txtPinCreate.value.length == 6) {
							var pin = form.txtPinCreate.value;
							var firstDigit = String(pin).charAt(0);
							if (Number(firstDigit) == 0) {
								$('#messageLabel')
										.html(
												"Pin code cannot start with zero..Please enter valid pin code!");
								event.originalEvent.options.submit = false;
							} else if (form.populationSelectCreate.value === "null"
									|| form.populationSelectCreate.value === null
									|| form.populationSelectCreate.value === "-1"
									|| form.populationSelectCreate.value === " "
									|| typeof form.populationSelectCreate.value === "undefined") {
								$('#messageLabel').html(
										"Please provide population flag!");
								event.originalEvent.options.submit = false;

							} else if (form.urbanSelectCreate.value === "null"
									|| form.urbanSelectCreate.value === null
									|| form.urbanSelectCreate.value === "-1"
									|| form.urbanSelectCreate.value === " "
									|| typeof form.urbanSelectCreate.value === "undefined") {
								$('#messageLabel').html(
										"Please provide urban flag!");
								event.originalEvent.options.submit = false;

							} else {
								$('#messageLabel').html("");
								event.originalEvent.options.submit = true;
							}
						}
					});
	$.subscribe('completeCreate', function(event, data) {

		$('#messageLabel').html("Village saved sucessfully");
	});

	function validateStringData(event) {
		var key = event.which;
		if ((key > 64 && key < 91) || (key == 0 || key == 8 || key == 32)) {
			$('#messageLabel').html("");
			return true;
		} else
			$('#messageLabel').html(
					"Please provide name in capital letter only!");
		return false;

	}
	function validateNumberData(event) {
		var key = event.which;
		if ((key > 47 && key < 58) || (key == 0 || key == 8)) {
			$('#messageLabel').html("");
			return true;
		} else
			$('#messageLabel').html("Please provide numbers only!");
		return false;

	}
	function validateAddress(event) {
		var key = event.which;
		if ((key > 64 && key < 91) || (key > 47 && key < 58)
				|| (key == 0 || key == 8 || key == 32)) {
			$('#messageLabel').html("");
			return true;
		} else
			$('#messageLabel').html(
					"Please provide address in capital letter only!");
		return false;

	}
</script>
</head>
<body>
	<s:form action="saveVillageMaster" id="villageMasterForm" method="post"
		theme="css_xhtml">

		<sj:div id="createFieldsDiv">
			<center>
				<s:label id="messageLabel" cssClass="errorMessage"></s:label>
				<s:actionmessage />
				<s:actionerror />
				<fieldset style="border-color: green; border-width: 3px;">
					<legend>Fill the following details:</legend>
					<table id="villageTable" cellpadding="8" cellspacing="8">
						<tr valign="bottom">
							<s:url var="bcListURL" action="findBC.action" />
							<td><sj:select id="bcSelectCreate" headerKey="-1"
									href="%{bcListURL}" cssClass="wwctrl" requiredLabel="true"
									requiredPosition="right" label="BC Code"
									headerValue="Select BC" list="bcList" listValue="displayValue"
									listKey="key" name="mvillage.bcCode" labelposition="left" /></td>
							<td><sj:textfield id="txtVCodeCreate" cssClass="wwctrl"
									label="Village Code" resizableGhost="true"
									name="mvillage.id.villageCode" labelposition="left"
									requiredLabel="true" requiredPosition="right" readonly="true" /></td>
							<td><sj:textfield id="txtVNameCreate" readonly="true"
									size="50" cssClass="wwctrl" label="Village Name"
									resizableGhost="true" name="mvillage.villageName"
									labelposition="left" requiredLabel="true"
									requiredPosition="right" /></td>
							<td><sj:textfield id="txtTCodeCreate" readonly="true"
									cssClass="wwctrl" requiredLabel="true" resizableGhost="true"
									name="mvillage.id.talukaCode" label="Taluka Code"
									labelposition="left" requiredPosition="right" /></td>
						</tr>

						<tr>
							<td><s:select id="branchCodeSelectID" cssClass="wwctrl"
									labelposition="right" list="branchList" headerKey="-1"
									headerValue="Select" label="Branch Code" listKey="key"
									listValue="displayValue" name="mvillage.branchCode"
									requiredLabel="true" requiredPosition="right" /></td>
							<td><sj:textfield id="txtPinCreate" label="Pin"
									onkeypress="return validateNumberData(event);"
									cssClass="wwctrl" maxlength="6" labelposition="left"
									resizableGhost="true" name="mvillage.pin" /></td>
							<td><sj:textfield id="txtCBSVCodeCreate" readonly="true"
									cssClass="wwctrl" label="CBS Village Code"
									resizableGhost="true" name="mvillage.cbsVillageCode"
									labelposition="left" requiredLabel="true"
									requiredPosition="right" /></td>
						</tr>
						<tr>
							<s:url var="populationListURL" action="findPopulation.action" />
							<td><sj:select id="populationSelectCreate" cssClass="wwctrl"
									href="%{populationListURL}" labelposition="left"
									list="populationList" headerKey="-1" headerValue="Select"
									label="Population Flag" listKey="key" listValue="displayValue"
									name="mvillage.populationFlag" requiredLabel="true"
									requiredPosition="right" /></td>
							<s:url var="urbanFlagListURL" action="findUrbanFlag.action" />
							<td><sj:select id="urbanSelectCreate" cssClass="wwctrl"
									href="%{urbanFlagListURL}" labelposition="left"
									list="urbanList" headerKey="-1" headerValue="Select"
									label="Urban Flag" listKey="key" listValue="displayValue"
									name="mvillage.urbanFlag" requiredLabel="true"
									requiredPosition="right" /></td>
							<td><sj:textfield id="txtLatitudeCreate" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);" label="Latitude"
									resizableGhost="true" labelposition="left" /></td>
							<td><sj:textfield id="txtLongitudeCreate" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);"
									label="Longitude" resizableGhost="true" labelposition="left" /></td>
						</tr>
					</table>
				</fieldset>
				<table>
					<tr>
						<td><sj:submit targets="result" button="true" value="Save"
								id="buttonSave" onBeforeTopics="beforeCreate"
								onCompleteTopics="completeCreate" /></td>
						<td><sj:submit button="true" id="buttonReset" value="Reset"
								name="buttonReset" onclick="this.form.reset()" /></td>
					</tr>
				</table>

			</center>
		</sj:div>
		<sj:dialog id="dlgErrorMessage" autoOpen="false" modal="true"
			onCloseTopics="closeDialog" title="Error Message"></sj:dialog>
	</s:form>

</body>
</html>
