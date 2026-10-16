<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Eliminar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.titulo, a.estado, i.titulo AS idea
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    WHERE a.id_estudiante = ?
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

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Eliminar anteproyecto</h1>
<p class="subtitulo">Esta accion no se puede deshacer. La idea quedara disponible para otros estudiantes.</p>

<div class="formulario">
    <div class="datos-resumen">
        <p><strong>Idea:</strong> <c:out value="${a.idea}"/></p>
        <p><strong>Titulo:</strong> <c:out value="${empty a.titulo ? 'Pendiente' : a.titulo}"/></p>
        <p><strong>Estado:</strong> <c:out value="${a.estado}"/></p>
    </div>

    <form action="${ctx}/estudiante/procesar-anteproyecto-eliminar.jsp" method="post">
        <div class="acciones">
            <button type="submit" class="btn btn-peligro">Si, eliminar</button>
            <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto.jsp">Cancelar</a>
        </div>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>