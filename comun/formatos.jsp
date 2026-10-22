<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-sesion.jspf" %>
<c:set var="titulo" value="Formatos de grado"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT nombre, descripcion, archivo FROM formatos_grado ORDER BY nombre
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Formatos de grado</h1>
<p class="subtitulo">Descargue las plantillas oficiales.</p>
<p class="acciones">
    <a class="btn btn-primario" href="https://www.dropbox.com/scl/fo/pudgcaq639agy7t06ahjs/AN084HnuyHffgYL5i--v_Ks/DOCUMENTOS%20DE%20GRADO?dl=0&amp;rlkey=6s0b9ajweteyx2ang7ywvk6xm&amp;subfolder_nav_tracking=1" target="_blank" rel="noopener noreferrer">Ver formatos de grado en Dropbox</a>
</p>

<div class="rejilla-tarjetas">
    <c:forEach var="f" items="${rs.rows}">
        <div class="tarjeta">
            <h3><c:out value="${f.nombre}"/></h3>
            <p><c:out value="${f.descripcion}"/></p>
        </div>
    </c:forEach>
    <c:if test="${rs.rowCount == 0}">
        <p class="vacio">No hay formatos disponibles.</p>
    </c:if>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
