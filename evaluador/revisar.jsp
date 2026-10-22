<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-evaluador.jspf" %>
<c:set var="titulo" value="Revisar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, a.titulo AS titulo_ante, a.resumen, a.archivo, a.estado,
           a.calificacion, a.observaciones_director, a.observaciones_evaluador,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           DATE_FORMAT(a.fecha_aprob_director, '%d/%m/%Y %H:%i') AS fecha_aprob_director,
           DATE_FORMAT(a.fecha_aprob_evaluador, '%d/%m/%Y %H:%i') AS fecha_aprob_evaluador,
           i.titulo AS idea,
           u.nombres, u.apellidos, u.correo, e.codigo, e.programa,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    INNER JOIN usuarios u ON u.id_usuario = a.id_estudiante
    INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
    LEFT JOIN usuarios ud ON ud.id_usuario = a.id_director
    WHERE a.id_anteproyecto = ? AND a.id_evaluador = ?
      AND a.estado IN ('Aprobado por director', 'Aprobado por evaluador', 'Rechazado')
    <sql:param value="${empty param.id ? 0 : param.id}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/evaluador/anteproyectos.jsp">
        <c:param name="error" value="El anteproyecto no existe o no esta a su cargo."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="documentoExterno" value="${not empty p.archivo and (fn:startsWith(fn:toLowerCase(p.archivo), 'https://') or fn:startsWith(fn:toLowerCase(p.archivo), 'http://'))}"/>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<section class="revision-hero">
    <div>
        <p class="anteproyecto-eyebrow">REVISIÓN DEL EVALUADOR</p>
        <h1>Anteproyecto</h1>
        <p class="anteproyecto-lead"><c:out value="${p.titulo_ante}"/></p>
    </div>
    <div class="revision-hero-acciones">
        <span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span>
        <a class="btn btn-secundario" href="${ctx}/evaluador/anteproyectos.jsp">Volver al listado</a>
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
        <div><span>Contacto</span><a href="mailto:<c:out value="${p.correo}"/>"><c:out value="${p.correo}"/></a></div>
    </div>
</section>

<div class="revision-columnas">
    <section class="revision-card revision-propuesta">
        <div class="anteproyecto-card-titulo">
            <span class="anteproyecto-icono" aria-hidden="true">02</span>
            <div><h2>Propuesta</h2><p>Contenido y documento compartido</p></div>
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
    </section>

    <aside class="revision-card revision-lateral">
        <div class="anteproyecto-card-titulo">
            <span class="anteproyecto-icono" aria-hidden="true">03</span>
            <div><h2>Revisión del director</h2><p>Resultado de la primera evaluación</p></div>
        </div>
        <div class="revision-persona">
            <span>DIRECTOR</span>
            <strong><c:out value="${empty p.director ? 'Sin asignar' : p.director}"/></strong>
        </div>
        <div class="revision-nota">
            <span>CALIFICACIÓN</span>
            <strong><c:out value="${empty p.calificacion ? '-' : p.calificacion}"/><small> / 5.0</small></strong>
        </div>
        <div class="revision-observaciones">
            <span>OBSERVACIONES DEL DIRECTOR</span>
            <p><c:out value="${empty p.observaciones_director ? 'Sin observaciones registradas.' : p.observaciones_director}"/></p>
        </div>
        <div class="revision-fecha"><span>Aprobado el</span><strong><c:out value="${empty p.fecha_aprob_director ? 'Pendiente' : p.fecha_aprob_director}"/></strong></div>
    </aside>
</div>

<c:choose>
    <c:when test="${p.estado == 'Aprobado por director'}">
        <form class="formulario revision-card revision-decision" method="post">
            <div class="anteproyecto-card-titulo">
                <span class="anteproyecto-icono" aria-hidden="true">04</span>
                <div><h2>Decisión del evaluador</h2><p>Registra el resultado de la revisión final.</p></div>
            </div>
            <input type="hidden" name="id" value="${p.id_anteproyecto}">

            <div class="campo">
                <label for="observaciones">Observaciones</label>
                <textarea id="observaciones" name="observaciones">${fn:escapeXml(param.observaciones)}</textarea>
                <div class="ayuda">Opcionales al aprobar. Obligatorias al rechazar (minimo 10 caracteres).</div>
            </div>

            <div class="acciones">
                <button type="submit" class="btn btn-primario" formaction="${ctx}/evaluador/procesar-aprobar.jsp">Aprobar anteproyecto</button>
                <button type="submit" class="btn btn-peligro" formaction="${ctx}/evaluador/procesar-rechazar.jsp">Rechazar anteproyecto</button>
            </div>
        </form>
    </c:when>
    <c:otherwise>
        <div class="revision-card revision-decision">
            <div class="anteproyecto-card-titulo">
                <span class="anteproyecto-icono" aria-hidden="true">04</span>
                <div><h2>Decisión registrada</h2><p>Resultado de la revisión final.</p></div>
            </div>
            <div class="revision-resultado"><span>RESULTADO</span><strong><span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span></strong></div>
            <div class="revision-observaciones">
                <span>OBSERVACIONES DEL EVALUADOR</span>
                <p><c:out value="${empty p.observaciones_evaluador ? 'Sin observaciones registradas.' : p.observaciones_evaluador}"/></p>
            </div>
            <c:if test="${not empty p.fecha_aprob_evaluador}">
                <div class="revision-fecha"><span>Aprobado el</span><strong><c:out value="${p.fecha_aprob_evaluador}"/></strong></div>
            </c:if>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
