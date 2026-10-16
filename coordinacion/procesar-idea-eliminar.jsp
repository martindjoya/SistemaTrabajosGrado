<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>

<c:if test="${pageContext.request.method != 'POST' or empty param.id}">
    <c:redirect url="/coordinacion/ideas.jsp"/>
</c:if>

<c:catch var="err">
    <sql:update dataSource="${bd}">
        DELETE FROM ideas WHERE id_idea = ?
        <sql:param value="${param.id}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty err}">
    <c:redirect url="/coordinacion/ideas.jsp">
        <c:param name="error" value="No se puede eliminar: la idea esta asignada a un anteproyecto."/>
    </c:redirect>
</c:if>

<c:redirect url="/coordinacion/ideas.jsp">
    <c:param name="ok" value="Idea eliminada correctamente."/>
</c:redirect>