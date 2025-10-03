<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Đang phát triển
        </div>
        <div class="card-body">
            <p>Module quản lý "<strong>
                    <%= request.getAttribute("viewTitle")==null ? "" : request.getAttribute("viewTitle") %>
                </strong>" đang được phát triển. Vui lòng chọn mục khác hoặc quay lại sau.</p>
        </div>
    </div>