<!DOCTYPE html>
<html lang="en">
<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <head>
            <title>Create Playlist - Luna Music</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta charset="utf-8">
            <meta name="context-path" content="${pageContext.request.contextPath}">

            <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/playlist-create.css">
        </head>

        <body>
            <div class="create-playlist-container">
                <div class="create-playlist-form">
                    <div class="form-header">
                        <h1>Create Playlist</h1>
                        <p>Give your playlist a name and description</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            ${error}
                        </div>
                    </c:if>

                    <form method="POST" action="${pageContext.request.contextPath}/playlist">
                        <input type="hidden" name="action" value="create">

                        <div class="form-group">
                            <label for="name">Playlist Name *</label>
                            <input type="text" id="name" name="name" class="form-control"
                                placeholder="Enter playlist name" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="4"
                                placeholder="Tell us about your playlist (optional)"></textarea>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn-cancel" onclick="goBack()">
                                Cancel
                            </button>
                            <button type="submit" class="btn-create">
                                Create Playlist
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function goBack() {
                    window.history.back();
                }
            </script>
        </body>

</html>