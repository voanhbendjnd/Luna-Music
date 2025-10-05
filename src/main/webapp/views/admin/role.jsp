<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-lg-10 col-xl-8">
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas fa-user-tag me-1"></i>
                        Role Management
                    </div>
                    <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="list" />
                        <input type="hidden" name="type" value="roles" />
                        <input class="form-control" type="search" name="q"
                            value="${requestScope.q == null ? '' : requestScope.q}" placeholder="Search by role name" />
                        <button class="btn btn-primary ms-2" type="submit">Search</button>
                    </form>
                </div>
                <div class="card-body">
                    <div class="mb-3 text-end">
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createRoleModal">
                            <i class="fas fa-plus me-1"></i>Add Role
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="roleTable" class="table table-striped align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Role Name</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="role" items="${requestScope.roles}">
                                    <tr>
                                        <td><c:out value="${role.id}" /></td>
                                        <td>
                                            <span class="badge bg-primary fs-6">
                                                <c:out value="${role.name}" />
                                            </span>
                                        </td>
                                        <td><c:out value="${role.description}" /></td>
                                        <td>
                                            <span class="badge ${role.active ? 'bg-success' : 'bg-secondary'}">
                                                ${role.active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1" data-bs-toggle="modal"
                                                data-bs-target="#editRoleModal" data-id="${role.id}" 
                                                data-name="${role.name}" data-description="${role.description}"
                                                data-active="${role.active}">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal"
                                                data-bs-target="#deleteRoleModal" data-id="${role.id}"
                                                data-name="${role.name}">
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
</div>

<!-- CREATE ROLE MODAL -->
<div class="modal fade" id="createRoleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle me-2"></i>Add New Role
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="createRole" />
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">
                                <i class="fas fa-tag me-1"></i>Role Name
                            </label>
                            <input required name="name" class="form-control form-control-lg" 
                                placeholder="Enter role name" />
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="active" id="createRoleActive" checked>
                                <label class="form-check-label fw-bold" for="createRoleActive">
                                    <i class="fas fa-toggle-on me-1"></i>Active Status
                                </label>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">
                                <i class="fas fa-align-left me-1"></i>Description
                            </label>
                            <textarea name="description" class="form-control" rows="3" 
                                placeholder="Enter role description"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-1"></i>Create Role
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- EDIT ROLE MODAL -->
<div class="modal fade" id="editRoleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Edit Role
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="updateRole" />
                <input type="hidden" name="id" id="editRoleId" />
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">
                                <i class="fas fa-tag me-1"></i>Role Name
                            </label>
                            <input required name="name" id="editRoleName" class="form-control form-control-lg" />
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="active" id="editRoleActive">
                                <label class="form-check-label fw-bold" for="editRoleActive">
                                    <i class="fas fa-toggle-on me-1"></i>Active Status
                                </label>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">
                                <i class="fas fa-align-left me-1"></i>Description
                            </label>
                            <textarea name="description" id="editRoleDescription" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i>Update Role
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- DELETE ROLE MODAL -->
<div class="modal fade" id="deleteRoleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle me-2"></i>Delete Role
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="deleteRole" />
                <input type="hidden" name="id" id="deleteRoleId" />
                <div class="modal-body">
                    <div class="alert alert-warning d-flex align-items-center" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <div>
                            Are you sure you want to delete the role: <strong id="deleteRoleName"></strong>?
                            <br><small class="text-muted">This action cannot be undone.</small>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash me-1"></i>Delete Role
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // DataTables init for role table
    window.addEventListener('DOMContentLoaded', () => {
        const table = document.getElementById('roleTable');
        if (table && window.simpleDatatables) {
            new simpleDatatables.DataTable(table, {
                searchable: true,
                sortable: true,
                perPage: 10,
                perPageSelect: [5, 10, 15, 20]
            });
        }
    });

    // Modal population for edit role
    document.addEventListener('DOMContentLoaded', function () {
        const editRoleModal = document.getElementById('editRoleModal');
        if (editRoleModal) {
            editRoleModal.addEventListener('show.bs.modal', function (event) {
                const btn = event.relatedTarget;
                document.getElementById('editRoleId').value = btn.getAttribute('data-id');
                document.getElementById('editRoleName').value = btn.getAttribute('data-name');
                document.getElementById('editRoleDescription').value = btn.getAttribute('data-description') || '';
                const active = btn.getAttribute('data-active') === 'true';
                document.getElementById('editRoleActive').checked = active;
            });
        }

        const deleteRoleModal = document.getElementById('deleteRoleModal');
        if (deleteRoleModal) {
            deleteRoleModal.addEventListener('show.bs.modal', function (event) {
                const btn = event.relatedTarget;
                document.getElementById('deleteRoleId').value = btn.getAttribute('data-id');
                document.getElementById('deleteRoleName').textContent = btn.getAttribute('data-name');
            });
        }
    });
</script>
