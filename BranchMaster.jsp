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
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>

<script>
	$(document).ready(function() {
		$('#updateDiv').hide();
		$('#createDiv').hide();
		$('#buttonUpdateDiv').hide();

	});
	$.subscribe('branchSelection', function(event, data) {
		$('#createDiv').hide();
		$('#actionMessage').html("");
		$('#messageDiv').html("");
		var grid = event.originalEvent.grid;
		var sel_id = grid.jqGrid('getGridParam', 'selrow');
		$('#gridDiv').hide();
		$('#fileUploadDiv').hide();
		$('#updateDiv').show();
		$('#buttonCreateDiv').hide();
		$('#buttonUpdateDiv').show();
		var branchCode = grid.jqGrid('getCell', sel_id, 'branchCode');
		var bankCode = grid.jqGrid('getCell', sel_id, 'bankCode');

		$.getJSON('loadBranchDetails.action', {
			'branchCode' : branchCode,
			'bankCode' : bankCode
		}, function(jdata) {
			$('#dlgMessage').html("Branch updated successfully");
			$("#bankCodeTextFieldUpdate").val(jdata.mbr.id.mbank.bankcode);
			$("#branchCodeTextFieldUpdate").val(jdata.mbr.id.branchcode);
			$("#branchNameTextFieldUpdate").val(jdata.mbr.branchname);
			$("#branchAddress1TextAreaUpdate").val(jdata.mbr.branchAddress1);
			$("#branchAddress2TextAreaUpdate").val(jdata.mbr.branchAddress2);
			$("#stateSelectUpdate").val(jdata.mbr.stateCode);
			$("#districtSelectUpdate").val(jdata.mbr.districtCode);
			$("#talukaSelectUpdate").val(jdata.mbr.talukaCode);
			$("#regionTextFieldUpdate").val(jdata.mbr.regionCode);
			$("#contactNumberTextFieldUpdate").val(jdata.mbr.contactNo);
			$("#mobileNumberTextFieldUpdate").val(jdata.mbr.mobileno);
			$("#isfcCodeTextFieldUpdate").val(jdata.mbr.isfccode);
			$("#pinCodeTextFieldUpdate").val(jdata.mbr.pincode);
			$("#emailIdTextFieldUpdate").val(jdata.mbr.emailid);
			if (jdata.mbr.districtCode == null) {
				stateOnChangeUpdate();
			}
			if (jdata.mbr.talukaCode == null) {
				districtOnChangeUpdate();
			}

		});
	});

	function loadCreateDiv() {
		$('#buttonCreateDiv').hide();
		$('#buttonUpdateDiv').show();
		$('#gridDiv').hide();
		$('#actionMessage').html("");
		$('#messageDiv').html("");
		/* $('#branchDetailsGrid').jqGrid('setGridState', 'hidden'); */
		$('#createDiv').show();
		$('#updateDiv').hide();
		/* $(this).remove(); */
		return true;

	}
	function loadGridDiv() {

		$('#actionMessage').html("");
		$('#messageDiv').html("");
		$('#buttonCreateDiv').show();
		$('#buttonUpdateDiv').hide();
		$('#gridDiv').show();
		$('#fileUploadDiv').show();
		$('#createDiv').hide();
		$('#updateDiv').hide();
		return true;

	}

	function stateOnChangeUpdate() {

		var stateCode = $('#stateSelectUpdate').val();

		$.getJSON('loadDistrictByState.action', {
			'stateCode' : stateCode
		}, function(data) {

			var districtList = (data.districtList);
			var options = $("#districtSelectUpdate");
			var options1 = $("#talukaSelectUpdate");
			options.find('option').remove().end();
			options.append($("<option />").val("-1").text(
					"----------------Select-----------------"));
			options1.find('option').remove().end();
			options1.append($("<option />").val("-1").text(
					"------------------------Select-----------------------"));

			$.each(districtList, function() {

				options.append($("<option />").val(this.key).html(
						"<pre style='margin:0;'>" + this.displayValue
								+ "</pre>"));
			});
		});
	}
	function districtOnChangeUpdate() {
		var districtCode = $('#districtSelectUpdate').val();
		if (districtCode == "" || districtCode == "null"
				|| districtCode == "-1" || districtCode == null
				|| districtCode == "undefined")
			stateOnChangeUpdate();

		$.getJSON('loadTalukaByDistrict.action', {
			'districtCode' : districtCode
		}, function(data) {

			var talukaList = (data.talukaList);
			var options = $("#talukaSelectUpdate");
			options.find('option').remove().end();
			options.append($("<option />").val("-1").text(
					"------------------------Select-----------------------"));
			$.each(talukaList, function() {
				options.append($("<option />").val(this.key).html(
						"<pre style='margin:0;'>" + this.displayValue
								+ "</pre>"));
			});

		});
		$.getJSON('loadRegionByDistrict.action', {
			'districtCode' : districtCode
		}, function(data) {
			var regionName = (data.regionName);
			$("#regionTextFieldUpdate").val(regionName.displayValue);
		});

	}

	function stateOnChangeCreate() {

		var stateCode = $('#stateSelectCreate').val();

		$
				.getJSON(
						'loadDistrictByState.action',
						{
							'stateCode' : stateCode
						},
						function(data) {

							var districtList = (data.districtList);
							var options = $("#districtSelectCreate");
							var options1 = $("#talukaSelectCreate");
							options.find('option').remove().end();
							options.append($("<option />").val("-1").text(
									"----------------Select-----------------"));
							options1.find('option').remove().end();
							options1
									.append($("<option />")
											.val("-1")
											.text(
													"--------------------------Select-------------------------"));
							$.each(districtList, function() {

								options.append($("<option />").val(this.key)
										.html(
												"<pre style='margin:0;'>"
														+ this.displayValue
														+ "</pree>"));
							});
						});
	}
	function districtOnChangeCreate() {
		var districtCode = $('#districtSelectCreate').val();

		$
				.getJSON(
						'loadTalukaByDistrict.action',
						{
							'districtCode' : districtCode
						},
						function(data) {

							var talukaList = (data.talukaList);
							var options = $("#talukaSelectCreate");
							options.find('option').remove().end();
							options
									.append($("<option />")
											.val("-1")
											.text(
													"--------------------------Select-------------------------"));
							$.each(talukaList, function() {
								options.append($("<option />").val(this.key)
										.html(
												"<pre style='margin:0;'>"
														+ this.displayValue
														+ "</pre>"));
							});

						});
		$.getJSON('loadRegionByDistrict.action', {
			'districtCode' : districtCode
		}, function(data) {
			var regionName = (data.regionName);
			$("#regionTextFieldCreate").val(regionName.displayValue);
		});

	}
	function talukaOnClick() {
		var talukaCode = $('#talukaSelectUpdate').val();
		if (talukaCode == "" || talukaCode == "null" || talukaCode == "-1"
				|| talukaCode == null || talukaCode == "undefined")
			districtOnChangeUpdate();
	}

	$.subscribe('completeCreate', function(event, data) {

		$('#createMessageLabel').html("Branch saved sucessfully");
	});
	$.subscribe('completeUpdate', function(event, data) {
		$('#updateMessageLabel').html("Branch updated sucessfully");
	});
	$.subscribe('updateButtonTopic', function(event, data) {
		event.originalEvent.options.submit = false;
	});
	$.subscribe('createButtonTopic', function(event, data) {
		event.originalEvent.options.submit = false;
	});
	$.subscribe('closeDialog', function(event, data) {
		$('#dlgErrorMessage').dialog('close');
	});

	$
			.subscribe(
					'beforeUpdate',
					function(event, data) {

						/* var fData = event.originalEvent.formData; */
						var form = event.originalEvent.form[0];

						if (form.branchNameTextFieldUpdate.value == "") {
							$('#updateMessageLabel').html(
									"Please provide  branch name!");
							event.originalEvent.options.submit = false;
						} else if (form.branchAddress1TextAreaUpdate.value == "") {
							$('#updateMessageLabel').html(
									"Please provide  branch address1!");
							event.originalEvent.options.submit = false;
						} else if (form.branchAddress2TextAreaUpdate.value == "") {
							$('#updateMessageLabel').html(
									"Please provide  branch address2!");
							event.originalEvent.options.submit = false;
						} else if (form.pinCodeTextFieldUpdate.value != ""
								&& form.pinCodeTextFieldUpdate.value.length != 6) {
							$('#updateMessageLabel').html(
									"Please provide 6 digit pin number!");
							event.originalEvent.options.submit = false;
						} else if (form.pinCodeTextFieldUpdate.value.length == 6) {
							var pin = form.pinCodeTextFieldUpdate.value;
							var firstDigit = String(pin).charAt(0);
							if (Number(firstDigit) == 0) {
								$('#updateMessageLabel')
										.html(
												"Pin code cannot start with zero..Please enter valid pin code!");
								event.originalEvent.options.submit = false;
							} else if (form.contactNumberTextFieldUpdate.value != ""
									&& form.contactNumberTextFieldUpdate.value.length != 12) {
								$('#updateMessageLabel').html(
										"Please provide valid contact number!");
								event.originalEvent.options.submit = false;
							} else if (form.mobileNumberTextFieldUpdate.value != ""
									&& form.mobileNumberTextFieldUpdate.value.length != 10) {
								$('#updateMessageLabel')
										.html(
												"Please provide 10 digit mobile number!");
								event.originalEvent.options.submit = false;
							} else if (form.mobileNumberTextFieldUpdate.value.length == 10) {
								var mobile = form.mobileNumberTextFieldUpdate.value;
								var firstDigit = String(mobile).charAt(0);
								if (Number(firstDigit) == 0) {
									$('#updateMessageLabel')
											.html(
													"Please enter valid Mobile number!");
									event.originalEvent.options.submit = false;
								} else if (form.emailIdTextFieldUpdate.value != "") {
									var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
									if (reg
											.test(form.emailIdTextFieldUpdate.value) == false) {
										$('#updateMessageLabel')
												.html(
														"Please provide  valid email id!");
										event.originalEvent.options.submit = false;
									} else if (form.isfcCodeTextFieldUpdate.value != ""
											&& form.isfcCodeTextFieldUpdate.value.length != 11) {
										$('#updateMessageLabel')
												.html(
														"Please provide minimum 11 digit IFSC Code!");
										event.originalEvent.options.submit = false;
									} else if (form.isfcCodeTextFieldUpdate.value.length == 11) {
										var reg = /^[A-Z]{4}\d{7}$/;
										if (reg
												.test(form.isfcCodeTextFieldUpdate.value) == false) {
											$('#updateMessageLabel')
													.html(
															"Please provide IFSC Code in (Start with four Capital Letter followed by seven numbers)format!");
											event.originalEvent.options.submit = false;
										} else {
											$('#updateMessageLabel').html("");
											event.originalEvent.options.submit = true;
										}
									}
								}
							}
						}
					});
	$
			.subscribe(
					'beforeCreate',
					function(event, data) {
						/* var fData = event.originalEvent.formData; */
						var form = event.originalEvent.form[0];
						if (form.bankSelectCreate.value == -1) {
							$('#createMessageLabel').html(
									"Please provide bank code!");
							// Cancel Submit comes with 1.8.0
							event.originalEvent.options.submit = false;
						} else if ((form.branchCodeTextFieldCreate.value == "")
								|| (form.branchCodeTextFieldCreate.value.length != 4)) {
							$('#createMessageLabel').html(
									"Please provide 4 digit branch code!");
							event.originalEvent.options.submit = false;

						} else if (form.branchNameTextFieldCreate.value == "") {
							$('#createMessageLabel').html(
									"Please provide  branch name!");
							event.originalEvent.options.submit = false;
						} else if (form.branchAddress1TextAreaCreate.value == "") {
							$('#createMessageLabel').html(
									"Please provide  branch address1!");
							event.originalEvent.options.submit = false;
						} else if (form.branchAddress2TextAreaCreate.value == "") {
							$('#createMessageLabel').html(
									"Please provide  branch address2!");
							event.originalEvent.options.submit = false;
						} else if (form.pinCodeTextFieldCreate.value != ""
								&& form.pinCodeTextFieldCreate.value.length != 6) {
							$('#createMessageLabel').html(
									"Please provide 6 digit pin number!");
							event.originalEvent.options.submit = false;
						} else if (form.pinCodeTextFieldCreate.value.length == 6) {
							var pin = form.pinCodeTextFieldCreate.value;
							var firstDigit = String(pin).charAt(0);
							if (Number(firstDigit) == 0) {
								$('#createMessageLabel')
										.html(
												"Pin code cannot start with zero..Please enter valid pin code!");
								event.originalEvent.options.submit = false;
							} else if (form.contactNumberTextFieldCreate.value != ""
									&& form.contactNumberTextFieldCreate.value.length != 12) {
								$('#createMessageLabel').html(
										"Please provide valid contact number!");
								event.originalEvent.options.submit = false;
							} else if (form.mobileNumberTextFieldCreate.value != ""
									&& form.mobileNumberTextFieldCreate.value.length != 10) {
								$('#createMessageLabel')
										.html(
												"Please provide 10 digit mobile number!");
								event.originalEvent.options.submit = false;
							} else if (form.mobileNumberTextFieldCreate.value.length == 10) {
								var mobile = form.mobileNumberTextFieldCreate.value;
								var firstDigit = String(mobile).charAt(0);
								if (Number(firstDigit) == 0) {
									$('#createMessageLabel')
											.html(
													"Please enter valid Mobile number!");
									event.originalEvent.options.submit = false;
								} else if (form.emailIdTextFieldCreate.value != "") {
									var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
									if (reg
											.test(form.emailIdTextFieldCreate.value) == false) {
										$('#createMessageLabel')
												.html(
														"Please provide  valid email id!");
										event.originalEvent.options.submit = false;

									} else if (form.isfcCodeTextFieldCreate.value != ""
											&& form.isfcCodeTextFieldCreate.value.length != 11) {
										$('#updateMessageLabel')
												.html(
														"Please provide minimum 11 digit IFSC Code!");
										event.originalEvent.options.submit = false;
									} else if (form.isfcCodeTextFieldCreate.value.length == 11) {
										var reg = /^[A-Z]{4}\d{7}$/;
										if (reg
												.test(form.isfcCodeTextFieldCreate.value) == false) {
											$('#updateMessageLabel')
													.html(
															"Please provide IFSC Code in (Start with four Capital Letter followed by seven numbers)format!");
											event.originalEvent.options.submit = false;
										} else {
											event.originalEvent.options.submit = true;
										}
									}
								}
							}
						}
					});

	function validateBranchName(event) {
		var key = event.which;
		if ((key > 64 && key < 91) || (key == 0 || key == 8 || key == 32)) {
			$('#updateMessageLabel').html("");
			$('#createMessageLabel').html("");
			return true;
		} else {
			$('#updateMessageLabel').html(
					"Please provide name in capital letter only!");
			$('#createMessageLabel').html(
					"Please provide name in capital letter only!");
		}
		return false;

	}
	function validateNumberData(event) {
		var key = event.which;
		if ((key > 47 && key < 58) || (key == 0 || key == 8)) {
			$('#updateMessageLabel').html("");
			$('#createMessageLabel').html("");
			return true;
		} else {
			$('#updateMessageLabel').html("Please provide numbers only!");
			$('#createMessageLabel').html("Please provide numbers only!");
		}
		return false;

	}
	function validateAddress(event) {
		var key = event.which;
		if ((key > 64 && key < 91) || (key > 47 && key < 58)
				|| (key == 0 || key == 8 || key == 32)) {
			$('#updateMessageLabel').html("");
			$('#createMessageLabel').html("");
			return true;
		} else {
			$('#updateMessageLabel').html(
					"Please provide address in capital letter only!");
			$('#createMessageLabel').html(
					"Please provide address in capital letter only!");
		}
		return false;

	}
	function readExcelFile() {
		var file = document.getElementById('fileUpload').value;
		if (file == '') {
			$('#actionMessage').html("");
			$('#messageDiv').html("Please select an excel file to upload!");
			return false;

		}
		document.forms['frmBranchMaster'].action = "readExcelToUpload.action";
		document.forms['frmBranchMaster'].submit();

	}
	$.subscribe('loadGrid', function(event, data) {
		$("#branchDetailsGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		}).trigger("reloadGrid");
		//$.publish("reloadGrids");
	});
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form action="createBranch" id="frmBranchMaster"
		enctype="multipart/form-data" name="frmBranchMaster" method="post"
		theme="css_xhtml">
		<table width="100%">
			<tr>
				<td colspan="4" align="left">
					<div class="divSearchCondition"></div>
				</td>
			</tr>
		</table>
		<s:url var="branchGridURL" action="branchGrid.action" />
		<div id="gridDiv">

			<sjg:grid id="branchDetailsGrid" caption="Branch Details"
				dataType="json" sortable="true" autowidth="true" shrinkToFit="true"
				href="%{branchGridURL}" pager="true" sortname="branchCode"
				sortable="true" gridModel="allBranchSubList"
				onSelectRowTopics="branchSelection" viewrecords="true"
				rowList="10,15,20,25" cssStyle="cursor: pointer;" rowNum="10"
				rownumbers="true" navigatorEdit="false" navigatorAdd="false"
				navigatorDelete="false" navigatorSearch="true" navigator="true"
				navigatorView="true" navigatorRefresh="false"
				navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}}"
				navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				marksearched:true,onReset:clearSearch,dragable:true}">

				<sjg:gridColumn name="branchCode" title="Branch Code"
					index="branchCode" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="branchName" index="branchName"
					title="Branch Name" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bankCode" title="Bank Code" index="bankCode"
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="branchAddress1" index="branchAddress1"
					title="Branch Address1" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="branchAddress2" index="branchAddress2"
					title="Branch Address2" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="stateCode" index="stateCode"
					title="State Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="districtCode" index="districtCode"
					title="DistrictCode" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="talukaCode" index="talukaCode"
					title="Taluka Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="pinCode" index="pinCode" title="Pin Code"
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="contactNo" index="contactNo"
					title="Contact No." sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="mobileNo" index="mobileNo" title="Mobile No."
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="emailId" index="emailId" title="Email Id"
					sortable="false" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="isfcCode" index="isfcCode" title="IFSC Code"
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="regionCode" index="regionCode"
					title="Region Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
			</sjg:grid>
		</div>
		<div id="updateDiv">

			<center>

				<s:label id="updateMessageLabel" cssClass="errorMessage"></s:label>
				<s:actionmessage cssClass="errorMessage" />
				<s:actionerror cssClass="errorMessage" />
				<fieldset style="border-color: green; border-width: 3px;">
					<legend>Fill the following details:</legend>
					<table cellpadding="8" cellspacing="8">
						<tr>
							<td><sj:textfield requiredLabel="true" cssClass="wwctrl"
									labelposition="right" requiredPosition="right"
									label="Bank Code" id="bankCodeTextFieldUpdate"
									name="mbr.id.mbank.bankcode" readonly="true" /></td>
							<td><sj:textfield requiredLabel="true" cssClass="wwctrl"
									labelposition="left" requiredPosition="right"
									label="Branch Code" id="branchCodeTextFieldUpdate"
									name="mbr.id.branchcode" readonly="true" /></td>

							<td><sj:textfield requiredLabel="true" maxlength="30"
									cssClass="wwctrl" labelposition="right"
									onkeypress="return validateBranchName(event);"
									requiredPosition="right" label="Branch Name"
									id="branchNameTextFieldUpdate" name="mbr.branchname" /></td>
						</tr>
						<tr>
							<td colspan="3" rowspan="1"><s:textfield cssClass="wwctrl"
									maxlength="60" cols="5" rows="1" requiredLabel="true"
									onkeypress="return validateAddress(event);"
									labelposition="left" requiredPosition="right"
									label="Branch Address1" id="branchAddress1TextAreaUpdate"
									name="mbr.branchAddress1" /></td>
						</tr>
						<tr>
							<td colspan="3" rowspan="1"><s:textfield cssClass="wwctrl"
									cols="5" rows="1" requiredLabel="true" maxlength="60"
									onkeypress="return validateAddress(event);"
									labelposition="left" requiredPosition="right"
									label="Branch Address2" id="branchAddress2TextAreaUpdate"
									name="mbr.branchAddress2" /></td>
							<td><sj:textfield label="Pin Code" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);" maxlength="6"
									labelposition="left" id="pinCodeTextFieldUpdate"
									name="mbr.pincode" /></td>
						</tr>
						<tr>
							<%-- <s:url var="stateList" action="loadState.action" /> --%>
							<td><s:select headerKey="-1" label="State"
									id="stateSelectUpdate" cssClass="wwctrl" labelSeparator=":<br>"
									onclick="stateOnChangeUpdate()" cssClass="wwctrl"
									labelposition="left" list="stateList" listKey="key"
									name="mbr.stateCode" listValue="displayValue"
									headerValue="----------------Select-----------------" /></td>

							<%-- <s:url var="districtList" action="loadDistrict.action" /> --%>
							<td><s:select headerKey="-1" label="District"
									cssClass="wwctrl" labelSeparator=":<br>"
									onclick="districtOnChangeUpdate()" id="districtSelectUpdate"
									labelposition="left" list="districtList" listKey="key"
									name="mbr.districtCode" listValue="displayValue"
									headerValue="----------------Select-----------------" /></td>
							<%-- <s:url var="talukaList" action="loadTaluka.action" /> --%>
							<td><s:select headerKey="-1" id="talukaSelectUpdate"
									onclick="talukaOnClick();" label="Taluka" cssClass="wwctrl"
									labelSeparator=":<br>" labelposition="left" list="talukaList"
									listKey="key" name="mbr.talukaCode" listValue="displayValue"
									headerValue="------------------------Select-----------------------" /></td>
						</tr>
						<tr>

							<td><sj:textfield label="Contact Number" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);" maxlength="12"
									labelposition="left" id="contactNumberTextFieldUpdate"
									name="mbr.contactNo" /></td>

							<td><sj:textfield label="Mobile Number" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);" maxlength="10"
									labelposition="left" id="mobileNumberTextFieldUpdate"
									name="mbr.mobileno" /></td>

							<td><sj:textfield label="Email Id" maxlength="40"
									cssClass="wwctrl" labelposition="left"
									id="emailIdTextFieldUpdate" name="mbr.emailid" /></td>
						</tr>
						<tr>
							<td><sj:textfield name="mbr.isfccode" labelposition="left"
									cssClass="wwctrl" maxlength="11" label="IFSC Code"
									id="isfcCodeTextFieldUpdate" /></td>

							<td><sj:textfield label="Region" cssClass="wwctrl"
									labelSeparator=":<br>" labelposition="left"
									name="mbr.regionCode" id="regionTextFieldUpdate"
									readonly="true" /></td>
						</tr>
					</table>
				</fieldset>

				<table>
					<tr>
						<td><small><sj:submit targets="result" button="true"
									value="Update" id="buttonUpdate" onBeforeTopics="beforeUpdate"
									onCompleteTopics="completeUpdate" /></small></td>
					</tr>
				</table>
			</center>
		</div>
		<div id="buttonCreateDiv">
			<table width="100%">
				<tr>
					<td style="float: left;"><small><sj:submit
								button="true" id="buttonCreate"
								onBeforeTopics="createButtonTopic" value="Create Branch"
								name="buttonCreate" onclick="return loadCreateDiv();" /></small></td>
					<td style="float: right;"><div id="fileUploadDiv">
							<table>
								<tr>
									<td>
										<fieldset
											style="width: 400px; height: 70px; border-color: green;">
											<legend>Select An Excel File To Upload</legend>
											<table width="100%">
												<tr>
													<td><s:file id="fileUpload" name="fileUpload" /></td>
												</tr>
											</table>
										</fieldset>
									</td>
									<td><small><sj:a button="true" id="exportToDB"
												onclick="readExcelFile()">
							Upload
						</sj:a></small></td>
								</tr>
							</table>
						</div></td>
				</tr>
			</table>
			<table>
				<tr>
					<td width="850" style="float: right;"></td>
					<td><sj:div id="actionMessage" cssClass="errorMessage">
							<s:actionerror />
							<s:actionmessage />
						</sj:div> <sj:div id="messageDiv" cssClass="errorMessage"></sj:div></td>
				</tr>
			</table>
		</div>
		<div id="createDiv">
			<center>
				<s:label id="createMessageLabel" cssClass="errorMessage"></s:label>
				<s:actionmessage cssClass="errorMessage" />
				<s:actionerror cssClass="errorMessage" />
				<fieldset style="border-color: green; border-width: 3px;">
					<legend>Fill the following details:</legend>
					<table cellpadding="8" cellspacing="8">
						<tr>
							<td><s:select headerKey="-1" labelposition="left"
									cssClass="wwctrl" labelSeparator=":<br>" list="bankList"
									label="Bank Code" requiredLabel="true" requiredPosition="right"
									listValue="displayValue" listKey="key"
									name="mbr.id.mbank.bankcode" id="bankSelectCreate"
									value="mbr.id.mbank.bankcode"
									headerValue="----------------Select-----------------" /></td>

							<td><sj:textfield requiredLabel="true" cssClass="wwctrl"
									maxlength="4" onkeypress="return validateNumberData(event);"
									labelposition="left" requiredPosition="right"
									label="Branch Code" id="branchCodeTextFieldCreate"
									name="mbr.id.branchcode" /></td>
							<td><sj:textfield requiredLabel="true" cssClass="wwctrl"
									maxlength="30" onkeypress="return validateBranchName(event);"
									labelposition="left" requiredPosition="right"
									label="Branch Name" id="branchNameTextFieldCreate"
									name="mbr.branchname" /></td>
						</tr>
						<tr>
							<td colspan="2" rowspan="1"><s:textfield cssClass="wwctrl"
									cols="5" rows="1" labelSeparator=":<br>" requiredLabel="true"
									onkeypress="return validateAddress(event);"
									labelposition="left" requiredPosition="right"
									label="Branch Address1" id="branchAddress1TextAreaCreate"
									name="mbr.branchAddress1" /></td>
						</tr>
						<tr>
							<td colspan="2" rowspan="1"><s:textfield cssClass="wwctrl"
									labelSeparator=":<br>" cols="5" rows="1" requiredLabel="true"
									onkeypress="return validateAddress(event);"
									labelposition="left" requiredPosition="right"
									label="Branch Address2" id="branchAddress2TextAreaCreate"
									name="mbr.branchAddress2" /></td>
							<td><sj:textfield label="Pin Code" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);" maxlength="6"
									labelposition="left" id="pinCodeTextFieldCreate"
									name="mbr.pincode" /></td>
						</tr>
						<tr>
							<td><s:select headerKey="-1" label="State"
									id="stateSelectCreate" cssClass="wwctrl" labelSeparator=":<br>"
									onchange="stateOnChangeCreate()" cssClass="wwctrl"
									labelposition="left" list="stateList" listKey="key"
									name="mbr.stateCode" listValue="displayValue"
									headerValue="----------------Select-----------------" /></td>
							<td><s:select headerKey="-1" label="District"
									cssClass="wwctrl" labelSeparator=":<br>"
									onchange="districtOnChangeCreate()" id="districtSelectCreate"
									labelposition="left" list="districtList" listKey="key"
									name="mbr.districtCode" listValue="displayValue"
									headerValue="----------------Select-----------------" /></td>
							<td><s:select headerKey="-1" id="talukaSelectCreate"
									label="Taluka" cssClass="wwctrl" labelSeparator=":<br>"
									labelposition="left" list="talukaList" listKey="key"
									name="mbr.talukaCode" listValue="displayValue"
									headerValue="--------------------------Select-------------------------" /></td>
						</tr>
						<tr>

							<td><sj:textfield label="Contact Number" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);" maxlength="12"
									labelposition="left" id="contactNumberTextFieldCreate"
									name="mbr.contactNo" /></td>

							<td><sj:textfield label="Mobile Number" cssClass="wwctrl"
									onkeypress="return validateNumberData(event);" maxlength="10"
									labelposition="left" id="mobileNumberTextFieldCreate"
									name="mbr.mobileno" /></td>

							<td><sj:textfield label="Email Id" maxlength="40"
									cssClass="wwctrl" labelposition="left"
									id="emailIdTextFieldCreate" name="mbr.emailid" /></td>

						</tr>
						<tr>
							<td><sj:textfield name="mbr.isfccode" labelposition="left"
									cssClass="wwctrl" maxlength="11" label="IFSC Code"
									id="isfcCodeTextFieldCreate" /></td>
							<td><sj:textfield label="Region" cssClass="wwctrl"
									labelSeparator=":<br>" labelposition="left"
									name="mbr.regionCode" id="regionTextFieldCreate"
									readonly="true" /></td>
						</tr>
					</table>
				</fieldset>
				<table>
					<tr>
						<td><small><sj:submit targets="result" button="true"
									value="Save" id="buttonSave" onBeforeTopics="beforeCreate"
									onCompleteTopics="completeCreate" /></small></td>
						<td><small><sj:submit button="true" id="buttonReset"
									value="Reset" name="buttonReset" onclick="this.form.reset()" /></small></td>

					</tr>
				</table>
			</center>

		</div>
		<div id="buttonUpdateDiv">
			<small> <sj:submit button="true" id="buttonloadUpdate"
					onBeforeTopics="updateButtonTopic" value="Back" name="buttonUpdate"
					onclick="return loadGridDiv();" /></small>
		</div>
		<sj:dialog id="dlgMessage" autoOpen="false" modal="true"
			title="Congratulations">Branch saved successfully</sj:dialog>
		<sj:dialog id="dlgErrorMessage" autoOpen="false" modal="true"
			onCloseTopics="closeDialog" title="Error Message"></sj:dialog>
	</s:form>
</body>
</html>