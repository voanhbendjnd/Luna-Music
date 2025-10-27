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
                                    <i class="fas fa-tags me-1"></i>
                                    Genre Management
                                </div>
                                <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin">
                                    <input type="hidden" name="action" value="list" />
                                    <input type="hidden" name="type" value="genres" />
                                    <input type="hidden" name="page" value="1" />
                                    <input class="form-control" type="search" name="q" value="${q == null ? '' : q}"
                                        placeholder="Search by name" />
                                    <button class="btn btn-primary ms-2" type="submit">Search</button>
                                </form>
                            </div>
                            <div class="card-body p-0">
                                <div
                                    class="d-flex justify-content-between align-items-center p-3 bg-light border-bottom">
                                    <h5 class="card-title mb-0 fw-bold">Genres</h5>
                                    <button class="btn btn-success" data-bs-toggle="modal"
                                        data-bs-target="#createModal">
                                        <i class="fas fa-plus me-1"></i>Add Genre
                                    </button>
                                </div>
                                <div class="table-responsive">
                                    <table id="datatablesSimple"
                                        class="table table-striped table-hover align-middle mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="genre" items="${genres}">
                                                <tr>
                                                    <td>
                                                        <c:out value="${genre.id}" />
                                                    </td>
                                                    <td>
                                                        <div class="fw-bold">
                                                            <span class="badge bg-primary fs-6">
                                                                <c:out value="${genre.name}" />
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty genre.description}">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${fn:length(genre.description) > 150}">
                                                                        <c:out
                                                                            value="${fn:substring(genre.description, 0, 150)}..." />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${genre.description}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">No description</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                data-bs-toggle="modal" data-bs-target="#editModal"
                                                                data-id="${genre.id}" data-name="${genre.name}"
                                                                data-description="${genre.description}">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-danger"
                                                                data-bs-toggle="modal" data-bs-target="#deleteModal"
                                                                data-id="${genre.id}" data-name="${genre.name}">
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

                                            <!-- <c:url var="basePageUrl" value="${pageContext.request.contextPath}/admin">
                                                <c:param name="action" value="list" />
                                                <c:param name="type" value="genres" />
                                                <c:if test="${not empty q}">
                                                    <c:param name="q" value="${q}" />
                                                </c:if>
                                            </c:url> -->

                                            <c:if test="${currentPage > 1}">
                                                <a class="page-link"
                                                    href="${pageContext.request.contextPath}/admin?action=list&type=genres&page=${currentPage - 1}">
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
                                                        href="${pageContext.request.contextPath}/admin?action=list&type=genres&page=${i}">${i}</a>
                                                </c:if>
                                                <c:if test="${currentPage != i}">
                                                    <a class="page-link"
                                                        href="${pageContext.request.contextPath}/admin?action=list&type=genres&page=${i}">${i}</a>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${currentPage < totalPages}">
                                                <a class="page-link"
                                                    href="${pageContext.request.contextPath}/admin?action=list&type=genres&page=${currentPage + 1}">
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
            </div>

            <!-- CREATE MODAL -->
            <div class="modal fade" id="createModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Add New Genre</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin">
                            <input type="hidden" name="action" value="create" />
                            <input type="hidden" name="type" value="genres" />
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Genre Name <span class="text-danger">*</span></label>
                                    <input required name="name" class="form-control" placeholder="Enter genre name" />
                                    <small class="form-text text-muted">e.g., Pop, Rock, Jazz, Classical</small>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea name="description" class="form-control" rows="3"
                                        placeholder="Enter genre description (optional)"></textarea>
                                    <small class="form-text text-muted">Brief description of the genre</small>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Save Genre
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- EDIT MODAL -->
            <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Edit Genre</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="type" value="genres" />
                            <input type="hidden" name="id" id="editId" />
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Genre Name <span class="text-danger">*</span></label>
                                    <input required name="name" id="editName" class="form-control" />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea name="description" id="editDescription" class="form-control"
                                        rows="3"></textarea>
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
                            <h5 class="modal-title">Delete Genre</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin">
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="type" value="genres" />
                            <input type="hidden" name="id" id="deleteId" />
                            <div class="modal-body">
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning!</strong> This action cannot be undone.
                                </div>
                                <p>Are you sure you want to delete the genre: <strong id="deleteName"></strong>?</p>
                                <p class="text-muted">This will remove the genre from all associated songs.</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Genre
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                // Modal population for edit
                document.addEventListener('DOMContentLoaded', function () {
                    const editModal = document.getElementById('editModal');
                    if (editModal) {
                        editModal.addEventListener('show.bs.modal', function (event) {
                            const btn = event.relatedTarget;

                            // Set basic fields
                            document.getElementById('editId').value = btn.getAttribute('data-id');
                            document.getElementById('editName').value = btn.getAttribute('data-name');
                            document.getElementById('editDescription').value = btn.getAttribute('data-description') || '';
                        });
                    }

                    // Delete modal population
                    const deleteModal = document.getElementById('deleteModal');
                    if (deleteModal) {
                        deleteModal.addEventListener('show.bs.modal', function (event) {
                            const btn = event.relatedTarget;
                            document.getElementById('deleteId').value = btn.getAttribute('data-id');
                            document.getElementById('deleteName').textContent = btn.getAttribute('data-name');
                        });
                    }
                });

                // Form submission handling
                document.addEventListener('DOMContentLoaded', function () {
                    const createForm = document.querySelector('#createModal form');
                    if (createForm) {
                        createForm.addEventListener('submit', function (e) {
                            const name = this.querySelector('input[name="name"]').value.trim();

                            if (!name) {
                                e.preventDefault();
                                // Please enter genre name
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

                // Auto-capitalize genre names
                document.addEventListener('DOMContentLoaded', function () {
                    const nameInputs = document.querySelectorAll('input[name="name"]');
                    nameInputs.forEach(input => {
                        input.addEventListener('input', function () {
                            const value = this.value;
                            if (value.length > 0) {
                                this.value = value.charAt(0).toUpperCase() + value.slice(1).toLowerCase();
                            }
                        });
                    });
                });
            </script>

            <style>
                /* Custom styles for genre management */
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

                /* Badge styling */
                .badge {
                    font-size: 0.875em;
                    padding: 0.5em 0.75em;
                }

                .badge.bg-primary {
                    background-color: #0d6efd !important;
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

                /* Responsive adjustments */
                @media (max-width: 768px) {
                    .table-responsive {
                        font-size: 0.875rem;
                    }

                    .badge {
                        font-size: 0.75em;
                        padding: 0.375em 0.5em;
                    }
                }

                /* Genre name styling */
                .fw-bold .badge {
                    font-weight: 600;
                }
            </style>