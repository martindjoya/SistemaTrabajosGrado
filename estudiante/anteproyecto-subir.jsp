<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Completar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.estado, a.id_idea
    FROM anteproyectos a
    WHERE a.id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/estudiante/ideas.jsp">
        <c:param name="error" value="Primero debe seleccionar una idea de proyecto."/>
    </c:redirect>
</c:if>
<c:if test="${rs.rows[0].estado != 'Idea'}">
    <c:redirect url="/estudiante/anteproyecto.jsp">
        <c:param name="error" value="Ya subio su anteproyecto. Use la opcion Editar."/>
    </c:redirect>
</c:if>
<sql:query var="idea" dataSource="${bd}">
    SELECT titulo, descripcion
    FROM ideas
    WHERE id_idea = ?
    <sql:param value="${rs.rows[0].id_idea}"/>
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <div>
        <h1>Completar anteproyecto</h1>
        <p class="subtitulo">Completa el título y resumen de tu propuesta para iniciar la revisión.</p>
    </div>
    <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto.jsp">Volver</a>
</div>

<form class="formulario" action="${ctx}/estudiante/procesar-anteproyecto-subir.jsp" method="post">
    <section class="idea-original">
        <span class="documento-etiqueta">Datos de la idea seleccionada:</span>
        <h2><c:out value="${idea.rows[0].titulo}"/></h2>
        <p><c:out value="${idea.rows[0].descripcion}"/></p>
    </section>
    <div class="campo">
        <label for="titulo">Título de tu anteproyecto *</label>
        <input type="text" id="titulo" name="titulo" maxlength="150" value="${fn:escapeXml(param.titulo)}" required>
        <div class="ayuda">Escribe el título de tu anteproyecto, distinto del título de la idea. Entre 5 y 150 caracteres.</div>
    </div>
    <div class="campo">
        <label for="resumen">Resumen de tu anteproyecto *</label>
        <textarea id="resumen" name="resumen" required>${fn:escapeXml(param.resumen)}</textarea>
        <div class="ayuda">Minimo 20 caracteres.</div>
    </div>
    <div class="campo">
        <label for="enlace_documento">Enlace al documento en la nube *</label>
        <input type="url" id="enlace_documento" name="enlace_documento" maxlength="255"
               placeholder="https://drive.google.com/..." value="${fn:escapeXml(param.enlace_documento)}" required>
        <div class="ayuda">Pega un enlace compartido de Google Drive, OneDrive, Dropbox u otro servicio. Asegúrate de permitir el acceso a quienes revisarán el anteproyecto.</div>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Enviar anteproyecto</button>
        <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto.jsp">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>