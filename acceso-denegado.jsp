<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<c:set var="titulo" value="Acceso denegado"/>
<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<section class="hero">
    <h1>Acceso denegado</h1>
    <p>No tienes permiso para ver esta pagina.</p>
    <a class="btn btn-primario" href="${ctx}/index.jsp">Volver a mi panel</a>
</section>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>