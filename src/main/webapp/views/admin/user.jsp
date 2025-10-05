<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas fa-table me-1"></i>
                        User Management
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
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="card-title mb-0">Users</h5>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createModal">
                            <i class="fas fa-plus me-1"></i>Add User
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="datatablesSimple" class="table table-striped table-hover align-middle w-100">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Gender</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Action</th>
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
                                            <div class="btn-group" role="group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                                    data-bs-target="#editModal" data-id="${u.id}" data-name="${u.name}"
                                                    data-email="${u.email}" data-gender="${u.gender}" data-role="${u.role.id}"
                                                    data-active="${u.active}">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal"
                                                    data-bs-target="#deleteModal" data-id="${u.id}"
                                                    data-name="${u.name}">
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
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add User</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="create" />
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Name</label>
                                <input required name="name" class="form-control" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input required type="email" name="email" class="form-control" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input required type="password" name="password" class="form-control" />
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Gender</label>
                                    <select class="form-select" name="gender">
                                        <option value="">--</option>
                                        <option value="MALE">Male</option>
                                        <option value="FEMALE">Female</option>
                                        <option value="OTHER">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6 d-flex align-items-end">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="active" id="createActive">
                                        <label class="form-check-label" for="createActive">Active</label>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Role</label>
                                    <select class="form-select" name="role">
                                        <option value="">-- Select Role --</option>
                                        <c:forEach var="role" items="${requestScope.roles}">
                                            <option value="${role.id}">${role.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save</button>
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
                        <h5 class="modal-title">Edit User</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" id="editId" />
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Name</label>
                                <input required name="name" id="editName" class="form-control" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input required type="email" name="email" id="editEmail" class="form-control" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" id="editPassword" class="form-control" />
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Gender</label>
                                    <select class="form-select" name="gender" id="editGender">
                                        <option value="">--</option>
                                        <option value="MALE">Male</option>
                                        <option value="FEMALE">Female</option>
                                        <option value="OTHER">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6 d-flex align-items-end">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="active" id="editActive">
                                        <label class="form-check-label" for="editActive">Active</label>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Role</label>
                                    <select class="form-select" name="role" id="editRole">
                                        <option value="">-- Select Role --</option>
                                        <c:forEach var="role" items="${requestScope.roles}">
                                            <option value="${role.id}">${role.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save</button>
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
                        <h5 class="modal-title">Delete User</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="delete" />
                        <input type="hidden" name="id" id="deleteId" />
                        <div class="modal-body">
                            <p>Are you sure you want to delete user: <strong id="deleteName"></strong>?</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-danger">Delete</button>
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