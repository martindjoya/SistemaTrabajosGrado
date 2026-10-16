<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Panel del estudiante"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, a.estado, a.calificacion, i.titulo AS idea,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director,
           CONCAT(ue.nombres, ' ', ue.apellidos) AS evaluador
    FROM usuarios u
    LEFT JOIN anteproyectos a ON a.id_estudiante = u.id_usuario
    LEFT JOIN ideas i ON i.id_idea = a.id_idea
    LEFT JOIN usuarios ud ON ud.id_usuario = a.id_director
    LEFT JOIN usuarios ue ON ue.id_usuario = a.id_evaluador
    WHERE u.id_usuario = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>
<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Panel del estudiante</h1>
<p class="subtitulo">Bienvenido, <c:out value="${sessionScope.nombre}"/>. Este es el resumen de su proyecto:</p>

<c:choose>
    <c:when test="${empty p.id_anteproyecto}">
        <div class="panel">
            <h3>Aun no tiene idea de proyecto</h3>
            <p class="subtitulo">Revise las ideas disponibles y seleccione una para comenzar.</p>
            <div class="acciones">
                <a class="btn btn-primario" href="${ctx}/estudiante/ideas.jsp">Ver ideas disponibles</a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="rejilla-tarjetas">
            <div class="tarjeta">
                <p>Estado</p>
                <div class="separador" style="margin:.6rem 0 0;padding:0;border:none;">
                    <span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span>
                </div>
            </div>
            <div class="tarjeta">
                <p>Idea elegida</p>
                <h3><c:out value="${p.idea}"/></h3>
            </div>
            <div class="tarjeta">
                <p>Director</p>
                <h3><c:out value="${empty p.director ? 'Sin asignar' : p.director}"/></h3>
            </div>
            <div class="tarjeta">
                <p>Evaluador</p>
                <h3><c:out value="${empty p.evaluador ? 'Sin asignar' : p.evaluador}"/></h3>
            </div>
            <div class="tarjeta">
                <p>Calificacion</p>
                <div class="numero"><c:out value="${empty p.calificacion ? '-' : p.calificacion}"/></div>
            </div>
        </div>
        <div class="acciones">
            <a class="btn btn-primario" href="${ctx}/estudiante/anteproyecto.jsp">Mi anteproyecto</a>
            <a class="btn btn-secundario" href="${ctx}/estudiante/calificacion.jsp">Ver calificacion</a>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>