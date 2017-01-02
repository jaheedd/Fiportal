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
	function change_frames(file1, file2) {
		parent.loginFrame.location = file1;
		parent.classFrame.location = file2;
		var menuID = parent.document.getElementById("mainFrameSet");
		$(menuID).attr("cols", "300px,*");
	}

$(document).ready(function() {
	var reportTitle = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument
	.getElementById("reportTitle");
	$(reportTitle).html('').css({
	'display' : 'none'
	});
	var helpBtn = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument
	.getElementById("helpBtn");
	$(helpBtn).css('display','none');
	parent.loginFrame.location='Login.jsp';
	var menuID = parent.document.getElementById("mainFrameSet");
	$(menuID).attr("cols", "300px,*");
});
</script>

</head>
<body>
	<s:form name="sessionCheck" method="post">
		<center>
			<h2>
				Session has expired..<br>Please login again!
			</h2>
		</center>
	</s:form>
</body>
</html>