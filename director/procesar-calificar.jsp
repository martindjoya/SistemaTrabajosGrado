<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-director.jspf" %>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/director/anteproyectos.jsp"/>
</c:if>

<c:set var="errorValidacion" value=""/>
<c:choose>
    <c:when test="${empty param.id or empty param.calificacion or empty fn:trim(param.observaciones)}">
        <c:set var="errorValidacion" value="Complete la calificacion y las observaciones."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.observaciones)) lt 10}">
        <c:set var="errorValidacion" value="Las observaciones deben tener minimo 10 caracteres."/>
    </c:when>
    <c:otherwise>
        <c:catch var="errorNota">
            <fmt:parseNumber var="nota" value="${param.calificacion}" parseLocale="en_US"/>
        </c:catch>
        <c:if test="${not empty errorNota}">
            <c:set var="errorValidacion" value="Ingrese una calificacion numerica valida entre 0.0 y 5.0."/>
        </c:if>
    </c:otherwise>
</c:choose>

<c:if test="${empty errorValidacion and (nota lt 0 or nota gt 5)}">
    <c:set var="errorValidacion" value="La calificacion debe estar entre 0.0 y 5.0."/>
</c:if>
<c:if test="${empty errorValidacion}">
    <fmt:setLocale value="en_US"/>
    <fmt:formatNumber var="notaUnaDecimal" value="${nota}" pattern="0.0"/>
    <c:if test="${nota != notaUnaDecimal}">
        <c:set var="errorValidacion" value="La calificacion solo puede tener un decimal."/>
    </c:if>
</c:if>

<c:if test="${not empty errorValidacion}">
    <jsp:forward page="/director/calificar.jsp">
        <jsp:param name="id" value="${param.id}"/>
        <jsp:param name="calificacion" value="${param.calificacion}"/>
        <jsp:param name="observaciones" value="${param.observaciones}"/>
        <jsp:param name="error" value="${errorValidacion}"/>
    </jsp:forward>
</c:if>

<c:catch var="errorGuardar">
    <sql:update var="actualizados" dataSource="${bd}">
        UPDATE anteproyectos
        SET calificacion = ?, observaciones_director = ?
        WHERE id_anteproyecto = ? AND id_director = ? AND estado = 'Enviado'
        <sql:param value="${nota}"/>
        <sql:param value="${fn:trim(param.observaciones)}"/>
        <sql:param value="${param.id}"/>
        <sql:param value="${sessionScope.id_usuario}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty errorGuardar}">
    <jsp:forward page="/director/calificar.jsp">
        <jsp:param name="id" value="${param.id}"/>
        <jsp:param name="calificacion" value="${param.calificacion}"/>
        <jsp:param name="observaciones" value="${param.observaciones}"/>
        <jsp:param name="error" value="No se pudo guardar la calificacion. Intente de nuevo."/>
    </jsp:forward>
</c:if>

<c:if test="${actualizados == 0}">
    <sql:query var="vigente" dataSource="${bd}">
        SELECT id_anteproyecto
        FROM anteproyectos
        WHERE id_anteproyecto = ? AND id_director = ? AND estado = 'Enviado'
        <sql:param value="${param.id}"/>
        <sql:param value="${sessionScope.id_usuario}"/>
    </sql:query>
    <c:if test="${vigente.rowCount == 0}">
        <c:redirect url="/director/anteproyectos.jsp">
            <c:param name="error" value="El anteproyecto no existe, no esta a su cargo o ya no admite cambios."/>
        </c:redirect>
    </c:if>
</c:if>

<c:redirect url="/director/calificar.jsp">
    <c:param name="id" value="${param.id}"/>
    <c:param name="ok" value="Calificacion guardada correctamente. Ya puede aprobar el anteproyecto."/>
</c:redirect>