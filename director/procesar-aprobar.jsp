<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-director.jspf" %>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/director/anteproyectos.jsp"/>
</c:if>

<c:if test="${empty param.id}">
    <c:redirect url="/director/anteproyectos.jsp">
        <c:param name="error" value="Seleccione un anteproyecto valido para aprobar."/>
    </c:redirect>
</c:if>

<c:catch var="errorAprobar">
    <sql:update var="actualizados" dataSource="${bd}">
        UPDATE anteproyectos
        SET estado = 'Aprobado por director', fecha_aprob_director = NOW()
        WHERE id_anteproyecto = ? AND id_director = ? AND estado = 'Enviado'
          AND calificacion IS NOT NULL
        <sql:param value="${param.id}"/>
        <sql:param value="${sessionScope.id_usuario}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty errorAprobar}">
    <c:redirect url="/director/anteproyectos.jsp">
        <c:param name="error" value="No se pudo aprobar el anteproyecto. Intente de nuevo."/>
    </c:redirect>
</c:if>

<c:if test="${actualizados == 0}">
    <c:redirect url="/director/anteproyectos.jsp">
        <c:param name="error" value="El anteproyecto no existe, no esta a su cargo, no tiene calificacion o ya fue procesado."/>
    </c:redirect>
</c:if>

<c:redirect url="/director/anteproyectos.jsp">
    <c:param name="ok" value="Anteproyecto aprobado y enviado al evaluador."/>
</c:redirect>