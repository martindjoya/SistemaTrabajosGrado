<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Editar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_idea, a.titulo, a.resumen, a.archivo, a.estado
    FROM anteproyectos a
    WHERE a.id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/estudiante/ideas.jsp">
        <c:param name="error" value="Primero debe seleccionar una idea de proyecto."/>
    </c:redirect>
</c:if>

<c:set var="a" value="${rs.rows[0]}"/>
<sql:query var="idea" dataSource="${bd}">
    SELECT titulo, descripcion
    FROM ideas
    WHERE id_idea = ?
    <sql:param value="${a.id_idea}"/>
</sql:query>

<c:if test="${a.estado == 'Idea'}">
    <c:redirect url="/estudiante/anteproyecto-subir.jsp"/>
</c:if>
<c:if test="${a.estado != 'Enviado' and a.estado != 'Rechazado'}">
    <c:redirect url="/estudiante/anteproyecto.jsp">
        <c:param name="error" value="El anteproyecto ya fue aprobado y no admite cambios."/>
    </c:redirect>
</c:if>

<c:set var="d" value="${pageContext.request.method == 'POST' ? param : a}"/>
<c:set var="documentoExterno" value="${not empty a.archivo and (fn:startsWith(fn:toLowerCase(a.archivo), 'https://') or fn:startsWith(fn:toLowerCase(a.archivo), 'http://'))}"/>
<c:set var="enlaceDocumento" value="${pageContext.request.method == 'POST' ? param.enlace_documento : a.archivo}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <div>
        <h1>Editar anteproyecto</h1>
        <p class="subtitulo">Actualiza los datos de tu propuesta. Al guardar, el anteproyecto vuelve al estado Enviado.</p>
    </div>
    <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto.jsp">Volver</a>
</div>

<form class="formulario" action="${ctx}/estudiante/procesar-anteproyecto-editar.jsp" method="post">
    <section class="idea-original">
        <span class="documento-etiqueta">Datos de la idea seleccionada:</span>
        <h2><c:out value="${idea.rows[0].titulo}"/></h2>
        <p><c:out value="${idea.rows[0].descripcion}"/></p>
    </section>
    <div class="campo">
        <label for="titulo">Título de tu anteproyecto *</label>
        <input type="text" id="titulo" name="titulo" maxlength="150" value="${fn:escapeXml(d.titulo)}" required>
    </div>
    <div class="campo">
        <label for="resumen">Resumen de tu anteproyecto *</label>
        <textarea id="resumen" name="resumen" required>${fn:escapeXml(d.resumen)}</textarea>
    </div>
    <div class="campo">
        <label for="enlace_documento">Enlace al documento en la nube *</label>
        <input type="url" id="enlace_documento" name="enlace_documento" maxlength="255"
               value="${fn:escapeXml(enlaceDocumento)}"
               placeholder="https://drive.google.com/..." required>
        <div class="ayuda">
            <c:choose>
                <c:when test="${empty a.archivo}">Aún no hay un documento enlazado.</c:when>
                <c:when test="${documentoExterno}">Enlace actual: <a href="<c:out value="${a.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a>.</c:when>
                <c:otherwise>Documento cargado anteriormente: <a href="${ctx}/uploads/<c:out value="${a.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir archivo actual</a>. Reemplázalo con un enlace compartido en la nube.</c:otherwise>
            </c:choose>
            Comprueba que el director y el evaluador tengan permiso para verlo.
        </div>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Guardar cambios</button>
        <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto.jsp">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>