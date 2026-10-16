<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Subir anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.estado, i.titulo AS idea
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
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

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Subir anteproyecto</h1>
<p class="subtitulo">Idea elegida: <c:out value="${rs.rows[0].idea}"/></p>

<form class="formulario" action="${ctx}/estudiante/procesar-anteproyecto-subir.jsp" method="post" enctype="multipart/form-data">
    <div class="campo">
        <label for="titulo">Titulo del anteproyecto *</label>
        <input type="text" id="titulo" name="titulo" maxlength="150" value="${fn:escapeXml(param.titulo)}" required>
        <div class="ayuda">Entre 5 y 150 caracteres.</div>
    </div>
    <div class="campo">
        <label for="resumen">Resumen *</label>
        <textarea id="resumen" name="resumen" required>${fn:escapeXml(param.resumen)}</textarea>
        <div class="ayuda">Minimo 20 caracteres.</div>
    </div>
    <div class="campo">
        <label for="archivo">Documento *</label>
        <input type="file" id="archivo" name="archivo" accept=".pdf,.doc,.docx" required>
        <div class="ayuda">Formatos permitidos: PDF o Word. Maximo 5 MB.</div>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Enviar anteproyecto</button>
        <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto.jsp">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>