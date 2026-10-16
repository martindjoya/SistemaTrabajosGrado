<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>

<c:if test="${pageContext.request.method != 'POST' or empty param.id_idea}">
    <c:redirect url="/estudiante/ideas.jsp"/>
</c:if>

<sql:query var="mio" dataSource="${bd}">
    SELECT COUNT(*) AS n FROM anteproyectos WHERE id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>
<c:if test="${mio.rows[0].n > 0}">
    <c:redirect url="/estudiante/anteproyecto.jsp">
        <c:param name="error" value="Ya selecciono una idea de proyecto."/>
    </c:redirect>
</c:if>

<c:catch var="err">
    <sql:transaction dataSource="${bd}">
        <sql:update var="n">
            UPDATE ideas SET estado = 'Ocupada' WHERE id_idea = ? AND estado = 'Disponible'
            <sql:param value="${param.id_idea}"/>
        </sql:update>
        <c:if test="${n == 1}">
            <sql:update>
                INSERT INTO anteproyectos (id_estudiante, id_idea) VALUES (?, ?)
                <sql:param value="${sessionScope.id_usuario}"/>
                <sql:param value="${param.id_idea}"/>
            </sql:update>
        </c:if>
    </sql:transaction>
</c:catch>

<c:if test="${not empty err or empty n or n != 1}">
    <c:redirect url="/estudiante/ideas.jsp">
        <c:param name="error" value="No se pudo seleccionar la idea. Puede que otro estudiante ya la tomara."/>
    </c:redirect>
</c:if>

<c:redirect url="/estudiante/anteproyecto.jsp">
    <c:param name="ok" value="Idea seleccionada correctamente. Ahora suba su anteproyecto."/>
</c:redirect>