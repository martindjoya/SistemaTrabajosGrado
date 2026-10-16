<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Editar idea"/>

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
<c:set var="d" value="${pageContext.request.method == 'POST' ? param : u}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Editar idea</h1>
<p class="subtitulo">Los campos con * son obligatorios.</p>

<form class="formulario" action="${ctx}/coordinacion/procesar-idea-editar.jsp" method="post">
    <input type="hidden" name="id" value="${u.id_idea}">

    <div class="campo">
        <label for="titulo">Titulo *</label>
        <input type="text" id="titulo" name="titulo" maxlength="150" value="${fn:escapeXml(d.titulo)}" required>
    </div>
    <div class="campo">
        <label for="descripcion">Descripcion *</label>
        <textarea id="descripcion" name="descripcion" required>${fn:escapeXml(d.descripcion)}</textarea>
    </div>
    <div class="campo">
        <label for="estado">Estado *</label>
        <select id="estado" name="estado" required>
            <option value="Disponible" ${d.estado == 'Disponible' ? 'selected' : ''}>Disponible</option>
            <option value="Ocupada" ${d.estado == 'Ocupada' ? 'selected' : ''}>Ocupada</option>
        </select>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Guardar cambios</button>
        <a class="btn btn-secundario" href="${ctx}/coordinacion/ideas.jsp">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>