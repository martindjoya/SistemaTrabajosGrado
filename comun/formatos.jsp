<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-sesion.jspf" %>
<c:if test="${sessionScope.id_rol == 1}">
    <c:redirect url="/acceso-denegado.jsp"/>
</c:if>
<c:set var="titulo" value="Formatos de grado"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT nombre, descripcion, archivo FROM formatos_grado ORDER BY nombre
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Formatos de grado</h1>
<p class="subtitulo">Descargue las plantillas oficiales.</p>

<div class="rejilla-tarjetas">
    <c:forEach var="f" items="${rs.rows}">
        <div class="tarjeta">
            <h3><c:out value="${f.nombre}"/></h3>
            <p><c:out value="${f.descripcion}"/></p>
            <div class="acciones">
                <a class="btn btn-primario btn-sm" href="${ctx}/formatos/<c:out value="${f.archivo}"/>" target="_blank">Descargar</a>
            </div>
        </div>
    </c:forEach>
    <c:if test="${rs.rowCount == 0}">
        <p class="vacio">No hay formatos disponibles.</p>
    </c:if>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
