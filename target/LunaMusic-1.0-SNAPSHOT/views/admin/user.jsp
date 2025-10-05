<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-lg-10 col-xl-8">
            <div class="card mb-4 shadow-sm">
            <div class="card-header d-flex justify-content-between align-items-center bg-primary text-white">
                <div>
                    <i class="fas fa-users me-2"></i>
                    <span class="fw-bold fs-5">User Management</span>
                </div>
                <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin">
                    <input type="hidden" name="action" value="list" />
                    <input type="hidden" name="type" value="users" />
                    <input class="form-control" type="search" name="q"
                        value="${requestScope.q == null ? '' : requestScope.q}" placeholder="Search by name/email" />
                    <button class="btn btn-primary ms-2" type="submit">Search</button>
                </form>
            </div>
            <div class="card-body">
                <div class="mb-3 text-end">
                    <button class="btn btn-success btn-lg" data-bs-toggle="modal" data-bs-target="#createModal">
                        <i class="fas fa-user-plus me-2"></i>Add New User
                    </button>
                </div>
                <div class="table-responsive">
                    <table id="datatablesSimple" class="table table-striped align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th><i class="fas fa-hashtag me-1"></i>ID</th>
                                <th><i class="fas fa-user me-1"></i>Name</th>
                                <th><i class="fas fa-envelope me-1"></i>Email</th>
                                <th><i class="fas fa-venus-mars me-1"></i>Gender</th>
                                <th><i class="fas fa-user-tag me-1"></i>Role</th>
                                <th><i class="fas fa-toggle-on me-1"></i>Status</th>
                                <th><i class="fas fa-cogs me-1"></i>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${requestScope.users}">
                                <tr>
                                    <td>
                                        <c:out value="${u.id}" />
                                    </td>
                                    <td>
                                        <c:out value="${u.name}" />
                                    </td>
                                    <td>
                                        <c:out value="${u.email}" />
                                    </td>
                                    <td>
                                        <c:out value="${u.gender}" />
                                    </td>
                                    <td>
                                        <span class="badge bg-info">
                                            <c:out value="${u.role.name}" />
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${u.active ? 'bg-success' : 'bg-secondary'}">${u.active ?
                                            'Active' : 'Inactive'}</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary me-1" data-bs-toggle="modal"
                                            data-bs-target="#editModal" data-id="${u.id}" data-name="${u.name}"
                                            data-email="${u.email}" data-gender="${u.gender}" data-role="${u.role}"
                                            data-active="${u.active}">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal"
                                            data-bs-target="#deleteModal" data-id="${u.id}"
                                            data-name="${u.name}">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
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

        <!-- CREATE MODAL -->
        <div class="modal fade" id="createModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-user-plus me-2"></i>Add New User
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="create" />
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-user me-1"></i>Full Name
                                    </label>
                                    <input required name="name" class="form-control form-control-lg" 
                                        placeholder="Enter full name" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-envelope me-1"></i>Email Address
                                    </label>
                                    <input required type="email" name="email" class="form-control form-control-lg" 
                                        placeholder="Enter email address" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-lock me-1"></i>Password
                                    </label>
                                    <input required type="password" name="password" class="form-control form-control-lg" 
                                        placeholder="Enter password" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-venus-mars me-1"></i>Gender
                                    </label>
                                    <select class="form-select form-select-lg" name="gender">
                                        <option value="">-- Select Gender --</option>
                                        <option value="MALE">Male</option>
                                        <option value="FEMALE">Female</option>
                                        <option value="OTHER">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-user-tag me-1"></i>Role
                                    </label>
                                    <select class="form-select form-select-lg" name="role">
                                        <option value="">-- Select Role --</option>
                                        <c:forEach var="role" items="${requestScope.roles}">
                                            <option value="${role.id}">${role.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 d-flex align-items-end">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" name="active" id="createActive" checked>
                                        <label class="form-check-label fw-bold" for="createActive">
                                            <i class="fas fa-toggle-on me-1"></i>Active Status
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-1"></i>Create User
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
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-user-edit me-2"></i>Edit User
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" id="editId" />
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-user me-1"></i>Full Name
                                    </label>
                                    <input required name="name" id="editName" class="form-control form-control-lg" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-envelope me-1"></i>Email Address
                                    </label>
                                    <input required type="email" name="email" id="editEmail" class="form-control form-control-lg" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-lock me-1"></i>Password
                                    </label>
                                    <input type="password" name="password" id="editPassword" class="form-control form-control-lg" 
                                        placeholder="Leave blank to keep current password" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-venus-mars me-1"></i>Gender
                                    </label>
                                    <select class="form-select form-select-lg" name="gender" id="editGender">
                                        <option value="">-- Select Gender --</option>
                                        <option value="MALE">Male</option>
                                        <option value="FEMALE">Female</option>
                                        <option value="OTHER">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-user-tag me-1"></i>Role
                                    </label>
                                    <select class="form-select form-select-lg" name="role" id="editRole">
                                        <option value="">-- Select Role --</option>
                                        <c:forEach var="role" items="${requestScope.roles}">
                                            <option value="${role.id}">${role.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 d-flex align-items-end">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" name="active" id="editActive">
                                        <label class="form-check-label fw-bold" for="editActive">
                                            <i class="fas fa-toggle-on me-1"></i>Active Status
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Update User
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
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle me-2"></i>Delete User
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="delete" />
                        <input type="hidden" name="id" id="deleteId" />
                        <div class="modal-body">
                            <div class="alert alert-warning d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <div>
                                    Are you sure you want to delete user: <strong id="deleteName"></strong>?
                                    <br><small class="text-muted">This action cannot be undone.</small>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>Cancel
                            </button>
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash me-1"></i>Delete User
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // DataTables init specific to user page
            window.addEventListener('DOMContentLoaded', () => {
                const table = document.getElementById('datatablesSimple');
                if (table && window.simpleDatatables) {
                    new simpleDatatables.DataTable(table);
                }
            });

            // Modal population
            document.addEventListener('DOMContentLoaded', function () {
                const editModal = document.getElementById('editModal');
                if (editModal) {
                    editModal.addEventListener('show.bs.modal', function (event) {
                        const btn = event.relatedTarget;
                        document.getElementById('editId').value = btn.getAttribute('data-id');
                        document.getElementById('editName').value = btn.getAttribute('data-name');
                        document.getElementById('editEmail').value = btn.getAttribute('data-email');
                        document.getElementById('editPassword').value = '';
                        const gender = btn.getAttribute('data-gender') || '';
                        document.getElementById('editGender').value = gender;
                        const role = btn.getAttribute('data-role') || '';
                        document.getElementById('editRole').value = role;
                        const active = btn.getAttribute('data-active') === 'true';
                        document.getElementById('editActive').checked = active;
                    });
                }

                const deleteModal = document.getElementById('deleteModal');
                if (deleteModal) {
                    deleteModal.addEventListener('show.bs.modal', function (event) {
                        const btn = event.relatedTarget;
                        document.getElementById('deleteId').value = btn.getAttribute('data-id');
                        document.getElementById('deleteName').textContent = btn.getAttribute('data-name');
                    });
                }
            });
        </script>