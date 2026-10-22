<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-director.jspf" %>
<c:set var="titulo" value="Aprobar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, a.titulo AS titulo_ante, a.resumen, a.archivo,
           a.calificacion, a.observaciones_director,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           i.titulo AS idea,
           u.nombres, u.apellidos, e.codigo, e.programa
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    INNER JOIN usuarios u ON u.id_usuario = a.id_estudiante
    INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
    WHERE a.id_anteproyecto = ? AND a.id_director = ? AND a.estado = 'Enviado'
    <sql:param value="${empty param.id ? 0 : param.id}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/director/anteproyectos.jsp">
        <c:param name="error" value="El anteproyecto no existe, no esta a su cargo o ya no puede aprobarse."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="documentoExterno" value="${not empty p.archivo and (fn:startsWith(fn:toLowerCase(p.archivo), 'https://') or fn:startsWith(fn:toLowerCase(p.archivo), 'http://'))}"/>
<c:if test="${empty p.calificacion}">
    <c:redirect url="/director/calificar.jsp">
        <c:param name="id" value="${p.id_anteproyecto}"/>
        <c:param name="error" value="Registre la calificacion antes de aprobar el anteproyecto."/>
    </c:redirect>
</c:if>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<section class="revision-hero">
    <div>
        <p class="anteproyecto-eyebrow">CONFIRMACIÓN DEL DIRECTOR</p>
        <h1>Aprobar anteproyecto</h1>
        <p class="anteproyecto-lead"><c:out value="${p.titulo_ante}"/></p>
    </div>
    <div class="revision-hero-acciones">
        <span class="badge badge-enviado">Enviado</span>
        <a class="btn btn-secundario" href="${ctx}/director/anteproyectos.jsp">Volver al listado</a>
    </div>
</section>

<section class="revision-card revision-estudiante">
    <div class="anteproyecto-card-titulo">
        <span class="anteproyecto-icono" aria-hidden="true">01</span>
        <div><h2>Estudiante</h2><p>Autor del anteproyecto</p></div>
    </div>
    <div class="revision-estudiante-datos">
        <div><span>Nombre</span><strong><c:out value="${p.nombres} ${p.apellidos}"/></strong></div>
        <div><span>Código</span><strong><c:out value="${p.codigo}"/></strong></div>
        <div><span>Programa</span><strong><c:out value="${p.programa}"/></strong></div>
    </div>
</section>

<section class="revision-card revision-propuesta revision-aprobar-propuesta">
    <div class="anteproyecto-card-titulo">
        <span class="anteproyecto-icono" aria-hidden="true">02</span>
        <div><h2>Confirma los datos</h2><p>Revisa la propuesta antes de remitirla al evaluador.</p></div>
    </div>
    <div class="revision-idea"><span>IDEA ELEGIDA</span><strong><c:out value="${p.idea}"/></strong></div>
    <div class="anteproyecto-dato">
        <span>Título del anteproyecto</span>
        <strong><c:out value="${p.titulo_ante}"/></strong>
    </div>
    <div class="anteproyecto-dato revision-resumen">
        <span>Resumen</span>
        <p><c:out value="${p.resumen}"/></p>
    </div>
    <div class="revision-aprobacion-datos">
        <div class="anteproyecto-documento">
            <div>
                <span class="documento-etiqueta">DOCUMENTO DEL ANTEPROYECTO</span>
                <strong><c:choose><c:when test="${empty p.archivo}">Sin documento enlazado</c:when><c:otherwise>Documento disponible para revisión</c:otherwise></c:choose></strong>
                <small><c:out value="${empty p.fecha_envio ? 'Fecha de envío pendiente' : p.fecha_envio}"/></small>
            </div>
            <c:if test="${not empty p.archivo}">
                <c:choose>
                    <c:when test="${documentoExterno}"><a class="btn btn-secundario btn-sm" href="<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a></c:when>
                    <c:otherwise><a class="btn btn-secundario btn-sm" href="${ctx}/uploads/<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a></c:otherwise>
                </c:choose>
            </c:if>
        </div>
        <div class="revision-nota">
            <span>CALIFICACIÓN DEL DIRECTOR</span>
            <strong><c:out value="${p.calificacion}"/><small> / 5.0</small></strong>
        </div>
    </div>
    <div class="revision-observaciones">
        <span>OBSERVACIONES DEL DIRECTOR</span>
        <p><c:out value="${empty p.observaciones_director ? 'Sin observaciones registradas.' : p.observaciones_director}"/></p>
    </div>
</section>

<div class="revision-card revision-confirmacion">
    <div>
        <h2>Enviar al evaluador</h2>
        <p>Al confirmar, el anteproyecto pasará a revisión del evaluador y dejará de admitir cambios del estudiante.</p>
    </div>
    <form action="${ctx}/director/procesar-aprobar.jsp" method="post">
        <input type="hidden" name="id" value="${p.id_anteproyecto}">
        <div class="acciones">
            <button type="submit" class="btn btn-primario">Confirmar aprobación</button>
            <a class="btn btn-secundario" href="${ctx}/director/calificar.jsp?id=${p.id_anteproyecto}">Volver a la calificación</a>
        </div>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>