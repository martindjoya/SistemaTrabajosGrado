<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Nueva idea"/>
<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Nueva idea de anteproyecto</h1>
<p class="subtitulo">Los campos con * son obligatorios.</p>

<form class="formulario" action="${ctx}/coordinacion/procesar-idea-nueva.jsp" method="post">
    <div class="campo">
        <label for="titulo">Titulo *</label>
        <input type="text" id="titulo" name="titulo" maxlength="150" value="${fn:escapeXml(param.titulo)}" required>
        <div class="ayuda">Entre 5 y 150 caracteres.</div>
    </div>
    <div class="campo">
        <label for="descripcion">Descripcion *</label>
        <textarea id="descripcion" name="descripcion" required>${fn:escapeXml(param.descripcion)}</textarea>
        <div class="ayuda">Minimo 10 caracteres.</div>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Guardar idea</button>
        <a class="btn btn-secundario" href="${ctx}/coordinacion/ideas.jsp">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>