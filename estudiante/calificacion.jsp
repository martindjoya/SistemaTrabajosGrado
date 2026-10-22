<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Mi calificacion"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_idea, a.titulo, a.estado, a.calificacion, a.observaciones_director, a.observaciones_evaluador,
           DATE_FORMAT(a.fecha_aprob_director, '%d/%m/%Y %H:%i') AS fecha_aprob_director,
           DATE_FORMAT(a.fecha_aprob_evaluador, '%d/%m/%Y %H:%i') AS fecha_aprob_evaluador
    FROM anteproyectos a
    WHERE a.id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/estudiante/ideas.jsp">
        <c:param name="error" value="Primero debe seleccionar una idea de proyecto."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<sql:query var="idea" dataSource="${bd}">
    SELECT titulo, descripcion
    FROM ideas
    WHERE id_idea = ?
    <sql:param value="${p.id_idea}"/>
</sql:query>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Calificacion del anteproyecto</h1>
<div class="idea-original">
    <span class="documento-etiqueta">Datos de la idea seleccionada:</span>
    <h2><c:out value="${idea.rows[0].titulo}"/></h2>
    <p><c:out value="${idea.rows[0].descripcion}"/></p>
</div>

<div class="anteproyecto-dato">
    <span>Título de tu anteproyecto</span>
    <strong><c:out value="${empty p.titulo ? 'Pendiente de completar' : p.titulo}"/></strong>
</div>

<div class="rejilla-tarjetas">
    <div class="tarjeta">
        <p>Calificacion</p>
        <c:choose>
            <c:when test="${empty p.calificacion}">
                <h3>Sin calificar</h3>
            </c:when>
            <c:otherwise>
                <div class="numero"><fmt:formatNumber value="${p.calificacion}" pattern="0.0"/> / 5.0</div>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="tarjeta">
        <p>Estado</p>
        <span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span>
    </div>
</div>

<div class="panel" style="margin-top:1.4rem;">
    <h3>Observaciones</h3>
    <dl class="ficha">
        <dt>Director</dt>
        <dd><c:out value="${empty p.observaciones_director ? 'Sin observaciones' : p.observaciones_director}"/></dd>
        <dt>Evaluador</dt>
        <dd><c:out value="${empty p.observaciones_evaluador ? 'Sin observaciones' : p.observaciones_evaluador}"/></dd>
        <dt>Aprobado por director</dt>
        <dd>
            <c:choose>
                <c:when test="${empty p.fecha_aprob_director}">Pendiente</c:when>
                <c:otherwise><c:out value="${p.fecha_aprob_director}"/></c:otherwise>
            </c:choose>
        </dd>
        <dt>Aprobado por evaluador</dt>
        <dd>
            <c:choose>
                <c:when test="${empty p.fecha_aprob_evaluador}">Pendiente</c:when>
                <c:otherwise><c:out value="${p.fecha_aprob_evaluador}"/></c:otherwise>
            </c:choose>
        </dd>
    </dl>
</div>

<div class="acciones">
    <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto.jsp">Volver a mi anteproyecto</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
