<!--Variety music-->
<!DOCTYPE html>
<html class="wide wow-animation" lang="en">

<head>
    <title>Home</title>
    <meta name="format-detection" content="telephone=no">
    <meta name="viewport"
        content="width=device-width, height=device-height, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="utf-8">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">


    <style>
        body {
            background-color: black
        }
    </style>
</head>

<body>
    <div>Home page</div>
    <div style="margin: 20px; padding: 20px; background-color: #333; border-radius: 10px;">
        <h3 style="color: white; margin-bottom: 15px;">Music Player</h3>
        <audio controls preload="metadata" style="width: 100%; max-width: 500px;">
            <source src="<%= request.getContextPath()%>/music/musics.mp3" type="audio/mpeg">
            <source src="<%= request.getContextPath()%>/music/test.m4a" type="audio/mp4">
            Your browser does not support the audio element.
        </audio>
        <p style="color: #ccc; font-size: 12px; margin-top: 10px;">
            Supported formats: MP3, M4A
        </p>
    </div>
    <script src="js/core.min.js"></script>
    <script src="js/script.js"></script>
</body>

</html>