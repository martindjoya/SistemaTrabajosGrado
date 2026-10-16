<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<c:if test="${not empty sessionScope.id_usuario}">
    <%@ include file="/WEB-INF/jspf/redirigir-rol.jspf" %>
</c:if>
<c:set var="titulo" value="Inicio"/>
<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<section class="hero">
    <h1>Gestion de Trabajos de Grado</h1>
    <p>Del anteproyecto a la entrega final: almacena, organiza y haz seguimiento a cada trabajo en un solo lugar.</p>
    <a class="btn btn-primario" href="${ctx}/login.jsp">Iniciar sesion</a>
</section>

<div class="rejilla-tarjetas">
    <div class="tarjeta">
        <h3>Organiza</h3>
        <p>Ideas, anteproyectos y documentos centralizados por estudiante.</p>
    </div>
    <div class="tarjeta">
        <h3>Evalua</h3>
        <p>Flujo de revision entre director y evaluador con observaciones.</p>
    </div>
    <div class="tarjeta">
        <h3>Consulta</h3>
        <p>Estado del proyecto, calificaciones, calendario y formatos de grado.</p>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>