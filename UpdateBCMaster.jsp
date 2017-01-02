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
<script>
	function stateOnChange() {
		var stateCode = $('#stateSelect').val();

		$.getJSON('findDistrictByState.action', {
			'stateCode' : stateCode
		}, function(data) {
			var districtList = (data.districtList);
			var options = $("#districtSelect");
			options.find('option').remove().end();
			options.append($("<option />").val("-1").text(
					"----------------Select-----------------"));

			$.each(districtList, function() {

				options.append($("<option />").val(this.key).html(
						"<pre style='margin:0;'>" + this.displayValue
								+ "</pre>"));
			});
		});
	}
	function districtOnChange() {
		var districtCode = $('#districtSelect').val();
		if (districtCode == "" || districtCode == "null"
				|| districtCode == "-1" || districtCode == null
				|| districtCode == "undefined")
			stateOnChange();

		$.getJSON('findSubDistrictByDist.action', {
			'districtCode' : districtCode
		}, function(data) {

			var subDistrictList = (data.subDistrictList);
			var options = $("#subDistrictSelect");
			options.find('option').remove().end();
			options.append($("<option />").val("-1").text(
					"----------------Select-----------------"));
			$.each(subDistrictList, function() {
				options.append($("<option />").val(this.key).html(
						"<pre style='margin:0;'>" + this.displayValue
								+ "</pre>"));
			});

		});

	}
	function subDistrictOnChange() {
		var subDistrictCode = $('#subDistrictSelect').val();
		if (subDistrictCode == "" || subDistrictCode == "null"
				|| subDistrictCode == "-1" || subDistrictCode == null
				|| subDistrictCode == "undefined")
			districtOnChange();

		$
				.getJSON(
						'findVillageBySub.action',
						{
							'subDistrictCode' : subDistrictCode
						},
						function(data) {

							var villageList = (data.villageList);
							var options = $("#villageSelect");
							options.find('option').remove().end();
							options
									.append($("<option />")
											.val("-1")
											.text(
													"-------------------------Select--------------------------"));
							$.each(villageList, function() {
								options.append($("<option />").val(this.key)
										.html(
												"<pre style='margin:0;'>"
														+ this.displayValue
														+ "</pre>"));
							});

						});
	}
	function villageOnClick() {
		var villageCode = $('#villageSelect').val();
		if (villageCode == "" || villageCode == "null" || villageCode == "-1"
				|| villageCode == null || villageCode == "undefined")
			subDistrictOnChange();

	}
	function bankOnChange() {
		var bankCode = $('#bankSelect').val();

		$.getJSON('findBranchList.action', {
			'bankCode' : bankCode
		}, function(data) {

			var branchList = (data.branchList);
			var options = $("#branchSelect");
			options.find('option').remove().end();
			options.append($("<option />").val("-1").text(
					"-------------------Select-------------------"));
			$.each(branchList, function() {
				options.append($("<option />").val(this.key).html(
						"<pre style='margin:0;'>" + this.displayValue
								+ "</pre>"));
			});

		});
	}

	$
			.subscribe(
					'beforeUpdate',
					function(event, data) {
						/* var fData = event.originalEvent.formData; */
						var form = event.originalEvent.form[0];
						if (form.txtPin.value != ""
								&& form.txtPin.value.length != 6) {
							$('#messageLabel').html(
									"Please provide 6 digit pin number!");
							event.originalEvent.options.submit = false;
						} else if (form.txtPin.value.length == 6) {
							var pin = form.txtPin.value;
							var firstDigit = String(pin).charAt(0);
							if (Number(firstDigit) == 0) {
								$('#messageLabel')
										.html(
												"Pin code cannot start with zero..Please enter valid pin code!");
								event.originalEvent.options.submit = false;
							} else if (form.txtMobileNo.value == ""
									|| form.txtMobileNo.value.length != 10) {
								$('#messageLabel')
										.html(
												"Please provide 10 digit mobile number!");
								event.originalEvent.options.submit = false;
							} else if (form.txtMobileNo.value.length == 10) {
								var mobile = form.txtMobileNo.value;
								var firstDigit = String(mobile).charAt(0);
								if (Number(firstDigit) == 0) {
									$('#messageLabel')
											.html(
													"Please enter valid Mobile number!");
									event.originalEvent.options.submit = false;
								}
							} else if (form.txtBcodAc.value != ""
									&& form.txtBcodAc.value.length < 17) {
								$('#messageLabel').html(
										"Please provide 17 digit BC OD Ac!");
								event.originalEvent.options.submit = false;
							} else if (form.txtBcsbAc.value != ""
									&& form.txtBcsbAc.value.length < 17) {
								$('#messageLabel').html(
										"Please provide 17 digit BC SB Ac!");
								event.originalEvent.options.submit = false;
							} else if (form.txtBcfdAc.value != ""
									&& form.txtBcfdAc.value.length < 17) {
								$('#messageLabel').html(
										"Please provide 17 digit BC FD Ac!");
								event.originalEvent.options.submit = false;
							} else {
								$('#messageLabel').html("");
								event.originalEvent.options.submit = true;
							}
						}
					}

			);
	$.subscribe('completeUpdate', function(event, data) {
		$('#messageLabel').html("BC updated sucessfully");
	});

	function validateStringData(event) {
		var key = event.which;
		if ((key > 64 && key < 91) || (key == 0 || key == 8 || key == 32)) {
			$('#messageLabel').html("");
			return true;
		} else
			$('#messageLabel').html("Please provide  capital letter only!");
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

	<s:form action="updateBcMaster.action" id="updateBcMasterForm"
		method="post" theme="css_xhtml">
		<center>
			<s:label id="messageLabel" cssClass="errorMessage"></s:label>
			<s:actionmessage />
			<s:actionerror />
			<fieldset style="border-color: green; border-width: 3px;">
				<legend>Fill the following details:</legend>
				<table id="villageTable" cellpadding="8" cellspacing="8">
					<tr valign="bottom">
						<td><sj:textfield id="txtBcCode" cssClass="wwctrl"
								readonly="true" label="BC Code" resizableGhost="true"
								name="bcMaster.id.bccode" labelposition="left"
								requiredLabel="true" requiredPosition="right" /></td>
						<td><sj:textfield id="txtBcName" cssClass="wwctrl"
								readonly="true" onkeypress="return validateStringData(event);"
								label="BC Name" resizableGhost="true" name="bcMaster.bcname"
								labelposition="left" requiredLabel="true"
								requiredPosition="right" /></td>
					</tr>
					<tr>
						<td colspan="2"><sj:textfield id="txtAddress1"
								readonly="true" cssClass="wwctrl" label="BC Address1"
								resizableGhost="true" name="bcMaster.bcaddress1"
								labelposition="left" requiredLabel="true"
								requiredPosition="right" /></td>
					</tr>
					<tr>
						<td colspan="2"><sj:textfield id="txtAddress2"
								readonly="true" cssClass="wwctrl" label="BC Address2"
								resizableGhost="true" name="bcMaster.bcaddress2"
								labelposition="left" requiredLabel="true"
								requiredPosition="right" /></td>
						<td><sj:textfield id="txtPin" cssClass="wwctrl"
								onkeypress="return validateNumberData(event);" label="Pin Code"
								maxlength="6" resizableGhost="true" name="bcMaster.pin"
								labelposition="left" /></td>
					</tr>
					<tr>
						<s:url var="getStateList" action="findStateList.action" />
						<td><sj:select headerKey="-1" label="State" id="stateSelect"
								name="bcMaster.statecode" cssClass="wwctrl"
								href="%{getStateList}" onclick="stateOnChange()"
								labelposition="left" list="stateList" listKey="key"
								listValue="displayValue"
								headerValue="----------------Select-----------------" /></td>
						<s:url var="getDistrict" action="findDistrict.action" />
						<td><sj:select headerKey="-1" label="District"
								href="%{getDistrict}" cssClass="wwctrl" labelSeparator=":<br>"
								onclick="districtOnChange()" id="districtSelect"
								labelposition="left" list="districtList" listKey="key"
								name="bcMaster.districtcode" listValue="displayValue"
								headerValue="----------------Select-----------------" /></td>
						<s:url var="getSubDistrict" action="findSubDistrict.action" />
						<td><sj:select headerKey="-1" id="subDistrictSelect"
								href="%{getSubDistrict}" onclick="subDistrictOnChange()"
								label="Sub District" cssClass="wwctrl" labelSeparator=":<br>"
								labelposition="left" list="subDistrictList" listKey="key"
								name="bcMaster.talukacode" listValue="displayValue"
								headerValue="----------------Select-----------------" /></td>
						<s:url var="getVillage" action="findVillage.action" />
						<td><sj:select headerKey="-1" id="villageSelect"
								onclick="villageOnClick();" href="%{getVillage}"
								name="bcMaster.villagecode" label="Village" cssClass="wwctrl"
								labelSeparator=":<br>" labelposition="left" list="villageList"
								listKey="key" listValue="displayValue"
								headerValue="-------------------------Select--------------------------" /></td>
					</tr>
					<tr>
						<td><sj:textfield id="txtMobileNo" cssClass="wwctrl"
								maxlength="10" onkeypress="return validateNumberData(event);"
								label="Mobile Number" resizableGhost="true"
								name="bcMaster.mobileno" labelposition="left"
								requiredLabel="true" requiredPosition="right" /></td>
						<td><sj:textfield id="txtBank" cssClass="wwctrl"
								requiredLabel="true" requiredPosition="right" readonly="true"
								label="Bank Code" resizableGhost="true"
								name="bcMaster.id.bankcode" labelposition="left" /></td>
						<td><sj:textfield id="txtBranch" cssClass="wwctrl"
								requiredLabel="true" requiredPosition="right" readonly="true"
								label="Branch Code" resizableGhost="true"
								name="bcMaster.id.branchcode" labelposition="left" /></td>
					</tr>
					<tr>
						<td><sj:textfield id="txtBcodAc" cssClass="wwctrl"
								maxlength="17" onkeypress="return validateNumberData(event);"
								label="BC OD Ac" resizableGhost="true"
								name="bcMaster.cbsodaccount" labelposition="left" /></td>
						<td><sj:textfield id="txtBcbfCode" cssClass="wwctrl"
								readonly="true" label="BC BF Code" resizableGhost="true"
								name="bcMaster.bcbfcode" labelposition="left" /></td>
						<td><sj:textfield id="txtBcsbAc" cssClass="wwctrl"
								maxlength="17" onkeypress="return validateNumberData(event);"
								label="BC SB Ac" resizableGhost="true" name="bcMaster.bcSbAc"
								labelposition="left" /></td>
						<td><sj:textfield id="txtBcfdAc" cssClass="wwctrl"
								maxlength="17" onkeypress="return validateNumberData(event);"
								label="BC FD Ac" resizableGhost="true" name="bcMaster.bcFdAc"
								labelposition="left" /></td>
					</tr>
				</table>
			</fieldset>
			<small><sj:submit targets="result" button="true"
					value="Update" id="buttonUpdate" onBeforeTopics="beforeUpdate"
					onCompleteTopics="completeUpdate" /></small>
		</center>
	</s:form>
</body>
</html>
