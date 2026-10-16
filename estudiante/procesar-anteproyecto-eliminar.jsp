<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/estudiante/anteproyecto.jsp"/>
</c:if>

<sql:query var="rs" dataSource="${bd}">
    SELECT id_anteproyecto, id_idea, estado FROM anteproyectos WHERE id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/estudiante/ideas.jsp"/>
</c:if>

<c:set var="a" value="${rs.rows[0]}"/>

<c:if test="${a.estado != 'Idea' and a.estado != 'Enviado' and a.estado != 'Rechazado'}">
    <c:redirect url="/estudiante/anteproyecto.jsp">
        <c:param name="error" value="El anteproyecto ya fue aprobado y no se puede eliminar."/>
    </c:redirect>
</c:if>

<c:catch var="err">
    <sql:transaction dataSource="${bd}">
        <sql:update>
            DELETE FROM anteproyectos WHERE id_anteproyecto = ? AND id_estudiante = ?
            <sql:param value="${a.id_anteproyecto}"/>
            <sql:param value="${sessionScope.id_usuario}"/>
        </sql:update>
        <sql:update>
            UPDATE ideas SET estado = 'Disponible' WHERE id_idea = ?
            <sql:param value="${a.id_idea}"/>
        </sql:update>
    </sql:transaction>
</c:catch>

<c:if test="${not empty err}">
    <c:redirect url="/estudiante/anteproyecto.jsp">
        <c:param name="error" value="No se pudo eliminar el anteproyecto. Intente de nuevo."/>
    </c:redirect>
</c:if>

<c:redirect url="/estudiante/ideas.jsp">
    <c:param name="ok" value="Anteproyecto eliminado. Puede seleccionar una nueva idea."/>
</c:redirect>