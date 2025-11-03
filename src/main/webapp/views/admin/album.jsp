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
                                    <i class="fas fa-compact-disc me-1"></i>
                                    Album Management
                                </div>
                                <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin">
                                    <input type="hidden" name="action" value="list" />
                                    <input type="hidden" name="type" value="albums" />
                                    <input class="form-control" type="search" name="q"
                                        value="${requestScope.q == null ? '' : requestScope.q}"
                                        placeholder="Search by title/artist" />
                                    <button class="btn btn-primary ms-2" type="submit">Search</button>
                                </form>
                            </div>
                            <div class="card-body p-0">
                                <div
                                    class="d-flex justify-content-between align-items-center p-3 bg-light border-bottom">
                                    <h5 class="card-title mb-0 fw-bold">Albums</h5>
                                    <button class="btn btn-success" data-bs-toggle="modal"
                                        data-bs-target="#createModal">
                                        <i class="fas fa-plus me-1"></i>Add Album
                                    </button>
                                </div>
                                <div class="table-responsive">
                                    <table id="datatablesSimple"
                                        class="table table-striped table-hover align-middle mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Cover</th>
                                                <th>Title</th>
                                                <th>Artist</th>
                                                <th>Year</th>
                                                <th>Created</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="album" items="${requestScope.albums}">
                                                <tr>
                                                    <td>
                                                        <c:out value="${album.id}" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty album.coverImagePath}">
                                                                <img src="${pageContext.request.contextPath}${album.coverImagePath}"
                                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/LogoFinal1.png'"
                                                                    alt="Album Cover" class="rounded"
                                                                    style="width: 60px; height: 60px; object-fit: cover;">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="bg-secondary rounded d-flex align-items-center justify-content-center"
                                                                    style="width: 60px; height: 60px;">
                                                                    <i class="fas fa-music text-white"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="fw-bold">
                                                            <c:out value="${album.title}" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <c:if test="${not empty album.artist.imagePath}">
                                                                <img src="${pageContext.request.contextPath}${album.artist.imagePath}"
                                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/LogoFinal1.png'"
                                                                    alt="Artist" class="rounded-circle me-2"
                                                                    style="width: 30px; height: 30px; object-fit: cover;">
                                                            </c:if>
                                                            <span>
                                                                <c:out value="${album.artist.name}" />
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty album.releaseYear}">
                                                                <span class="badge bg-info">
                                                                    <c:out value="${album.releaseYear}" />
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <small class="text-muted">
                                                            <c:out value="${album.createdAt}" />
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                data-bs-toggle="modal" data-bs-target="#editModal"
                                                                data-id="${album.id}" data-title="${album.title}"
                                                                data-artist-id="${album.artist.id}"
                                                                data-release-year="${album.releaseYear}"
                                                                data-cover-image-path="${album.coverImagePath}">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-danger"
                                                                data-bs-toggle="modal" data-bs-target="#deleteModal"
                                                                data-id="${album.id}" data-title="${album.title}">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="card-footer bg-white border-top">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination justify-content-center mb-0">
                                            <c:if test="${currentPage > 1}">
                                                <a class="page-link"
                                                    href="${pageContext.request.contextPath}/admin?action=list&type=albums&page=${currentPage - 1}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                        fill="currentColor" class="bi bi-arrow-left-square-fill"
                                                        viewBox="0 0 16 16">
                                                        <path
                                                            d="M16 14a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2zm-4.5-6.5H5.707l2.147-2.146a.5.5 0 1 0-.708-.708l-3 3a.5.5 0 0 0 0 .708l3 3a.5.5 0 0 0 .708-.708L5.707 8.5H11.5a.5.5 0 0 0 0-1" />
                                                    </svg>
                                                </a>
                                            </c:if>
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:if test="${currentPage == i}">
                                                    <a class="page-link nav-link active"
                                                        href="${pageContext.request.contextPath}/admin?action=list&type=albums&page=${i}">${i}</a>
                                                </c:if>
                                                <c:if test="${currentPage != i}">
                                                    <a class="page-link"
                                                        href="${pageContext.request.contextPath}/admin?action=list&type=albums&page=${i}">${i}</a>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${currentPage < totalPages}">
                                                <a class="page-link"
                                                    href="${pageContext.request.contextPath}/admin?action=list&type=albums&page=${currentPage + 1}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                        fill="currentColor" class="bi bi-arrow-right-square-fill"
                                                        viewBox="0 0 16 16">
                                                        <path
                                                            d="M0 14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2a2 2 0 0 0-2 2zm4.5-6.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5a.5.5 0 0 1 0-1" />
                                                    </svg>
                                                </a>
                                            </c:if>
                                        </ul>
                                    </nav>
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
                            <h5 class="modal-title">Add New Album</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                            enctype="multipart/form-data">
                            <input type="hidden" name="action" value="create" />
                            <input type="hidden" name="type" value="albums" />
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Album Title <span
                                                    class="text-danger">*</span></label>
                                            <input required name="title" class="form-control"
                                                placeholder="Enter album title" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Artist <span class="text-danger">*</span></label>
                                            <select required name="artistId" class="form-select">
                                                <option value="">Select artist</option>
                                                <c:forEach var="artist" items="${requestScope.artists}">
                                                    <option value="${artist.id}">${artist.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Release Year</label>
                                            <input type="number" name="releaseYear" class="form-control"
                                                placeholder="e.g., 2024" min="1900" max="2030" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Cover Image</label>
                                            <input type="file" name="coverImage" class="form-control"
                                                accept=".jpg,.jpeg,.png,.gif" />
                                            <small class="form-text text-muted">Recommended: JPG, PNG, GIF (max
                                                5MB)</small>
                                        </div>

                                        <div class="mb-3">
                                            <div class="image-preview-container">
                                                <img id="createImagePreview" src="" alt="Preview"
                                                    class="img-thumbnail d-none"
                                                    style="max-width: 250px; max-height: 250px;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Save Album
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
                            <h5 class="modal-title">Edit Album</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                            enctype="multipart/form-data">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="type" value="albums" />
                            <input type="hidden" name="id" id="editId" />
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Album Title <span
                                                    class="text-danger">*</span></label>
                                            <input required name="title" id="editTitle" class="form-control" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Artist <span class="text-danger">*</span></label>
                                            <select required name="artistId" id="editArtistId" class="form-select">
                                                <option value="">Select artist</option>
                                                <c:forEach var="artist" items="${requestScope.artists}">
                                                    <option value="${artist.id}">${artist.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Release Year</label>
                                            <input type="number" name="releaseYear" id="editReleaseYear"
                                                class="form-control" min="1900" max="2025" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Cover Image</label>
                                            <input type="file" name="coverImage" class="form-control"
                                                id="editCoverImageInput" accept=".jpg,.jpeg,.png,.gif" />
                                            <small class="form-text text-muted">Leave empty to keep current
                                                image</small>
                                            <p id="currentFileName" class="mt-2 text-primary"></p>
                                            <p id="newFileName" class="mt-2 text-success d-none"></p>
                                        </div>

                                        <div class="mb-3">
                                            <div class="image-preview-container">
                                                <img id="editImagePreview" src="" alt="Current Image"
                                                    class="img-thumbnail" style="max-width: 250px; max-height: 250px;">
                                            </div>
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
                            <h5 class="modal-title">Delete Album</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin">
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="type" value="albums" />
                            <input type="hidden" name="id" id="deleteId" />
                            <div class="modal-body">
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning!</strong> This action cannot be undone.
                                </div>
                                <p>Are you sure you want to delete the album: <strong id="deleteTitle"></strong>?</p>
                                <p class="text-muted">This will also remove all associated songs.</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Album
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>



                // File validation
                document.addEventListener('DOMContentLoaded', function () {
                    const imageInputs = document.querySelectorAll('input[name="coverImage"]');
                    imageInputs.forEach(input => {
                        input.addEventListener('change', function () {
                            const file = this.files[0];
                            if (file) {
                                const maxSize = 5 * 1024 * 1024; // 5MB
                                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];

                                if (file.size > maxSize) {
                                    this.value = '';
                                    return;
                                }

                                if (!allowedTypes.includes(file.type) && !file.name.match(/\.(jpg|jpeg|png|gif)$/i)) {
                                    this.value = '';
                                    return;
                                }
                            }
                        });
                    });
                });

                // Modal population for edit
                document.addEventListener('DOMContentLoaded', function () {
                    const editModal = document.getElementById('editModal');
                    if (editModal) {
                        editModal.addEventListener('show.bs.modal', function (event) {
                            const btn = event.relatedTarget;
                            const contextPath = '${pageContext.request.contextPath}';
                            const currentFileNameEl = document.getElementById('currentFileName');
                            const editCoverImageInput = document.getElementById('editCoverImageInput');
                            document.getElementById('editId').value = btn.getAttribute('data-id');
                            document.getElementById('editTitle').value = btn.getAttribute('data-title');
                            document.getElementById('editArtistId').value = btn.getAttribute('data-artist-id');
                            document.getElementById('editReleaseYear').value = btn.getAttribute('data-release-year') || '';
                            const imagePath = btn.getAttribute('data-cover-image-path');
                            const editImagePreview = document.getElementById('editImagePreview');
                            if (imagePath && imagePath.trim() !== '') {
                                // hiển ảnh
                                editImagePreview.src = '${pageContext.request.contextPath}' + imagePath;
                                editImagePreview.classList.remove('d-none');

                                // file hiện tại
                                const fileName = imagePath.substring(imagePath.lastIndexOf('/') + 1);
                                currentFileNameEl.textContent = 'Current file: ' + fileName;
                                currentFileNameEl.classList.remove('d-none');
                            } else {
                                editImagePreview.src = '';
                                editImagePreview.classList.add('d-none');
                            }
                        });
                    }

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
                            const title = this.querySelector('input[name="title"]').value.trim();
                            const artistId = this.querySelector('select[name="artistId"]').value;

                            if (!title) {
                                e.preventDefault();
                                // Please enter album title
                                return;
                            }

                            if (!artistId) {
                                e.preventDefault();
                                // Please select an artist
                                return;
                            }

                            // Show loading state
                            const submitBtn = this.querySelector('button[type="submit"]');
                            const originalText = submitBtn.innerHTML;
                            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Saving...';
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
                /* Custom styles for album management */
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

                /* Modal styling */
                .modal-lg {
                    max-width: 800px;
                }

                /* File input styling */
                .form-control[type="file"] {
                    padding: 0.375rem 0.75rem;
                }

                /* Badge styling */
                .badge {
                    font-size: 0.75em;
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

                /* Loading state */
                .btn:disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                }
            </style>