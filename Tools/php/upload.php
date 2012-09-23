<!DOCTYPE html>
<html>
	<head>
		<title>Dateiupload</title>
	</head>
	<body>
		<form enctype="multipart/form-data" method="POST">
			Your name: <input type="text" name="name" /></br />
			Choose a file to upload: <input name="file" type="file" /><br />
			<input type="submit" value="Upload File" />
		</form>
	</body>
</html>
<?php
	if(isset($_FILES['file']) && move_uploaded_file($_FILES['file']['tmp_name'], "uploads/".$_FILES['file']['name'])) {
		echo "Moved <emph>".$_FILES['file']['tmp_name']."</emph> to <emph>".$_FILES['file']['name']."</emph> for <strong>".$_POST['name'].".</strong><br/>";
	}
?>