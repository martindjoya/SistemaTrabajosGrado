<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Eliminar idea"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT id_idea, titulo, descripcion, estado FROM ideas WHERE id_idea = ?
    <sql:param value="${empty param.id ? 0 : param.id}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/coordinacion/ideas.jsp">
        <c:param name="error" value="La idea no existe."/>
    </c:redirect>
</c:if>

<c:set var="u" value="${rs.rows[0]}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Eliminar idea</h1>
<p class="subtitulo">Esta accion no se puede deshacer.</p>

<div class="formulario">
    <div class="datos-resumen">
        <p><strong>Titulo:</strong> <c:out value="${u.titulo}"/></p>
        <p><strong>Descripcion:</strong> <c:out value="${u.descripcion}"/></p>
        <p><strong>Estado:</strong> <c:out value="${u.estado}"/></p>
    </div>

    <form action="${ctx}/coordinacion/procesar-idea-eliminar.jsp" method="post">
        <input type="hidden" name="id" value="${u.id_idea}">
        <div class="acciones">
            <button type="submit" class="btn btn-peligro">Si, eliminar</button>
            <a class="btn btn-secundario" href="${ctx}/coordinacion/ideas.jsp">Cancelar</a>
        </div>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>