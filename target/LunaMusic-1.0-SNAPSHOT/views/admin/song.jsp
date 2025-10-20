<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <div class="container-fluid px-0">
                <div class="row mx-0">
                    <div class="col-12 px-0">
                        <div class="card mb-4 border-0 shadow-sm">
                            <div
                                class="card-header d-flex justify-content-between align-items-center bg-white border-bottom">
                                <div>
                                    <i class="fas fa-music me-1"></i>
                                    Song Management
                                </div>
                                <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin">
                                    <input type="hidden" name="action" value="list" />
                                    <input type="hidden" name="type" value="songs" />
                                    <input class="form-control" type="search" name="q"
                                        value="${requestScope.q == null ? '' : requestScope.q}"
                                        placeholder="Search by title/artist" />
                                    <button class="btn btn-primary ms-2" type="submit">Search</button>
                                </form>
                            </div>
                            <div class="card-body p-0">
                                <div
                                    class="d-flex justify-content-between align-items-center p-3 bg-light border-bottom">
                                    <h5 class="card-title mb-0 fw-bold">Songs</h5>
                                    <button class="btn btn-success" data-bs-toggle="modal"
                                        data-bs-target="#createModal">
                                        <i class="fas fa-plus me-1"></i>Add Song
                                    </button>
                                </div>
                                <div class="table-responsive">
                                    <table id="datatablesSimple"
                                        class="table table-striped table-hover align-middle mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Title</th>
                                                <th>Artists</th>
                                                <th>Album</th>
                                                <th>Genre</th>
                                                <th>Duration</th>
                                                <th>Play Count</th>
                                                <th>Audio</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="song" items="${requestScope.songs}">
                                                <tr>
                                                    <td>
                                                        <c:out value="${song.id}" />
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <c:if test="${not empty song.coverImage}">
                                                                <img src="${pageContext.request.contextPath}${song.coverImage}"
                                                                    alt="Song Cover" class="rounded me-2"
                                                                    style="width: 40px; height: 40px; object-fit: cover;">
                                                            </c:if>
                                                            <div>
                                                                <div class="fw-bold">
                                                                    <c:out value="${song.title}" />
                                                                </div>
                                                                <small class="text-muted">
                                                                    <c:forEach var="songArtist"
                                                                        items="${song.songArtists}" varStatus="status">
                                                                        <c:out value="${songArtist.artist.name}" />
                                                                        <c:if test="${not status.last}">, </c:if>
                                                                    </c:forEach>
                                                                </small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:forEach var="songArtist" items="${song.songArtists}"
                                                            varStatus="status">
                                                            <span class="badge bg-info me-1">
                                                                <c:out value="${songArtist.artist.name}" />
                                                            </span>
                                                        </c:forEach>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty song.album}">
                                                                <c:out value="${song.album.title}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">No Album</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty song.genre}">
                                                                <span class="badge bg-secondary">
                                                                    <c:out value="${song.genre.name}" />
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">No Genre</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty song.duration}">
                                                                <c:out value="${song.formattedDuration}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">--:--</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-primary">
                                                            <c:out
                                                                value="${song.playCount != null ? song.playCount : 0}" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty song.filePath}">
                                                            <audio controls preload="none" style="width: 200px;">
                                                                <source
                                                                    src="${pageContext.request.contextPath}${song.filePath}"
                                                                    type="audio/mpeg">
                                                                Your browser does not support the audio element.
                                                            </audio>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                data-bs-toggle="modal" data-bs-target="#editModal"
                                                                data-id="${song.id}" data-title="${song.title}"
                                                                data-album-id="${song.album != null ? song.album.id : ''}"
                                                                data-genre-id="${song.genre != null ? song.genre.id : ''}"
                                                                data-duration-id="${song.duration}"
                                                                data-lyric="${song.lyric}"
                                                                data-cover-image-path="${song.coverImage}"
                                                                data-artist-ids="<c:forEach var='songArtist' items='${song.songArtists}' varStatus='status'>${songArtist.artist.id}<c:if test='${not status.last}'>,</c:if></c:forEach>">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-danger"
                                                                data-bs-toggle="modal" data-bs-target="#deleteModal"
                                                                data-id="${song.id}" data-title="${song.title}">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- CREATE MODAL -->
            <div class="modal fade" id="createModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Add New Song</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                            enctype="multipart/form-data">
                            <input type="hidden" name="action" value="create" />
                            <input type="hidden" name="type" value="songs" />
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Song Title <span
                                                    class="text-danger">*</span></label>
                                            <input required name="title" class="form-control"
                                                placeholder="Enter song title" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Artists <span class="text-danger">*</span></label>
                                            <select multiple class="form-select" name="artistIds" required>
                                                <option value="">Select artists (hold Ctrl/Cmd for multiple)</option>
                                                <c:forEach var="artist" items="${requestScope.artists}">
                                                    <option value="${artist.id}">${artist.name}</option>
                                                </c:forEach>
                                            </select>
                                            <small class="form-text text-muted">Hold Ctrl/Cmd to select multiple
                                                artists</small>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Album</label>
                                            <select class="form-select" name="albumId">
                                                <option value="">Select album (optional)</option>
                                                <c:forEach var="album" items="${requestScope.albums}">
                                                    <option value="${album.id}">${album.title} - ${album.artist.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Genre</label>
                                            <select class="form-select" name="genreId">
                                                <option value="">Select genre (optional)</option>
                                                <c:forEach var="genre" items="${requestScope.genres}">
                                                    <option value="${genre.id}">${genre.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Audio File <span
                                                    class="text-danger">*</span></label>
                                            <input type="file" name="audioFile" class="form-control"
                                                accept=".mp3,.m4a,.wav" required />
                                            <small class="form-text text-muted">Supported formats: MP3, M4A, WAV</small>
                                        </div>
                                        <div>
                                            <div class="mb-3">
                                                <label class="form-label">Cover Image</label>
                                                <input type="file" name="coverImage" class="form-control"
                                                    accept=".jpg,.jpeg,.png,.gif" />
                                                <small class="form-text text-muted">Optional: JPG, PNG, GIF</small>
                                            </div>
                                            <div class="mb-3">
                                                <div class="image-preview-container">
                                                    <img id="createImagePreview" src="" alt="Preview"
                                                        class="img-thumbnail d-none"
                                                        style="max-width: 250px; max-height: 250px;">
                                                </div>
                                            </div>
                                        </div>


                                        <div class="mb-3">
                                            <label class="form-label">Duration (seconds)</label>
                                            <input type="number" name="duration" class="form-control"
                                                placeholder="Auto-detect from file" />
                                            <small class="form-text text-muted">Leave empty to auto-detect from audio
                                                file</small>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Lyric</label>
                                            <textarea required name="lyric" class="form-control"
                                                placeholder="Enter lyric"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-upload me-1"></i>Upload Song
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- EDIT MODAL -->
            <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Edit Song</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                            enctype="multipart/form-data">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="type" value="songs" />
                            <input type="hidden" name="id" id="editId" />
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Song Title <span
                                                    class="text-danger">*</span></label>
                                            <input required name="title" id="editTitle" class="form-control" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Artists <span class="text-danger">*</span></label>
                                            <select multiple class="form-select" name="artistIds" id="editArtistIds"
                                                required>
                                                <option value="">Select artists (hold Ctrl/Cmd for multiple)</option>
                                                <c:forEach var="artist" items="${requestScope.artists}">
                                                    <option value="${artist.id}">${artist.name}</option>
                                                </c:forEach>
                                            </select>
                                            <small class="form-text text-muted">Hold Ctrl/Cmd to select multiple
                                                artists</small>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Album</label>
                                            <select class="form-select" name="albumId" id="editAlbumId">
                                                <option value="">Select album (optional)</option>
                                                <c:forEach var="album" items="${requestScope.albums}">
                                                    <option value="${album.id}">${album.title} - ${album.artist.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Genre</label>
                                            <select class="form-select" name="genreId" id="editGenreId">
                                                <option value="">Select genre (optional)</option>
                                                <c:forEach var="genre" items="${requestScope.genres}">
                                                    <option value="${genre.id}">${genre.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Lyric</label>
                                            <textarea required name="lyric" id="editLyric" class="form-control"
                                                placeholder="Enter lyric"></textarea>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Audio File</label>
                                            <input type="file" name="audioFile" class="form-control"
                                                accept=".mp3,.m4a,.wav" />
                                            <small class="form-text text-muted">Leave empty to keep current file</small>
                                        </div>
                                        <div>
                                            <div class="mb-3">
                                                <label class="form-label">Cover Image</label>
                                                <input type="file" name="coverImage" class="form-control"
                                                    accept=".jpg,.jpeg,.png,.gif" />
                                                <small class="form-text text-muted">Leave empty to keep current
                                                    image</small>
                                            </div>
                                            <div class="mb-3">
                                                <div class="image-preview-container">
                                                    <img id="editImagePreview" src="" alt="Current Image"
                                                        class="img-thumbnail"
                                                        style="max-width: 250px; max-height: 250px; display: none;">
                                                    <div id="noCurrentImageLabel" class="text-muted"
                                                        style="display: block;">
                                                        <i class="fas fa-image me-2"></i>No current image
                                                    </div>
                                                </div>
                                            </div>
                                        </div>


                                        <div class="mb-3">
                                            <label class="form-label">Duration (seconds)</label>
                                            <input type="number" name="duration" id="editDuration"
                                                class="form-control" />
                                        </div>


                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- DELETE MODAL -->
            <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Delete Song</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin">
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="type" value="songs" />
                            <input type="hidden" name="id" id="deleteId" />
                            <div class="modal-body">
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning!</strong> This action cannot be undone.
                                </div>
                                <p>Are you sure you want to delete the song: <strong id="deleteTitle"></strong>?</p>
                                <p class="text-muted">This will also remove all associated artist relationships.</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Song
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                // DataTables initialization
                window.addEventListener('DOMContentLoaded', () => {
                    const table = document.getElementById('datatablesSimple');
                    if (table && window.simpleDatatables) {
                        new simpleDatatables.DataTable(table, {
                            searchable: true,
                            sortable: true,
                            perPage: 10,
                            perPageSelect: [5, 10, 15, 20, 25]
                        });
                    }
                });

                // File upload validation
                document.addEventListener('DOMContentLoaded', function () {
                    // Audio file validation
                    const audioInputs = document.querySelectorAll('input[name="audioFile"]');
                    audioInputs.forEach(input => {
                        input.addEventListener('change', function () {
                            const file = this.files[0];
                            if (file) {
                                const maxSize = 50 * 1024 * 1024; // 50MB
                                const allowedTypes = ['audio/mpeg', 'audio/mp4', 'audio/wav', 'audio/x-m4a'];

                                if (file.size > maxSize) {
                                    // File size must be less than 50MB
                                    this.value = '';
                                    return;
                                }

                                if (!allowedTypes.includes(file.type) && !file.name.match(/\.(mp3|m4a|wav)$/i)) {
                                    // Please select a valid audio file (MP3, M4A, WAV)
                                    this.value = '';
                                    return;
                                }

                                // Auto-detect duration if possible
                                if (this.name === 'audioFile') {
                                    // Detect duration for both create and edit forms
                                    const form = this.closest('form');
                                    const durationInput = form.querySelector('input[name="duration"]') || form.querySelector('#editDuration');

                                    if (file && file.size > 0) {
                                        // khi người dùng chon audio mới
                                        detectAudioDuration(file, durationInput);
                                    } else {
                                        // khi người dùng xóa audio cũ
                                        if (form.id === 'editModal' || form.closest('#editModal')) {
                                            const originalDuration = form.querySelector('#editDuration').getAttribute('data-original-duration');
                                            if (originalDuration && durationInput) {
                                                durationInput.value = originalDuration;
                                            }
                                        } else {
                                            // khi người dùng chon audio mới
                                            if (durationInput) {
                                                durationInput.value = '';
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    });
                    // Image preview functionality
                    document.addEventListener('DOMContentLoaded', function () {
                        // Create modal image preview
                        const createImageInput = document.querySelector('#createModal input[name="coverImage"]');
                        const createImagePreview = document.getElementById('createImagePreview');

                        if (createImageInput && createImagePreview) {
                            createImageInput.addEventListener('change', function () {
                                const file = this.files[0];
                                if (file) {
                                    const reader = new FileReader();
                                    reader.onload = function (e) {
                                        createImagePreview.src = e.target.result;
                                        createImagePreview.classList.remove('d-none');
                                    };
                                    reader.readAsDataURL(file);
                                } else {
                                    createImagePreview.classList.add('d-none');
                                }
                            });
                        }

                        // Edit modal image preview
                        const editImageInput = document.querySelector('#editModal input[name="coverImage"]');
                        const editImagePreview = document.getElementById('editImagePreview');

                        if (editImageInput && editImagePreview) {
                            editImageInput.addEventListener('change', function () {
                                const file = this.files[0];
                                const noCurrentImageLabel = document.getElementById('noCurrentImageLabel');
                                if (file) {
                                    const reader = new FileReader();
                                    reader.onload = function (e) {
                                        editImagePreview.src = e.target.result;
                                        editImagePreview.style.display = 'block';
                                        if (noCurrentImageLabel) {
                                            noCurrentImageLabel.style.display = 'none';
                                        }
                                    };
                                    reader.readAsDataURL(file);
                                } else {
                                    // Reset to current image or show "No current image"
                                    const editModal = document.getElementById('editModal');
                                    if (editModal) {
                                        const modalBtn = editModal.querySelector('[data-bs-target="#editModal"]');
                                        if (modalBtn) {
                                            const currentImagePath = modalBtn.getAttribute('data-cover-image-path');
                                            if (currentImagePath && currentImagePath.trim() !== '') {
                                                editImagePreview.src = '${pageContext.request.contextPath}' + currentImagePath;
                                                editImagePreview.style.display = 'block';
                                                if (noCurrentImageLabel) {
                                                    noCurrentImageLabel.style.display = 'none';
                                                }
                                            } else {
                                                editImagePreview.src = '';
                                                editImagePreview.style.display = 'none';
                                                if (noCurrentImageLabel) {
                                                    noCurrentImageLabel.style.display = 'block';
                                                }
                                            }
                                        }
                                    }
                                }
                            });
                        }
                    });

                    // Image file validation
                    const imageInputs = document.querySelectorAll('input[name="coverImage"]');
                    imageInputs.forEach(input => {
                        input.addEventListener('change', function () {
                            const file = this.files[0];
                            if (file) {
                                const maxSize = 5 * 1024 * 1024; // 5MB
                                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];

                                if (file.size > maxSize) {
                                    // Image size must be less than 5MB
                                    this.value = '';
                                    return;
                                }

                                if (!allowedTypes.includes(file.type) && !file.name.match(/\.(jpg|jpeg|png|gif)$/i)) {
                                    // Please select a valid image file (JPG, PNG, GIF)
                                    this.value = '';
                                    return;
                                }
                            }
                        });
                    });
                });

                // Audio duration detection
                function detectAudioDuration(file, durationInput) {
                    if (!file || !durationInput) return;

                    const audio = new Audio();
                    const url = URL.createObjectURL(file);

                    // Show loading indicator
                    durationInput.placeholder = 'Detecting duration...';
                    durationInput.disabled = true;

                    audio.addEventListener('loadedmetadata', function () {
                        const duration = Math.round(audio.duration);
                        if (duration > 0) {
                            durationInput.value = duration;
                            durationInput.placeholder = '';
                        } else {
                            durationInput.placeholder = 'Duration not detected';
                        }
                        durationInput.disabled = false;
                        URL.revokeObjectURL(url);
                    });

                    audio.addEventListener('error', function () {
                        durationInput.placeholder = 'Duration not detected';
                        durationInput.disabled = false;
                        URL.revokeObjectURL(url);
                    });

                    audio.src = url;
                }

                // Modal population for edit
                document.addEventListener('DOMContentLoaded', function () {
                    const editModal = document.getElementById('editModal');
                    if (editModal) {
                        editModal.addEventListener('show.bs.modal', function (event) {
                            const btn = event.relatedTarget;

                            // Reset file input
                            const editImageInput = document.querySelector('#editModal input[name="coverImage"]');
                            if (editImageInput) {
                                editImageInput.value = '';
                            }

                            // Set basic fields
                            document.getElementById('editId').value = btn.getAttribute('data-id');
                            document.getElementById('editTitle').value = btn.getAttribute('data-title');
                            // Set lyric
                            document.getElementById('editLyric').value = btn.getAttribute('data-lyric');
                            // Set album
                            const albumId = btn.getAttribute('data-album-id');
                            if (albumId) {
                                document.getElementById('editAlbumId').value = albumId;
                            }

                            // Set genre
                            const genreId = btn.getAttribute('data-genre-id');
                            if (genreId) {
                                document.getElementById('editGenreId').value = genreId;
                            }
                            // Set current image
                            const imagePath = btn.getAttribute('data-cover-image-path');
                            const editImagePreview = document.getElementById('editImagePreview');
                            const noCurrentImageLabel = document.getElementById('noCurrentImageLabel');
                            if (editImagePreview && noCurrentImageLabel) {
                                if (imagePath && imagePath.trim() !== '') {
                                    const fullImagePath = '${pageContext.request.contextPath}' + imagePath;
                                    editImagePreview.src = fullImagePath;
                                    editImagePreview.style.display = 'block';
                                    noCurrentImageLabel.style.display = 'none';
                                } else {
                                    editImagePreview.src = '';
                                    editImagePreview.style.display = 'none';
                                    noCurrentImageLabel.style.display = 'block';
                                }
                            }


                            // Lấy duration từ database
                            const durationValue = btn.getAttribute('data-duration-id'); // VD: "180"

                            // Set vào input
                            const editDurationInput = document.getElementById('editDuration');
                            editDurationInput.value = durationValue;                    // duration = 180

                            // LƯU original duration để backup
                            editDurationInput.setAttribute('data-original-duration', durationValue); // data-original-duration = "180"

                            // Set artists (multiple selection)
                            const artistIds = btn.getAttribute('data-artist-ids');
                            if (artistIds) {
                                const artistSelect = document.getElementById('editArtistIds');
                                const ids = artistIds.split(',');
                                Array.from(artistSelect.options).forEach(option => {
                                    option.selected = ids.includes(option.value);
                                });
                            }
                        });
                    }

                    // Reset edit form when modal is hidden
                    editModal.addEventListener('hidden.bs.modal', function () {
                        // Reset file inputs
                        const audioInput = editModal.querySelector('input[name="audioFile"]');
                        const imageInput = editModal.querySelector('input[name="coverImage"]');
                        if (audioInput) audioInput.value = '';
                        if (imageInput) imageInput.value = '';

                        // Reset duration to original value
                        const durationInput = document.getElementById('editDuration');
                        const originalDuration = durationInput.getAttribute('data-original-duration');
                        if (originalDuration) {
                            durationInput.value = originalDuration;
                            durationInput.placeholder = '';
                            durationInput.disabled = false;
                        }

                        // Reset image preview
                        const editImagePreview = document.getElementById('editImagePreview');
                        const noCurrentImageLabel = document.getElementById('noCurrentImageLabel');
                        if (editImagePreview && noCurrentImageLabel) {
                            editImagePreview.src = '';
                            editImagePreview.style.display = 'none';
                            noCurrentImageLabel.style.display = 'block';
                        }
                    });

                    // Delete modal population
                    const deleteModal = document.getElementById('deleteModal');
                    if (deleteModal) {
                        deleteModal.addEventListener('show.bs.modal', function (event) {
                            const btn = event.relatedTarget;
                            document.getElementById('deleteId').value = btn.getAttribute('data-id');
                            document.getElementById('deleteTitle').textContent = btn.getAttribute('data-title');
                        });
                    }
                });

                // Form submission handling
                document.addEventListener('DOMContentLoaded', function () {
                    const createForm = document.querySelector('#createModal form');
                    if (createForm) {
                        createForm.addEventListener('submit', function (e) {
                            const audioFile = this.querySelector('input[name="audioFile"]');
                            const artistIds = this.querySelector('select[name="artistIds"]');

                            if (!audioFile.files[0]) {
                                e.preventDefault();
                                // Please select an audio file
                                return;
                            }

                            const selectedArtists = Array.from(artistIds.selectedOptions).map(option => option.value);
                            if (selectedArtists.length === 0) {
                                e.preventDefault();
                                // Please select at least one artist
                                return;
                            }

                            // Show loading state
                            const submitBtn = this.querySelector('button[type="submit"]');
                            const originalText = submitBtn.innerHTML;
                            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Uploading...';
                            submitBtn.disabled = true;

                            // Re-enable button if form submission fails
                            setTimeout(() => {
                                submitBtn.innerHTML = originalText;
                                submitBtn.disabled = false;
                            }, 10000);
                        });
                    }
                });
            </script>

            <style>
                /* Custom styles for song management */
                .container-fluid.px-0 {
                    padding-left: 0 !important;
                    padding-right: 0 !important;
                }

                .row.mx-0 {
                    margin-left: 0 !important;
                    margin-right: 0 !important;
                }

                .col-12.px-0 {
                    padding-left: 0 !important;
                    padding-right: 0 !important;
                }

                .card.border-0 {
                    border: none !important;
                }

                .table-responsive {
                    overflow-x: auto;
                }

                .table {
                    width: 100% !important;
                    margin-bottom: 0 !important;
                }

                #datatablesSimple {
                    width: 100% !important;
                    min-width: 100% !important;
                }

                .card-header {
                    padding: 1rem 1.5rem;
                }

                .bg-light {
                    background-color: #f8f9fa !important;
                }

                .btn-group .btn {
                    border-radius: 0.375rem;
                }

                .btn-group .btn:not(:last-child) {
                    margin-right: 0.25rem;
                }

                /* Audio player styling */
                audio {
                    max-width: 200px;
                    height: 32px;
                }

                /* Badge styling */
                .badge {
                    font-size: 0.75em;
                }

                /* Modal styling */
                .modal-lg {
                    max-width: 800px;
                }

                /* File input styling */
                .form-control[type="file"] {
                    padding: 0.375rem 0.75rem;
                }

                /* Multi-select styling */
                select[multiple] {
                    min-height: 120px;
                }

                /* Image preview in table */
                .table img {
                    border: 1px solid #dee2e6;
                }

                /* Loading state */
                .btn:disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                }

                /* Alert styling */
                .alert {
                    border-radius: 0.375rem;
                }

                /* Form validation */
                .form-control:invalid {
                    border-color: #dc3545;
                }

                .form-control:valid {
                    border-color: #198754;
                }

                /* Responsive adjustments */
                @media (max-width: 768px) {
                    .modal-lg {
                        max-width: 95%;
                    }

                    .table-responsive {
                        font-size: 0.875rem;
                    }

                    audio {
                        max-width: 150px;
                    }
                }
            </style>