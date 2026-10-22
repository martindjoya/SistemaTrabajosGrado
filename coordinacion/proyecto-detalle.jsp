<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Detalle del proyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.nombres, u.apellidos, u.correo, u.telefono, e.codigo, e.programa,
           a.id_anteproyecto, a.titulo AS titulo_ante, a.resumen, a.archivo, a.estado,
           a.calificacion, a.observaciones_director, a.observaciones_evaluador,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           i.titulo AS idea,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director,
           CONCAT(ue.nombres, ' ', ue.apellidos) AS evaluador
    FROM estudiantes e
    INNER JOIN usuarios u ON u.id_usuario = e.id_usuario
    LEFT JOIN anteproyectos a ON a.id_estudiante = e.id_usuario
    LEFT JOIN ideas i ON i.id_idea = a.id_idea
    LEFT JOIN usuarios ud ON ud.id_usuario = a.id_director
    LEFT JOIN usuarios ue ON ue.id_usuario = a.id_evaluador
    WHERE e.id_usuario = ?
    <sql:param value="${empty param.id ? 0 : param.id}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/coordinacion/buscar-estudiante.jsp">
        <c:param name="error" value="El estudiante no existe."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="documentoExterno" value="${fn:startsWith(fn:toLowerCase(p.archivo), 'https://') or fn:startsWith(fn:toLowerCase(p.archivo), 'http://')}"/>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <h1>Detalle del proyecto</h1>
    <a class="btn btn-secundario" href="${ctx}/coordinacion/buscar-estudiante.jsp">Volver a la busqueda</a>
</div>

<div class="panel">
    <h3>Datos del estudiante</h3>
    <dl class="ficha">
        <dt>Nombre</dt><dd><c:out value="${p.nombres} ${p.apellidos}"/></dd>
        <dt>Codigo</dt><dd><c:out value="${p.codigo}"/></dd>
        <dt>Programa</dt><dd><c:out value="${p.programa}"/></dd>
        <dt>Correo</dt><dd><c:out value="${p.correo}"/></dd>
        <dt>Telefono</dt><dd><c:out value="${empty p.telefono ? 'No registrado' : p.telefono}"/></dd>
    </dl>
</div>

<c:choose>
    <c:when test="${empty p.id_anteproyecto}">
        <div class="panel">
            <p class="vacio">El estudiante aun no ha seleccionado una idea de proyecto.</p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="panel">
            <h3>Anteproyecto</h3>
            <dl class="ficha">
                <dt>Idea elegida</dt><dd><c:out value="${p.idea}"/></dd>
                <dt>Titulo</dt><dd><c:out value="${empty p.titulo_ante ? 'Pendiente' : p.titulo_ante}"/></dd>
                <dt>Resumen</dt><dd><c:out value="${empty p.resumen ? 'Pendiente' : p.resumen}"/></dd>
                <dt>Documento</dt>
                <dd>
                    <c:choose>
                        <c:when test="${empty p.archivo}">Sin documento enlazado</c:when>
                        <c:when test="${documentoExterno}"><a href="<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento en la nube</a></c:when>
                        <c:otherwise><a href="${ctx}/uploads/<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a></c:otherwise>
                    </c:choose>
                </dd>
                <dt>Estado</dt><dd><span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span></dd>
                <dt>Calificacion</dt><dd><c:out value="${empty p.calificacion ? 'Sin calificar' : p.calificacion}"/></dd>
                <dt>Observaciones del director</dt><dd><c:out value="${empty p.observaciones_director ? 'Ninguna' : p.observaciones_director}"/></dd>
                <dt>Observaciones del evaluador</dt><dd><c:out value="${empty p.observaciones_evaluador ? 'Ninguna' : p.observaciones_evaluador}"/></dd>
                <dt>Fecha de envio</dt>
                <dd>
                    <c:choose>
                        <c:when test="${empty p.fecha_envio}">Aun no enviado</c:when>
                        <c:otherwise><c:out value="${p.fecha_envio}"/></c:otherwise>
                    </c:choose>
                </dd>
            </dl>
        </div>

        <div class="panel">
            <h3>Asignaciones</h3>
            <dl class="ficha">
                <dt>Director</dt><dd><c:out value="${empty p.director ? 'Sin asignar' : p.director}"/></dd>
                <dt>Evaluador</dt><dd><c:out value="${empty p.evaluador ? 'Sin asignar' : p.evaluador}"/></dd>
            </dl>
            <c:if test="${p.estado != 'Aprobado por evaluador'}">
                <div class="acciones">
                    <a class="btn btn-primario" href="${ctx}/coordinacion/asignar-director.jsp?id=${p.id_anteproyecto}">
                        <c:out value="${empty p.director ? 'Asignar director' : 'Cambiar director'}"/>
                    </a>
                    <a class="btn btn-secundario" href="${ctx}/coordinacion/asignar-evaluador.jsp?id=${p.id_anteproyecto}">
                        <c:out value="${empty p.evaluador ? 'Asignar evaluador' : 'Cambiar evaluador'}"/>
                    </a>
                </div>
            </c:if>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
